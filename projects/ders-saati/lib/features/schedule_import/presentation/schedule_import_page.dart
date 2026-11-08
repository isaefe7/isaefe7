import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/alarm_lesson.dart';
import '../services/notification_service.dart';
import '../services/schedule_parser.dart';
import 'schedule_results_page.dart';

class ScheduleImportPage extends StatefulWidget {
  const ScheduleImportPage({super.key});

  @override
  State<ScheduleImportPage> createState() => _ScheduleImportPageState();
}

class _ScheduleImportPageState extends State<ScheduleImportPage> {
  final ScheduleParser _parser = ScheduleParser();
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = false;
  String? _statusMessage;
  List<AlarmLesson> _lessons = const [];
  Timer? _countdownTimer;
  DateTime? _nextAlarmAt;
  String _countdownText = 'Henüz planlanmış alarm yok.';

  String? _universityName;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadScheduleFromDB();

    _universityName =
        Supabase.instance.client.auth.currentUser?.userMetadata?['university']
            as String?;
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadScheduleFromDB() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        setState(() => _isLoading = false);
        return;
      }

      final response = await Supabase.instance.client
          .from('user_schedules')
          .select('schedule_data')
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null && response['schedule_data'] != null) {
        final List<dynamic> data = response['schedule_data'];
        setState(() {
          _lessons = data.map((json) => AlarmLesson.fromJson(json)).toList();
          _statusMessage = 'Ders programınız yüklendi.';
        });
        _updateNextAlarmTarget();
      }
    } catch (e) {
      debugPrint('Veri çekme hatası: $e');
      setState(() {
        _statusMessage = 'Kaydedilmiş program bulunamadı veya okunamadı.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _saveScheduleToDB(List<AlarmLesson> lessons) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        setState(() {
          _statusMessage =
              'Uyarı: Giriş yapılmadığı için veritabanına kaydedilmedi.';
        });
        return false;
      }

      final scheduleData = lessons.map((l) => l.toJson()).toList();

      await Supabase.instance.client.from('user_schedules').upsert({
        'user_id': userId,
        'schedule_data': scheduleData,
      });

      debugPrint('Supabase kaydı başarılı!');
      return true;
    } catch (e) {
      debugPrint('Veri kaydetme hatası: $e');
      setState(() {
        _statusMessage = 'Veritabanı hatası: $e';
      });
      return false;
    }
  }

  Future<void> _pickScheduleFile() async {
    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ScheduleParser.supportedExtensions,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        setState(() {
          _isLoading = false;
          _statusMessage = 'Dosya seçilmedi.';
        });
        return;
      }

      final pickedFile = result.files.single;
      final bytes = pickedFile.bytes;
      if (bytes == null) {
        throw Exception('Dosya okunamadı. Lütfen dosyayı tekrar seçin.');
      }

      final parsed = _parser.parseFile(
        pickedFile.name,
        Uint8List.fromList(bytes),
      );

      setState(() {
        _lessons = parsed.lessons;
        _isLoading = false;
        _statusMessage = parsed.lessons.isEmpty
            ? 'Uygun ders satırı bulunamadı.'
            : '${parsed.lessons.length} ders için alarm hazırlandı.';
      });

      _updateNextAlarmTarget();

      final isSaved = await _saveScheduleToDB(parsed.lessons);
      if (!isSaved) return;

      try {
        await _notificationService.scheduleLessons(parsed.lessons);
      } catch (e) {
        debugPrint('Alarm kurulamadı: $e');
      }

      if (!mounted || parsed.lessons.isEmpty) {
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ScheduleResultsPage(
            lessons: parsed.lessons,
            statusMessage:
                _statusMessage ??
                '${parsed.lessons.length} ders için alarm hazırlandı.',
          ),
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Dosya okunamadı: $error';
      });
    }
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _refreshCountdownText();
    });
    _refreshCountdownText();
  }

  void _updateNextAlarmTarget() {
    DateTime? nextTarget;

    for (final lesson in _lessons) {
      final candidate = _nextOccurrenceForLesson(lesson);
      if (nextTarget == null || candidate.isBefore(nextTarget)) {
        nextTarget = candidate;
      }
    }

    _setNextAlarmTarget(nextTarget);
  }

  void _setNextAlarmTarget(DateTime? target) {
    _nextAlarmAt = target;
    _refreshCountdownText();
  }

  void _refreshCountdownText() {
    final target = _nextAlarmAt;
    if (target == null) {
      if (mounted) {
        setState(() {
          _countdownText = 'Henüz planlanmış alarm yok.';
        });
      }
      return;
    }

    final remaining = target.difference(DateTime.now());
    final text = remaining.isNegative
        ? 'Alarm zamanı geldi.'
        : 'Sonraki alarm: ${_formatDuration(remaining)} sonra';

    if (mounted) {
      setState(() {
        _countdownText = text;
      });
    }
  }

  DateTime _nextOccurrenceForLesson(AlarmLesson lesson) {
    final now = DateTime.now();
    var scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      lesson.startTime.hour,
      lesson.startTime.minute,
    );

    while (scheduled.weekday != lesson.weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  String _formatDuration(Duration duration) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final hours = safeDuration.inHours;
    final minutes = safeDuration.inMinutes.remainder(60);
    final seconds = safeDuration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}s ${minutes}dk ${seconds}sn';
    }

    if (minutes > 0) {
      return '${minutes}dk ${seconds}sn';
    }

    return '${seconds}sn';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ders Saati'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
          ),
        ],
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
                        elevation: 16,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Ders Saati',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ders programı dosyanızı yükleyin; ders kodu değişimlerine göre alarm oluşturulsun.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: const Color(0xFF27364A),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 24),
                              FilledButton.icon(
                                onPressed: _isLoading
                                    ? null
                                    : _pickScheduleFile,
                                icon: const Icon(Icons.upload_file_rounded),
                                label: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    'Dosya yükle (.xls, .csv, .json, .xml)',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F7FB),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.timer_outlined),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _countdownText,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_isLoading) ...[
                                const SizedBox(height: 16),
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                              if (_statusMessage != null) ...[
                                const SizedBox(height: 16),
                                _StatusBanner(message: _statusMessage!),
                              ],
                              if (_lessons.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ScheduleResultsPage(
                                          lessons: _lessons,
                                          statusMessage:
                                              'Kayıtlı alarmlarınız.',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.alarm_on_rounded),
                                  label: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Text('Alarmları Düzenle'),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF123B73),
                                    side: const BorderSide(
                                      color: Color(0xFF123B73),
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Ders Programı',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF27364A),
                                  ),
                                ),

                                if (_universityName != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _universityName!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF123B73),
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        headingRowColor:
                                            WidgetStateProperty.all(
                                              const Color(0xFFF5F7FB),
                                            ),
                                        columns: const [
                                          DataColumn(
                                            label: Text(
                                              'Gün',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Saat',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Ders Kodu',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Ders Adı',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: _lessons.map((lesson) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(lesson.dayLabel)),
                                              DataCell(
                                                Text(
                                                  '${lesson.startTime.hour.toString().padLeft(2, '0')}:${lesson.startTime.minute.toString().padLeft(2, '0')} - ${lesson.endTime.hour.toString().padLeft(2, '0')}:${lesson.endTime.minute.toString().padLeft(2, '0')}',
                                                ),
                                              ),
                                              DataCell(Text(lesson.code)),
                                              DataCell(Text(lesson.name)),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
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
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB4CCFF)),
      ),
      child: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
