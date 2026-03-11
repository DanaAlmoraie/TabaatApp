import 'package:flutter/material.dart';
import 'package:frontend/core/user_session.dart';
import 'package:frontend/services/api_service.dart';
import '../../widgets/profile_header.dart';
import '../../l10n/app_localizations.dart';

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
  late final List<String> avatars;
  late final String role;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    role = widget.userData['role'] ?? 'farmer';

    avatars = role == 'farmer'
        ? ['assets/Male-Farmer.png', 'assets/Female-Farmer.png']
        : ['assets/Male-Shopper.png', 'assets/Female-Shopper.png'];

    name = TextEditingController(text: widget.userData['name']);
    email = TextEditingController(text: widget.userData['email']);
    password = TextEditingController();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            buildProfileHeader(
              context: context,
              pageTitle: tr.personalData,
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

              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // NAME
                    TextFormField(
                      controller: name,
                      decoration: _decoration(tr.name),
                      validator: (value) {
                        if (value == null || value.trim().length < 3) {
                          return tr.nameTooShort;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // EMAIL
                    TextFormField(
                      controller: email,
                      decoration: _decoration(tr.email),
                      validator: (value) {
                        if (value == null ||
                            !RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            ).hasMatch(value)) {
                          return tr.validEmail;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // PASSWORD
                    TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration: _decoration(tr.newPasswordOptional),
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length < 6) {
                          return tr.password8Chars;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    // SAVE BUTTON
                    SizedBox(
                      width: 100,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: isSaving ? null : _saveChanges,
                        child: isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                tr.saveChanges,
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SAVE FUNCTION =================

  Future<void> _saveChanges() async {
    final tr = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    try {
      final updatedUser = await ApiService.updateUserProfile(
        name: name.text.trim(),
        email: email.text.trim(),
        password: password.text.trim().isEmpty ? null : password.text.trim(),
        token: UserSession.user['token'],
      );

      // تحديث السيشن
      UserSession.updateUser(updatedUser);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr.profileupdatedsuccess)));

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isSaving = false);
    }
  }

  // INPUT STYLE
  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
