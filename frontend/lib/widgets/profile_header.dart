import 'package:flutter/material.dart';
import '../main.dart';

const Color kGreenTop = Color.fromARGB(255, 90, 128, 90);
const Color kGreenBottom = Color.fromARGB(255, 60, 156, 78);

Widget buildProfileHeader({
  required BuildContext context,
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
      Positioned(top: 40, right: 16, child: _languageSwitcher(context)),

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
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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

Widget _languageSwitcher(BuildContext context) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.18),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // English
        GestureDetector(
          onTap: () {
            TaabatApp.setLocale(context, const Locale('en'));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: !isArabic ? Colors.orange : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              "EN",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: !isArabic ? Colors.white : Colors.black54,
              ),
            ),
          ),
        ),

        const SizedBox(width: 6),

        // Arabic
        GestureDetector(
          onTap: () {
            TaabatApp.setLocale(context, const Locale('ar'));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isArabic ? Colors.orange : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              "ع",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isArabic ? Colors.white : Colors.black54,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
