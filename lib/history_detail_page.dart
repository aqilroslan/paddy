import 'dart:io';
import 'package:flutter/material.dart';

class HistoryDetailPage extends StatelessWidget {
  final String imagePath;
  final String prediction;
  final DateTime date;

  const HistoryDetailPage({
    Key? key,
    required this.imagePath,
    required this.prediction,
    required this.date,
  }) : super(key: key);

  /// Format label for display
  String formatLabel(String raw) {
    return raw
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '')
        .join(' ');
  }

  /// Disease-specific info tags (Height, Light, Water)
  List<Map<String, dynamic>> getDiseaseInfoTags(String label) {
    switch (label) {
      case 'bacterial_leaf_blight':
        return [
          {
            'icon': Icons.height,
            'text': "Height\nAffected",
            'bgColor': Colors.green.shade100,
            'iconColor': Colors.green.shade700,
          },
          {
            'icon': Icons.wb_sunny,
            'text': "Light\nAdequate",
            'bgColor': Colors.yellow.shade50,
            'iconColor': Colors.orange.shade600,
          },
          {
            'icon': Icons.water_drop,
            'text': "Water\nReduce",
            'bgColor': Colors.blue.shade50,
            'iconColor': Colors.blue.shade700,
          },
        ];
      case 'bacterial_leaf_streak':
        return [
          {
            'icon': Icons.height,
            'text': "Height\nReduced",
            'bgColor': Colors.green.shade100,
            'iconColor': Colors.green.shade700,
          },
          {
            'icon': Icons.wb_sunny,
            'text': "Light\nHigh Humidity",
            'bgColor': Colors.yellow.shade50,
            'iconColor': Colors.orange.shade600,
          },
          {
            'icon': Icons.water_drop,
            'text': "Water\nLimit",
            'bgColor': Colors.blue.shade50,
            'iconColor': Colors.blue.shade700,
          },
        ];
      case 'bacterial_panicle_blight':
        return [
          {
            'icon': Icons.height,
            'text': "Height\nNormal",
            'bgColor': Colors.green.shade100,
            'iconColor': Colors.green.shade700,
          },
          {
            'icon': Icons.wb_sunny,
            'text': "Light\nModerate",
            'bgColor': Colors.yellow.shade50,
            'iconColor': Colors.orange.shade600,
          },
          {
            'icon': Icons.water_drop,
            'text': "Water\nAvoid Wet",
            'bgColor': Colors.blue.shade50,
            'iconColor': Colors.blue.shade700,
          },
        ];
      case 'blast':
        return [
          {
            'icon': Icons.height,
            'text': "Height\nNormal",
            'bgColor': Colors.green.shade100,
            'iconColor': Colors.green.shade700,
          },
          {
            'icon': Icons.wb_sunny,
            'text': "Light\nStable",
            'bgColor': Colors.yellow.shade50,
            'iconColor': Colors.orange.shade700,
          },
          {
            'icon': Icons.water_drop,
            'text': "Water\nMaintain",
            'bgColor': Colors.blue.shade50,
            'iconColor': Colors.blue.shade700,
          },
        ];
      case 'brown_spot':
        return [
          {
            'icon': Icons.height,
            'text': "Height\nWeak",
            'bgColor': Colors.green.shade100,
            'iconColor': Colors.green.shade700,
          },
          {
            'icon': Icons.wb_sunny,
            'text': "Light\nIncrease",
            'bgColor': Colors.yellow.shade50,
            'iconColor': Colors.orange.shade700,
          },
          {
            'icon': Icons.water_drop,
            'text': "Water\nAdequate",
            'bgColor': Colors.blue.shade50,
            'iconColor': Colors.blue.shade700,
          },
        ];
      case 'dead_heart':
        return [
          {
            'icon': Icons.height,
            'text': "Height\nCentral Dead",
            'bgColor': Colors.green.shade100,
            'iconColor': Colors.green.shade700,
          },
          {
            'icon': Icons.wb_sunny,
            'text': "Light\nNormal",
            'bgColor': Colors.yellow.shade50,
            'iconColor': Colors.orange.shade700,
          },
          {
            'icon': Icons.water_drop,
            'text': "Water\nNormal",
            'bgColor': Colors.blue.shade50,
            'iconColor': Colors.blue.shade700,
          },
        ];
      case 'downy_mildew':
        return [
          {
            'icon': Icons.height,
            'text': "Height\nStunted",
            'bgColor': Colors.green.shade100,
            'iconColor': Colors.green.shade700,
          },
          {
            'icon': Icons.wb_sunny,
            'text': "Light\nLow",
            'bgColor': Colors.yellow.shade50,
            'iconColor': Colors.orange.shade700,
          },
          {
            'icon': Icons.water_drop,
            'text': "Water\nReduce",
            'bgColor': Colors.blue.shade50,
            'iconColor': Colors.blue.shade700,
          },
        ];
      case 'hispa':
        return [
          {
            'icon': Icons.height,
            'text': "Height\nScarred",
            'bgColor': Colors.green.shade100,
            'iconColor': Colors.green.shade700,
          },
          {
            'icon': Icons.wb_sunny,
            'text': "Light\nNormal",
            'bgColor': Colors.yellow.shade50,
            'iconColor': Colors.orange.shade700,
          },
          {
            'icon': Icons.water_drop,
            'text': "Water\nMaintain",
            'bgColor': Colors.blue.shade50,
            'iconColor': Colors.blue.shade700,
          },
        ];
      case 'tungro':
        return [
          {
            'icon': Icons.height,
            'text': "Height\nStunted",
            'bgColor': Colors.green.shade100,
            'iconColor': Colors.green.shade700,
          },
          {
            'icon': Icons.wb_sunny,
            'text': "Light\nNormal",
            'bgColor': Colors.yellow.shade50,
            'iconColor': Colors.orange.shade700,
          },
          {
            'icon': Icons.water_drop,
            'text': "Water\nMonitor",
            'bgColor': Colors.blue.shade50,
            'iconColor': Colors.blue.shade700,
          },
        ];
      case 'normal':
        return [
          {
            'icon': Icons.height,
            'text': "Height\nHealthy",
            'bgColor': Colors.green.shade100,
            'iconColor': Colors.green.shade700,
          },
          {
            'icon': Icons.wb_sunny,
            'text': "Light\nGood",
            'bgColor': Colors.yellow.shade50,
            'iconColor': Colors.orange.shade700,
          },
          {
            'icon': Icons.water_drop,
            'text': "Water\nSufficient",
            'bgColor': Colors.blue.shade50,
            'iconColor': Colors.blue.shade700,
          },
        ];
      case 'unknown':
        return [];
      default:
        return [];
    }
  }

  String getDiseaseDescription(String label) {
    switch (label) {
      case 'bacterial_leaf_blight':
        return "A major rice disease caused by Xanthomonas oryzae. It causes yellowing and drying of leaf tips, spreading downwards, and is common in wet seasons. It can reduce yields significantly if not managed early.";
      case 'bacterial_leaf_streak':
        return "Caused by Xanthomonas oryzae pv. oryzicola, this disease forms narrow, water-soaked streaks that turn yellow. It thrives in humid, rainy conditions and spreads quickly.";
      case 'bacterial_panicle_blight':
        return "This disease affects rice panicles, causing poor grain filling and unfilled, discolored grains. It develops in warm, wet weather and can result in significant yield loss.";
      case 'blast':
        return "A fungal disease (Magnaporthe oryzae) that produces diamond-shaped leaf lesions and neck rot. Blast can devastate rice fields, especially during periods of high humidity.";
      case 'brown_spot':
        return "A fungal disease (Bipolaris oryzae) characterized by brown lesions with yellow halos. Brown spot is common in poor soils and drought, reducing seedling vigor and grain quality.";
      case 'dead_heart':
        return "Central shoot death caused by stem borer larvae inside the stem. Leaves turn yellow and detach easily. Early detection and management are crucial.";
      case 'downy_mildew':
        return "Fungal-like pathogens cause yellowing, downy growth, and stunted seedlings, particularly in cool, humid environments.";
      case 'hispa':
        return "An insect pest (Dicladispa armigera) that scrapes leaf surfaces, leaving white streaks and causing drying. Severe infestations can cause major crop losses.";
      case 'normal':
        return "No major disease detected. The rice leaf appears healthy and normal.";
      case 'tungro':
        return "A viral disease spread by leafhoppers. Tungro stunts growth, turns leaves orange-yellow, and reduces tillering. Severe cases cause major yield loss.";
      case 'unknown':
        return "Symptoms do not clearly match a known disease. Monitor the plant closely or consult an agricultural expert.";
      default:
        return "No information available for this disease.";
    }
  }

  String getRecommendation(String label) {
    switch (label) {
      case 'bacterial_leaf_blight':
        return "• Remove and destroy infected leaves immediately.\n"
            "• Apply copper-based bactericides as recommended.\n"
            "• Avoid overhead irrigation; use ground-level methods.\n"
            "• Use disease-free seeds and resistant varieties.\n"
            "• Reduce nitrogen fertilizer and improve drainage.";
      case 'bacterial_leaf_streak':
        return "• Practice strict field sanitation; remove crop residues.\n"
            "• Use certified, disease-free seeds and treat before sowing.\n"
            "• Apply bactericides early; avoid excessive watering.\n"
            "• Control weeds and limit movement between fields.";
      case 'bacterial_panicle_blight':
        return "• Improve drainage and avoid waterlogging.\n"
            "• Remove and destroy infected panicles.\n"
            "• Grow resistant or tolerant rice varieties.\n"
            "• Apply balanced fertilizer; avoid excess nitrogen.";
      case 'blast':
        return "• Use recommended fungicides (e.g., tricyclazole) at booting stage.\n"
            "• Avoid excess nitrogen; split applications instead.\n"
            "• Maintain stable water levels and remove weeds.\n"
            "• Grow resistant varieties and rotate crops.";
      case 'brown_spot':
        return "• Use balanced fertilizers, especially potassium and phosphorus.\n"
            "• Plant high-quality, treated seeds.\n"
            "• Remove crop residues and weeds after harvest.\n"
            "• Rotate crops and ensure proper drainage.";
      case 'dead_heart':
        return "• Monitor for stem borers and early symptoms.\n"
            "• Remove and destroy affected tillers.\n"
            "• Use pheromone or light traps to catch moths.\n"
            "• Apply recommended insecticides if needed.";
      case 'downy_mildew':
        return "• Improve drainage; avoid excessive irrigation.\n"
            "• Apply fungicides (e.g., metalaxyl) at early symptoms.\n"
            "• Increase plant spacing and remove infected plants.\n"
            "• Grow resistant varieties when possible.";
      case 'hispa':
        return "• Inspect crops regularly; handpick adults/larvae.\n"
            "• Apply insecticides (e.g., carbaryl) for severe outbreaks.\n"
            "• Avoid high nitrogen and encourage natural predators.";
      case 'normal':
        return "Your plant is healthy! Maintain good care, proper water, and fertilizer management for continued growth.";
      case 'tungro':
        return "• Remove and destroy infected plants quickly.\n"
            "• Control green leafhopper vectors with insecticides.\n"
            "• Plant tungro-resistant varieties.\n"
            "• Maintain weed control; avoid overlapping crops.";
      case 'unknown':
        return "• Isolate and monitor the plant area.\n"
            "• Remove suspicious plants if symptoms spread.\n"
            "• Consult local agriculture officers for a diagnosis.\n"
            "• Continue regular monitoring and weed control.";
      default:
        return "No specific recommendation available. Please consult your local agriculture expert for further advice.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color greenMain = Colors.green.shade700;
    final Color bgColor = Colors.white;

    // True if unknown or blank/empty label
    final isUnknown = prediction.trim().toLowerCase() == 'unknown' || prediction.trim().isEmpty;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Image with curve and back button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                  child: Image.file(
                    File(imagePath),
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.7),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      "Scan date: ${date.day}/${date.month}/${date.year}",
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                  if (isUnknown)
                  // Only show for unknown/invalid image
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 40),
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.red.shade100, width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              "Wrong image input, please upload another image.",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.analytics, color: greenMain, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Analysis Result",
                          style: TextStyle(
                            color: greenMain,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 8, top: 4),
                      child: Text(
                        formatLabel(prediction.isNotEmpty ? prediction : 'No disease detected.'),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                    Divider(height: 24, thickness: 1, color: Colors.grey.shade300),
                    _sectionTitleWithIcon(
                      icon: Icons.info_outline,
                      iconColor: Colors.teal,
                      title: "About this Disease",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 8, top: 2),
                      child: Text(
                        getDiseaseDescription(prediction),
                        style: TextStyle(
                          fontSize: 13.2,
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.w400,
                          height: 1.35,
                        ),
                      ),
                    ),
                    Divider(height: 24, thickness: 1, color: Colors.grey.shade300),
                    _sectionTitleWithIcon(
                      icon: Icons.lightbulb_outline,
                      iconColor: Colors.orange.shade800,
                      title: "Recommendation",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 8, top: 2),
                      child: Text(
                        getRecommendation(prediction),
                        style: TextStyle(
                          fontSize: 13.2,
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Divider(height: 28, thickness: 1, color: Colors.grey.shade300),
                    // Info tags (Height, Light, Water) if available
                    if (getDiseaseInfoTags(prediction).isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: getDiseaseInfoTags(prediction)
                              .map((tag) => _infoTag(
                            tag['icon'] as IconData,
                            tag['text'] as String,
                            tag['bgColor'] as Color,
                            tag['iconColor'] as Color,
                          ))
                              .toList(),
                        ),
                      ),
                    const SizedBox(height: 18),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitleWithIcon({
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 6),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: iconColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.05,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _infoTag(IconData icon, String text, Color bgColor, Color iconColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: bgColor,
          child: Icon(icon, color: iconColor, size: 19),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11.7, fontWeight: FontWeight.w600, height: 1.18),
        ),
      ],
    );
  }
}
