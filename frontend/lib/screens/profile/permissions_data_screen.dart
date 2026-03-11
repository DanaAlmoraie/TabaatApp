// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../widgets/profile_header.dart';
import '../../core/user_session.dart';
import '../../l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

const Color kGreenTop = Color.fromARGB(255, 90, 128, 90);
const Color kGreenBottom = Color.fromARGB(255, 60, 156, 78);
const Color kPrimaryOrange = Color(0xFFFF9F1C);
const Color kBgColor = Color(0xFFF4F6F8);

class PermissionsPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PermissionsPage({super.key, required this.userData});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  late final List<String> avatars;
  late final String role;
  bool camera = true;
  bool location = true;

  @override
  void initState() {
    super.initState();
    role = widget.userData['role'] ?? 'farmer';

    camera = UserSession.cameraEnabled;
    location = UserSession.locationEnabled;

    avatars = role == 'farmer'
        ? ['assets/Male-Farmer.png', 'assets/Female-Farmer.png']
        : ['assets/Male-Shopper.png', 'assets/Female-Shopper.png'];
  }

  Future<void> _toggleCamera(bool value) async {
    if (value) {
      final status = await Permission.camera.request();
      if (!status.isGranted) return;
    }

    await UserSession.setCameraPermission(value);

    setState(() {
      camera = value;
    });
  }

  Future<void> _toggleLocation(bool value) async {
    if (value) {
      final status = await Permission.location.request();
      if (!status.isGranted) return;
    }

    await UserSession.setLocationPermission(value);

    setState(() {
      location = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Column(
          children: [
            buildProfileHeader(
              context: context,
              pageTitle: tr.permissions,
              userName: widget.userData['name'] ?? '',
              showBack: true,
              onBack: () => Navigator.pop(context),
              avatar: CircleAvatar(
                radius: 42,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(avatars[UserSession.avatarIndex]),
              ),
            ),

            const SizedBox(height: 70),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _permissionTile(tr.cameraAccess, camera, _toggleCamera),
                  _permissionTile(
                    tr.locationSharing,
                    location,
                    _toggleLocation,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _permissionTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: SwitchListTile(
        title: Text(title),
        value: value,
        activeColor: kPrimaryOrange,
        onChanged: onChanged,
      ),
    );
  }
}
