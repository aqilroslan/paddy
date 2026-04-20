import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'image_processing.dart';
import 'scan_result_page.dart';

class ScanCameraPage extends StatefulWidget {
  const ScanCameraPage({Key? key}) : super(key: key);

  @override
  State<ScanCameraPage> createState() => _ScanCameraPageState();
}

class _ScanCameraPageState extends State<ScanCameraPage> {
  Interpreter? interpreter;
  List<String>? labels;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    await Future.wait([_loadModel(), _loadLabels()]);
    setState(() => isLoading = false);
  }

  Future<void> _loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/model/leaf_model.tflite');
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load model: $e';
      });
    }
  }

  Future<void> _loadLabels() async {
    try {
      final String data = await rootBundle.loadString('assets/model/labels.json');
      final Map<String, dynamic> labelMap = json.decode(data);
      setState(() {
        labels = List.generate(labelMap.length, (i) => labelMap['$i'] as String);
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load labels: $e';
      });
    }
  }

  Future<void> _pickAndPredict(ImageSource source) async {
    if (interpreter == null || labels == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Model or labels not loaded. Please try again.')),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) return;

    setState(() => isLoading = true);

    try {
      final input = await preprocessImage(File(pickedFile.path), targetSize: 128);
      final inputTensor = input.reshape([1, 128, 128, 3]);
      final output = List.filled(labels!.length, 0.0).reshape([1, labels!.length]);
      interpreter?.run(inputTensor, output);

      final List<double> outputList = List<double>.from(output[0]);
      final double maxValue = outputList.reduce((a, b) => a > b ? a : b);
      final int predIndex = outputList.indexOf(maxValue);
      String result = labels![predIndex];

      setState(() => isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanResultPage(
            imagePath: pickedFile.path,
            prediction: result,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error during prediction: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during prediction: $e')),
      );
    }
  }

  // Widget for Snap → Analyze → Result
  Widget _buildStepsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStepIcon(Icons.photo_camera, "Snap"),
        _buildStepDivider(),
        _buildStepIcon(Icons.bar_chart, "Analyze"),
        _buildStepDivider(),
        _buildStepIcon(Icons.assignment_turned_in_rounded, "Result"),
      ],
    );
  }

  Widget _buildStepIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.13),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 26, color: Colors.green.shade700),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12.5, color: Colors.green)),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Container(
      width: 24,
      height: 2,
      color: Colors.green.withOpacity(0.22),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color glassColor = Colors.white.withOpacity(0.88);
    final Color borderColor = const Color(0xFFE6EBD4);
    final Color gradient1 = Colors.green.shade800;
    final Color tipBg = const Color(0xFFF4F8E9);
    final Color tipText = Colors.green.shade800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar (like history/task) with full-width divider
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Center(
                child: Text(
                  "Scan Paddy Leaf",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.green.shade800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            Row(
              children: const [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    height: 1,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
              ],
            ),
            // Align content to top, not center!
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadAll,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : (interpreter == null || labels == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Less top space (move content closer to top)
                      const SizedBox(height: 12),
                      // Action Card (steps + info)
                      Container(
                        margin: const EdgeInsets.only(top: 100, bottom: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: glassColor,
                          border: Border.all(
                            color: borderColor,
                            width: 1.3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.07),
                              blurRadius: 32,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 14),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildStepsRow(),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Get instant crop health results.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.green.shade900.withOpacity(0.92),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "Analyze your paddy or rice leaf using AI.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Buttons
                      ElevatedButton.icon(
                        onPressed: () => _pickAndPredict(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Take Photo & Predict"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gradient1,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 52),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => _pickAndPredict(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text("Upload from Gallery"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: gradient1,
                          minimumSize: const Size(double.infinity, 52),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: gradient1, width: 2),
                          ),
                          elevation: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Tip
                      Container(
                        decoration: BoxDecoration(
                          color: tipBg.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.tips_and_updates,
                                color: Colors.green, size: 22),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                "Tip: Make sure the leaf is clean & placed on a plain background for best results.",
                                style: TextStyle(
                                  color: tipText,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.7,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
