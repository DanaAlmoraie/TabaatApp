import 'package:flutter/material.dart';

class MainNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.grid_view_outlined, "Home", 0),
              const SizedBox(width: 80),
              _navItem(Icons.person_outline, "Profile", 1),
            ],
          ),

          /// الدائرة الطالعة فوق
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            left: currentIndex == 0
                ? 70
                : MediaQuery.of(context).size.width - 150,
            top: -25,
            child: GestureDetector(
              onTap: () => onTap(currentIndex),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0), // نفس خلفية الصفحة
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Icon(
                  currentIndex == 0 ? Icons.grid_view : Icons.person,
                  color: Colors.orange,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final selected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: selected ? Colors.transparent : Colors.white),
          const SizedBox(height: 4),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: selected ? 0 : 1,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
