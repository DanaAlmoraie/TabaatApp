import 'package:flutter/material.dart';
import 'package:frontend/core/role_router.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/widgets/profile_header.dart';
import 'personal_data_screen.dart';
import 'permissions_data_screen.dart';
import '../../core/user_session.dart';
import '../../l10n/app_localizations.dart';

const Color kGreenTop = Color.fromARGB(255, 90, 128, 90);
const Color kGreenBottom = Color.fromARGB(255, 60, 156, 78);
const Color kPrimaryOrange = Color(0xFFFF9F1C);
const Color kBgColor = Color(0xFFF4F6F8);

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const ProfilePage({super.key, required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  /*
  void _changeLanguage(BuildContext context, String langCode) {
    MyApp.setLocale(context, locale(langCode));
  }
  */
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedAvatar = UserSession.avatarIndex;
  late final List<String> avatars;
  late final String role;
  late String userName;

  @override
  void initState() {
    super.initState();

    userName = widget.userData['name'] ?? 'User';
    role = widget.userData['role'] ?? 'farmer';

    avatars = role == 'farmer'
        ? ['assets/Male-Farmer.png', 'assets/Female-Farmer.png']
        : ['assets/Male-Shopper.png', 'assets/Female-Shopper.png'];
  }

  // --------------------- Avatar Picker -----------------------
  void _showAvatarPicker(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    int tempIndex = selectedAvatar;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tr.chooseAvatar,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(avatars.length, (index) {
                      final isSelected = tempIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            tempIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.orange
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(avatars[index]),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedAvatar = tempIndex;
                          UserSession.setAvatar(tempIndex);
                        });
                        Navigator.pop(context);
                      },
                      child: Text(tr.confirm),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmLogout() {
    final tr = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.logout),
        content: Text(tr.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              UserSession.logout();

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: Text(tr.logout),
          ),
        ],
      ),
    );
  }

  // ================= LOGOUT BUTTON =================
  Widget _logoutButton() {
    final tr = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: _confirmLogout,
      child: Container(
        width: 130,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF9F1C), Color(0xFFFF7A00)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              tr.logout,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 36,
            decoration: BoxDecoration(
              color: active
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: active ? Colors.amber : Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // ================= NAV BAR =================
  Widget _buildBottomNavBar() {
    final tr = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navItem(
              icon: Icons.grid_view_outlined,
              label: tr.home,
              active: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => getHomeByRole()),
                );
              },
            ),
            _navItem(
              icon: Icons.person,
              label: tr.profile,
              active: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
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
              pageTitle: tr.profile,
              userName: userName,
              avatar: Stack(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundImage: AssetImage(avatars[selectedAvatar]),
                    backgroundColor: Colors.white,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showAvatarPicker(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: kPrimaryOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 70),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _mainButton(
                    icon: Icons.person,
                    title: tr.personalData,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PersonalDataPage(userData: widget.userData),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  _mainButton(
                    icon: Icons.security,
                    title: tr.permissions,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PermissionsPage(userData: widget.userData),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  _logoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(colors: [kGreenTop, kGreenBottom]),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
