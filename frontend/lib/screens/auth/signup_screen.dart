// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/core/main_shell.dart';
import 'package:frontend/main.dart';
import 'package:geolocator/geolocator.dart';
import '../../l10n/app_localizations.dart';
import '../../../services/api_service.dart';
import 'login_screen.dart';

// ألوان موحدة مع شاشة تسجيل الدخول
const Color kGreenTop = Color.fromARGB(255, 90, 128, 90);
const Color kGreenBottom = Color.fromARGB(255, 60, 156, 78);
const Color kPrimaryOrange = Color(0xFFFF9F1C);
const Color kBgColor = Color(0xFFF4F6F8);

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedRole; // Farmer / Shopper
  bool _shareLocation = false;
  bool _isSubmitting = false;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  double? _userLatitude;
  double? _userLongitude;

  bool _isGettingLocation = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _languageButton(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return GestureDetector(
      onTap: () {
        if (isArabic) {
          TaabatApp.setLocale(context, const Locale('en'));
        } else {
          TaabatApp.setLocale(context, const Locale('ar'));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isArabic ? "EN" : "ع",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kGreenBottom, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Future<bool> _ensureLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied.')),
      );
      return false;
    }

    return true;
  }

  Future<bool> _getCurrentLocation() async {
    final tr = AppLocalizations.of(context)!;
    final ok = await _ensureLocationPermission();
    if (!ok) return false;

    setState(() => _isGettingLocation = true);

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10));

      if (!mounted) return false;

      setState(() {
        _userLatitude = position.latitude;
        _userLongitude = position.longitude;
        _isGettingLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Location saved: (${_userLatitude!.toStringAsFixed(5)}, ${_userLongitude!.toStringAsFixed(5)})',
          ),
        ),
      );

      return true;
    } catch (_) {
      if (!mounted) return false;

      setState(() => _isGettingLocation = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr.couldNotGetLocation)));
      return false;
    }
  }

  Future<void> _submitSignup() async {
    final tr = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRole == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr.selectRoleError)));
      return;
    }

    // ✅ لو اليوزر فعّل مشاركة اللوكيشن وما انحفظت الإحداثيات لسه
    if (_shareLocation && (_userLatitude == null || _userLongitude == null)) {
      await _getCurrentLocation(); // حاول يجيبها الآن

      if (_userLatitude == null || _userLongitude == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(tr.pleaseEnableLocation)));
        return;
      }
    }

    setState(() => _isSubmitting = true);

    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final userJson = await ApiService.registerUser(
        name: name,
        email: email,
        password: password,
        role: _selectedRole!,
        shareLocation: _shareLocation,
        latitude: _userLatitude,
        longitude: _userLongitude,
      );

      (userJson['role'] ?? '').toString().toLowerCase().trim();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainShell()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${tr.registrationFailed}:$e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER – نفس ألوان Sign In وبنفس الـ radius
              Container(
                width: double.infinity,
                height: 190,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kGreenTop, kGreenBottom],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Stack(
                  children: [
                    PositionedDirectional(
                      top: 10,
                      end: 10,
                      child: _languageButton(context),
                    ),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/tabbat_logo.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr.signUp,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tr.createAccount,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // CARD
              Transform.translate(
                offset: const Offset(0, -40),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 22,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 4),

                          // Name
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              tr.fullName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _nameController,
                            decoration: _fieldDecoration(tr.enterFullName),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return tr.enterFullName;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // Email
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              tr.email,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _fieldDecoration(tr.emailHint),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return tr.enterEmail;
                              }
                              final emailRegex = RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                return tr.validEmail;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // Password
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              tr.password,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: _fieldDecoration(tr.password).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 20,
                                  color: Colors.grey.shade500,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return tr.password;
                              }
                              if (value.length < 8) {
                                return tr.password8Chars;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // Confirm Password
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              tr.confirmPassword,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: _fieldDecoration(tr.reEnterPassword)
                                .copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 20,
                                      color: Colors.grey.shade500,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return tr.confirmPassword;
                              }
                              if (value != _passwordController.text) {
                                return tr.passwordsNotMatch;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // Role Dropdown
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              tr.role,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            decoration: _fieldDecoration(tr.selectRole),
                            value: _selectedRole,
                            items: [
                              DropdownMenuItem(
                                value: 'Farmer',
                                child: Text(tr.farmer),
                              ),
                              DropdownMenuItem(
                                value: 'Shopper',
                                child: Text(tr.shopper),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return tr.selectRoleError;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _shareLocation,
                                activeColor: kGreenBottom,
                                onChanged: (value) async {
                                  if (value == null) return;

                                  if (value) {
                                    setState(() {
                                      _shareLocation = true;
                                      _isSubmitting =
                                          true; // نخلي زر التسجيل يقفل مؤقتًا
                                    });

                                    await _getCurrentLocation();

                                    if (!mounted) return;
                                    setState(() => _isSubmitting = false);

                                    if (_userLatitude == null ||
                                        _userLongitude == null) {
                                      setState(() => _shareLocation = false);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(tr.couldNotGetLocation),
                                        ),
                                      );
                                    }
                                  } else {
                                    setState(() {
                                      _shareLocation = false;
                                      _userLatitude = null;
                                      _userLongitude = null;
                                    });
                                  }
                                },
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        tr.shareMyGPSLocation,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                    if (_isGettingLocation)
                                      const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Sign Up Button
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _submitSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryOrange,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      tr.signUp,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Already have account → Sign In
              Transform.translate(
                offset: const Offset(0, -28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tr.haveAccount, style: const TextStyle(fontSize: 13)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        tr.login,
                        style: const TextStyle(
                          fontSize: 13,
                          color: kGreenBottom,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
