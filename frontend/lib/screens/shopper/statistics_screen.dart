import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';

Future<void> initializeDateFormattingForArabic() async {
  await initializeDateFormatting('ar', null);
}

class Farm {
  final String id;
  final String name;
  final String imageUrl;
  final String location;
  final double rating;
  final int ratingCount;
  final int foundedYear;
  final String farmingType;
  final List<QualityBadge> qualityBadges;

  Farm({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.rating,
    required this.ratingCount,
    required this.foundedYear,
    required this.farmingType,
    required this.qualityBadges,
  });
}

class QualityBadge {
  final String icon;
  final String label;

  QualityBadge({required this.icon, required this.label});
}

class Crop {
  final String id;
  final String name;
  final String imageUrl;
  final double quantity;
  final DateTime harvestDate;
  final String cropType;

  Crop({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.harvestDate,
    required this.cropType,
  });
}

final List<Farm> mockFarms = [
  Farm(
    id: '1',
    name: 'مزرعة النخلة الذهبية',
    imageUrl:
        'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
    location: 'القصيم، عنيزة',
    rating: 4.8,
    ratingCount: 124,
    foundedYear: 2010,
    farmingType: 'عضوي',
    qualityBadges: [
      QualityBadge(icon: '🌱', label: 'زراعة عضوية'),
      QualityBadge(icon: '🚿', label: 'ري بالتنقيط'),
      QualityBadge(icon: '☀️', label: 'تجفيف طبيعي'),
      QualityBadge(icon: '✅', label: 'معتمد رسمياً'),
      QualityBadge(icon: '🧪', label: 'بدون هرمونات'),
      QualityBadge(icon: '📋', label: 'تتبع المحصول'),
      QualityBadge(icon: '🌡️', label: 'مراقبة مستمرة'),
      QualityBadge(icon: '♻️', label: 'زراعة مستدامة'),
    ],
  ),
];

final List<Crop> mockCrops = [
  Crop(
    id: 'c1',
    name: 'تمر مجدول',
    imageUrl:
        'https://images.unsplash.com/photo-1590137876900-760f7a2e5ecb?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
    quantity: 1500,
    harvestDate: DateTime.now().subtract(const Duration(days: 2)),
    cropType: 'تمور',
  ),
  Crop(
    id: 'c2',
    name: 'رمان',
    imageUrl:
        'https://images.unsplash.com/photo-1580051846064-b25df5062d1c?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
    quantity: 800,
    harvestDate: DateTime.now().subtract(const Duration(days: 5)),
    cropType: 'فواكه',
  ),
  Crop(
    id: 'c3',
    name: 'زيتون',
    imageUrl:
        'https://images.unsplash.com/photo-1554618668-303f92b9b9e1?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
    quantity: 2200,
    harvestDate: DateTime.now().subtract(const Duration(days: 10)),
    cropType: 'زيتون',
  ),
];

String formatNumber(BuildContext context, double number) {
  final locale = Localizations.localeOf(context).languageCode;
  final format = NumberFormat('#,##0', locale);
  return format.format(number);
}

String formatDate(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).languageCode;
  final format = DateFormat.yMMMd(locale);
  return format.format(date);
}

class Skeleton extends StatelessWidget {
  final double? height;
  final double? width;
  final BorderRadius borderRadius;

  const Skeleton({
    Key? key,
    this.height,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: borderRadius,
      ),
      child: const ShimmerMask(),
    );
  }
}

class ShimmerMask extends StatefulWidget {
  const ShimmerMask({Key? key}) : super(key: key);

  @override
  _ShimmerMaskState createState() => _ShimmerMaskState();
}

class _ShimmerMaskState extends State<ShimmerMask>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade200,
                Colors.grey.shade50,
                Colors.grey.shade200,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + _controller.value * 2, 0),
              end: Alignment(1.0 + _controller.value * 2, 0),
            ),
          ),
        );
      },
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({Key? key, required this.title, this.subtitle})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textDirection: ui.TextDirection.rtl,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F4F2F),
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                subtitle!,
                textDirection: ui.TextDirection.rtl,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B8E6B)),
              ),
            ),
        ],
      ),
    );
  }
}

class CountUp extends StatefulWidget {
  final double target;
  final bool inView;
  final int decimals;

  const CountUp({
    Key? key,
    required this.target,
    required this.inView,
    this.decimals = 0,
  }) : super(key: key);

  @override
  _CountUpState createState() => _CountUpState();
}

class _CountUpState extends State<CountUp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.addListener(() {
      setState(() {
        _currentValue = _animation.value * widget.target;
      });
    });
  }

  @override
  void didUpdateWidget(CountUp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.inView && !_controller.isAnimating) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatted = widget.decimals > 0
        ? _currentValue.toStringAsFixed(widget.decimals)
        : _currentValue.round().toString();

    final locale = Localizations.localeOf(context).languageCode;
    return Text(
      NumberFormat('#,##0', locale).format(double.parse(formatted)),
      textDirection: ui.TextDirection.rtl,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class FarmHero extends StatefulWidget {
  final Farm farm;

  const FarmHero({Key? key, required this.farm}) : super(key: key);

  @override
  _FarmHeroState createState() => _FarmHeroState();
}

class _FarmHeroState extends State<FarmHero>
    with SingleTickerProviderStateMixin {
  bool _flipped = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  static const LatLng _farmCoords = LatLng(26.3271, 43.9750);
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_flipped) {
      _flipController.reverse();
      setState(() => _mapReady = false);
    } else {
      _flipController.forward();
      Timer(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _mapReady = true);
      });
    }
    setState(() => _flipped = !_flipped);
  }

  Future<void> _openGoogleMaps() async {
    final query = Uri.encodeComponent(widget.farm.location);
    final url = 'https://www.google.com/maps/search/?api=1&query=$query';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final angle = _flipAnimation.value * math.pi;
                final isFront = angle < math.pi / 2;
                final transform = Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle);
                return Transform(
                  transform: transform,
                  alignment: Alignment.center,
                  child: isFront ? _buildFront() : _buildBack(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFront() {
    final tr = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: widget.farm.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Skeleton(),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.farm.farmingType == 'عضوي'
                    ? const Color(0xFF6B8E6B).withOpacity(0.9) // أخضر فاتح
                    : const Color(0xFFC4A484).withOpacity(0.9), // بيج ناعم
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [BoxShadow(blurRadius: 10)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.eco, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    widget.farm.farmingType,
                    textDirection: ui.TextDirection.rtl,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 16,
            child: GestureDetector(
              onTap: _toggleFlip,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.map, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      tr.mapView,
                      textDirection: ui.TextDirection.rtl,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.farm.name,
                  textDirection: ui.TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 8)],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.farm.location,
                      textDirection: ui.TextDirection.rtl,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.farm.rating.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' (${widget.farm.ratingCount} ${tr.reviews})',
                      textDirection: ui.TextDirection.rtl,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white70,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${tr.founded} ${widget.farm.foundedYear}',
                      textDirection: ui.TextDirection.rtl,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    final tr = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_mapReady)
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(math.pi),
              child: Directionality(
                textDirection: ui.TextDirection.ltr,
                child: FlutterMap(
                  options: MapOptions(
                    center: _farmCoords,
                    zoom: 11,
                    maxZoom: 18,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.de/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _farmCoords,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              color: Colors.grey.shade200,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.map, color: Colors.grey, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      tr.loadingMap,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

          Positioned(
            top: 70,
            left: 16,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(math.pi),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(blurRadius: 8)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      widget.farm.location,
                      textDirection: ui.TextDirection.rtl,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.farm.name,
                      textDirection: ui.TextDirection.rtl,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1f2937),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 60,
            right: 16,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(math.pi),
              child: GestureDetector(
                onTap: _toggleFlip,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B8E6B).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF6B8E6B).withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.image, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        tr.backToFarm,
                        textDirection: ui.TextDirection.rtl,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 60,
            left: 16,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(math.pi),
              child: GestureDetector(
                onTap: _openGoogleMaps,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(blurRadius: 10)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.open_in_new,
                        size: 16,
                        color: Color(0xFF1f2937),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tr.openInMaps,
                        textDirection: ui.TextDirection.ltr,
                        style: const TextStyle(
                          color: Color(0xFF1f2937),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FarmStats extends StatelessWidget {
  final int cropTypes;
  final int availableCrops;
  final double totalQuantity;
  final int farmAge;
  final bool inView;

  const FarmStats({
    Key? key,
    required this.cropTypes,
    required this.availableCrops,
    required this.totalQuantity,
    required this.farmAge,
    required this.inView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    final stats = [
      {
        'icon': '🌱',
        'label': tr.cropTypes,
        'value': cropTypes.toDouble(),
        'suffix': tr.type,
        'desc': tr.varietyCropsGrown,
        'bgStart': 0xFF9ABF9A,
        'bgEnd': 0xFF6B8E6B,
      },
      {
        'icon': '🧺',
        'label': tr.availableCropsLabel,
        'value': availableCrops.toDouble(),
        'suffix': tr.crop,
        'desc': tr.availableSlaeNow,
        'bgStart': 0xFFA4C3A4,
        'bgEnd': 0xFF7AA57A,
      },
      {
        'icon': '📦',
        'label': tr.annualProduction,
        'value': totalQuantity,
        'suffix': tr.kiloGram,
        'desc': tr.totalProduction,
        'bgStart': 0xFF8FBC8F,
        'bgEnd': 0xFF5F9F5F,
      },
      {
        'icon': '🏡',
        'label': tr.farmAge,
        'value': farmAge.toDouble(),
        'suffix': tr.year,
        'desc': tr.fromFoundingUntilNow,
        'bgStart': 0xFFB0C4B0,
        'bgEnd': 0xFF8DAF8D,
      },
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.0,
      children: List.generate(stats.length, (index) {
        final stat = stats[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: inView ? 1 : 0),
          duration: Duration(milliseconds: 500 + index * 100),
          curve: Curves.easeOut,
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - opacity)),
                child: child,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(stat['bgStart'] as int),
                  Color(stat['bgEnd'] as int),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(stat['bgStart'] as int).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stat['icon'] as String,
                  style: const TextStyle(fontSize: 28),
                ),
                CountUp(target: stat['value'] as double, inView: inView),
                Text(
                  stat['suffix'] as String,
                  textDirection: ui.TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stat['label'] as String,
                  textDirection: ui.TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  stat['desc'] as String,
                  textDirection: ui.TextDirection.rtl,
                  style: const TextStyle(color: Colors.white70, fontSize: 9),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class CropsChart extends StatelessWidget {
  final List<Crop> crops;
  final bool inView;

  const CropsChart({Key? key, required this.crops, required this.inView})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    final maxValue = crops.map((c) => c.quantity).reduce(math.max);
    final barData = crops.map((c) => (name: c.name, value: c.quantity)).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr.cropsQuantity,
                textDirection: ui.TextDirection.rtl,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF2F4F2F),
                ),
              ),
              Row(
                children: [
                  _legendItem(const Color(0xFFE6B800), tr.highestQuantity),
                  const SizedBox(width: 12),
                  _legendItem(const Color(0xFF6B8E6B), tr.available),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 280,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.white,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.round()} ${tr.kiloGram}',
                        const TextStyle(color: Color(0xFF6B8E6B)),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < 0 ||
                            value.toInt() >= barData.length)
                          return const SizedBox();
                        final name = barData[value.toInt()].name;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            name,
                            textDirection: ui.TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF2F4F2F),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (maxValue / 4).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        final locale = Localizations.localeOf(
                          context,
                        ).languageCode;
                        return Text(
                          NumberFormat('#,##0', locale).format(value),
                          textDirection: ui.TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF2F4F2F),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: (maxValue / 4).ceilToDouble(),
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(barData.length, (i) {
                  final isMax = barData[i].value == maxValue;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: barData[i].value,
                        color: isMax
                            ? const Color(0xFFE6B800)
                            : const Color(0xFF8FBC8F).withOpacity(0.75),
                        width: 22,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              swapAnimationDuration: const Duration(milliseconds: 800),
              swapAnimationCurve: Curves.easeOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

class CropCard extends StatelessWidget {
  final Crop crop;
  final int index;

  const CropCard({Key? key, required this.crop, required this.index})
    : super(key: key);

  Map<String, dynamic> _getFreshnessStatus(AppLocalizations tr) {
    final days = DateTime.now().difference(crop.harvestDate).inDays;
    if (days <= 3) {
      return {
        'label': tr.veryFresh,
        'color': const Color(0xFFE0F0E0),
        'textColor': const Color(0xFF2F4F2F),
        'dotColor': const Color(0xFF6B8E6B),
      };
    } else if (days <= 7) {
      return {
        'label': tr.fresh,
        'color': const Color(0xFFD0E8D0),
        'textColor': const Color(0xFF2F4F2F),
        'dotColor': const Color(0xFF7AA57A),
      };
    } else if (days <= 14) {
      return {
        'label': tr.good,
        'color': const Color(0xFFC0E0C0),
        'textColor': const Color(0xFF2F4F2F),
        'dotColor': const Color(0xFF8FBC8F),
      };
    } else if (days <= 30) {
      return {
        'label': tr.acceptable,
        'color': const Color(0xFFB0D8B0),
        'textColor': const Color(0xFF2F4F2F),
        'dotColor': const Color(0xFFA0C8A0),
      };
    } else {
      return {
        'label': tr.old,
        'color': const Color(0xFFF0D0D0),
        'textColor': const Color(0xFF8B3A3A),
        'dotColor': const Color(0xFFCD5C5C),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    final freshness = _getFreshnessStatus(tr);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + index * 80),
      curve: Curves.easeOut,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - opacity)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: CachedNetworkImage(
                imageUrl: crop.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Skeleton(height: 200),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: freshness['color'],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: freshness['textColor'].withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: freshness['dotColor'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      freshness['label'],
                      textDirection: ui.TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 12,
                        color: freshness['textColor'],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                crop.name,
                textDirection: ui.TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F4F2F),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _infoRow(
                    Icons.inventory_2,
                    tr.quantity,
                    formatNumber(context, crop.quantity),
                  ),
                  _infoRow(
                    Icons.calendar_today,
                    tr.harvestDate,
                    formatDate(context, crop.harvestDate),
                  ),
                  _infoRow(Icons.category, tr.type, crop.cropType),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            label,
            textDirection: ui.TextDirection.rtl,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const Spacer(),
          Text(
            value,
            textDirection: ui.TextDirection.rtl,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F4F2F),
            ),
          ),
        ],
      ),
    );
  }
}

class QualityBadges extends StatelessWidget {
  final List<QualityBadge> badges;
  final String farmName;

  const QualityBadges({Key? key, required this.badges, required this.farmName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    final items = badges.isNotEmpty
        ? badges.take(4).toList()
        : _defaultBadges.take(4).toList();

    return Column(
      children: [
        Row(
          children: List.generate(items.length, (i) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 400 + i * 40),
                  curve: Curves.easeOut,
                  builder: (context, opacity, child) {
                    return Opacity(
                      opacity: opacity,
                      child: Transform.scale(scale: opacity, child: child),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F0E0),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF6B8E6B).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          items[i].icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[i].label,
                          textAlign: TextAlign.center,
                          textDirection: ui.TextDirection.rtl,
                          style: const TextStyle(
                            color: Color(0xFF2F4F2F),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 16),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - opacity)),
                child: child,
              ),
            );
          },
          child: GestureDetector(
            onTap: () async {
              final msg = Uri.encodeComponent(
                '${tr.whatsappMessage} $farmName',
              );
              final url = 'https://wa.me/966500000000?text=$msg';
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(blurRadius: 10, color: Color(0xFF25D366)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    tr.contactWhatsapp,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static final List<QualityBadge> _defaultBadges = [
    QualityBadge(icon: '🌱', label: 'زراعة عضوية'),
    QualityBadge(icon: '🚿', label: 'ري بالتنقيط'),
    QualityBadge(icon: '☀️', label: 'تجفيف طبيعي'),
    QualityBadge(icon: '✅', label: 'معتمد رسمياً'),
    QualityBadge(icon: '🧪', label: 'بدون هرمونات'),
    QualityBadge(icon: '📋', label: 'تتبع المحصول'),
    QualityBadge(icon: '🌡️', label: 'مراقبة مستمرة'),
    QualityBadge(icon: '♻️', label: 'زراعة مستدامة'),
  ];
}

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Farm? _farm;
  List<Crop> _crops = [];
  bool _isLoading = true;
  bool _statsInView = false;

  final _statsObserver = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeDateFormattingAndLoadData();
  }

  Future<void> _initializeDateFormattingAndLoadData() async {
    await initializeDateFormattingForArabic();
    await _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _farm = mockFarms.first;
      _crops = mockCrops;
      _isLoading = false;
    });
    _checkStatsVisibility();
  }

  void _checkStatsVisibility() {
    setState(() {
      _statsInView = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      body: _isLoading
          ? _buildLoading()
          : _farm == null
          ? _buildNoFarm(context)
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: FarmHero(farm: _farm!)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      SectionHeader(
                        title: tr.farmStats,
                        subtitle: tr.farmStatsDesc,
                      ),
                      Container(
                        key: _statsObserver,
                        child: FarmStats(
                          cropTypes: _crops
                              .map((c) => c.cropType)
                              .toSet()
                              .length,
                          availableCrops: _crops.length,
                          totalQuantity: _crops.fold(
                            0,
                            (sum, c) => sum + c.quantity,
                          ),
                          farmAge: DateTime.now().year - _farm!.foundedYear,
                          inView: _statsInView,
                        ),
                      ),
                      const SizedBox(height: 32),

                      SectionHeader(
                        title: tr.availableCrops,
                        subtitle: tr.availableCropsDesc,
                      ),
                      if (_crops.isNotEmpty)
                        CropsChart(crops: _crops, inView: _statsInView),
                      if (_crops.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _crops.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return CropCard(crop: _crops[index], index: index);
                          },
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Text('🧺', style: TextStyle(fontSize: 40)),
                              const SizedBox(height: 8),
                              Text(
                                tr.noCrops,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 32),

                      SectionHeader(
                        title: tr.qualityIndicators,
                        subtitle: tr.qualityDesc,
                      ),
                      QualityBadges(
                        badges: _farm!.qualityBadges,
                        farmName: _farm!.name,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLoading() {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Skeleton(
            height: 400,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              Row(
                children: List.generate(
                  4,
                  (index) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: Skeleton(height: 120),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Skeleton(height: 200),
              const SizedBox(height: 24),
              ...List.generate(
                3,
                (index) => const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Skeleton(height: 380),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildNoFarm(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌾', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            tr.noFarm,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(tr.noFarmDesc, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
