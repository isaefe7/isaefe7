import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../models/alarm_lesson.dart';
import '../models/parsed_schedule.dart';

class XmlScheduleParser {
  ParsedSchedule parseBytes(Uint8List bytes) {
    List<AlarmLesson> lessons = [];

    try {
      final xmlString = utf8.decode(bytes);
      int rowIndex = 1;

      // 1. Durum: <gun isim="Pazartesi"> <program> ... </program> </gun> formatı
      final gunMatches = RegExp(
        r'<gun[^>]*isim="([^"]+)"[^>]*>([\s\S]*?)<\/gun>',
        caseSensitive: false,
      ).allMatches(xmlString);

      if (gunMatches.isNotEmpty) {
        for (var gunMatch in gunMatches) {
          String dayLabel = gunMatch.group(1) ?? 'Pazartesi';
          String gunIcerik = gunMatch.group(2) ?? '';

          final programMatches = RegExp(
            r'<program>([\s\S]*?)<\/program>',
            caseSensitive: false,
          ).allMatches(gunIcerik);
          for (var progMatch in programMatches) {
            final block = progMatch.group(1);
            if (block == null) continue;

            String? name = _extract(block, ['ders', 'name']);
            String? saatRaw = _extract(block, ['saat', 'time']);

            if (name != null && saatRaw != null) {
              _addLesson(lessons, rowIndex++, name, dayLabel, saatRaw, block);
            }
          }
        }
      } else {
        // 2. Durum: Eski tip düz <lesson> formatı (Geriye dönük uyumluluk)
        final lessonMatches = RegExp(
          r'<lesson>([\s\S]*?)<\/lesson>',
          caseSensitive: false,
        ).allMatches(xmlString);
        for (var match in lessonMatches) {
          final block = match.group(1);
          if (block == null) continue;

          String? name = _extract(block, ['ders', 'name']);
          String? dayLabel = _extract(block, ['gun', 'day', 'dayLabel']);
          String? saatRaw = _extract(block, ['saat', 'startTime']);

          if (name != null && dayLabel != null && saatRaw != null) {
            _addLesson(lessons, rowIndex++, name, dayLabel, saatRaw, block);
          }
        }
      }
    } catch (e) {
      debugPrint('XML ayrıştırma hatası: $e');
    }

    return ParsedSchedule(lessons: lessons, dayName: 'Tümü');
  }

  // Okunan dersi listeye ekleyen yardımcı fonksiyon
  void _addLesson(
    List<AlarmLesson> lessons,
    int rowIndex,
    String name,
    String dayLabel,
    String saatRaw,
    String block,
  ) {
    // ÇÖZÜM: Ders kodu yoksa isimden türet (Örn: Rehberlik -> REH)
    String? extractedCode = _extract(block, ['kod', 'code']);
    String code = '-';
    if (extractedCode != null && extractedCode.isNotEmpty) {
      code = extractedCode;
    } else {
      code = name.length >= 3
          ? name.substring(0, 3).toUpperCase()
          : name.toUpperCase();
    }

    // Saat verisini parçala ("09:00 - 12:00" formatını destekler)
    String startStr = saatRaw;
    String? endStr = _extract(block, ['bitis_saati', 'endTime']);

    if (saatRaw.contains('-')) {
      final parts = saatRaw.split('-');
      startStr = parts[0].trim();
      endStr = parts[1].trim();
    }

    int startHour = 9, startMinute = 0;
    final startParts = startStr.split(':');
    if (startParts.length >= 2) {
      startHour = int.tryParse(startParts[0]) ?? 9;
      startMinute = int.tryParse(startParts[1]) ?? 0;
    }
    final startTime = TimeOfDay(hour: startHour, minute: startMinute);

    TimeOfDay endTime;
    if (endStr != null && endStr.isNotEmpty) {
      int endHour = 10, endMinute = 0;
      final endParts = endStr.split(':');
      if (endParts.length >= 2) {
        endHour = int.tryParse(endParts[0]) ?? 10;
        endMinute = int.tryParse(endParts[1]) ?? 0;
      }
      endTime = TimeOfDay(hour: endHour, minute: endMinute);
    } else {
      int calcMinute = startMinute + 50;
      int calcHour = startHour + (calcMinute ~/ 60);
      calcMinute = calcMinute % 60;
      endTime = TimeOfDay(hour: calcHour, minute: calcMinute);
    }

    lessons.add(
      AlarmLesson(
        rowNumber: rowIndex,
        code: code,
        name: name,
        weekday: _mapDayToWeekday(dayLabel),
        dayLabel: dayLabel,
        startTime: startTime,
        endTime: endTime,
      ),
    );
  }

  // XML bloğu içinden istenilen etiketleri çeken yardımcı fonksiyon
  String? _extract(String text, List<String> tags) {
    for (var tag in tags) {
      var match = RegExp(
        '<$tag>(.*?)<\/$tag>',
        caseSensitive: false,
      ).firstMatch(text);
      if (match != null && match.group(1) != null) {
        return match.group(1)!.trim();
      }
    }
    return null;
  }

  int _mapDayToWeekday(String day) {
    switch (day.trim().toLowerCase()) {
      case 'pazartesi':
        return 1;
      case 'salı':
      case 'sali':
        return 2;
      case 'çarşamba':
      case 'carsamba':
        return 3;
      case 'perşembe':
      case 'persembe':
        return 4;
      case 'cuma':
        return 5;
      case 'cumartesi':
        return 6;
      case 'pazar':
        return 7;
      default:
        return 1;
    }
  }
}
