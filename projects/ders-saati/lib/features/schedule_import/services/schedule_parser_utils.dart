import 'package:flutter/material.dart';

import '../models/alarm_lesson.dart';

class ScheduleParserUtils {
  const ScheduleParserUtils._();

  static List<AlarmLesson> mergeConsecutiveLessons(List<AlarmLesson> lessons) {
    if (lessons.isEmpty) {
      return const [];
    }

    final merged = <AlarmLesson>[];

    for (final lesson in lessons) {
      if (merged.isEmpty) {
        merged.add(lesson);
        continue;
      }

      final last = merged.last;
      final canMerge = last.dayLabel == lesson.dayLabel &&
          last.code == lesson.code &&
          areConsecutiveSlots(last.endTime, lesson.startTime);

      if (canMerge) {
        merged[merged.length - 1] = AlarmLesson(
          dayLabel: last.dayLabel,
          weekday: last.weekday,
          code: last.code,
          name: last.name,
          startTime: last.startTime,
          endTime: lesson.endTime,
          rowNumber: last.rowNumber,
        );
      } else {
        merged.add(lesson);
      }
    }

    return merged;
  }

  static bool areConsecutiveSlots(TimeOfDay firstEnd, TimeOfDay secondStart) {
    final firstMinutes = firstEnd.hour * 60 + firstEnd.minute;
    final secondMinutes = secondStart.hour * 60 + secondStart.minute;
    return secondMinutes - firstMinutes == 10;
  }

  static int? weekdayFromTurkishName(String? dayName) {
    switch (normalizeText(dayName)) {
      case 'pazartesi':
        return DateTime.monday;
      case 'sali':
        return DateTime.tuesday;
      case 'carsamba':
        return DateTime.wednesday;
      case 'persembe':
        return DateTime.thursday;
      case 'cuma':
        return DateTime.friday;
      case 'cumartesi':
        return DateTime.saturday;
      case 'pazar':
        return DateTime.sunday;
      default:
        return null;
    }
  }

  static String? weekdayLabelFromText(String? value) {
    final normalized = normalizeText(value);
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
        return value!.trim();
      default:
        return null;
    }
  }

  static TimeOfDay parseTimeOfDay(String rawValue) {
    final normalized = rawValue.trim().replaceAll('.', ':');
    final parts = normalized.split(':');
    if (parts.length < 2) {
      return const TimeOfDay(hour: 0, minute: 0);
    }

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return TimeOfDay(hour: hour.clamp(0, 23), minute: minute.clamp(0, 59));
  }

  static String normalizeText(String? input) {
    return (input ?? '')
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ş', 's')
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o')
        .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
        .trim();
  }

  static String normalizeKey(String key) {
    return normalizeText(key).replaceAll(' ', '');
  }

  static String? valueForKeys(Map<String, String> row, List<String> keys) {
    for (final key in keys) {
      final normalizedKey = normalizeKey(key);
      for (final entry in row.entries) {
        final entryKey = normalizeKey(entry.key);
        if (entryKey == normalizedKey || entryKey.contains(normalizedKey)) {
          final value = entry.value.trim();
          if (value.isNotEmpty) {
            return value;
          }
        }
      }
    }
    return null;
  }

  static AlarmLesson? lessonFromRow(Map<String, String> row, {required int rowNumber}) {
    final dayValue = valueForKeys(row, const [
      'gun',
      'gün',
      'day',
      'daylabel',
      'day label',
    ]);
    final dayLabel = weekdayLabelFromText(dayValue);
    final weekday = weekdayFromTurkishName(dayValue);

    if (dayLabel == null || weekday == null) {
      return null;
    }

    final code = valueForKeys(row, const [
      'ders kodu',
      'derskodu',
      'ders_kodu',
      'code',
    ]);
    final startText = valueForKeys(row, const [
      'bas.saat',
      'bas saat',
      'bas_saat',
      'baslangic saati',
      'baslangic',
      'start',
    ]);
    final endText = valueForKeys(row, const [
      'bit.saat',
      'bit saat',
      'bit_saat',
      'bitis saati',
      'bitis',
      'end',
    ]);
    final lessonName = valueForKeys(row, const [
      'derslik kodu',
      'ders adi',
      'ders ismi',
      'ders_adi',
      'name',
    ]);

    if (code == null || startText == null || endText == null) {
      return null;
    }

    return AlarmLesson(
      dayLabel: dayLabel,
      weekday: weekday,
      code: code,
      name: (lessonName == null || lessonName.isEmpty) ? code : lessonName,
      startTime: parseTimeOfDay(startText),
      endTime: parseTimeOfDay(endText),
      rowNumber: rowNumber,
    );
  }
}
