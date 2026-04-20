import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class DiseaseStatsPage extends StatefulWidget {
  const DiseaseStatsPage({Key? key}) : super(key: key);

  @override
  State<DiseaseStatsPage> createState() => _DiseaseStatsPageState();
}

class _DiseaseStatsPageState extends State<DiseaseStatsPage> {
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
      final disease = doc['result'] as String? ?? 'Unknown';
      counts[disease] = (counts[disease] ?? 0) + 1;
    }
    return counts;
  }

  String formatLabel(String raw) {
    return raw
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.green.shade800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Disease Statistics",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.green.shade800,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, int>>(
          future: getUserDiseaseStats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data ?? {};
            if (data.isEmpty) {
              return const Center(
                child: Text(
                  "No disease history found.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            // --- sort by count descending, top 3 for graph ---
            final sorted = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
            final top = sorted.take(3).toList();
            final keys = top.map((e) => e.key).toList();
            final values = top.map((e) => e.value).toList();
            final total = data.values.fold<int>(0, (sum, val) => sum + val);

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              children: [
                // Card: Bar Chart (Top 3)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  margin: const EdgeInsets.only(bottom: 20),
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
                        "Most Frequent Diseases",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
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
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
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
                      ),
                    ],
                  ),
                ),
                // Breakdown (ALL, not just top 3)
                const SizedBox(height: 10),
                const Text(
                  "Breakdown",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                ...List.generate(sorted.length, (i) {
                  final percent = total == 0 ? 0 : (sorted[i].value / total * 100);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.green.shade100,
                        child: Text(
                          sorted[i].value.toString(),
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      title: Text(
                        formatLabel(sorted[i].key),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Text(
                        "${percent.toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
