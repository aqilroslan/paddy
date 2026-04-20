import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Privacy & Policy",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        children: [
          Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: BorderSide(color: Colors.green.shade50, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Paddy App Privacy Policy",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Effective Date: 13 June 2025",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  SizedBox(height: 18),

                  // 1. Introduction
                  Text("1. Introduction",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      )),
                  SizedBox(height: 3),
                  Text(
                    "Your privacy is important to us. Paddy (“we”, “us”, or “our”) is committed to protecting your personal data and ensuring a safe experience when you use our app.",
                    style: TextStyle(fontSize: 15, height: 1.55),
                  ),
                  SizedBox(height: 16),

                  // 2. Information We Collect
                  Text("2. Information We Collect",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      )),
                  SizedBox(height: 3),
                  Text(
                    "- Personal Data: Name, email, profile picture, and any additional information you provide for registration or profile management.\n"
                        "- Usage Data: App usage statistics, interactions, and device information to improve app performance.\n"
                        "- Images & Tasks: Photos you upload for plant analysis, as well as tasks and notes you add.",
                    style: TextStyle(fontSize: 15, height: 1.55),
                  ),
                  SizedBox(height: 16),

                  // 3. How We Use Your Information
                  Text("3. How We Use Your Information",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      )),
                  SizedBox(height: 3),
                  Text(
                    "We use your data to:\n• Provide and personalize app features.\n• Improve app security and user experience.\n• Communicate important updates or support.",
                    style: TextStyle(fontSize: 15, height: 1.55),
                  ),
                  SizedBox(height: 16),

                  // 4. Data Security
                  Text("4. Data Security",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      )),
                  SizedBox(height: 3),
                  Text(
                    "We use industry-standard security practices and Firebase security rules to protect your data from unauthorized access. Your information is stored securely and never shared with third parties for marketing purposes.",
                    style: TextStyle(fontSize: 15, height: 1.55),
                  ),
                  SizedBox(height: 16),

                  // 5. Data Sharing
                  Text("5. Data Sharing",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      )),
                  SizedBox(height: 3),
                  Text(
                    "We do not sell, trade, or share your personal information with outside parties except:\n• When required by law.\n• To protect our rights and safety, or that of other users.",
                    style: TextStyle(fontSize: 15, height: 1.55),
                  ),
                  SizedBox(height: 16),

                  // 6. User Rights
                  Text("6. User Rights",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      )),
                  SizedBox(height: 3),
                  Text(
                    "You have the right to:\n• Access, update, or delete your profile at any time.\n• Request deletion of your account by contacting support.",
                    style: TextStyle(fontSize: 15, height: 1.55),
                  ),
                  SizedBox(height: 16),

                  // 7. Children’s Privacy
                  Text("7. Children’s Privacy",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      )),
                  SizedBox(height: 3),
                  Text(
                    "The Paddy app is not intended for users under 13 years of age. We do not knowingly collect data from children.",
                    style: TextStyle(fontSize: 15, height: 1.55),
                  ),
                  SizedBox(height: 16),

                  // 8. Changes to This Policy
                  Text("8. Changes to This Policy",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      )),
                  SizedBox(height: 3),
                  Text(
                    "We may update this policy occasionally. We will notify you of any changes via the app or email.",
                    style: TextStyle(fontSize: 15, height: 1.55),
                  ),
                  SizedBox(height: 16),

                  // 9. Contact Us
                  Text("9. Contact Us",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      )),
                  SizedBox(height: 3),
                  Text(
                    "If you have any questions about this policy or your data, contact us at:",
                    style: TextStyle(fontSize: 15, height: 1.55),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Email: paddy.support@email.com",
                    style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
