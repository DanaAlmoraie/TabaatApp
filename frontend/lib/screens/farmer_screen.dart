// lib/screens/farmer_screen.dart
/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:camera/camera.dart';
import '../main.dart';
import 'camera_screen.dart';


class FarmerHomePage extends StatefulWidget {
  final String userName;

  const FarmerHomePage({
    super.key,
    required this.userName,
  });

  @override
  State<FarmerHomePage> createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en', null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildCameraButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // الهيدر
            _buildHeader(),

            // بوكس الطقس
            Transform.translate(
              offset: const Offset(0, -20),
              child: _buildWeatherBox(),
            ),

            const SizedBox(height: 15),

            // بوكس الفروت كلاسفاي
            _buildClassifyBox(),

            const SizedBox(height: 12),

            // بوكس Add Farm
            _buildAddFarmBox(),

            const SizedBox(height: 12),

            // بوكس View History
            _buildViewHistoryBox(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFD700), // أصفر
            Color(0xFFFF8C00), // برتقالي
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // اللوقو
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/tabaat_logo.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 15),
              // اسم المستخدم
              Expanded(
                child: Text(
                  "Hello ${widget.userName}",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // زر الإشعارات
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Color(0xFFFF8C00),
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          // التاريخ
          Padding(
            padding: const EdgeInsets.only(left: 63),
            child: Text(
              _getCurrentDate(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'en');
    return dateFormat.format(now);
  }

  // ================= WEATHER BOX =================
  Widget _buildWeatherBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 15,
              spreadRadius: 3,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined,
                      color: Colors.grey[700], size: 14),
                  const SizedBox(width: 5),
                  Text(
                    'San Francisco, CA',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '72°',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Partly Cloudy',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue[800]!,
                          Colors.blue[900]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.cloud_queue,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
           const SizedBox(height: 12),
           Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildWeatherDetailCard(0),
                  _buildWeatherDetailCard(1),
                  _buildWeatherDetailCard(2),
                  _buildWeatherDetailCard(3),
    ],
  ),
),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetailCard(int index) {
    final List<Map<String, dynamic>> weatherDetails = [
      {
        'icon': Icons.wb_sunny_outlined,
        'label': 'UV',
        'value': 'High',
        'color': Colors.amber.withOpacity(0.12),
        'iconColor': Colors.amber[700],
        'textColor': Colors.amber[800],
      },
      {
        'icon': Icons.water_drop_outlined,
        'label': 'Humid',
        'value': '68%',
        'color': Colors.pink.withOpacity(0.12),
        'iconColor': Colors.pink[400],
        'textColor': Colors.pink[800],
      },
      {
        'icon': Icons.cloud_outlined,
        'label': 'Rain',
        'value': '20%',
        'color': Colors.blue.withOpacity(0.12),
        'iconColor': Colors.blue[400],
        'textColor': Colors.blue[800],
      },
      {
        'icon': Icons.air_outlined,
        'label': 'Wind',
        'value': '12mph',
        'color': Colors.teal.withOpacity(0.12),
        'iconColor': Colors.teal[400],
        'textColor': Colors.teal[800],
      },
    ];

    final detail = weatherDetails[index];

    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      decoration: BoxDecoration(
        color: detail['color'],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: detail['iconColor']!.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            detail['icon'] as IconData,
            color: detail['iconColor'],
            size: 16,
          ),
          const SizedBox(height: 2),
          Text(
            detail['label'] as String,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: detail['textColor'],
            ),
          ),
          const SizedBox(height: 1),
          Text(
            detail['value'] as String,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: detail['textColor'],
            ),
          ),
        ],
      ),
    );
  }

  // ================= CLASSIFY BOX =================
  Widget _buildClassifyBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.orange[200]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.orange[300]!,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.orange[800],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Classify Fruit",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Identify fruit type using AI-powered camera",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700]!.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.orange[700],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ================= ADD FARM BOX =================
  Widget _buildAddFarmBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.green[200]!,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.eco_outlined,
                    color: Colors.green[700],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Farm',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add a new farm to your account',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700]!.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.add,
              color: Colors.green[700],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // ================= VIEW HISTORY BOX =================
  Widget _buildViewHistoryBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.green[200]!,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.history_outlined,
                    color: Colors.green[700],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'View History',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View harvest and activity history',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700]!.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.green[700],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ================= CAMERA BUTTON =================
  Widget _buildCameraButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Colors.orange[700]!,
            Colors.amber[600]!,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.6),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 1;
          });

         
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CameraScreen(camera: cameras.first),
            ),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.camera_alt, size: 26),
      ),
    );
  }

  // ================= BOTTOM NAV BAR =================
  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.grid_view_outlined, Icons.grid_view, 'Home', 0),
            _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData iconOutlined, IconData iconFilled, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 36,
            decoration: BoxDecoration(
              color: _currentIndex == index
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _currentIndex == index ? iconFilled : iconOutlined,
              color: _currentIndex == index ? Colors.amber : Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight:
                  _currentIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}*/

// lib/screens/farmer_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:camera/camera.dart';
import '../main.dart';
import 'camera_screen.dart';

class FarmerHomePage extends StatefulWidget {
  final String userName;

  const FarmerHomePage({
    super.key,
    required this.userName,
  });

  @override
  State<FarmerHomePage> createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en', null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildCameraButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),

            Transform.translate(
              offset: const Offset(0, -20),
              child: _buildWeatherBox(),
            ),

            const SizedBox(height: 15),

            _buildClassifyBox(),

            const SizedBox(height: 12),

            _buildAddFarmBox(),

            const SizedBox(height: 12),

            _buildViewHistoryBox(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFD700),
            Color(0xFFFF8C00),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Logo
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/tabbat_logo.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 15),

              // Username
              Expanded(
                child: Text(
                  "Hello ${widget.userName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Notifications
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Color(0xFFFF8C00),
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),

          // Date
          Padding(
            padding: const EdgeInsets.only(left: 63),
            child: Text(
              _getCurrentDate(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'en');
    return dateFormat.format(now);
  }

  // ================= WEATHER BOX =================
  Widget _buildWeatherBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 15,
              spreadRadius: 3,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined,
                      color: Colors.grey[700], size: 14),
                  const SizedBox(width: 5),
                  Text(
                    'San Francisco, CA',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '72°',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Partly Cloudy',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue[800]!,
                          Colors.blue[900]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.cloud_queue,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ✅ Wrap بدل Row عشان ما يصير overflow
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildWeatherDetailCard(0),
                  _buildWeatherDetailCard(1),
                  _buildWeatherDetailCard(2),
                  _buildWeatherDetailCard(3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetailCard(int index) {
    final List<Map<String, dynamic>> weatherDetails = [
      {
        'icon': Icons.wb_sunny_outlined,
        'label': 'UV',
        'value': 'High',
        'color': Colors.amber.withOpacity(0.12),
        'iconColor': Colors.amber[700],
        'textColor': Colors.amber[800],
      },
      {
        'icon': Icons.water_drop_outlined,
        'label': 'Humid',
        'value': '68%',
        'color': Colors.pink.withOpacity(0.12),
        'iconColor': Colors.pink[400],
        'textColor': Colors.pink[800],
      },
      {
        'icon': Icons.cloud_outlined,
        'label': 'Rain',
        'value': '20%',
        'color': Colors.blue.withOpacity(0.12),
        'iconColor': Colors.blue[400],
        'textColor': Colors.blue[800],
      },
      {
        'icon': Icons.air_outlined,
        'label': 'Wind',
        'value': '12mph',
        'color': Colors.teal.withOpacity(0.12),
        'iconColor': Colors.teal[400],
        'textColor': Colors.teal[800],
      },
    ];

    final detail = weatherDetails[index];

    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      decoration: BoxDecoration(
        color: detail['color'],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: (detail['iconColor'] as Color).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            detail['icon'] as IconData,
            color: detail['iconColor'] as Color?,
            size: 16,
          ),
          const SizedBox(height: 2),
          Text(
            detail['label'] as String,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: detail['textColor'] as Color?,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            detail['value'] as String,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: detail['textColor'] as Color?,
            ),
          ),
        ],
      ),
    );
  }

  // ================= CLASSIFY BOX =================
  // ✅ تم إصلاح overflow هنا
  Widget _buildClassifyBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.orange[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.orange[300]!,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.orange[800],
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Classify Fruit",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[900],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Identify fruit type using AI-powered camera",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[700]!.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.orange[700],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ================= ADD FARM BOX =================
  // ✅ تم إصلاح overflow هنا
  Widget _buildAddFarmBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.green[200]!,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.eco_outlined,
                color: Colors.green[700],
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Farm',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add a new farm to your account',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700]!.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),
            Icon(
              Icons.add,
              color: Colors.green[700],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // ================= VIEW HISTORY BOX =================
  // ✅ تم إصلاح overflow هنا
  Widget _buildViewHistoryBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.green[200]!,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.history_outlined,
                color: Colors.green[700],
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'View History',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'View harvest and activity history',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700]!.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.green[700],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ================= CAMERA BUTTON =================
  Widget _buildCameraButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Colors.orange[700]!,
            Colors.amber[600]!,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.6),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 1;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CameraScreen(camera: cameras.first),
            ),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.camera_alt, size: 26),
      ),
    );
  }

  // ================= BOTTOM NAV BAR =================
  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.grid_view_outlined, Icons.grid_view, 'Home', 0),
            _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData iconOutlined,
    IconData iconFilled,
    String label,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 36,
            decoration: BoxDecoration(
              color: _currentIndex == index
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _currentIndex == index ? iconFilled : iconOutlined,
              color: _currentIndex == index ? Colors.amber : Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight:
                  _currentIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}