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
import 'statistics_screen.dart';
import '../../l10n/app_localizations.dart';

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
  final TextEditingController _farmSearchController = TextEditingController();
final Set<String> _selectedFruitFilters = {};
String _distanceSort = 'none'; // none / nearest / farthest
bool _showFilters = false;

final Set<int> _selectedStatsFarmIds = {};
bool _showFarmPicker = false;

String _statsFactor = 'crops'; // crops / freshness / fruitQuantity
String? _selectedStatsFruit;
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
  void dispose() {
   _farmSearchController.dispose();
    super.dispose();
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
Transform.translate(
  offset: const Offset(0, -35),
  child: Column(
    children: [
      _buildFarmComparisonCard(),
      const SizedBox(height: 14),
      _buildClassifyBox(),
      const SizedBox(height: 18),
      _buildFarmSection(context),
    ],
  ),
),
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
List get _filteredFarms {
  final query = _farmSearchController.text.trim().toLowerCase();

  List result = farms.where((farm) {
    final name = (farm['name'] ?? '').toString().toLowerCase();
    final location = (farm['location'] ?? '').toString().toLowerCase();

    final fruits =
        (farm['fruits'] as List?)?.map((e) => e.toString()).toList() ?? [];

    final matchesSearch =
        query.isEmpty || name.contains(query) || location.contains(query);

    final matchesFruits = _selectedFruitFilters.isEmpty ||
    fruits.any((fruit) => _selectedFruitFilters.contains(fruit));

    return matchesSearch && matchesFruits;
  }).toList();

  if (_distanceSort == 'nearest') {
    result.sort((a, b) => _distanceKmValue(a).compareTo(_distanceKmValue(b)));
  } else if (_distanceSort == 'farthest') {
    result.sort((a, b) => _distanceKmValue(b).compareTo(_distanceKmValue(a)));
  }

  return result;
}

List<String> get _availableFruits {
  final Set<String> result = {};

  for (final farm in farms) {
    final fruits = (farm['fruits'] as List?)?.map((e) => e.toString()).toList() ?? [];
    result.addAll(fruits);
  }

  return result.toList()..sort();
}

double _distanceKmValue(dynamic farm) {
  if (UserSession.user['latitude'] == null ||
      UserSession.user['longitude'] == null ||
      farm['latitude'] == null ||
      farm['longitude'] == null) {
    return 0.0;
  }

  final userLat = (UserSession.user['latitude'] as num).toDouble();
  final userLng = (UserSession.user['longitude'] as num).toDouble();
  final farmLat = (farm['latitude'] as num).toDouble();
  final farmLng = (farm['longitude'] as num).toDouble();

  return Geolocator.distanceBetween(userLat, userLng, farmLat, farmLng) / 1000;
}
double _statsValue(dynamic farm) {
  if (_statsFactor == 'crops') {
    return ((farm['fruits'] as List?)?.length ?? 0).toDouble();
  }

  if (_statsFactor == 'freshness') {
    // مؤقتًا لو عندكم freshness_score من الباك اند بيستخدمه
    // إذا مو موجود يعطي قيمة 0
    return ((farm['freshness_score'] as num?)?.toDouble() ?? 0.0);
  }

  if (_statsFactor == 'fruitQuantity') {
    if (_selectedStatsFruit == null) return 0;

    final fruitCounts = farm['fruit_counts'];

    // لو عندكم fruit_counts في الداتا بيس
    if (fruitCounts is Map && fruitCounts[_selectedStatsFruit] != null) {
      return (fruitCounts[_selectedStatsFruit] as num).toDouble();
    }

    // fallback مؤقت: لو الفاكهة موجودة في farm['fruits'] نحسبها 1
    final fruits =
        (farm['fruits'] as List?)?.map((e) => e.toString()).toList() ?? [];

    return fruits.contains(_selectedStatsFruit) ? 1.0 : 0.0;
  }

  return 0;
}

String _statsLabel() {
  final tr = AppLocalizations.of(context)!;

  if (_statsFactor == 'crops') {
    return tr.compareFarmsDescription;
  }

  if (_statsFactor == 'freshness') {
    return tr.freshness;
  }

  if (_statsFactor == 'fruitQuantity') {
    return _selectedStatsFruit == null
        ? tr.selectFruits
        : '${tr.fruitAvailability}: $_selectedStatsFruit';
  }

  return '';
}

String _formatStatsValue(double value) {
  final tr = AppLocalizations.of(context)!;

  if (_statsFactor == 'freshness') {
    return '${value.toStringAsFixed(0)}%';
  }

  if (_statsFactor == 'fruitQuantity') {
    return value.toInt().toString();
  }

  return '${tr.cropCount} ${value.toInt()}';
}


int _farmId(dynamic farm) {
  return (farm['farm_id'] ?? farm['id'] ?? 0) as int;
}

List _nearestDefaultFarms() {
  final sorted = List.from(farms);

  sorted.sort((a, b) => _distanceKmValue(a).compareTo(_distanceKmValue(b)));

  return sorted.take(4).toList();
}

List _selectedComparisonFarms() {
  // Default: nearest 4 farms
  if (_selectedStatsFarmIds.isEmpty) {
    return _nearestDefaultFarms();
  }

  return farms.where((farm) {
    return _selectedStatsFarmIds.contains(_farmId(farm));
  }).toList();
}

Widget _buildFarmComparisonCard() {
  final tr = AppLocalizations.of(context)!;
  if (!UserSession.locationEnabled || loadingFarms || farms.isEmpty) {
    return const SizedBox.shrink();
  }

  final shownFarms = _selectedComparisonFarms();
  final values = shownFarms.map((farm) => _statsValue(farm)).toList();

  final maxValue = values.isEmpty
      ? 1.0
      : values.reduce((a, b) => a > b ? a : b);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
Row(
  children: [
    Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(Icons.bar_chart_rounded,
          color: Colors.orange[800], size: 22),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: Text(
        tr.farmComparison,
        style: const TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),

    // 🔥 زر الفلتر الجديد
    GestureDetector(
      onTap: () {
        setState(() {
          _showFarmPicker = !_showFarmPicker;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.25)),
        ),
        child: Icon(
          Icons.filter_list_rounded,
          color: Colors.green[800],
          size: 22,
        ),
      ),
    ),
  ],
),

          const SizedBox(height: 6),

          Text(
            _statsLabel(),
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),

          const SizedBox(height: 14),

          // Creative filter buttons
Row(
  children: [
    Expanded(
      child: _statsFilterChip(
        title: tr.cropCount,
        icon: Icons.eco_rounded,
        value: 'crops',
      ),
    ),
    const SizedBox(width: 8),
    Expanded(
      child: _statsFilterChip(
        title: tr.freshness,
        icon: Icons.verified_rounded,
        value: 'freshness',
      ),
    ),
    const SizedBox(width: 8),
    Expanded(
      child: _statsFilterChip(
        title: tr.fruitAvailability,
        icon: Icons.shopping_basket_rounded,
        value: 'fruitQuantity',
      ),
    ),
  ],
),

          const SizedBox(height: 18),
          if (_statsFactor == 'fruitQuantity') ...[
  const SizedBox(height: 12),

  Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.orange[50],
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.orange.withOpacity(0.25)),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedStatsFruit,
        hint: Text(tr.selectFruits),
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.orange[800]),
        items: _availableFruits.map((fruit) {
          return DropdownMenuItem<String>(
            value: fruit,
            child: Text(fruit),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedStatsFruit = value;
          });
        },
      ),
    ),
  ),
],
const SizedBox(height: 12),


if (_showFarmPicker) ...[
  const SizedBox(height: 10),
  _buildFarmSelectionPanel(),
],

if (_selectedStatsFarmIds.isNotEmpty && shownFarms.length < 2)
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.red[50],
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.red.withOpacity(0.25)),
    ),
    child: Text(
      tr.selectedFarms,
      style: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w600,
      ),
    ),
  )
else
  Column(
    children: List.generate(shownFarms.length, (index) {
      final farm = shownFarms[index];
      final value = values[index];

      final farmName = (farm['name'] ?? 'Unknown Farm').toString();

      final percent = maxValue == 0 ? 0.0 : value / maxValue;

      return Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: _statisticsBarItem(
          farmName: farmName,
          valueText: _formatStatsValue(value),
          percent: percent,
          index: index,
        ),
      );
    }),
  ),

        ],
      ),
    ),
  );
}

Widget _buildFarmSelectionPanel() {
  final tr = AppLocalizations.of(context)!;
  final sortedFarms = List.from(farms)
    ..sort((a, b) => _distanceKmValue(a).compareTo(_distanceKmValue(b)));

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.green.withOpacity(0.15)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr.selectedFarms,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.green[900],
          ),
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sortedFarms.map<Widget>((farm) {
            final id = _farmId(farm);
            final name = (farm['name'] ?? tr.unknownFarm).toString();
            final selected = _selectedStatsFarmIds.contains(id);

            return FilterChip(
              label: Text(name),
              selected: selected,
              selectedColor: Colors.green[100],
              checkmarkColor: Colors.green[900],
              onSelected: (value) {
                setState(() {
                  if (value) {
                    if (_selectedStatsFarmIds.length >= 5) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(tr.compareUpTo5),
                        ),
                      );
                      return;
                    }

                    _selectedStatsFarmIds.add(id);
                  } else {
                    _selectedStatsFarmIds.remove(id);
                  }
                });
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedStatsFarmIds.clear();
                });
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(tr.useNearest4),
            ),

            const Spacer(),

            Text(
              _selectedStatsFarmIds.isEmpty
                  ? tr.defaultSelection
                  :tr.selectedOutOfFive(_selectedStatsFarmIds.length.toString()),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        if (_selectedStatsFarmIds.isNotEmpty &&
            _selectedStatsFarmIds.length < 2)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              tr.selectAtLeast2Farms,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    ),
  );
}
Widget _statsFilterChip({
  required String title,
  required IconData icon,
  required String value,
}) {
  final bool selected = _statsFactor == value;

  return GestureDetector(
onTap: () {
  setState(() {
    _statsFactor = value;

    if (_statsFactor == 'fruitQuantity' &&
        _selectedStatsFruit == null &&
        _availableFruits.isNotEmpty) {
      _selectedStatsFruit = _availableFruits.first;
    }
  });
},
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: selected ? null : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? Colors.orange : Colors.grey.withOpacity(0.25),
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: selected ? Colors.white : Colors.grey[700],
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : Colors.grey[700],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _statisticsBarItem({
  required String farmName,
  required String valueText,
  required double percent,
  required int index,
}) {
  final colors = [
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.pinkAccent,
    Colors.purple,
  ];

  final barColor = colors[index % colors.length];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              farmName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: barColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              valueText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: barColor,
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 7),

      Stack(
        children: [
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          FractionallySizedBox(
            widthFactor: percent.clamp(0.05, 1.0),
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildStatRow(String label, String value, Color color) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget _buildFarmFilters() {
  final fruits = _availableFruits;

  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _farmSearchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search farms...',
                prefixIcon: Icon(Icons.search, color: Colors.green[700]),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                filled: true,
                fillColor: Colors.green[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.green.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.green.withOpacity(0.2)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(Icons.tune, color: Colors.green[800]),
          ),
        ],
      ),

      if (_showFilters) ...[
        const SizedBox(height: 12),

        // Distance filter
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Sort by distance',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
            ),
          ),
        ),
        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('None'),
              selected: _distanceSort == 'none',
              selectedColor: Colors.green[100],
              onSelected: (_) {
                setState(() => _distanceSort = 'none');
              },
            ),
            ChoiceChip(
              label: const Text('Nearest first'),
              selected: _distanceSort == 'nearest',
              selectedColor: Colors.green[100],
              onSelected: (_) {
                setState(() => _distanceSort = 'nearest');
              },
            ),
            ChoiceChip(
              label: const Text('Farthest first'),
              selected: _distanceSort == 'farthest',
              selectedColor: Colors.green[100],
              onSelected: (_) {
                setState(() => _distanceSort = 'farthest');
              },
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Fruit filter
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Filter by available fruits',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
            ),
          ),
        ),
        const SizedBox(height: 8),

        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _selectedFruitFilters.isEmpty,
                selectedColor: Colors.green[100],
                onSelected: (_) {
                  setState(() => _selectedFruitFilters.clear());
                },
              ),
              ...fruits.map((fruit) {
                final selected = _selectedFruitFilters.contains(fruit);

                return FilterChip(
                  label: Text(fruit),
                  selected: selected,
                  selectedColor: Colors.green[100],
                  checkmarkColor: Colors.green[900],
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        _selectedFruitFilters.add(fruit);
                      } else {
                        _selectedFruitFilters.remove(fruit);
                      }
                    });
                  },
                );
              }),
            ],
          ),
        ),
      ],
    ],
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

_buildFarmFilters(),

const SizedBox(height: 12),

if (_filteredFarms.isEmpty)
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Center(
      child: Text(
        'No farms match your filters',
        style: TextStyle(color: Colors.grey[700]),
      ),
    ),
  )
else
  Column(
    children: _filteredFarms.take(3).map<Widget>((farm) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
child: _buildFarmListItemDynamic(
  farm: farm,
  name: farm['name']?.toString() ?? tr.unknownFarm,
  location: farm['location']?.toString() ?? tr.unknownLocation,
  fruits: (farm['fruits'] as List?)?.map((e) => e.toString()).toList() ?? [],
  distance: _calculateDistance(
    (farm['latitude'] as num?)?.toDouble() ?? 0.0,
    (farm['longitude'] as num?)?.toDouble() ?? 0.0,
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
  required dynamic farm,
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

    const SizedBox(height: 8),

    InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>StatisticsScreen()
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.orange.withOpacity(0.25)),
        ),
        child: Icon(
          Icons.dashboard_rounded,
          size: 17,
          color: Colors.orange[800],
        ),
      ),
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
