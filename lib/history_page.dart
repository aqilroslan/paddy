import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'history_detail_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _monthYearKey(DateTime date) => DateFormat('yyyy-MM').format(date);
  String _formatMonthTitle(DateTime date) => DateFormat('MMMM yyyy').format(date);
  String _formatCardDate(DateTime date) => DateFormat('MMMM d, yyyy').format(date);

  Future<void> _confirmAndDelete(BuildContext context, String docId) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Delete Task", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text(
                "Are you sure you want to delete this task?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel", style: TextStyle(color: Colors.purple)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _deleteHistory(context, docId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteHistory(BuildContext context, String docId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('history')
        .doc(docId)
        .delete();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
              const SizedBox(height: 10),
              const Text(
                "Deleted Successfully",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                "The selected history item has been removed.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Center(
                child: Text(
                  "History",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),

            // --- Search and Sort function REMOVED here ---

            // History List
            Expanded(
              child: uid == null
                  ? const Center(child: Text("User not logged in."))
                  : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('history')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No history found.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;
                  final Map<String, List<QueryDocumentSnapshot>> grouped = {};

                  for (var doc in docs) {
                    final ts = (doc['timestamp'] as Timestamp).toDate();
                    final key = _monthYearKey(ts);
                    grouped.putIfAbsent(key, () => []).add(doc);
                  }

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: grouped.entries.expand((entry) {
                      final monthDate = DateFormat('yyyy-MM').parse(entry.key);
                      final title = _formatMonthTitle(monthDate);
                      return [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, top: 12),
                          child: Row(
                            children: [
                              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const Expanded(child: Divider(thickness: 1, indent: 12)),
                            ],
                          ),
                        ),
                        ...entry.value.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final ts = (data['timestamp'] as Timestamp).toDate();

                          return Dismissible(
                            key: Key(doc.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(Icons.delete, color: Colors.white, size: 28),
                            ),
                            confirmDismiss: (_) async {
                              await _confirmAndDelete(context, doc.id);
                              return false;
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.green.shade100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.05),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HistoryDetailPage(
                                      imagePath: data['localPath'] ?? '',
                                      prediction: data['result'] ?? '',
                                      date: ts,
                                    ),
                                  ),
                                ),
                                child: SizedBox(
                                  height: 100,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(18),
                                            bottomLeft: Radius.circular(18),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            _formatCardDate(ts),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(18),
                                            bottomRight: Radius.circular(18),
                                          ),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              data['localPath'] != null
                                                  ? Image.file(File(data['localPath']), fit: BoxFit.cover)
                                                  : Container(color: Colors.grey.shade300),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.white,
                                                    child: const Icon(Icons.chevron_right, color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ];
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
