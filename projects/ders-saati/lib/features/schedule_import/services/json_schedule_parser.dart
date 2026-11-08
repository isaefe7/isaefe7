import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../models/alarm_lesson.dart';
import '../models/parsed_schedule.dart';

class JsonScheduleParser {
  ParsedSchedule parseBytes(Uint8List bytes) {
    List<AlarmLesson> lessons = [];

    try {
      final jsonString = utf8.decode(bytes);
      final dynamic jsonData = json.decode(jsonString);

      List<Map<String, dynamic>> extractedItems = [];
      _deepSearch(jsonData, extractedItems, null);

      int rowIndex = 1;
      for (var item in extractedItems) {
        String name = item['ders'] ?? 'İsimsiz Ders';
        String dayLabel = item['gun'] ?? 'Pazartesi';
        String saatRaw = item['saat'] ?? '09:00';

        // ÇÖZÜM: Kod yoksa isimden türet (JSON için)
        String code = item['kod'] ?? item['code'] ?? '';
        if (code.isEmpty || code == '-') {
          code = name.length >= 3
              ? name.substring(0, 3).toUpperCase()
              : name.toUpperCase();
        }

        String startStr = saatRaw;
        String? endStr = item['bitis_saati'];

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
            rowNumber: rowIndex++,
            code: code,
            name: name,
            weekday: _mapDayToWeekday(dayLabel),
            dayLabel: dayLabel,
            startTime: startTime,
            endTime: endTime,
          ),
        );
      }
    } catch (e) {
      debugPrint('JSON ayrıştırma hatası: $e');
    }

    return ParsedSchedule(lessons: lessons, dayName: 'Tümü');
  }

  void _deepSearch(
    dynamic node,
    List<Map<String, dynamic>> results,
    String? inheritedDay,
  ) {
    if (node is Map) {
      Map<String, dynamic> lowerMap = {};
      node.forEach((k, v) => lowerMap[k.toString().toLowerCase()] = v);

      String? currentDay =
          lowerMap['gun'] ??
          lowerMap['day'] ??
          lowerMap['isim'] ??
          inheritedDay;

      bool hasLesson = lowerMap.keys.any(
        (k) => k.contains('ders') || k.contains('name'),
      );
      bool hasTime = lowerMap.keys.any(
        (k) => k.contains('saat') || k.contains('time'),
      );

      if (hasLesson && hasTime) {
        Map<String, dynamic> lessonData = {'gun': currentDay};
        lowerMap.forEach((k, v) {
          if (k.contains('ders') || k.contains('name'))
            lessonData['ders'] = v.toString();
          if (k.contains('saat') || k.contains('time'))
            lessonData['saat'] = v.toString();
          if (k.contains('kod') || k.contains('code'))
            lessonData['kod'] = v.toString();
          if (k.contains('bitis') || k.contains('end'))
            lessonData['bitis_saati'] = v.toString();
        });
        results.add(lessonData);
      }

      node.values.forEach((v) => _deepSearch(v, results, currentDay));
    } else if (node is List) {
      node.forEach((v) => _deepSearch(v, results, inheritedDay));
    }
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
