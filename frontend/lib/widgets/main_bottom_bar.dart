import 'package:flutter/material.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/camera_screen.dart';
import '../core/user_session.dart';
import '../core/role_router.dart';
import '../main.dart';

class MainBottomBar extends StatelessWidget {
  const MainBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF0D1B2A),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // HOME
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => getHomeByRole()),
                  (route) => false,
                );
              },
            ),

            const SizedBox(width: 40),

            // PROFILE
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(userData: UserSession.user!),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
