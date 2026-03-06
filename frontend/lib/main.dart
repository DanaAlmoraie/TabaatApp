import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'screens/auth/login_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/nutrition_screen.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await Supabase.initialize(
    url: 'https://kbgvmporyktnoolndood.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtiZ3ZtcG9yeWt0bm9vbG5kb29kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA3NDczMTAsImV4cCI6MjA4NjMyMzMxMH0.oGaDlitL3MSs13rHaPX90q-DuEdAfY9LuLwkCCWTpLc',
  );

  cameras = await availableCameras();

  runApp(const TaabatApp());
}

class AppColors {
  static const background = Color(0xFFF4F6F8);
  static const headerGradientStart = Color(0xFF00C569);
  static const headerGradientEnd = Color(0xFF0FA574);
}

class TaabatApp extends StatelessWidget {
  const TaabatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taabat App',
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
