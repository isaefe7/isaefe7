import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NOT: Gerçek URL ve anon anahtarı depoya konmadı; kendi Supabase projenin değerlerini gir.
  await Supabase.initialize(
    url: 'https://PROJE-ID.supabase.co',
    anonKey: 'SUPABASE_ANON_KEY',
  );

  runApp(const DersSaatiApp());
}
