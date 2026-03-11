import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../l10n/app_localizations.dart';

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
    final tr = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(tr.pickFarmLocation)),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(21.4858, 39.1925), // جدة كمثال
          zoom: 12,
        ),
        onTap: (LatLng pos) {
          setState(() {
            _picked = pos;
            _marker = Marker(markerId: const MarkerId("picked"), position: pos);
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
                    Navigator.pop(context, _picked);
                  },
            child: Text(tr.confirm),
          ),
        ),
      ),
    );
  }
}
