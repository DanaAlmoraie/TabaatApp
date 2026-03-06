import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class Nutrition {
  final String classKey; // e.g. "banana", "apple", "date_sukkari"
  final String displayName;
  final double energy; 
  final double water; 
  final double protein; 
  final double totalFat; 
  final double carbs; 
  final double fiber; 
  final double sugar; 
  final double calcium; 
  final double iron; 

  const Nutrition({
    required this.classKey,
    required this.displayName,
    required this.energy,
    required this.water,
    required this.protein,
    required this.totalFat,
    required this.carbs,
    required this.fiber,
    required this.sugar,
    required this.calcium,
    required this.iron,
  });
}


class NutritionLoader extends StatelessWidget {
  final String fruitType; // 'Banana', 'Apple', 'Medjool', 'Sukkari', 'Asail'

  const NutritionLoader({
    super.key,
    required this.fruitType,
  });

  Future<Nutrition?> _loadNutrition() async {
    final client = Supabase.instance.client;

    final fruitRow = await client
        .from('fruits')
        .select('fruit_id, fruit_type')
        .eq('fruit_type', fruitType)
        .maybeSingle();

    if (fruitRow == null) {
      debugPrint('No fruit found for type: $fruitType');
      return null;
    }

    final int fruitId = fruitRow['fruit_id'] as int;
    final String displayName = fruitRow['fruit_type'] as String;

    final nutRow = await client
        .from('nutritional_info')
        .select(
            'energy, water, protein, total_fat, carbs, fiber, sugar, calcium, iron')
        .eq('fruit_id', fruitId)
        .maybeSingle();

    if (nutRow == null) {
      debugPrint('No nutritional_info row for fruit_id: $fruitId');
      return null;
    }

    double toDouble(dynamic v) => (v as num).toDouble();

    return Nutrition(
      classKey: fruitType.toLowerCase(), 
      displayName: displayName,
      energy: toDouble(nutRow['energy']),
      water: toDouble(nutRow['water']),
      protein: toDouble(nutRow['protein']),
      totalFat: toDouble(nutRow['total_fat']),
      carbs: toDouble(nutRow['carbs']),
      fiber: toDouble(nutRow['fiber']),
      sugar: toDouble(nutRow['sugar']),
      calcium: toDouble(nutRow['calcium']),
      iron: toDouble(nutRow['iron']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Nutrition?>(
      future: _loadNutrition(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final nutrition = snapshot.data;
        if (nutrition == null) {
          return Scaffold(
            body: Center(
              child: Text('No nutrition data found for $fruitType'),
            ),
          );
        }

        
        return NutritionDetailsPage(nutrition: nutrition);
      },
    );
  }
}


class NutritionDetailsPage extends StatelessWidget {
  final Nutrition nutrition;

  const NutritionDetailsPage({
    super.key,
    required this.nutrition,
  });

  static const Color _primary = Color(0xFFFFA000); // Taabat orange

  @override
  Widget build(BuildContext context) {
    const dailyGoal = 2000.0;
    final kcalRatio = (nutrition.energy / dailyGoal).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
         
          Container(
            height: 190,
            decoration: const BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(26),
                bottomRight: Radius.circular(26),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nutrition.displayName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Nutrition information · 100 g',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ======= CONTENT UNDER HEADER =======
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 170),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 90,
                            height: 90,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: CircularProgressIndicator(
                                    value: kcalRatio,
                                    strokeWidth: 8,
                                    backgroundColor:
                                        _primary.withOpacity(0.15),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      _primary,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      nutrition.energy.toStringAsFixed(0),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'kcal',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Calories',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Approximate energy in 100 g of ${nutrition.displayName}.',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '${(kcalRatio * 100).toStringAsFixed(1)}% of a 2000 kcal daily intake',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---- Macronutrients cards ----
                    const Text(
                      'Macronutrients',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: _MacroCard(
                            label: 'Carbs',
                            value: '${nutrition.carbs.toStringAsFixed(1)} g',
                            barValue: (nutrition.carbs / 80).clamp(0, 1),
                            barColor: _primary,
                            subtitle: 'Main energy source',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MacroCard(
                            label: 'Protein',
                            value:
                                '${nutrition.protein.toStringAsFixed(1)} g',
                            barValue: (nutrition.protein / 5).clamp(0, 1),
                            barColor: const Color(0xFF66BB6A),
                            subtitle: 'Supports muscles',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MacroCard(
                            label: 'Total Fat',
                            value: '${nutrition.totalFat.toStringAsFixed(2)} g',
                            barValue: (nutrition.totalFat / 5).clamp(0, 1),
                            barColor: const Color(0xFF90A4AE),
                            subtitle: 'Overall fat amount',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ---- Fiber & Sugar card ----
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fiber & Sugar',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _MiniStat(
                                  title: 'Fiber',
                                  value:
                                      '${nutrition.fiber.toStringAsFixed(1)} g',
                                  description:
                                      'Helps digestion & satiety.',
                                  icon: Icons.grass_rounded,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _MiniStat(
                                  title: 'Sugar',
                                  value:
                                      '${nutrition.sugar.toStringAsFixed(1)} g',
                                  description: 'Natural sugar content.',
                                  icon: Icons.cake_rounded,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---- Micronutrients grid ----
                    const Text(
                      'Micronutrients',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: _MicronutrientTile(
                            label: 'Water',
                            value:
                                '${nutrition.water.toStringAsFixed(1)} g',
                            icon: Icons.water_drop_rounded,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MicronutrientTile(
                            label: 'Calcium',
                            value:
                                '${nutrition.calcium.toStringAsFixed(0)} mg',
                            icon: Icons.health_and_safety_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _MicronutrientTile(
                            label: 'Iron',
                            value:
                                '${nutrition.iron.toStringAsFixed(2)} mg',
                            icon: Icons.bloodtype_rounded,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: SizedBox.shrink(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      '* All values are approximate and based on a 100 g portion.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====== Helper widgets ======

class _MacroCard extends StatelessWidget {
  final String label;
  final String value;
  final double barValue; // 0..1
  final Color barColor;
  final String subtitle;

  const _MacroCard({
    required this.label,
    required this.value,
    required this.barValue,
    required this.barColor,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: barValue.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: const Color(0xFFF0F0F0),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String title;
  final String value;
  final String description;
  final IconData icon;

  const _MiniStat({
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: Color(0xFFFFA000),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _MicronutrientTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MicronutrientTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 18,
              color: const Color(0xFF90A4AE),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}