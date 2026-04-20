import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherDetailPage extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherDetailPage({
    Key? key,
    required this.weatherData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color glassColor = Colors.white.withOpacity(0.92);
    final Color borderColor = const Color(0xFFE6EBD4);

    final temp = (weatherData['main']['temp'] as num?)?.toInt() ?? 0;
    final desc = (weatherData['weather']?[0]?['description'] ?? '').toString();
    final icon = weatherData['weather']?[0]?['icon'] ?? '01d';
    final minTemp = (weatherData['main']['temp_min'] as num?)?.toInt() ?? 0;
    final maxTemp = (weatherData['main']['temp_max'] as num?)?.toInt() ?? 0;
    final feelsLike = (weatherData['main']['feels_like'] as num?)?.toInt() ?? 0;
    final humidity = weatherData['main']['humidity'] ?? 0;
    final pressure = weatherData['main']['pressure'] ?? 0;
    final windSpeed = weatherData['wind']['speed'] ?? 0.0;
    final cloudiness = weatherData['clouds']['all'] ?? 0;
    final sunrise = weatherData['sys']['sunrise'] ?? 0;
    final sunset = weatherData['sys']['sunset'] ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Weather Details",
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hero Top Card (bigger, aligned, background image)
                      Container(
                        height: 170,
                        margin: const EdgeInsets.only(top: 28, bottom: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/padi-3602921_1280.jpg'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: Offset(0, 7),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Overlay for text readability
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.black.withOpacity(0.17),
                                ),
                              ),
                            ),
                            // Main card content
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 19),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Left info
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Now",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                      // Icon immediately beside Celsius number with faint background
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "$temp°",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 52,
                                              height: 1.05,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 0),
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.18),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.network(
                                                "https://openweathermap.org/img/wn/$icon@2x.png",
                                                width: 38,
                                                height: 38,
                                                fit: BoxFit.contain,
                                                errorBuilder: (_, __, ___) =>
                                                    Icon(Icons.cloud, color: Colors.white, size: 36),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "High: $maxTemp°  Low: $minTemp°",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  // Right info (desc, feels like)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        desc.isNotEmpty
                                            ? desc[0].toUpperCase() + desc.substring(1)
                                            : "",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(height: 0),
                                      Text(
                                        "Feels like $feelsLike°",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Info cards in grid (with colored top bar)
                      GridView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.27,
                        ),
                        children: [
                          _infoCard(
                            icon: Icons.water_drop_outlined,
                            label: "Humidity",
                            value: "$humidity%",
                            color: Colors.teal,
                            labelColor: Colors.teal,
                          ),
                          _infoCard(
                            icon: Icons.speed_rounded,
                            label: "Pressure",
                            value: "$pressure hPa",
                            color: Colors.deepOrange,
                            labelColor: Colors.deepOrange,
                          ),
                          _infoCard(
                            icon: Icons.air_rounded,
                            label: "Wind",
                            value: "${windSpeed.toString()} m/s",
                            color: Colors.blue,
                            labelColor: Colors.blue,
                          ),
                          _infoCard(
                            icon: Icons.cloud_queue,
                            label: "Cloudiness",
                            value: "$cloudiness%",
                            color: Colors.grey,
                            labelColor: Colors.grey,
                          ),
                          _infoCard(
                            icon: Icons.wb_sunny_outlined,
                            label: "Sunrise",
                            value: _formatTime(sunrise),
                            color: Colors.amber[700]!,
                            labelColor: Colors.orange,
                          ),
                          _infoCard(
                            icon: Icons.nightlight_outlined,
                            label: "Sunset",
                            value: _formatTime(sunset),
                            color: Colors.purple,
                            labelColor: Colors.purple,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    Color? labelColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withOpacity(0.96),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Colored top bar
          Container(
            height: 4,
            width: 34,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 10),
          Icon(icon, color: color, size: 33),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: labelColor?.withOpacity(0.9) ?? color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatTime(int unix) {
    final dt = DateTime.fromMillisecondsSinceEpoch(unix * 1000, isUtc: true).toLocal();
    return DateFormat('h:mm a').format(dt);
  }
}
