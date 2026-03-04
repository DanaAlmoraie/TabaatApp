import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../l10n/app_localizations.dart';
import 'package:frontend/services/api_service.dart';
import '../../moldels/farm_model.dart';
import 'package:frontend/services/maps/pick_location_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  bool isOpen = true;
  double? _farmLat;
  double? _farmLng;
  bool _gettingLocation = false;

  // =============================================== TRANSLATE
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
    final farm = widget.farm;

    nameController = TextEditingController(text: farm != null ? farm.name : '');

    locationController = TextEditingController(
      text: farm != null ? farm.location : '',
    );
    selectedFruits = widget.farm?.fruits ?? [];
    isOpen = widget.farm?.isOpen ?? true; // default = visible
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    super.dispose();
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

  Future<bool> _ensureLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
      return false;
    }
    return true;
  }

  Future<void> _useCurrentLocationForFarm() async {
    final ok = await _ensureLocationPermission();
    if (!ok) return;

    setState(() => _gettingLocation = true);

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;
      setState(() {
        _farmLat = pos.latitude;
        _farmLng = pos.longitude;
      });

      // =============================================== TRANSLATE
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Farm GPS set: ${_farmLat}, ${_farmLng}')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not get current location')),
      );
      // =============================================== TRANSLATE
    } finally {
      if (mounted) setState(() => _gettingLocation = false);
    }
  }

  Future<void> _pickLocationFromMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PickLocationMap()),
    );

    if (result == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No Lcation selected')));
      return;
    }

    // picked المفروض يكون LatLng
    setState(() {
      _farmLat = (result as LatLng).latitude;
      _farmLng = (result as LatLng).longitude;
    });
    // =============================================== TRANSLATE
    debugPrint("PICKED FARM => $_farmLat, $_farmLng");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Farm GPS set: $_farmLat, $_farmLng')),
    );
  }

  Widget gradientButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text(widget.farm == null ? tr.addFarm : tr.editFarm),
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
                      return tr.farmNameRequired;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: tr.farmName,
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
                      return tr.locationRequired;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: tr.location,
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

                const SizedBox(height: 14),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Farm Location (GPS) *',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
                // =============================================== TRANSLATE
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: gradientButton(
                        onPressed: _gettingLocation
                            ? null
                            : _useCurrentLocationForFarm,
                        icon: Icons.my_location,
                        label: _gettingLocation
                            ? 'Getting...'
                            : 'Current Location',
                        // =============================================== TRANSLATE
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: gradientButton(
                        onPressed: _pickLocationFromMap,
                        icon: Icons.map,
                        label: 'Pick on Map',
                        // =============================================== TRANSLATE                        label: 'Pick on Map',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Text(
                    // =============================================== TRANSLATE
                    _farmLat == null || _farmLng == null
                        ? 'No GPS selected yet'
                        : 'Selected: $_farmLat , $_farmLng',
                    style: const TextStyle(fontSize: 12),
                  ),
                  // =============================================== TRANSLATE
                ),

                const SizedBox(height: 20),
                // ================= FRUITS =================
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr.selectFruits,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr.visibleToShoppers,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          tr.disableArchiveFarm,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    gradientSwitch(
                      value: isOpen,
                      onChanged: (val) {
                        setState(() {
                          isOpen = val;
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
                          SnackBar(
                            content: Text(tr.selectAtLeastOneFruit),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      try {
                        if (_farmLat == null || _farmLng == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please set farm GPS (Current location or Pick on map)',
                              ),
                              // =============================================== TRANSLATE
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        await ApiService.addFarm(
                          name: nameController.text.trim(),
                          location: locationController.text
                              .trim(), // نص وصف للمكان
                          fruits: selectedFruits,
                          isOpen: isOpen,
                          latitude: _farmLat!,
                          longitude: _farmLng!,
                        );

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(tr.farmAddedSuccess)),
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
                    child: Text(
                      tr.saveFarm,
                      style: const TextStyle(
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
