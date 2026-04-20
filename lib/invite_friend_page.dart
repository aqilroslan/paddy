import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

class InviteFriendPage extends StatelessWidget {
  // Example invitation link (change to your real app link!)
  final String inviteLink = "https://yourapp.com/download-paddy";

  const InviteFriendPage({Key? key}) : super(key: key);

  void _shareWhatsApp(BuildContext context) async {
    final text = "Join me on Paddy! 🌾 $inviteLink";
    final whatsappUrl = "whatsapp://send?text=${Uri.encodeComponent(text)}";
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp not installed')),
      );
    }
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: inviteLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard!')),
    );
  }

  void _shareGeneral(BuildContext context) {
    Share.share("Join me on Paddy! 🌾 $inviteLink");
  }

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
          'Invite a Friend',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        children: [
          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: BorderSide(color: Colors.green.shade50, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Invite your friends to join Paddy!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: () => _shareWhatsApp(context),
                    icon: const Icon(Icons.chat, color: Colors.white),
                    label: const Text('Share via WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 14),

                  ElevatedButton.icon(
                    onPressed: () => _copyLink(context),
                    icon: const Icon(Icons.link, color: Colors.white),
                    label: const Text('Copy Invite Link'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 14),

                  OutlinedButton.icon(
                    onPressed: () => _shareGeneral(context),
                    icon: const Icon(Icons.share),
                    label: const Text('Share with Others'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: BorderSide(color: Colors.green.shade300, width: 1.5),
                      foregroundColor: Colors.green[700],
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    'Scan QR code to join:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.09),
                            offset: const Offset(0, 4),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: QrImageView(
                        data: inviteLink,
                        version: QrVersions.auto,
                        size: 140.0,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    inviteLink,
                    style: TextStyle(
                        color: Colors.green.shade800,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
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
