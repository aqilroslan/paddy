import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project2/terms_conditions_page.dart';
import 'edit_profile_page.dart';
import 'auth_page.dart';
import 'invite_friend_page.dart';
import 'feedback_page.dart';
import 'help_center_page.dart';
import 'privacy_policy_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  String address = '';
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        name = userDoc['name'] ?? '';
        email = userDoc['email'] ?? '';
        address = userDoc['address'] ?? '';
        profileImageUrl = userDoc['profileImageUrl'] ?? '';
      });
    }
  }

  Widget _buildProfileOption(String title, IconData icon, VoidCallback onTap, {Color? iconColor, Color? textColor}) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.green),
      title: Text(title, style: TextStyle(fontSize: 16, color: textColor ?? Colors.black)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      onTap: onTap,
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Paddy App Logo
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Image.asset(
                  'assets/images/Screenshot_2025-06-14_020127-removebg-preview.png',
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),

              // App Name below logo
              const Text(
                'Paddy.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              // Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              // Email
              Text(
                email,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 24),
              const Divider(thickness: 1),

              // Profile Options
              _buildProfileOption(
                "Edit Profile",
                Icons.edit,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  ).then((_) => fetchUserProfile());
                },
              ),
              _buildProfileOption(
                "Invite a Friend",
                Icons.person_add_alt_1,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InviteFriendPage()),
                  );
                },
              ),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              _buildProfileOption(
                "Feedback",
                Icons.feedback_outlined,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FeedbackPage()),
                  );
                },
              ),
              _buildProfileOption(
                "Help Center",
                Icons.help_outline,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpCenterPage()),
                  );
                },
              ),
              _buildProfileOption(
                "Privacy & Policy",
                Icons.privacy_tip,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                  );
                },
              ),
              _buildProfileOption(
                "Terms & Conditions",
                Icons.article_outlined,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TermsConditionsPage()),
                  );
                },
              ),
              const Divider(thickness: 1),
              _buildProfileOption(
                "Logout",
                Icons.logout,
                    () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.pop(ctx, false),
                        ),
                        ElevatedButton(
                          child: const Text("Logout"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () => Navigator.pop(ctx, true),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    _logout();
                  }
                },
                iconColor: Colors.red,
                textColor: Colors.red,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

}
