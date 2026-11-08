import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/alarm_lesson.dart';

class NotificationService {
  NotificationService()
      : _notifications = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _notifications;
  static const String _lessonChannelId = 'ders-saati-channel-v2';
  // test channel removed

  Future<void> initialize() async {
    tz.initializeTimeZones();
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: android);
    await _notifications.initialize(initializationSettings);

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> scheduleLessons(List<AlarmLesson> lessons) async {
    if (lessons.isEmpty) {
      return;
    }

    for (final lesson in lessons) {
      if (lesson.enabled) {
        await scheduleLesson(lesson);
      }
    }
  }

  Future<void> scheduleLesson(AlarmLesson lesson) async {
    final scheduledBase = _nextInstanceOfWeekdayTime(lesson.weekday, lesson.startTime);
    var scheduled = scheduledBase.subtract(Duration(minutes: lesson.minutesBefore));

    final now = tz.TZDateTime.now(tz.local);
    if (scheduled.isBefore(now)) {
      // schedule for next week
      scheduled = scheduled.add(const Duration(days: 7));
    }

    final androidDetails = AndroidNotificationDetails(
      _lessonChannelId,
      'Ders Saati',
      channelDescription: 'Ders programı dosyasından oluşturulan alarmlar',
      importance: Importance.max,
      priority: Priority.max,
      playSound: lesson.playSound,
      enableVibration: lesson.vibration,
      sound: (() {
        final r = lesson.ringtone;
        if (r == null || r.isEmpty) return null;
        // If the ringtone looks like a content/file URI, currently fall back to default sound
        // (platform-specific custom URI handling not implemented here)
        if (r.startsWith('content://') || r.startsWith('file://') || r.startsWith('assets://')) {
          return null;
        }
        // Otherwise assume it's a raw resource name and use RawResourceAndroidNotificationSound
        return RawResourceAndroidNotificationSound(r);
      })(),
    );

    await _notifications.zonedSchedule(
      _notificationIdForLesson(lesson.code, lesson.weekday, lesson.startTime),
      'Ders saati: ${lesson.code}',
      '${lesson.dayLabel} - ${lesson.name} başladı. ${_formatTime(lesson.startTime)} - ${_formatTime(lesson.endTime)}',
      scheduled,
      NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Schedule repeats (one-off) according to repeatCount and snoozeMinutes
    for (var i = 1; i <= lesson.repeatCount; i++) {
      final id = _notificationIdForLesson(lesson.code, lesson.weekday, lesson.startTime) + i;
      final repeatTime = scheduled.add(Duration(minutes: lesson.snoozeMinutes * i));
      // one-off notification for this occurrence
      await _notifications.zonedSchedule(
        id,
        'Ders saati (tekrar): ${lesson.code}',
        '${lesson.dayLabel} - ${lesson.name} başladı. ${_formatTime(lesson.startTime)} - ${_formatTime(lesson.endTime)}',
        repeatTime,
        NotificationDetails(android: androidDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
  Future<void> cancelLesson(AlarmLesson lesson) async {
    final id = _notificationIdForLesson(lesson.code, lesson.weekday, lesson.startTime);
    await _notifications.cancel(id);
  }

  tz.TZDateTime _nextInstanceOfWeekdayTime(int weekday, TimeOfDay timeOfDay) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  int _notificationIdForLesson(String code, int weekday, TimeOfDay startTime) {
    final raw = '$code-$weekday-${startTime.hour}-${startTime.minute}';
    return raw.codeUnits.fold<int>(0, (previous, element) => previous + element) & 0x7fffffff;
  }

  String _formatTime(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
