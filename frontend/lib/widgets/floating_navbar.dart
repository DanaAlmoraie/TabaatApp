import 'package:flutter/material.dart';

class FloatingNavBar extends StatelessWidget {
  final int index;
  final Function(int) onChange;

  const FloatingNavBar({
    super.key,
    required this.index,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          /// الناف نفسه
          Container(
            height: 65,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B2A),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  blurRadius: 25,
                  color: Colors.black.withOpacity(0.35),
                ),
              ],
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _item(Icons.home_rounded, 0),
                const SizedBox(width: 60),
                _item(Icons.settings_rounded, 1),
              ],
            ),
          ),

          /// زر الكاميرا (الوسط)
          Positioned(
            top: -28,
            child: GestureDetector(
              onTap: () => onChange(2),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9F1C), Color(0xFFFF7A00)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      color: Colors.orange.withOpacity(0.6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),

          /// الدائرة الطالعة (الصفحة الحالية)
          AnimatedPositionedDirectional(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack,
            start: index == 0 ? 40 : null,
            end: index == 1 ? 40 : null,
            top: -22,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9F1C), Color(0xFFFF7A00)],
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 14,
                    color: Colors.orange.withOpacity(0.55),
                  ),
                ],
              ),
              child: Icon(
                index == 0 ? Icons.home : Icons.settings,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(IconData icon, int i) {
    final active = i == index;

    return GestureDetector(
      onTap: () => onChange(i),
      child: Icon(
        icon,
        color: active ? Colors.transparent : Colors.white,
        size: 26,
      ),
    );
  }
}
