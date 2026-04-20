import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();

  final List<Color> pastelColors = [
    Color(0xFFFCE8E6),
    Color(0xFFE3F3FD),
    Color(0xFFE8F5E9),
    Color(0xFFF3E8FD),
    Color(0xFFFFF4E5),
  ];

  bool isToday(DateTime date) => DateUtils.isSameDay(date, DateTime.now());

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Please log in first.'));
    }
    final userId = user.uid;
    final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDay);

    // Weekdays for the bar
    List<DateTime> weekDays = [];
    DateTime startOfWeek = _selectedDay.subtract(Duration(days: _selectedDay.weekday - 1));
    for (int i = 0; i < 7; i++) {
      weekDays.add(startOfWeek.add(Duration(days: i)));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Calendar",
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.green.shade800),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Month & Year with Calendar Icon
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 26, right: 26, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('MMMM, yyyy').format(_selectedDay),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 7),
                GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDay,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                      builder: (context, child) => Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: Colors.green,
                          colorScheme: const ColorScheme.light(primary: Colors.green),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDay = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.calendar_month, color: Colors.green, size: 22),
                  ),
                ),
              ],
            ),
          ),

          // Glassy card with the rest of the calendar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  children: [
                    // Foreground card
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.white.withOpacity(0.82),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.08),
                            blurRadius: 22,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Today button if not today
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 18, 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isToday(_selectedDay))
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    ),
                                    icon: const Icon(Icons.today, size: 19),
                                    label: const Text(
                                      "Back to Today",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    onPressed: () => setState(() => _selectedDay = DateTime.now()),
                                  ),
                              ],
                            ),
                          ),
                          // Weekday bar
                          Container(
                            height: 60,
                            margin: const EdgeInsets.only(top: 2, bottom: 6),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: weekDays.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 9),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              itemBuilder: (context, i) {
                                DateTime day = weekDays[i];
                                bool isSelected = DateUtils.isSameDay(day, _selectedDay);
                                bool today = isToday(day);
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedDay = day),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeOutCubic,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.green
                                          : today
                                          ? Colors.green.withOpacity(0.09)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      border: isSelected
                                          ? Border.all(color: Colors.green.shade700, width: 2)
                                          : null,
                                      boxShadow: isSelected
                                          ? [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.18),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ]
                                          : [],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          DateFormat('EEE').format(day).toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Colors.white
                                                : today
                                                ? Colors.green.shade800
                                                : Colors.black54,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        CircleAvatar(
                                          radius: 13,
                                          backgroundColor: isSelected
                                              ? Colors.white
                                              : today
                                              ? Colors.green.withOpacity(0.13)
                                              : Colors.transparent,
                                          child: Text(
                                            DateFormat('d').format(day),
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? Colors.green
                                                  : today
                                                  ? Colors.green
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Task list (no delete)
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .collection('tasks')
                                  .where('date', isEqualTo: dateKey)
                                  .orderBy('time', descending: false)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      "No task for this date.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }
                                final docs = snapshot.data!.docs;
                                return ListView.separated(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                                  itemCount: docs.length,
                                  separatorBuilder: (context, idx) => const SizedBox(height: 11),
                                  itemBuilder: (context, idx) {
                                    final data = docs[idx].data() as Map<String, dynamic>;
                                    final color = pastelColors[idx % pastelColors.length];

                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.topRight,
                                          width: 63,
                                          child: Text(
                                            data['time'] ?? '',
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.green,
                                              letterSpacing: 0.1,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 7),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 17, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: color.withOpacity(0.62),
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(color: color.withOpacity(0.28)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: color.withOpacity(0.09),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 2),
                                                )
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data['title'] ?? '',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                if (data['note'] != null &&
                                                    data['note'].toString().isNotEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 2.0),
                                                    child: Text(
                                                      data['note'],
                                                      style: TextStyle(
                                                          color: Colors.grey[800], fontSize: 13),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Add Task Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.add, size: 22),
                label: const Text(
                  'Add Task',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.2),
                ),
                onPressed: () => _showAddTaskDialog(context, userId, _selectedDay),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, String userId, DateTime date) async {
    final taskController = TextEditingController();
    final noteController = TextEditingController();
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text("Add Task for ${DateFormat('yyyy-MM-dd').format(date)}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  selectedTime == null
                      ? "Select Task Time"
                      : "Time: ${selectedTime!.format(context)}",
                  style: TextStyle(
                      color: selectedTime == null ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w600),
                ),
                trailing: Icon(Icons.access_time, color: Colors.green),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setStateDialog(() => selectedTime = picked);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (taskController.text.trim().isEmpty || selectedTime == null) return;
                final String timeStr = selectedTime!.format(context); // e.g., "13:00"
                final taskDoc = FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('tasks')
                    .doc(); // auto-ID

                await taskDoc.set({
                  'title': taskController.text.trim(),
                  'note': noteController.text.trim(),
                  'date': DateFormat('yyyy-MM-dd').format(date),
                  'time': timeStr,
                  'timestamp': DateTime(
                    date.year,
                    date.month,
                    date.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  ),
                  'done': false,
                });
                if (mounted) Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
