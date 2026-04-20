import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

late List<String> labels;

Future<void> loadLabels() async {
  final String data = await rootBundle.loadString('assets/model/labels.json');
  final Map<String, dynamic> labelMap = json.decode(data);
  // keys are indices as strings, values are label names
  // sort by key to ensure order is correct
  labels = List.generate(labelMap.length, (i) => labelMap['$i'] as String);
}
