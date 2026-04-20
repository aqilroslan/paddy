/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'labels.dart';
import 'image_processing.dart';
import 'scan_result_page.dart';

class ScanCameraPage extends StatefulWidget {
  const ScanCameraPage({Key? key}) : super(key: key);

  @override
  State<ScanCameraPage> createState() => _ScanCameraPageState();
}

class _ScanCameraPageState extends State<ScanCameraPage> {
  Interpreter? interpreter;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      interpreter = await Interpreter.fromAsset('assets/model/rice_leaf_model.tflite');

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading model: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load model: $e';
      });
    }
  }

  // Generalized method for both camera and gallery
  Future<void> _pickAndPredict({required ImageSource source}) async {
    if (interpreter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Model not loaded. Please try again.')),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) return;

    setState(() => isLoading = true);

    try {
      // Use shared preprocessing
      final input = await preprocessImage(File(pickedFile.path), targetSize: 224);
      final inputTensor = input.reshape([1, 224, 224, 3]);
      var output = List.filled(1 * labels.length, 0.0).reshape([1, labels.length]);
      interpreter?.run(inputTensor, output);

      // Find highest confidence index
      final List<double> outputList = List<double>.from(output[0]);
      final double maxValue = outputList.reduce((a, b) => a > b ? a : b);
      final int predIndex = outputList.indexOf(maxValue);
      String result = labels[predIndex];

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
      print('Error during prediction: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error during prediction: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during prediction: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan with Camera')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CircularProgressIndicator()
            else if (errorMessage != null)
              Column(
                children: [
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadModel,
                    child: const Text('Retry Loading Model'),
                  ),
                ],
              )
            else ...[
                ElevatedButton.icon(
                  onPressed: interpreter == null
                      ? null
                      : () => _pickAndPredict(source: ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Take Photo & Predict"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: interpreter == null
                      ? null
                      : () => _pickAndPredict(source: ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Upload from Gallery & Predict"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
          ],
        ),
      ),
    );
  }
}
*/