import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';

import '../models/alarm_lesson.dart';
import '../models/parsed_schedule.dart';
import 'schedule_parser_utils.dart';

class CsvScheduleParser {
  ParsedSchedule parseBytes(Uint8List bytes) {
    final content = _decodeText(bytes);
    final rows = csv.decode(content);

    if (rows.isEmpty) {
      return const ParsedSchedule(dayName: null, lessons: []);
    }

    final headerRow = rows.first.map((cell) => cell?.toString().trim() ?? '').toList();
    final mappedRows = <Map<String, String>>[];

    for (final row in rows.skip(1)) {
      if (row.isEmpty) {
        continue;
      }

      final mapped = <String, String>{};
      for (var index = 0; index < headerRow.length; index++) {
        final header = headerRow[index];
        if (header.isEmpty) {
          continue;
        }

        final value = index < row.length ? row[index]?.toString().trim() ?? '' : '';
        mapped[header] = value;
      }

      if (mapped.values.every((value) => value.isEmpty)) {
        continue;
      }

      mappedRows.add(mapped);
    }

    final lessons = <AlarmLesson>[];
    for (var index = 0; index < mappedRows.length; index++) {
      final lesson = ScheduleParserUtils.lessonFromRow(
        mappedRows[index],
        rowNumber: index + 2,
      );
      if (lesson != null) {
        lessons.add(lesson);
      }
    }

    final mergedLessons = ScheduleParserUtils.mergeConsecutiveLessons(lessons);
    final firstDay = mergedLessons.isEmpty ? null : mergedLessons.first.dayLabel;
    return ParsedSchedule(dayName: firstDay, lessons: mergedLessons);
  }

  String _decodeText(Uint8List bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xEF &&
        bytes[1] == 0xBB &&
        bytes[2] == 0xBF) {
      return utf8.decode(bytes.sublist(3));
    }

    try {
      return utf8.decode(bytes);
    } catch (_) {
      return latin1.decode(bytes);
    }
  }
}
