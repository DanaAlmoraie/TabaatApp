import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> ensureLocationPermission() async {
    // هل خدمة الـ GPS شغّالة؟
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) return false;

    if (permission == LocationPermission.deniedForever) {
      // لازم يروح Settings
      return false;
    }

    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    final ok = await ensureLocationPermission();
    if (!ok) return null;

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}