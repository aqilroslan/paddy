import 'package:flutter/material.dart';

class RateAppPage extends StatelessWidget {
  const RateAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate App'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 1,
      ),
      body: const Center(
        child: Text(
          "Thank you for using Paddy App!\n\nRate us soon on the Play Store.\n\n(Feature coming soon!)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
