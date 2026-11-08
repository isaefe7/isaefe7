# Ders Saati

A Flutter app that imports a university class timetable and turns it into **weekly local notifications** that fire before each lesson, so you never have to set alarms by hand.

> 🇹🇷 Türkçe dokümantasyon: [README.tr.md](README.tr.md)

Built as a course project for *Mobile Programming* (Yıldız Technical University, Computer Education and Instructional Technology), then extended with account sign-in.

## Features

- **Import a timetable** from `.xls`, `.xlsx`, `.csv`, `.json` or `.xml` files (one parser per format, selected by file extension).
- **Merges consecutive time blocks** of the same lesson into a single entry.
- **Weekly repeating notifications** for every lesson, scheduled with the device's local time zone.
- **Per-lesson settings**: switch notifications on/off and choose how many minutes/hours before the lesson they fire.
- **Test alarm** to check that notifications work without loading a real timetable.
- **Live countdown** to the next alarm on the home screen.
- **Account sign-in** (email + password) with [Supabase](https://supabase.com) Auth; the sign-up form offers a university list loaded from `assets/universiteler.csv`.
- Flutter multi-platform project (Android, iOS, web, Windows, macOS, Linux folders are present). Notification and alarm-sound behaviour differs by platform; the web build uses a separate alarm-sound implementation.

## Tech stack

Flutter · Dart · `flutter_local_notifications` · `timezone` / `flutter_timezone` · `excel2003` · `csv` · `xml` · `file_picker` · `supabase_flutter` · `google_fonts`

## Project structure

```text
lib/
├── main.dart                      # app entry, Supabase initialisation
├── app.dart                       # theme and auth-state routing
└── features/
    ├── auth/
    │   └── auth_page.dart         # sign in / sign up
    └── schedule_import/
        ├── models/                # AlarmLesson, ParsedSchedule
        ├── presentation/          # import, results and per-lesson settings pages
        └── services/              # xls/csv/json/xml parsers, notification service, alarm sound
```

The code is organised by feature, with a clear split between UI (`presentation`), logic (`services`) and data (`models`).

## Getting started

Requirements: [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.11.1`, see `pubspec.yaml`) and, for sign-in, a free Supabase project.

```bash
git clone https://github.com/isaefe7/isaefe7.git
cd isaefe7/projects/ders-saati
flutter pub get
```

Open `lib/main.dart` and replace the placeholders with your own Supabase project values:

```dart
await Supabase.initialize(
  url: 'https://PROJE-ID.supabase.co',
  anonKey: 'SUPABASE_ANON_KEY',
);
```

> The real project URL and key are intentionally not part of this repository.

Then run:

```bash
flutter run
```

Try the importer with the files in [`sample-data/`](sample-data/) (`schedule.csv`, `schedule.json`, `schedule.xml`). They contain made-up lessons.

## Status and limitations

- A course project, not a published app. Some folder names and the Android package id still use Flutter defaults (`com.example.ders_saati`).
- `.xls` import expects the layout of the university timetable export it was written for (Turkish day names as column headers); other layouts may not parse.
- Roadmap ideas, not implemented: iOS-specific alarm handling, OCR import of PDF/photo timetables, calendar sync.

## License

[MIT](LICENSE) © 2026 İsa Efe
