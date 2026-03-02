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

  final String name = (farm['name'] ?? 'Unnamed Farm').toString();
  final String location = (farm['location'] ?? 'No location').toString();
  final bool isOpen = (farm['is_open'] ?? false) == true;

  final double? lat = (farm['latitude'] as num?)?.toDouble();
  final double? lng = (farm['longitude'] as num?)?.toDouble();

  final List fruits = (farm['fruits'] ?? []) as List;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        // ====== Top row: Name + Status + Actions ======
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isOpen
                                ? Colors.green.withOpacity(0.35)
                                : Colors.grey.withOpacity(0.35),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isOpen ? Icons.visibility : Icons.visibility_off,
                              size: 16,
                              color: isOpen ? Colors.green[800] : Colors.grey[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isOpen ? 'Open' : 'Closed',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isOpen ? Colors.green[800] : Colors.grey[700],
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

            // Actions
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
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Delete failed: $e")),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),

        // ====== GPS Row (اختياري) ======
        if (lat != null && lng != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withOpacity(0.06)),
            ),
            child: Row(
              children: [
                Icon(Icons.place, size: 16, color: Colors.green[800]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'GPS: $lat , $lng',
                    style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

        if (lat != null && lng != null) const SizedBox(height: 10),

        // ====== Fruits chips ======
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: fruits.isEmpty
              ? [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Text(
                      'No fruits added',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[800],
                      ),
                    ),
                  )
                ]
              : fruits.map<Widget>((f) {
                  final txt = f.toString();
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.green.withOpacity(0.25)),
                    ),
                    child: Text(
                      txt,
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
