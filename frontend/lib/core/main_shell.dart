import 'package:flutter/material.dart';
import 'package:frontend/core/role_router.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/camera_screen.dart';
import 'package:frontend/widgets/floating_navbar.dart';
import '../screens/profile/profile_screen.dart';
import '../core/user_session.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      getHomeByRole(),
      //CameraScreen(camera: camera),
      ProfilePage(userData: UserSession.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: FloatingNavBar(
        index: index,
        onChange: (i) {
          if (i == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CameraScreen(camera: cameras.first),
              ),
            );
            return;
          }
          setState(() => index = i);
        },
      ),
    );
  }
}
