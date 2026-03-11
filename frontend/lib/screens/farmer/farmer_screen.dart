import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/user_session.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/foundation.dart';
import '../../main.dart';
import '../camera_screen.dart';
import 'farms_manage_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../services/api_service.dart';

class FarmerHomePage extends StatefulWidget {
  const FarmerHomePage({super.key});

  @override
  State<FarmerHomePage> createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  int _currentIndex = 0;

  Map<String, dynamic>? userData;

  Map<String, dynamic>? _weather;
  bool _weatherLoading = true;
  String? _weatherError;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en', null);

    Future.microtask(() async {
      userData = UserSession.user;

      await _loadWeatherForUser();

      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _loadWeatherForUser() async {
    setState(() {
      _weatherLoading = true;
      _weatherError = null;
    });

    try {
      final locString = userData?['location'] as String?;
      double lat = 21.5433;
      double lon = 39.1728;

      if (locString != null && locString.contains(',')) {
        final parts = locString.split(',');
        if (parts.length == 2) {
          final parsedLat = double.tryParse(parts[0].trim());
          final parsedLon = double.tryParse(parts[1].trim());
          if (parsedLat != null && parsedLon != null) {
            lat = parsedLat;
            lon = parsedLon;
          }
        }
      }

      final data = await ApiService.getWeather(latitude: lat, longitude: lon);

      setState(() {
        _weather = data;
        _weatherLoading = false;
      });
    } catch (e) {
      setState(() {
        _weatherLoading = false;
        _weatherError = e.toString();
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
      floatingActionButton: kIsWeb ? null : _buildCameraButton(),
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
            _buildManageFarmBox(),
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
    final tr = AppLocalizations.of(context)!;

    return Container(
      height: 220,
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
    final tr = AppLocalizations.of(context)!;

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
        child: _weatherLoading
            ? const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              )
            : _weatherError != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(
                    tr.unableLoadingWeather,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: _loadWeatherForUser,
                    child: Text(tr.retry, style: const TextStyle(fontSize: 12)),
                  ),
                ],
              )
            : _buildWeatherContent(),
      ),
    );
  }

  Widget _buildWeatherContent() {
    final tr = AppLocalizations.of(context)!;

    final temp = (_weather?['temperature_c'] as num?)?.toDouble() ?? 0.0;
    final humidity = (_weather?['humidity'] as num?)?.toDouble() ?? 0.0;
    final wind = (_weather?['wind_kph'] as num?)?.toDouble() ?? 0.0;
    final rain = (_weather?['rain_mm'] as num?)?.toDouble() ?? 0.0;
    final condition = _weather?['condition'] as String? ?? 'N/A';

    // Location text: لو عندك GPS نخليه "Based on your location"، غير كذا نخليه "Farm weather"
    final locString = userData?['location'] as String?;
    final locationLabel = (locString != null && locString.isNotEmpty)
        ? tr.basedOnYourLocation
        : tr.farmWeather;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Location row
        Container(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.grey[700],
                size: 14,
              ),
              const SizedBox(width: 5),
              Text(
                locationLabel,
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

        // Main row (temperature + condition + icon)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${temp.toStringAsFixed(0)}°',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      condition,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
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
                    colors: [Colors.blue[800]!, Colors.blue[900]!],
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

        // Detail cards
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildWeatherDetailCard(
                icon: Icons.wb_sunny_outlined,
                label: tr.uvIndex,
                value: tr.moderate,
                color: Colors.amber.withOpacity(0.12),
                iconColor: Colors.amber[700]!,
                textColor: Colors.amber[800]!,
              ),
              _buildWeatherDetailCard(
                icon: Icons.water_drop_outlined,
                label: tr.humidity,
                value: '${humidity.toStringAsFixed(0)}%',
                color: Colors.pink.withOpacity(0.12),
                iconColor: Colors.pink[400]!,
                textColor: Colors.pink[800]!,
              ),
              _buildWeatherDetailCard(
                icon: Icons.cloud_outlined,
                label: tr.rain,
                value: '${rain.toStringAsFixed(1)} mm',
                color: Colors.blue.withOpacity(0.12),
                iconColor: Colors.blue[400]!,
                textColor: Colors.blue[800]!,
              ),
              _buildWeatherDetailCard(
                icon: Icons.air_outlined,
                label: tr.wind,
                value: '${wind.toStringAsFixed(0)} km/h',
                color: Colors.teal.withOpacity(0.12),
                iconColor: Colors.teal[400]!,
                textColor: Colors.teal[800]!,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetailCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: iconColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ================= CLASSIFY BOX =================
  Widget _buildClassifyBox() {
    final tr = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () async {
          try {
            final cameras = await availableCameras();

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
            );
            if (cameras.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No camera available on this device'),
                ),
              );
              return;
            }

            final firstCamera = cameras.first;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CameraScreen(camera: firstCamera),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error accessing camera: $e')),
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
      ),
    );
  }

  // ================= MANAGE FARMS BOX =================
  Widget _buildManageFarmBox() {
    final tr = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FarmsManageScreen()),
          );
        },
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
                      tr.manageFarm,
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
                      tr.manageFarmDesc,
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
              Icon(Icons.arrow_forward_ios, color: Colors.green[700], size: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ================= VIEW HISTORY BOX =================
  Widget _buildViewHistoryBox() {
    final tr = AppLocalizations.of(context)!;

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
                    tr.viewHistory,
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
                    tr.viewHistoryDesc,
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
            Icon(Icons.arrow_forward_ios, color: Colors.green[700], size: 20),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.camera_alt, size: 26),
      ),
    );
  }
}
