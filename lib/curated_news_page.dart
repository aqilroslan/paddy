import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class CuratedNewsPage extends StatelessWidget {
  CuratedNewsPage({Key? key}) : super(key: key);

  final String mardiUrl = "https://www.mardi.gov.my/penyelidikan/padi-beras.html";
  final String bannerImage = "assets/images/padi-705586_1280.jpg"; // Change if needed

  @override
  Widget build(BuildContext context) {
    final Color glassColor = Colors.white.withOpacity(0.88);
    final Color borderColor = const Color(0xFFE6EBD4);
    final Color green1 = const Color(0xFF8CC84B);
    final String today = DateFormat('d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Curated News",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.green.shade800,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              // Banner image (hero)
              Container(
                width: double.infinity,
                height: 180,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(bannerImage),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.09),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
              ),
              // Glass card article
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: glassColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.07),
                      blurRadius: 28,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // News title
                    Text(
                      "MARDI Leads Innovation in Malaysian Paddy Farming",
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 19.5,
                      ),
                    ),
                    const SizedBox(height: 7),
                    // Subtitle / brief
                    Text(
                      "Discover how the Malaysian Agricultural Research and Development Institute (MARDI) is transforming rice farming for the future.",
                      style: TextStyle(
                        fontSize: 15.2,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        height: 1.38,
                      ),
                    ),
                    const SizedBox(height: 11),
                    // Source & last updated
                    Row(
                      children: [
                        const Icon(Icons.public, size: 17, color: Color(0xFF8CC84B)),
                        const SizedBox(width: 5),
                        Text(
                          "Source: MARDI • Last Updated $today",
                          style: const TextStyle(
                              color: Color(0xFF8CC84B),
                              fontWeight: FontWeight.w500,
                              fontSize: 12.3
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 26, color: Color(0xFFE0E0E0)),
                    // Article body with headings
                    _sectionTitle("🌾 What is MARDI Paddy Research?"),
                    const Text(
                      "MARDI is the nation's leader for research and innovation in paddy and rice. Their work helps farmers improve productivity, crop quality, and sustainability by introducing high-yield varieties and modern technology.",
                      style: TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
                    ),
                    const SizedBox(height: 18),

                    _sectionTitle("🔬 Focus Areas"),
                    _bullet("Developing high-yield, climate-resilient, and disease-resistant rice varieties."),
                    _bullet("Applying tech such as drones, smart irrigation, and soil sensors."),
                    _bullet("Empowering local farmers through training and workshops."),
                    _bullet("Promoting sustainable and eco-friendly farming practices."),
                    const SizedBox(height: 14),

                    _sectionTitle("🌱 Featured Varieties"),
                    const Text(
                      "MARDI has released varieties like MR297 and MR315, which are suitable for Malaysia's climate and deliver higher, stable yields.",
                      style: TextStyle(fontSize: 14.7, height: 1.44),
                    ),
                    const SizedBox(height: 13),

                    _sectionTitle("🚀 Latest Innovations"),
                    _bullet("Drones for crop monitoring and fertilizer application."),
                    _bullet("Mobile apps for disease detection and reporting."),
                    _bullet("Integrated, digital farming systems for higher productivity."),
                    const SizedBox(height: 13),

                    _sectionTitle("👨‍🌾 Farmer Support"),
                    const Text(
                      "MARDI provides field demonstrations, technical support, and practical training to help farmers adopt new technology and techniques.",
                      style: TextStyle(fontSize: 14.7, height: 1.44),
                    ),
                    const SizedBox(height: 23),
                    // Read More button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new, color: Colors.white, size: 20),
                      label: const Text(
                        "Read More at MARDI Official Site",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green1,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () async {
                        final uri = Uri.parse(mardiUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Unable to open website')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.4,
        color: Color(0xFF8CC84B),
      ),
    ),
  );

  static Widget _bullet(String text) => Padding(
    padding: const EdgeInsets.only(left: 7.0, bottom: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("• ", style: TextStyle(fontSize: 15.5, color: Color(0xFF8CC84B))),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 14.6, height: 1.42)),
        ),
      ],
    ),
  );
}
