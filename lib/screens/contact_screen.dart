import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('اتصل بنا'), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: isDark ? const Color(0xFF1A2A22) : null,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('معلومات الاتصال', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: Icon(Icons.location_on, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                      title: const Text('العنوان'),
                      subtitle: const Text('القاهرة، مصر - شارع التحرير'),
                      onTap: () => _launchMap(),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                      title: const Text('الهاتف'),
                      subtitle: const Text('5678 1234 2 20+'),
                      onTap: () => _launchPhone('+201234567890'),
                    ),
                    ListTile(
                      leading: Icon(Icons.email, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                      title: const Text('البريد الإلكتروني'),
                      subtitle: const Text('info@nour-charity.org'),
                      onTap: () => _launchEmail('info@nour-charity.org'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: isDark ? const Color(0xFF1A2A22) : null,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('تواصل معنا', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'الاسم',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                      ),
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                      ),
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                      ),
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'الرسالة',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                      ),
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الإرسال، شكراً لتواصلك')));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('إرسال'),
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

  void _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
  void _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
  void _launchMap() async {
    final uri = Uri.parse('https://maps.google.com/?q=Cairo,Egypt');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
