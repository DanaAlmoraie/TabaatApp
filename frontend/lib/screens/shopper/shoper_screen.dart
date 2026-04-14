// ignore_for_file: deprecated_member_use, unused_field, use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/user_session.dart';
import 'package:frontend/services/api_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'farms_screen.dart';
import 'package:flutter/foundation.dart';
import '../camera_screen.dart';
import '../../l10n/app_localizations.dart';
import '../profile/permissions_data_screen.dart';
import 'package:geolocator/geolocator.dart';

class ShopperHomePage extends StatefulWidget {
  const ShopperHomePage({super.key});

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
    if (!UserSession.locationEnabled) {
      setState(() {
        farms = [];
        loadingFarms = false;
      });
      return;
    }

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
      backgroundColor: const Color.fromRGBO(244, 246, 248, 1),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: kIsWeb ? null : _buildCameraButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildClassifyBox(),
            const SizedBox(height: 25),
            _buildFarmSection(context),
            const SizedBox(height: 100),
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
          colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
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
                  "${tr.hello} ${userData?['name']}",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Date
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

  Widget _buildClassifyBox() {
    final tr = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () async {
          try {
            final cameras = await availableCameras();
            final firstCamera = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
              orElse: () => cameras.first,
            );

            if (cameras.isEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(tr.noCameraFound)));
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CameraScreen(camera: firstCamera),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${tr.errorAccessingCamera} $e')),
            );
          }
        },
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
            border: Border.all(color: Colors.orange[200]!, width: 1),
          ),
          child: Row(
            children: [
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.classifyFruit,
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
                      tr.classifyFruitDesc,
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
      ),
    );
  }

  // ================= FARM SECTION =================
  Widget _buildFarmSection(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    //if user is not allowing 'share location' permission
    if (!UserSession.locationEnabled) {
      return _buildLocationRequiredBox();
    }
    // if farms are being loaded
    if (loadingFarms) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    //if no farms at all in database
    if (farms.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text(tr.noFarmsAvailable)),
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

            Column(
              children: farms.take(3).map<Widget>((farm) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildFarmListItemDynamic(
                    name: farm['name']?.toString() ?? tr.unknownFarm,
                    location:
                        farm['location']?.toString() ?? tr.unknownLocation,
                    fruits: (farm['fruits'] as List?)?.cast<String>() ?? [],
                    distance: _calculateDistance(
                      farm['latitude']?.toDouble() ?? 0.0,
                      farm['longitude']?.toDouble() ?? 0.0,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

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

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                const SizedBox(height: 3),

                Text(
                  location,
                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

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

  String _calculateDistance(double farmLat, double farmLng) {
    final tr = AppLocalizations.of(context)!;

    if (UserSession.user['latitude'] == null ||
        UserSession.user['longitude'] == null) {
      return "--";
    }

    final userLat = UserSession.user['latitude'];
    final userLng = UserSession.user['longitude'];

    final distanceMeters = Geolocator.distanceBetween(
      userLat,
      userLng,
      farmLat,
      farmLng,
    );

    final km = distanceMeters / 1000;

    return '${km.toStringAsFixed(1)} ${tr.kiloMeter}';
  }

  Widget _buildLocationRequiredBox() {
    final tr = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.orange[200]!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_rounded,
              size: 42,
              color: Colors.orange[700],
            ),

            const SizedBox(height: 10),

            Text(
              tr.locationRequired,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              tr.locationRequiredDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 14),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(Icons.settings, color: Colors.white),
              label: Text(
                tr.openPermissions,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PermissionsPage(userData: UserSession.user),
                  ),
                );
              },
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
        onPressed: () async {
          final cams = await availableCameras();
          final firstCmera = cams.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
            orElse: () => cams.first,
          );

          setState(() {
            _currentIndex = 1;
          });

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CameraScreen(camera: firstCmera)),
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
