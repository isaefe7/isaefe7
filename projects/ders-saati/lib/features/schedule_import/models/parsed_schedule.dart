import 'alarm_lesson.dart';

class ParsedSchedule {
  const ParsedSchedule({required this.dayName, required this.lessons});

  final String? dayName;
  final List<AlarmLesson> lessons;
}
