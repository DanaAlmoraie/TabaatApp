// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:frontend/moldels/farm_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/utils/fruit_translator.dart';
import 'add_edit_farm_screen.dart';
import '../../l10n/app_localizations.dart';

class FarmsManageScreen extends StatefulWidget {
  const FarmsManageScreen({super.key});

  @override
  State<FarmsManageScreen> createState() => _FarmsManageScreenState();
}

class _FarmsManageScreenState extends State<FarmsManageScreen> {
  List myFarms = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMyFarms();
  }

  Future<void> loadMyFarms() async {
    try {
      final data = await ApiService.getMyFarms();
      setState(() {
        myFarms = data;
        loading = false;
      });
      print(data);
    } catch (e) {
      loading = false;
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load Farms $e')));
    }
  }

  void _openAddEditFarm({Map<String, dynamic>? farm}) async {
    Farm? farmModel;

    if (farm != null) {
      List<String> fruits = [];

      if (farm['fruits'] != null) {
        fruits = List<String>.from(
          (farm['fruits'] as List).map((e) => e.toString()),
        );
      }

      farmModel = Farm(
        id: farm['farm_id'] ?? farm['id'],
        name: farm['name'],
        location: farm['location'],
        fruits: fruits,
        isOpen: farm['is_open'] ?? true,
        latitude: (farm['latitude'] as num?)?.toDouble(),
        longitude: (farm['longitude'] as num?)?.toDouble(),
      );
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditFarmScreen(farm: farmModel)),
    );
    loadMyFarms();
    print("OPEN ADD EDIT FARM");
  }

  Future<void> _deleteFarm(int farmId) async {
    final tr = AppLocalizations.of(context)!;

    try {
      await ApiService.deleteFarm(farmId);
      loadMyFarms();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${tr.deleteFailed}: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),

      // ===== AppBar =====
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              tr.manageFarm,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),

      // ===== Body =====
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : myFarms.isEmpty
          ? Center(child: Text(tr.noFarmsYet))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 90),
              itemCount: myFarms.length,
              itemBuilder: (context, index) {
                final farm = myFarms[index];
                print(farm);
                final String name = (farm['name'] ?? tr.unnamedFarm).toString();
                final String location = (farm['location'] ?? tr.noLocation)
                    .toString();
                final bool isOpen = (farm['is_open'] ?? false) == true;

                final double? lat = (farm['latitude'] as num?)?.toDouble();
                final double? lng = (farm['longitude'] as num?)?.toDouble();

                List<String> fruits = [];
                final rawFruits = farm['fruits'];
                if (rawFruits != null) {
                  if (rawFruits is List) {
                    fruits = rawFruits.map((e) => e.toString()).toList();
                  } else if (rawFruits is String) {
                    fruits = rawFruits.split(',');
                  }
                }

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black.withOpacity(0.06)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== Top Row =====
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Status + Location
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isOpen
                                            ? Colors.green.withOpacity(0.12)
                                            : Colors.grey.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(
                                          color: isOpen
                                              ? Colors.green.withOpacity(0.35)
                                              : Colors.grey.withOpacity(0.35),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isOpen
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            size: 16,
                                            color: isOpen
                                                ? Colors.green[800]
                                                : Colors.grey[700],
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            isOpen ? tr.open : tr.closed,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: isOpen
                                                  ? Colors.green[800]
                                                  : Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        location,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // ===== Actions =====
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Color.fromARGB(255, 45, 119, 49),
                                ),
                                onPressed: () => _openAddEditFarm(farm: farm),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Color.fromARGB(255, 212, 56, 44),
                                ),
                                onPressed: () {
                                  final farmId = farm['farm_id'] ?? farm['id'];
                                  if (farmId != null) {
                                    _deleteFarm(farmId);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ===== GPS =====
                      if (lat != null && lng != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.06),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.place,
                                size: 16,
                                color: Colors.green[800],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${tr.gps}: $lat , $lng',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (lat != null && lng != null)
                        const SizedBox(height: 10),

                      // ===== Fruits =====
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: fruits.isEmpty
                            ? [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    tr.noFruitAdded,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange[800],
                                    ),
                                  ),
                                ),
                              ]
                            : fruits.map<Widget>((f) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    FruitTranslator.translate(f.toString(), tr),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[900],
                                    ),
                                  ),
                                );
                              }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),

      // ===== Bottom Button =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              tr.addFarm,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => _openAddEditFarm(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
