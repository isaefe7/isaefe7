import 'dart:typed_data';

import 'package:excel2003/excel2003.dart';

import '../models/alarm_lesson.dart';
import '../models/parsed_schedule.dart';
import 'schedule_parser_utils.dart';

class XlsScheduleParser {
  ParsedSchedule parseBytes(Uint8List bytes) {
    final workbook = XlsReader.fromBytes(bytes);
    workbook.open();
    return _parseWorkbook(workbook);
  }

  ParsedSchedule _parseWorkbook(XlsReader workbook) {
    final lessons = <AlarmLesson>[];

    for (var sheetIndex = 0; sheetIndex < workbook.sheetCount; sheetIndex++) {
      final sheet = workbook.sheet(sheetIndex);
      if (sheet.rows.isEmpty) {
        continue;
      }

      for (var rowIndex = 0; rowIndex < sheet.rows.length; rowIndex++) {
        final row = sheet.rows[rowIndex];
        for (var colIndex = 0; colIndex < row.length; colIndex++) {
          final dayLabel = _weekdayLabelFromCell(row[colIndex]);
          if (dayLabel == null) {
            continue;
          }

          final headerRowIndex = rowIndex + 1;
          if (headerRowIndex >= sheet.rows.length) {
            continue;
          }

          final block = _parseDayBlock(
            rows: sheet.rows,
            dayLabel: dayLabel,
            weekday: ScheduleParserUtils.weekdayFromTurkishName(dayLabel),
            headerRowIndex: headerRowIndex,
            startColumn: colIndex,
          );
          lessons.addAll(block);
        }
      }
    }

    final mergedLessons = ScheduleParserUtils.mergeConsecutiveLessons(lessons);
    final firstDay = lessons.isEmpty ? null : lessons.first.dayLabel;
    return ParsedSchedule(dayName: firstDay, lessons: mergedLessons);
  }

  List<AlarmLesson> _parseDayBlock({
    required List<List<dynamic>> rows,
    required String dayLabel,
    required int? weekday,
    required int headerRowIndex,
    required int startColumn,
  }) {
    if (weekday == null) {
      return const [];
    }

    final headerRow = rows[headerRowIndex];
    final codeIndex = _findHeaderColumn(headerRow, startColumn, const [
      'ders kodu',
      'derskodu',
    ]);
    final startIndex = _findHeaderColumn(headerRow, startColumn, const [
      'bas.saat',
      'bas saat',
      'baslangic saati',
      'bas.saat',
    ]);
    final endIndex = _findHeaderColumn(headerRow, startColumn, const [
      'bit.saat',
      'bit saat',
      'bitis saati',
    ]);
    final nameIndex = _findHeaderColumn(headerRow, startColumn, const [
      'derslik kodu',
      'dersik kodu',
      'ders adi',
      'ders ismi',
    ]);

    if (codeIndex == null || startIndex == null || endIndex == null) {
      return const [];
    }

    final lessons = <AlarmLesson>[];
    for (var rowIndex = headerRowIndex + 1; rowIndex < rows.length; rowIndex++) {
      final row = rows[rowIndex];
      if (_isNewDayBlock(row, startColumn)) {
        break;
      }

      if (row.length <= codeIndex) {
        continue;
      }

      final code = _readCellValue(row[codeIndex]);
      final startText = row.length > startIndex ? _readCellValue(row[startIndex]) : '';
      final endText = row.length > endIndex ? _readCellValue(row[endIndex]) : '';
      final lessonName = nameIndex != null && row.length > nameIndex
          ? _readCellValue(row[nameIndex])
          : '';

      if (code.isEmpty || startText.isEmpty || endText.isEmpty) {
        continue;
      }

      lessons.add(
        AlarmLesson(
          dayLabel: dayLabel,
          weekday: weekday,
          code: code,
          name: lessonName.isEmpty ? code : lessonName,
          startTime: ScheduleParserUtils.parseTimeOfDay(startText),
          endTime: ScheduleParserUtils.parseTimeOfDay(endText),
          rowNumber: rowIndex + 1,
        ),
      );
    }

    return lessons;
  }

  bool _isNewDayBlock(List<dynamic> row, int startColumn) {
    if (row.isEmpty || startColumn >= row.length) {
      return false;
    }

    final value = ScheduleParserUtils.normalizeText(_readCellValue(row[startColumn]));
    return ScheduleParserUtils.weekdayFromTurkishName(value) != null;
  }

  int? _findHeaderColumn(List<dynamic> row, int startColumn, List<String> expectedValues) {
    for (var index = startColumn; index < row.length && index < startColumn + 6; index++) {
      final normalized = ScheduleParserUtils.normalizeText(_readCellValue(row[index])).replaceAll(' ', '');
      for (final expected in expectedValues) {
        final normalizedExpected = ScheduleParserUtils.normalizeText(expected).replaceAll(' ', '');
        if (normalized == normalizedExpected || normalized.contains(normalizedExpected)) {
          return index;
        }
      }
    }
    return null;
  }

  String? _weekdayLabelFromCell(dynamic cellValue) {
    final normalized = ScheduleParserUtils.normalizeText(_readCellValue(cellValue));
    if (normalized.isEmpty) {
      return null;
    }

    switch (normalized) {
      case 'pazartesi':
      case 'sali':
      case 'carsamba':
      case 'persembe':
      case 'cuma':
      case 'cumartesi':
      case 'pazar':
        return _readCellValue(cellValue);
      default:
        return null;
    }
  }

  String _readCellValue(dynamic value) {
    if (value == null) {
      return '';
    }

    return value.toString().trim();
  }
}
