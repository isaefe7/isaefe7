import 'package:flutter/material.dart';

class AlarmLesson {
  AlarmLesson({
    required this.dayLabel,
    required this.weekday,
    required this.code,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.rowNumber,
    this.enabled = true,
    this.minutesBefore = 0,
    this.ringtone,
    this.playSound = true,
    this.vibration = true,
    this.snoozeMinutes = 5,
    this.volume = 100,
    this.repeatCount = 0,
  });

  String dayLabel;
  int weekday;
  String code;
  String name;
  TimeOfDay startTime;
  TimeOfDay endTime;
  int rowNumber;
  bool enabled;
  int minutesBefore; // minutes before lesson to trigger notification
  // New alarm settings
  String? ringtone; // raw resource name for Android (without extension)
  bool playSound;
  bool vibration;
  int snoozeMinutes; // minutes for snooze
  int volume; // 0-100
  int repeatCount; // how many extra times to repeat at snooze interval

  AlarmLesson copyWith({
    String? dayLabel,
    int? weekday,
    String? code,
    String? name,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? rowNumber,
    bool? enabled,
    int? minutesBefore,
    String? ringtone,
    bool? playSound,
    bool? vibration,
    int? snoozeMinutes,
    int? volume,
    int? repeatCount,
  }) {
    return AlarmLesson(
        dayLabel: dayLabel ?? this.dayLabel,
        weekday: weekday ?? this.weekday,
        code: code ?? this.code,
        name: name ?? this.name,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        rowNumber: rowNumber ?? this.rowNumber,
        enabled: enabled ?? this.enabled,
        minutesBefore: minutesBefore ?? this.minutesBefore,
      )
      ..ringtone = ringtone ?? this.ringtone
      ..playSound = playSound ?? this.playSound
      ..vibration = vibration ?? this.vibration
      ..snoozeMinutes = snoozeMinutes ?? this.snoozeMinutes
      ..volume = volume ?? this.volume
      ..repeatCount = repeatCount ?? this.repeatCount;
  }

  Map<String, dynamic> toJson() => {
    'dayLabel': dayLabel,
    'weekday': weekday,
    'code': code,
    'name': name,
    'startTime': '${startTime.hour}:${startTime.minute}',
    'endTime': '${endTime.hour}:${endTime.minute}',
    'rowNumber': rowNumber,
    'enabled': enabled,
    'minutesBefore': minutesBefore,
    'ringtone': ringtone,
    'playSound': playSound,
    'vibration': vibration,
    'snoozeMinutes': snoozeMinutes,
    'volume': volume,
    'repeatCount': repeatCount,
  };

  factory AlarmLesson.fromJson(Map<String, dynamic> json) {
    final startParts = json['startTime'].toString().split(':');
    final endParts = json['endTime'].toString().split(':');
    return AlarmLesson(
      dayLabel: json['dayLabel'] as String,
      weekday: json['weekday'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      startTime: TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      ),
      rowNumber: json['rowNumber'] as int,
      enabled: json['enabled'] as bool? ?? true,
      minutesBefore: json['minutesBefore'] as int? ?? 0,
      ringtone: json['ringtone'] as String?,
      playSound: json['playSound'] as bool? ?? true,
      vibration: json['vibration'] as bool? ?? true,
      snoozeMinutes: json['snoozeMinutes'] as int? ?? 5,
      volume: json['volume'] as int? ?? 100,
      repeatCount: json['repeatCount'] as int? ?? 0,
    );
  }
}
