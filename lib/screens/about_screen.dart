import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('من نحن'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: isDark ? const Color(0xFF1A2A22) : null,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('رؤيتنا', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'أن تكون النموذج الرائد في العمل الخيري المستدام، نحفظ كرامة الإنسان ونبني مجتمعاً متكافلاً.',
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text('رسالتنا', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'إيصال الأمانات إلى أهلها في مصر وغزة والسودان بدقة وشفافية، وتوفير حياة أكثر كرامة من خلال مشاريع تنموية وإغاثية.',
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('قيمنا الراسخة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildValueItem(context, isDark, 'الإتقان', 'ندير الموارد باحترافية لتعظيم الأثر'),
                    _buildValueItem(context, isDark, 'الوضوح', 'نطلعكم على أين ذهبت صدقاتكم بالصور والتقارير'),
                    _buildValueItem(context, isDark, 'الأمانة', 'كل جنيه أمانة في رقابنا حتى يصل لمستحقه'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem(BuildContext context, bool isDark, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• $title',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black87),
          ),
        ],
      ),
    );
  }
}
