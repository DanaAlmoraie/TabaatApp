import 'package:flutter/material.dart';
import '../../widgets/profile_header.dart';
import '../../core/user_session.dart';
import '../../l10n/app_localizations.dart';

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
  bool camera = true;
  bool location = true;

  late final List<String> avatars;
  late final String role;

  @override
  void initState() {
    super.initState();
    role = widget.userData['role'] ?? 'farmer';

    avatars = role == 'farmer'
        ? ['assets/Male-Farmer.png', 'assets/Female-Farmer.png']
        : ['assets/Male-Shopper.png', 'assets/Female-Shopper.png'];
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
                  _permissionTile(tr.cameraAccess, camera, (v) {
                    setState(() => camera = v);
                  }),
                  _permissionTile(tr.locationSharing, location, (v) {
                    setState(() => location = v);
                  }),
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
