import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/core/user_session.dart';
import 'package:frontend/services/api_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'farms_screen.dart';
import '../profile/profile_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import '../../main.dart';
import '../camera_screen.dart';
import '../../l10n/app_localizations.dart';

class ShopperHomePage extends StatefulWidget {
  const ShopperHomePage({Key? key}) : super(key: key);

  @override
  State<ShopperHomePage> createState() => _ShopperHomePageState();
}

class _ShopperHomePageState extends State<ShopperHomePage> {
  int _currentIndex = 0;
  Map<String, dynamic>? userData;
  List farms = [];
  bool loadingFarms = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en', null);
    _initializePage();
  }

  Future<void> _initializePage() async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    setState(() {
      userData = UserSession.user;
    });

    await loadFarms();
  }

  Future<void> loadFarms() async {
    setState(() => loadingFarms = true);

    try {
      final data = await ApiService.getAllFarms();

      if (!mounted) return;

      setState(() {
        farms = List.from(
          data,
        ).where((farm) => farm['is_open'] == true).toList();
        loadingFarms = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loadingFarms = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floatingActionButton: _buildCameraButton(),
      floatingActionButton: kIsWeb ? null : _buildCameraButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildClassifyBox(context),
            const SizedBox(height: 25), // مساحة بين البوكسين
            _buildFarmSection(context),
            const SizedBox(height: 100), // مساحة بين البوكسين
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    final tr = AppLocalizations.of(context)!;

    return Container(
      height: 250,
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
                  'assets/tabbat_logo.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 15),
              // اسم المستخدم
              Expanded(
                child: Text(
                  "${tr.hello} ${userData?['name']}",
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
                  onPressed: () {
                    // TODO: اضف زر الإشعارات
                  },
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
              _getCurrentDate(context),
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

  String _getCurrentDate(BuildContext context) {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', locale);
    return dateFormat.format(now);
  }

  // ================= CLASSIFY BOX =================
  Widget _buildClassifyBox(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
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
          border: Border.all(color: Colors.orange[200]!, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // أيقونة الكاميرا بمربع بخلفية شفافة
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.orange[300]!, width: 1.5),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.orange[800],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                // النصوص
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.classifyFruit,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tr.classifyFruitDesc,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700]!.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // السهم البرتقالي
            Icon(Icons.arrow_forward_ios, color: Colors.orange[700], size: 20),
          ],
        ),
      ),
    );
  }

  // ================= FARM SECTION =================
  Widget _buildFarmSection(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    // عرض المزارع غير المؤرشفة
    if (loadingFarms) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(child: CircularProgressIndicator()),
      );
    }

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
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr.exploreFarms,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FarmsPage()),
                    ).then((_) {
                      loadFarms();
                    });
                  },

                  child: Text(
                    tr.viewAll,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// إذا ما فيه مزارع
            if (farms.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text(tr.noFarmsAvailable)),
              ),
            Column(
              children: farms.take(3).map<Widget>((farm) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildFarmListItemDynamic(
                    name: farm['name'] ?? tr.unknownFarm,
                    location: farm['location'] ?? tr.unknownLocation,
                    fruits: List<String>.from(farm['fruits'] ?? []),
                    distance: _fakeDistance(),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// عنصر المزرعة (ديناميكي)
  Widget _buildFarmListItemDynamic({
    required String name,
    required String location,
    required List<String> fruits,
    required String distance,
  }) {
    final tr = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.2), width: 1.1),
      ),
      child: Row(
        children: [
          // أيقونة الموقع
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.green[200]!, width: 1.5),
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.green[700],
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // النصوص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المزرعة
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                const SizedBox(height: 3),

                // الموقع كنص
                Text(
                  location,
                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // الفواكه
                Wrap(
                  spacing: 6,
                  children: fruits.take(3).map((f) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // المسافة
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  distance,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                tr.distance,
                style: TextStyle(fontSize: 10, color: Colors.green[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// مسافة وهمية مؤقتة (لين نربط GPS)
  String _fakeDistance() {
    final distances = ["1.2 km", "2.5 km", "3.1 km", "4.0 km"];
    distances.shuffle();
    return distances.first;
  }

  // ================= CAMERA BUTTON =================
  Widget _buildCameraButton() {
    final tr = AppLocalizations.of(context)!;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3),
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [Colors.orange[700]!, Colors.amber[600]!],
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

          // ✅ الربط المطلوب: فتح CameraScreen
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.camera_alt, size: 26),
      ),
    );
  }
}
