import 'package:flutter/material.dart';
import 'farm_model.dart';
import '../core/mock_farms_db.dart';

class FarmsPage extends StatelessWidget {
  const FarmsPage({super.key});

  @override
  Widget build(BuildContext context) {
    /// المزارع المتاحة فقط
    final List<Farm> visibleFarms = MockFarmsDB.farms
        .where((farm) => farm.isArchived == false)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),

      appBar: AppBar(
        title: const Text("Explore Farms"),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF8C00),
      ),

      body: visibleFarms.isEmpty
          ? const Center(
              child: Text(
                "No farms available yet",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: visibleFarms.length,
              itemBuilder: (context, index) {
                final farm = visibleFarms[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      /// أيقونة المزرعة
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Image.asset(
                          'Farm-Location.png',
                          height: 35,
                          width: 35,
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// معلومات المزرعة
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              farm.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              farm.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),

                            const SizedBox(height: 8),

                            Wrap(
                              spacing: 6,
                              children: farm.fruits.map((fruit) {
                                return Chip(
                                  label: Text(
                                    fruit,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  backgroundColor: Colors.green[100],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
