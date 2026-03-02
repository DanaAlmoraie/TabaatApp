import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickLocationMap extends StatefulWidget {
  const PickLocationMap({super.key});

  @override
  State<PickLocationMap> createState() => _PickLocationMapState();
}

class _PickLocationMapState extends State<PickLocationMap> {
  LatLng? _picked;
  Marker? _marker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Farm Location")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(21.4858, 39.1925), // جدة كمثال
          zoom: 12,
        ),
        onTap: (LatLng pos) {
          setState(() {
            _picked = pos;
            _marker = Marker(
              markerId: const MarkerId("picked"),
              position: pos,
            );
          });
        },
        markers: _marker == null ? {} : {_marker!},
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: _picked == null
                ? null
                : () {
                    // ✅ هذا أهم سطر
                    Navigator.pop(context, _picked);
                  },
            child: const Text("Confirm"),
          ),
        ),
      ),
    );
  }
}