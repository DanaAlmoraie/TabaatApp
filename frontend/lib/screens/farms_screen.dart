import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FarmsPage extends StatefulWidget {
  const FarmsPage({super.key});

  @override
  State<FarmsPage> createState() => _FarmsPageState();
}

class _FarmsPageState extends State<FarmsPage> {
  GoogleMapController? mapController;

  // Jeddah's location, needs to be changed later
  final LatLng initialPosition = const LatLng(21.543333, 39.172778);

  // Example Farms, maybe needs to be changed later also
  final Set<Marker> farmMarkers = {
    const Marker(
      markerId: MarkerId('farm1'),
      position: LatLng(21.60, 39.20),
      infoWindow: InfoWindow(title: "Orange Farm", snippet: "Fresh Oranges"),
    ),
    const Marker(
      markerId: MarkerId('farm2'),
      position: LatLng(21.55, 39.18),
      infoWindow: InfoWindow(title: "Dtae Farm", snippet: "Best Ajua Date"),
    ),
    const Marker(
      markerId: MarkerId('farm3'),
      position: LatLng(21.50, 39.25),
      infoWindow: InfoWindow(
        title: "Banana Farm",
        snippet: "The yellowish Banana Farm",
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Farms"),
        backgroundColor: Colors.green,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 11.5,
        ),
        markers: farmMarkers,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
