import 'package:flutter/material.dart';

import '../models/alarm_lesson.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class LessonSettingsResult {
  LessonSettingsResult(this.lesson, this.applyToAll);
  final AlarmLesson lesson;
  final bool applyToAll;
}

class LessonAlarmSettingsPage extends StatefulWidget {
  const LessonAlarmSettingsPage({super.key, required this.lesson});

  final AlarmLesson lesson;

  @override
  State<LessonAlarmSettingsPage> createState() => _LessonAlarmSettingsPageState();
}

class _LessonAlarmSettingsPageState extends State<LessonAlarmSettingsPage> {
  late AlarmLesson tmp;
  var applyToAll = false;
  String? selectedRingtoneUri;
  String? selectedRingtoneTitle;
  late TextEditingController hoursCtl;
  late TextEditingController minutesCtl;
  late int selectedSnooze;
  late int selectedRepeat;

  @override
  void initState() {
    super.initState();
    tmp = widget.lesson.copyWith();
    selectedRingtoneUri = tmp.ringtone;
    selectedRingtoneTitle = tmp.ringtone;
    hoursCtl = TextEditingController(text: (tmp.minutesBefore ~/ 60).toString());
    minutesCtl = TextEditingController(text: (tmp.minutesBefore % 60).toString());
    selectedSnooze = tmp.snoozeMinutes;
    selectedRepeat = tmp.repeatCount;
  }

  @override
  void dispose() {
    hoursCtl.dispose();
    minutesCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // applyOffset will be handled on save using the text controllers

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text('Alarm Ayarları', style: TextStyle(color: Color(0xFF13253B))),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: Color(0xFF13253B))),
          ),
          TextButton(
            onPressed: () {
              tmp.ringtone = selectedRingtoneUri;
              // snoozeMinutes and repeatCount are set via dropdowns
              tmp.snoozeMinutes = selectedSnooze;
              tmp.repeatCount = selectedRepeat;
              // parse and clamp hours/minutes
              final h = int.tryParse(hoursCtl.text) ?? 0;
              final m = int.tryParse(minutesCtl.text) ?? 0;
              final hh = h.clamp(0, 23);
              final mm = m.clamp(0, 59);
              tmp.minutesBefore = hh * 60 + mm;
              Navigator.pop(context, LessonSettingsResult(tmp, applyToAll));
            },
            child: const Text('Kaydet', style: TextStyle(color: Color(0xFF13253B))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.music_note),
                      title: Text(selectedRingtoneTitle ?? 'Varsayılan'),
                      subtitle: const Text('Zil sesi seçmek için dokun'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        // Only open native ringtone picker on Android devices.
                        if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
                          await showDialog<void>(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: const Text('Desteklenmiyor'),
                              content: const Text('Zil sesi seçimi yalnızca gerçek Android cihazlarda desteklenir. Lütfen gerçek bir cihazda veya Android emulatoründe deneyin.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(c), child: const Text('Tamam')),
                              ],
                            ),
                          );
                          return;
                        }

                        const channel = MethodChannel('ders_saati/ringtone');
                        try {
                          final result = await channel.invokeMethod<Object?>('pick');
                          if (result is Map) {
                            final uri = result['uri'] as String?;
                            final title = result['title'] as String?;
                            setState(() {
                              selectedRingtoneUri = uri;
                              selectedRingtoneTitle = title ?? uri;
                              tmp.ringtone = selectedRingtoneUri;
                            });
                          }
                        } on PlatformException {
                          // ignore
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Sesli'),
                      value: tmp.playSound,
                      onChanged: (v) => setState(() => tmp.playSound = v),
                    ),
                    SwitchListTile(
                      title: const Text('Titreşim'),
                      value: tmp.vibration,
                      onChanged: (v) => setState(() => tmp.vibration = v),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kaç dakika/saat önce'),
                Row(
                  children: [
                    // Hours input (0-23)
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: hoursCtl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(labelText: 'Saat', hintText: '0-23'),
                        maxLength: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Minutes input (0-59)
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: minutesCtl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(labelText: 'Dakika', hintText: '0-59'),
                        maxLength: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Erteleme (dakika): '),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: selectedSnooze,
                  items: const [1, 3, 5, 10, 15, 20]
                      .map((m) => DropdownMenuItem(value: m, child: Text('$m dk')))
                      .toList(),
                  onChanged: (m) => setState(() {
                    if (m != null) selectedSnooze = m;
                    tmp.snoozeMinutes = selectedSnooze;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Ses seviyesi'),
                Expanded(
                  child: Slider(
                    value: tmp.volume.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: tmp.volume.toString(),
                    onChanged: (v) => setState(() => tmp.volume = v.toInt()),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Tekrar sayısı: '),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: selectedRepeat,
                  items: [-1, 0, 1, 2, 3, 4, 5]
                      .map((r) => DropdownMenuItem(value: r, child: Text(r == -1 ? 'Süresiz' : r.toString())))
                      .toList(),
                  onChanged: (r) => setState(() {
                    if (r != null) selectedRepeat = r;
                    tmp.repeatCount = selectedRepeat;
                  }),
                ),
              ],
            ),
            CheckboxListTile(
              title: const Text('Bu ayarları dersin yer aldığı tüm haftalara uygula'),
              value: applyToAll,
              activeColor: const Color(0xFF123B73),
              onChanged: (v) => setState(() => applyToAll = v ?? false),
            ),
          ],
        ),
      ),
    );
  }
}
