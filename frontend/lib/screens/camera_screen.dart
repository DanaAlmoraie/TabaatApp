import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:frontend/core/user_session.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'nutrition_screen.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool isScanning = false;
  String? detectedFruit;
  File? selectedImageFile;

  final ImagePicker _picker = ImagePicker();

  final String baseUrl = "http://localhost:5050";

  @override
  void initState() {
    super.initState();

    final tr = AppLocalizations.of(context)!;

    if (!UserSession.cameraEnabled) {
      Future.microtask(() {
        Navigator.pop(context);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(tr.cameraPermissionDenied)));
      });
      return;
    }

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() => _isInitialized = true);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> startScan() async {
    final tr = AppLocalizations.of(context)!;

    if (!_isInitialized || isScanning) return;

    setState(() {
      isScanning = true;
      detectedFruit = null;
      selectedImageFile = null;
    });

    try {
      final XFile xfile = await _controller!.takePicture();
      final File imageFile = File(xfile.path);

      selectedImageFile = imageFile;

      const fakeLabel = 'orange';

      setState(() {
        isScanning = false;
        detectedFruit = fakeLabel;
      });

      _showResultSheet();
    } catch (e) {
      setState(() => isScanning = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${tr.errorWhileScanning}: $e')));
    }
  }

  Future<void> uploadFromGallery() async {
    final tr = AppLocalizations.of(context)!;

    if (isScanning) return;

    setState(() {
      isScanning = true;
      detectedFruit = null;
      selectedImageFile = null;
    });

    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) {
        setState(() => isScanning = false);
        return;
      }

      final File imageFile = File(picked.path);
      selectedImageFile = imageFile;

      const fakeLabel = 'orange';

      setState(() {
        isScanning = false;
        detectedFruit = fakeLabel;
      });

      _showResultSheet();
    } catch (e) {
      setState(() => isScanning = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${tr.errorWhileUploading} $e')));
    }
  }

  Future<Map<String, dynamic>> _sendImageToServer(File imageFile) async {
    final tr = AppLocalizations.of(context)!;

    final uri = Uri.parse('$baseUrl/predict');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 90),
    );
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return {'label': data['label'] ?? tr.unknown};
    }

    throw Exception('Server error: ${response.statusCode} - ${response.body}');
  }

  void _showResultSheet() {
    final tr = AppLocalizations.of(context)!;

    if (detectedFruit == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                detectedFruit!,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                tr.fruitCondition,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _conditionRow(Icons.check_circle, tr.fruitStructureIsStable),
              _conditionRow(Icons.warning_amber_rounded, tr.spotsFound),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFFA000),
                    side: const BorderSide(color: Color(0xFFFFA000)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (detectedFruit == null ||
                        detectedFruit!.toLowerCase() == tr.unknown) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(tr.unableDetectingFruitClearly)),
                      );
                      return;
                    }

                    // Close bottom sheet first
                    Navigator.pop(context);

                    // Navigate to nutrition page (direct widget)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            NutritionLoader(fruitType: detectedFruit!),
                      ),
                    );
                  },
                  child: Text(tr.seeDetailInformation),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _conditionRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: icon == Icons.check_circle ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(context).size;
    final frameWidth = size.width * 0.7;
    final frameHeight = frameWidth * 1.3;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox.expand(child: CameraPreview(_controller!)),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            Positioned(
              top: 8,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: _circleIcon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Center(
                      child: Text(
                        tr.scan,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(tr.placeFruitInsideFrame)),
                      );
                    },
                    child: _circleIcon(Icons.info_outline),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Container(
                width: frameWidth,
                height: frameHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
                child: Stack(
                  children: [
                    if (detectedFruit != null)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            detectedFruit!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    if (isScanning)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: frameHeight * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(18),
                            ),
                            color: const Color(0xFFFFA000).withOpacity(0.35),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 24,
              right: 24,
              bottom: 40,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: isScanning ? null : startScan,
                      child: _actionButton(
                        icon: Icons.camera_alt_rounded,
                        text: isScanning ? tr.scanning : tr.scan,
                        enabled: !isScanning,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: isScanning ? null : uploadFromGallery,
                      child: _actionButton(
                        icon: Icons.upload_rounded,
                        text: tr.upload,
                        enabled: !isScanning,
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

  Widget _actionButton({
    required IconData icon,
    required String text,
    required bool enabled,
  }) {
    final tr = AppLocalizations.of(context)!;

    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFFFFA000) : Colors.grey[700],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}
