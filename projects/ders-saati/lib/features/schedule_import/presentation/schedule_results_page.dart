import 'dart:async';
import 'package:flutter/material.dart';

import '../models/alarm_lesson.dart';
import '../services/notification_service.dart';
import 'lesson_alarm_settings_page.dart';

class ScheduleResultsPage extends StatefulWidget {
  const ScheduleResultsPage({super.key, required this.lessons, required this.statusMessage});

  final List<AlarmLesson> lessons;
  final String statusMessage;

  @override
  State<ScheduleResultsPage> createState() => _ScheduleResultsPageState();

}


class _ScheduleResultsPageState extends State<ScheduleResultsPage> {
  late List<AlarmLesson> lessons;
  final _notifier = NotificationService();
  Timer? _countdownTimer;
  DateTime? _nextAlarmAt;
  String _countdownText = 'Henüz planlanmış alarm yok.';

  @override
  void initState() {
    super.initState();
    lessons = widget.lessons.map((e) => e).toList();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _updateNextAlarmTarget();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _refreshCountdownText());
    _refreshCountdownText();
  }

  void _updateNextAlarmTarget() {
    DateTime? nextTarget;
    for (final lesson in lessons) {
      final candidate = _nextOccurrenceForLesson(lesson);
      if (nextTarget == null || candidate.isBefore(nextTarget)) {
        nextTarget = candidate;
      }
    }
    _nextAlarmAt = nextTarget;
  }

  void _refreshCountdownText() {
    final target = _nextAlarmAt;
    if (target == null) {
      if (mounted) setState(() => _countdownText = 'Henüz planlanmış alarm yok.');
      return;
    }
    final remaining = target.difference(DateTime.now());
    final text = remaining.isNegative
        ? 'Alarm zamanı geldi.'
        : 'Sonraki alarm: ${_formatDuration(remaining)} sonra';
    if (mounted) setState(() => _countdownText = text);
  }

  DateTime _nextOccurrenceForLesson(AlarmLesson lesson) {
    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, lesson.startTime.hour, lesson.startTime.minute);
    while (scheduled.weekday != lesson.weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    // subtract minutesBefore
    scheduled = scheduled.subtract(Duration(minutes: lesson.minutesBefore));
    return scheduled;
  }

  String _formatDuration(Duration duration) {
    final safe = duration.isNegative ? Duration.zero : duration;
    final hours = safe.inHours;
    final minutes = safe.inMinutes.remainder(60);
    final seconds = safe.inSeconds.remainder(60);
    if (hours > 0) return '$hours saat $minutes dk $seconds sn';
    if (minutes > 0) return '$minutes dk $seconds sn';
    return '$seconds sn';
  }

  // kept for countdown helpers only
  Map<String, List<AlarmLesson>> _groupLessonsByDay(List<AlarmLesson> items) {
    final grouped = <String, List<AlarmLesson>>{};

    for (final lesson in items) {
      grouped.putIfAbsent(lesson.dayLabel, () => <AlarmLesson>[]).add(lesson);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedLessons = _groupLessonsByDay(lessons);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text('Oluşturulan Alarmlar', style: TextStyle(color: Color(0xFF13253B), fontWeight: FontWeight.w700)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF13253B)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF081120), Color(0xFF123B73), Color(0xFFE8EEF9)],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Card(
                        elevation: 12,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Oluşturulan alarmlar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF13253B),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Countdown moved here from import page
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F7FB),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.timer_outlined),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _countdownText,
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.statusMessage,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFF27364A),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              for (final entry in groupedLessons.entries) ...[
                                _DayLessonsSection(
                                  dayLabel: entry.key,
                                  lessons: entry.value,
                                  onSettingsSaved: _onSettingsSaved,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onSettingsSaved(AlarmLesson updated, bool applyToAll) async {
    setState(() {
      if (applyToAll) {
        for (var i = 0; i < lessons.length; i++) {
          if (lessons[i].code == updated.code) {
            lessons[i] = lessons[i].copyWith(
              minutesBefore: updated.minutesBefore,
              ringtone: updated.ringtone,
              playSound: updated.playSound,
              vibration: updated.vibration,
              snoozeMinutes: updated.snoozeMinutes,
              volume: updated.volume,
              repeatCount: updated.repeatCount,
            );
          }
        }
      } else {
        final idx = lessons.indexWhere((l) => l.rowNumber == updated.rowNumber && l.weekday == updated.weekday && l.code == updated.code);
        if (idx != -1) lessons[idx] = updated;
      }
    });

    // Reschedule affected lessons
    final affected = lessons.where((l) => l.code == updated.code);
    for (final l in affected) {
      await _notifier.cancelLesson(l);
      if (l.enabled) await _notifier.scheduleLesson(l);
    }
  }

}

class _DayLessonsSection extends StatelessWidget {
  const _DayLessonsSection({required this.dayLabel, required this.lessons, required this.onSettingsSaved});

  final String dayLabel;
  final List<AlarmLesson> lessons;
  final Future<void> Function(AlarmLesson updated, bool applyToAll) onSettingsSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            dayLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF13253B),
                ),
          ),
        ),
        for (final lesson in lessons) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _LessonCard(lesson: lesson, onSettingsSaved: onSettingsSaved),
          ),
        ],
      ],
    );
  }
}

class _LessonCard extends StatefulWidget {
  const _LessonCard({required this.lesson, required this.onSettingsSaved});

  final AlarmLesson lesson;
  final Future<void> Function(AlarmLesson updated, bool applyToAll) onSettingsSaved;

  @override
  State<_LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<_LessonCard> {
  late AlarmLesson lesson;
  

  @override
  void initState() {
    super.initState();
    lesson = widget.lesson;
  }

  Future<void> _openSettingsDialog() async {
    final result = await Navigator.push<LessonSettingsResult?>(
      context,
      MaterialPageRoute(builder: (context) => LessonAlarmSettingsPage(lesson: lesson)),
    );

    if (result != null) {
      await widget.onSettingsSaved(result.lesson, result.applyToAll);
      setState(() => lesson = result.lesson);
    }
  }

  @override
  Widget build(BuildContext context) {
    String formatOffset(int minutesBefore) {
      if (minutesBefore <= 0) return '0 dk önce';
      final h = minutesBefore ~/ 60;
      final m = minutesBefore % 60;
      if (h > 0) return '$h saat $m dk önce';
      return '$m dk önce';
    }
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF123B73),
          child: const Icon(Icons.alarm, color: Colors.white),
        ),
        title: Text(lesson.code, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('${lesson.name} • ${lesson.startTime.format(context)} • ${formatOffset(lesson.minutesBefore)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: lesson.enabled,
              onChanged: (v) async {
                final updated = lesson.copyWith(enabled: v);
                await widget.onSettingsSaved(updated, false);
                setState(() => lesson = updated);
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Color(0xFF13253B)),
              onPressed: _openSettingsDialog,
            ),
          ],
        ),
      ),
    );
  }

}
 