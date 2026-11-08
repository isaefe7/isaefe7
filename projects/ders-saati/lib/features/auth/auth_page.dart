import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../schedule_import/presentation/schedule_import_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isLoginScreen = true;

  String? _selectedCity;
  String? _selectedUniversity;
  bool _isCsvLoading = true;
  Map<String, List<String>> _universitiesByCity = {};

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  Future<void> _loadCsvData() async {
    try {
      final csvString = await rootBundle.loadString('assets/universiteler.csv');

      Map<String, List<String>> tempMap = {};

      List<String> lines = csvString.split(RegExp(r'\r?\n'));

      for (var i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        List<String> columns = line.split(',');

        if (columns.length >= 3) {
          String uni = columns[1].trim();
          String city = columns[2].trim();

          if (city.isNotEmpty && uni.isNotEmpty) {
            if (!tempMap.containsKey(city)) {
              tempMap[city] = [];
            }
            tempMap[city]!.add(uni);
          }
        }
      }

      var sortedKeys = tempMap.keys.toList()..sort();
      Map<String, List<String>> sortedMap = {};
      for (var key in sortedKeys) {
        sortedMap[key] = tempMap[key]!..sort();
      }

      setState(() {
        _universitiesByCity = sortedMap;
        _isCsvLoading = false;
      });
    } catch (e) {
      debugPrint('Dosya okuma hatası: $e');
      setState(() => _isCsvLoading = false);
    }
  }

  Future<void> _authenticate() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (_isLoginScreen) {
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        _showSnackBar('Giriş başarılı!', isError: false);
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ScheduleImportPage()),
        );
      } else {
        if (_selectedUniversity == null) {
          _showSnackBar(
            'Lütfen il ve üniversite seçimi yapınız.',
            isError: true,
          );
          setState(() => _isLoading = false);
          return;
        }

        await supabase.auth.signUp(
          email: email,
          password: password,
          data: {'university': _selectedUniversity},
        );

        _showSnackBar('Kayıt başarılı! Lütfen giriş yapın.', isError: false);
        setState(() {
          _isLoginScreen = true;
          _selectedCity = null;
          _selectedUniversity = null;
          _passwordController.clear();
        });
      }
    } on AuthException catch (e) {
      _showSnackBar(e.message, isError: true);
    } catch (e) {
      _showSnackBar('Beklenmeyen bir hata oluştu.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginScreen ? 'Giriş Yap' : 'Kayıt Ol'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

              if (!_isLoginScreen) ...[
                const SizedBox(height: 16),
                if (_isCsvLoading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Okuduğunuz İl',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    value: _selectedCity,
                    items: _universitiesByCity.keys.map((city) {
                      return DropdownMenuItem(value: city, child: Text(city));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value;
                        _selectedUniversity = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Üniversiteniz',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    value: _selectedUniversity,
                    items: _selectedCity == null
                        ? []
                        : _universitiesByCity[_selectedCity]!.map((uni) {
                            return DropdownMenuItem(
                              value: uni,
                              child: Text(uni, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                    onChanged: _selectedCity == null
                        ? null
                        : (value) {
                            setState(() {
                              _selectedUniversity = value;
                            });
                          },
                    isExpanded: true,
                  ),
                ],
              ],

              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                FilledButton(
                  onPressed: _authenticate,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(_isLoginScreen ? 'GİRİŞ YAP' : 'KAYIT OL'),
                  ),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoginScreen = !_isLoginScreen;
                    _selectedCity = null;
                    _selectedUniversity = null;
                  });
                },
                child: Text(
                  _isLoginScreen
                      ? 'Hesabın yok mu? Kayıt Ol'
                      : 'Zaten hesabın var mı? Giriş Yap',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
