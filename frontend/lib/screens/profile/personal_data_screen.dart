import 'package:flutter/material.dart';
import 'package:frontend/core/user_session.dart';
import 'package:frontend/services/api_service.dart';
import '../../widgets/profile_header.dart';

const Color kGreenTop = Color.fromARGB(255, 90, 128, 90);
const Color kGreenBottom = Color.fromARGB(255, 60, 156, 78);
const Color kPrimaryOrange = Color(0xFFFF9F1C);
const Color kBgColor = Color(0xFFF4F6F8);

class PersonalDataPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PersonalDataPage({super.key, required this.userData});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController phoneNum;
  late TextEditingController password;

  late final List<String> avatars;
  late final String role;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.userData['name'] ?? '');
    email = TextEditingController(text: widget.userData['email'] ?? '');
    phoneNum = TextEditingController(text: widget.userData['phoneNum'] ?? '');
    password = TextEditingController();

    role = widget.userData['role'] ?? 'farmer';

    avatars = role == 'farmer'
        ? ['assets/Male-Farmer.png', 'assets/Female-Farmer.png']
        : ['assets/Male-Shopper.png', 'assets/Female-Shopper.png'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Column(
          children: [
            buildProfileHeader(
              pageTitle: 'Personal Data',
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
                  _field('Name', name),
                  _field('Email', email),
                  _field('Phone Number', phoneNum),
                  _field('New Password', password, obscure: true),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () async {
                        final token = UserSession.token;
                        if (name.text.trim().length < 3) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Name too short")),
                          );
                          return;
                        }
                        final emailRegex = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );
                        if (!emailRegex.hasMatch(email.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Invalid email")),
                          );
                          return;
                        }
                        try {
                          await ApiService.updateUserProfile(
                            name: name.text.trim(),
                            email: email.text.trim(),
                            password: password.text.isEmpty
                                ? null
                                : password.text,
                            token: token,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
