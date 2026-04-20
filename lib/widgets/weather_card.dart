import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../weather_detail_page.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({Key? key}) : super(key: key);

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  String city = "Changlun";
  String country = "MY";
  String apiKey = "4e7a155f415b4feb5b445b832dab238a";

  Map<String, dynamic>? weather;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city,$country&appid=$apiKey&units=metric";
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        setState(() {
          weather = json.decode(res.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width - 32; // Respect ListView horizontal padding

    if (isLoading) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(height: 110, child: Center(child: CircularProgressIndicator())),
      );
    }
    if (weather == null) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(height: 110, child: Center(child: Text('Failed to load weather'))),
      );
    }

    final temp = (weather!['main']['temp'] as num?)?.toInt() ?? 0;
    final desc = weather!['weather'][0]['description'] ?? '';
    final icon = weather!['weather'][0]['icon'];
    final minTemp = (weather!['main']['temp_min'] as num?)?.toInt() ?? 0;
    final maxTemp = (weather!['main']['temp_max'] as num?)?.toInt() ?? 0;
    final feelsLike = (weather!['main']['feels_like'] as num?)?.toInt() ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WeatherDetailPage(weatherData: weather!),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 110,
          width: cardWidth,
          child: Stack(
            children: [
              // Background image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/padi-3602921_1280.jpg',
                  width: cardWidth,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
              // White overlay for readability
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: cardWidth,
                  height: 110,
                //  color: Colors.white.withOpacity(0.80), // blur the image
                ),
              ),
              // Foreground content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      "https://openweathermap.org/img/wn/$icon@2x.png",
                      width: 46,
                      height: 46,
                      errorBuilder: (_, __, ___) => Icon(Icons.cloud, size: 36),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "$temp°C",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              desc[0].toUpperCase() + desc.substring(1),
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            _mainTag("Feels like $feelsLike°"),
                            const SizedBox(width: 5),
                            _mainTag("High $maxTemp°"),
                            const SizedBox(width: 5),
                            _mainTag("Low $minTemp°"),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade200.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.green,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
