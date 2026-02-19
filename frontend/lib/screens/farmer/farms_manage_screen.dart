import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
import 'add_edit_farm_screen.dart';

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
    } catch (e) {
      loading = false;
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load farms: $e")));
      }
    }
  }

  void _openAddEditFarm({dynamic farm}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditFarmScreen(farm: farm)),
    );
    loadMyFarms();
  }

  Widget footerAddFarmButton() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text(
            'Add Farm',
            style: TextStyle(
              color: Color(0xFFFF8C00),
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => _openAddEditFarm(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasFarms = myFarms.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
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
            title: const Text(
              'Manage Farms',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : hasFarms
          ? ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: myFarms.length,
              itemBuilder: (context, index) {
                final farm = myFarms[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/Farm-location.png',
                          height: 35,
                          width: 35,
                          color: Colors.green,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      farm['name'] ?? 'Unnamed Farm',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),

                                  if ((farm['is_open'] ?? false) == true)
                                    const Icon(
                                      Icons.visibility_off_rounded,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              Text(
                                farm['location'] ?? 'No location',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Wrap(
                                spacing: 6,
                                children: (farm['fruits'] ?? [])
                                    .map<Widget>(
                                      (f) => Chip(
                                        label: Text(
                                          f.toString(),
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),

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

                              onPressed: () async {
                                try {
                                  await ApiService.deleteFarm(farm['farm_id']);
                                  loadMyFarms();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Delete failed: $e"),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: Text('No farms to manage yet')),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Farm',
              style: TextStyle(
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
