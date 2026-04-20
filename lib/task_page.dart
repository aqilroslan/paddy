import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final user = FirebaseAuth.instance.currentUser;
  late String todayKey;
  late String todayDisplay;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    todayKey = DateFormat('yyyy-MM-dd').format(today);
    todayDisplay = DateFormat('d MMMM, yyyy').format(today);
  }

  Future<void> _toggleDone(DocumentReference doc, bool currentDone) async {
    await doc.update({'done': !currentDone});
  }

  Future<void> _deleteTask(DocumentReference doc) async {
    await doc.delete();
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
                SizedBox(height: 12),
                Text(
                  'Task deleted',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      );
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = Colors.green.shade700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Center(
                child: Text(
                  "Today's Tasks",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.green.shade800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "This your To-do List",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    todayDisplay,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .collection('tasks')
                  .where('date', isEqualTo: todayKey)
                  .snapshots(),
              builder: (context, snapshot) {
                final docs = snapshot.data?.docs ?? [];
                final completed = docs.where((d) => d['done'] == true).length;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.green.shade100, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("DAILY TASK",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade800)),
                              const SizedBox(height: 6),
                              Text("$completed / ${docs.length} Tasks",
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                              const SizedBox(height: 6),
                              Text("You're almost there! Keep going!",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.green.shade700.withOpacity(0.7))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        CircularPercentIndicator(
                          radius: 42,
                          lineWidth: 6,
                          percent: docs.isNotEmpty ? completed / docs.length : 0.0,
                          center: Text(
                            "${((docs.isNotEmpty ? completed / docs.length : 0.0) * 100).toInt()}%",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13, color: Colors.green.shade800),
                          ),
                          progressColor: Colors.green.shade800,
                          backgroundColor: Colors.green.shade50,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Your Task",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .collection('tasks')
                    .where('date', isEqualTo: todayKey)
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No task for today.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  final sortedDocs =
                  List<QueryDocumentSnapshot>.from(snapshot.data!.docs)
                    ..sort((a, b) {
                      final doneA = a['done'] == true;
                      final doneB = b['done'] == true;
                      return doneB ? -1 : 1;
                    });

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: sortedDocs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, idx) {
                      final doc = sortedDocs[idx];
                      final data = doc.data() as Map<String, dynamic>;
                      final done = data['done'] == true;

                      return Dismissible(
                        key: Key(doc.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red.shade400,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Delete Task"),
                              content: const Text("Are you sure you want to delete this task?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (_) => _deleteTask(doc.reference),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: done ? Colors.grey[200] : Colors.white,
                            border: Border.all(color: Colors.green.shade100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Checkbox(
                              value: done,
                              onChanged: (_) => _toggleDone(doc.reference, done),
                              activeColor: accent,
                            ),
                            title: Text(
                              data['title'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: done ? TextDecoration.lineThrough : null,
                                color: done ? Colors.grey : Colors.black,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if ((data['time'] ?? '').toString().isNotEmpty)
                                  Text("${data['time']}",
                                      style: TextStyle(color: Colors.green.shade600)),
                                if ((data['note'] ?? '').toString().isNotEmpty)
                                  Text("Note: ${data['note']}",
                                      style: const TextStyle(fontSize: 13)),
                                if ((data['priority'] ?? '').toString().isNotEmpty)
                                  Text("Priority: ${data['priority']}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: data['priority'] == 'high'
                                            ? Colors.red
                                            : data['priority'] == 'medium'
                                            ? Colors.orange
                                            : Colors.green,
                                      )),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _deleteTask(doc.reference),
                            ),
                            onTap: () => _toggleDone(doc.reference, done),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
