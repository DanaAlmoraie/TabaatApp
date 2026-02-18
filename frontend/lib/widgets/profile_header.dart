import 'package:flutter/material.dart';

const Color kGreenTop = Color.fromARGB(255, 90, 128, 90);
const Color kGreenBottom = Color.fromARGB(255, 60, 156, 78);

Widget buildProfileHeader({
  required String pageTitle,
  required String userName,
  required Widget avatar,
  bool showBack = false,
  VoidCallback? onBack,
}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        height: 240,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kGreenTop, kGreenBottom],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),

      // خط التدرج
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 6,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.orange, Colors.yellow]),
          ),
        ),
      ),

      if (showBack)
        Positioned(
          top: 40,
          left: 16,
          child: GestureDetector(
            onTap: onBack,
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),

      Positioned(
        top: 50,
        left: 0,
        right: 0,
        child: Column(
          children: [
            Text(
              pageTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              userName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 16),
            avatar,
          ],
        ),
      ),
    ],
  );
}
