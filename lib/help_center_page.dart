import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({Key? key}) : super(key: key);

  final List<Map<String, String>> faqs = const [
    {
      "question": "How do I add a new field task?",
      "answer": "Go to the Calendar page, tap '+ Add Task', then fill in the details for your new task."
    },
    {
      "question": "How can I scan or predict crop diseases?",
      "answer": "Select 'Scan' at the bottom navigation bar, then choose to take a photo or upload from your gallery."
    },
    {
      "question": "How do I invite a friend to use this app?",
      "answer": "Go to your Profile page, tap 'Invite a Friend', and share the invitation link via WhatsApp, QR code, or copy the link."
    },
    {
      "question": "How do I submit feedback?",
      "answer": "From your Profile page, select 'Feedback' and fill in the feedback form. We appreciate your suggestions!"
    },
    {
      "question": "I forgot my password. What should I do?",
      "answer": "On the Sign In page, tap 'Forgot Password' and follow the instructions to reset your password."
    },
    {
      "question": "Is my data safe?",
      "answer": "Yes. Your data is securely stored and never shared with third parties. See our Privacy Policy for more info."
    },
  ];

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
          "Help Center",
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
          Container(
            margin: const EdgeInsets.only(bottom: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FAQs",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Find answers to common questions about using the Paddy app.",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          ...faqs.map((faq) => _buildModernFAQ(faq)).toList(),
          const SizedBox(height: 36),
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.09),
                  offset: const Offset(0, 4),
                  blurRadius: 14,
                ),
              ],
            ),
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.support_agent, color: Colors.green, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Need more help?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Contact us at paddy.support@email.com or submit a Feedback form.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFAQ(Map<String, String> faq) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.green.shade50, width: 2),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 18),
          iconColor: Colors.green,
          collapsedIconColor: Colors.green,
          title: Text(
            faq["question"] ?? "",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                faq["answer"] ?? "",
                style: TextStyle(color: Colors.grey[800], fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
