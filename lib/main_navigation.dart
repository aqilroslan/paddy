import 'package:flutter/material.dart';
import 'package:project2/task_page.dart';

// Import your page files!
import 'dashboard_page.dart';
import 'task_page.dart';
import 'scan_camera_page.dart';
import 'history_page.dart';
import 'profile_page.dart';
import 'scan_result_page.dart';

class MainNavigation extends StatefulWidget {
  final int startIndex;
  const MainNavigation({super.key, this.startIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.startIndex;
  }

  final List<Widget> _pages = [
    DashboardPage(),   // 0: Home
    TaskPage(),    // 1: Task
    ScanCameraPage(),  // 2: Scan
    HistoryPage(),     // 3: History
    ProfilePage(),     // 4: Profile
  ];

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final accent = Colors.green.shade700;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: _pages[_selectedIndex == 2 ? 2 : _selectedIndex], // show Home when Scan pressed, Scan via FAB
      // Floating Scan Button (lowered/overlap)
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 15), // Move down 24px (adjust for more/less)
        child: SizedBox(
          height: 72,
          width: 72,
          child: Material(
            elevation: 14,
            color: Colors.transparent,
            shape: const CircleBorder(),
            shadowColor: Colors.black26,
            child: FloatingActionButton(
              backgroundColor: accent,
              elevation: 2,
              onPressed: () {
                _onTabSelected(2);
              },
              shape: const CircleBorder(),
              child: Icon(Icons.qr_code_scanner, size: 32, color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
        child: PhysicalModel(
          elevation: 12,
          color: Colors.white,
          borderRadius: BorderRadius.circular(34),
          shadowColor: Colors.green.withOpacity(0.10),
          child: Container(
            height: 76,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(34),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  label: "Home",
                  selected: _selectedIndex == 0,
                  onTap: () => _onTabSelected(0),
                  accent: accent,
                ),
                _NavItem(
                  icon: Icons.checklist_outlined,
                  label: "Task",
                  selected: _selectedIndex == 1,
                  onTap: () => _onTabSelected(1),
                  accent: accent,
                ),
                const SizedBox(width: 68), // Space for the floating button
                _NavItem(
                  icon: Icons.history,
                  label: "History",
                  selected: _selectedIndex == 3,
                  onTap: () => _onTabSelected(3),
                  accent: accent,
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  label: "Profile",
                  selected: _selectedIndex == 4,
                  onTap: () => _onTabSelected(4),
                  accent: accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// NavItem widget
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color accent;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? accent : Colors.grey[400],
              size: 28,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected ? accent : Colors.grey[400],
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
