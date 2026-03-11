import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:frontend/core/user_session.dart';
import 'screens/auth/login_screen.dart';
import 'screens/camera_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'core/locale_manager.dart';
import 'screens/nutrition_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kbgvmporyktnoolndood.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtiZ3ZtcG9yeWt0bm9vbG5kb29kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA3NDczMTAsImV4cCI6MjA4NjMyMzMxMH0.oGaDlitL3MSs13rHaPX90q-DuEdAfY9LuLwkCCWTpLc',
  );

  cameras = await availableCameras();

  runApp(const TaabatApp());
}

class AppColors {
  static const background = Color(0xFFF4F6F8);
  static const headerGradientStart = Color(0xFF00C569);
  static const headerGradientEnd = Color(0xFF0FA574);
}

class TaabatApp extends StatefulWidget {
  const TaabatApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _TaabatAppState? state = context.findAncestorStateOfType<_TaabatAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<TaabatApp> createState() => _TaabatAppState();
}

class _TaabatAppState extends State<TaabatApp> {
  Locale _locale = Locale('en');

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedLang = await LocaleManager.getSavedLocale();

    if (savedLang != null) {
      setState(() {
        _locale = Locale(savedLang);
      });
    }
  }

  void setLocale(Locale locale) async {
    await LocaleManager.saveLocale(locale.languageCode);

    setState(() {
      _locale = locale;
      UserSession.language = locale.languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: _locale,

      title: 'Taabat App',

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [Locale('en'), Locale('ar')],

      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
      ),

      routes: {
        '/camera': (context) => CameraScreen(camera: cameras.first),
        '/login': (context) => const LoginScreen(),
        '/nutrition': (context) {
          final fruitName =
              ModalRoute.of(context)!.settings.arguments as String?;

          if (fruitName == null) {
            return const Scaffold(
              body: Center(child: Text('No fruit detected')),
            );
          }

          return NutritionLoader(fruitType: fruitName);
        },
      },

      home: const LoginScreen(),
    );
  }
}
