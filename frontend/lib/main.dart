import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'screens/login_screen.dart';
import 'screens/camera_screen.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const TaabatApp());
}

class AppColors {
  static const background = Color(0xFFF4F6F8);
  static const headerGradientStart = Color(0xFF00C569);
  static const headerGradientEnd = Color(0xFF0FA574);
}

class TaabatApp extends StatelessWidget {
  const TaabatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taabat App',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const LoginScreen(),
      routes: {
        '/camera': (context) => CameraScreen(camera: cameras.first),
      },
    );
  }
}
