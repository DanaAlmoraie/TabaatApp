import 'package:flutter/material.dart';

import 'package:frontend/core/mock_farms_db.dart';
import 'package:frontend/services/api_service.dart';
import 'farm_model.dart';

class AddEditFarmScreen extends StatefulWidget {
  final Farm? farm;
  const AddEditFarmScreen({super.key, this.farm});

  @override
  State<AddEditFarmScreen> createState() => _AddEditFarmScreenState();
}

class _AddEditFarmScreenState extends State<AddEditFarmScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController locationController;
  bool isArchived = false;

  // Predefined list of fruits
  final List<String> allFruits = [
    'Apple',
    'Banana',
    'Majdool Dates',
    'Asil Dates',
    'Sukary Dates',
    'Orange',
    'Kiwi',
    'Grapes',
    'Strawberry',
    'Lemon',
  ];

  List<String> selectedFruits = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.farm?.name ?? '');
    locationController = TextEditingController(
      text: widget.farm?.location ?? '',
    );
    selectedFruits = widget.farm?.fruits ?? [];
    isArchived = widget.farm?.isArchived ?? false;
  }

  // ================= GRADIENT SWITCH =================
  Widget gradientSwitch({
    required bool value,
    required Function(bool) onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 60,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: value
              ? const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                )
              : LinearGradient(colors: [Colors.grey[400]!, Colors.grey[500]!]),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text(widget.farm == null ? 'Add Farm' : 'Edit Farm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ================= FARM NAME =================
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Farm name is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Farm Name *',
                    labelStyle: TextStyle(color: Colors.green[700]),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[800]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green[700]!.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ================= LOCATION =================
                TextFormField(
                  controller: locationController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Location is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Location (City, Area, Street) *',
                    labelStyle: TextStyle(color: Colors.green[700]),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[800]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green[700]!.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ================= FRUITS =================
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Fruits *',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: allFruits.map((fruit) {
                    final isSelected = selectedFruits.contains(fruit);
                    return FilterChip(
                      label: Text(
                        fruit,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.green[800],
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.green[700],
                      backgroundColor: Colors.green[50],
                      checkmarkColor: Colors.white,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            selectedFruits.add(fruit);
                          } else {
                            selectedFruits.remove(fruit);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // ================= ARCHIVE SWITCH =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Visible to shoppers',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Disable to archive the farm',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    gradientSwitch(
                      value: !isArchived,
                      onChanged: (val) {
                        setState(() {
                          isArchived = !val;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ================= SAVE BUTTON =================
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate form
                      if (!_formKey.currentState!.validate()) return;

                      // Validate fruits
                      if (selectedFruits.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select at least one fruit'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      try {
                        await ApiService.addFarm(
                          // Save logic
                          name: nameController.text.trim(),
                          location: locationController.text.trim(),
                          fruits: selectedFruits,
                          isArchived: isArchived,
                        );

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Farm added successfully"),
                          ),
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Error: $e")));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      elevation: 6,
                      shadowColor: Colors.green.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Save Farm',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
