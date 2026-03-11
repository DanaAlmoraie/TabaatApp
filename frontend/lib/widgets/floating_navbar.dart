// ignore_for_file: deprecated_member_use

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
    final width = MediaQuery.of(context).size.width;

    double position() {
      if (index == 0) return width * 0.20;
      if (index == 1) return width * 0.60;
      return width * 0.70;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 90,
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            /// خلفية الناف نفسه
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B2A),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 50,
                    spreadRadius: 1,
                    color: Colors.black.withOpacity(0.35),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _item(Icons.home_rounded, 0),
                  //_item(Icons.camera_alt_rounded, 1),
                  _item(Icons.person, 1), //TODO Change 1 to 2
                ],
              ),
            ),

            //خلفية التجويف الرمادي
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutBack,
              left: position(),
              top: -10,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xfff0f2f4),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            /// الدائرة البرتقالية (الصفحة الحالية)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutBack,
              left: position() - 0.5,
              top: -15,
              child: GestureDetector(
                onTap: () => onChange(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 55,
                  height: 55,
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
                    index == 0
                        ? Icons.home
                        : index == 1
                        ? Icons.camera_alt
                        : Icons.person,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, int i) {
    final active = i == index;

    return GestureDetector(
      onTap: () => onChange(i),
      child: AnimatedOpacity(
        opacity: active ? 0 : 1,
        duration: const Duration(milliseconds: 200),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }
}
