import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'calendar_page.dart';
import 'weather_detail_page.dart';
import 'disease_stats_page.dart';
import 'curated_news_page.dart'; // <-- Import here!
import 'package:fl_chart/fl_chart.dart';

// ...all your imports...

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? weather;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    String city = "Alor Setar";
    String country = "MY";
    String apiKey = "4e7a155f415b4feb5b445b832dab238a";
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

  Future<Map<String, int>> getUserDiseaseStats() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return {};

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('history')
        .get();

    final Map<String, int> counts = {};
    for (var doc in snapshot.docs) {
      final disease = doc['result'] as String? ?? 'unknown';
      counts[disease] = (counts[disease] ?? 0) + 1;
    }
    return counts;
  }

  String formatLabel(String raw) {
    return raw
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String getTodayDate() {
    final now = DateTime.now();
    return DateFormat('EEEE, d MMMM yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Paddy.",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          /*IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),*/
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          children: [
            Row(
              children: const [
                Text(
                  "New & Popular ",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Story",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Story Card (NOW CLICKABLE)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CuratedNewsPage()),
                );
              },
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/padi-705586_1280.jpg'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.04),
                      blurRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          "New In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 22,
                      left: 14,
                      right: 14,
                      child: Text(
                        "To know more about paddy update visit us MARDI!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 16,
                              color: Colors.black45,
                              offset: Offset(1, 2),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Weather + Calendar Row
            Row(
              children: [
                // WEATHER CARD
                Expanded(
                  child: GestureDetector(
                    onTap: isLoading || weather == null
                        ? null
                        : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WeatherDetailPage(weatherData: weather!),
                        ),
                      );
                    },
                    child: Container(
                      height: 200,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECF7FE),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.04),
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(Icons.cloud_outlined, color: Colors.blue, size: 33),
                              SizedBox(width: 8),
                              Text(
                                "Weather",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "${(weather?['main']['temp'] as num?)?.toInt() ?? '--'}°C",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            "${weather?['weather'][0]['description'] ?? ''}".replaceFirstMapped(RegExp(r'^\w'), (m) => m[0]!.toUpperCase()),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Feels like ${(weather?['main']['feels_like'] as num?)?.toInt() ?? '--'}°",
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          const SizedBox(height: 1),
                          const Text(
                            "Changlun, MY",
                            style: TextStyle(fontSize: 11, color: Colors.black38),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // CALENDAR CARD
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CalendarPage()),
                      );
                    },
                    child: Container(
                      height: 200,
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.greenAccent.withOpacity(0.04),
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(Icons.calendar_month, color: Colors.green, size: 33),
                              SizedBox(width: 8),
                              Text(
                                "Calendar",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black87),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            getTodayDate(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.green),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Task for today",
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            children: const [
                              Text(
                                "View Calendar",
                                style: TextStyle(fontSize: 12, color: Colors.green),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.green),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Disease Chart Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DiseaseStatsPage()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                margin: const EdgeInsets.only(bottom: 14, top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.04),
                      blurRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Disease History",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<Map<String, int>>(
                      future: getUserDiseaseStats(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final data = snapshot.data ?? {};
                        if (data.isEmpty) {
                          return const Center(child: Text("No disease data found."));
                        }
                        final sorted = data.entries.toList()
                          ..sort((a, b) => b.value.compareTo(a.value));
                        final top = sorted.take(3).toList();
                        final keys = top.map((e) => e.key).toList();
                        final values = top.map((e) => e.value).toList();

                        return SizedBox(
                          height: 180,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      if (index < 0 || index >= keys.length) return const Text('');
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: Text(
                                          formatLabel(keys[index]),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 10, fontWeight: FontWeight.w500),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: true, horizontalInterval: 2),
                              barGroups: List.generate(
                                keys.length,
                                    (i) => BarChartGroupData(
                                  x: i,
                                  barRods: [
                                    BarChartRodData(
                                      toY: values[i].toDouble(),
                                      width: 23,
                                      gradient: LinearGradient(
                                        colors: [Colors.green.shade400, Colors.green.shade700],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      backDrawRodData: BackgroundBarChartRodData(
                                        show: true,
                                        toY: 0,
                                        color: Colors.grey.shade100,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
