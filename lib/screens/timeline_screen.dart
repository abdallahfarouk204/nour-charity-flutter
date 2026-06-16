import 'package:flutter/material.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  final List<Map<String, String>> timeline = const [
    {'year': '2010', 'event': 'تأسيس الجمعية'},
    {'year': '2012', 'event': 'افتتاح أول دائرة'},
    {'year': '2015', 'event': 'إطلاق برنامج القوافل الطبية'},
    {'year': '2018', 'event': 'الوصول إلى 10,000 مستفيد'},
    {'year': '2020', 'event': 'إطلاق المنصة الإلكترونية'},
    {'year': '2023', 'event': 'تحقيق 15 مليون جنيه تبرعات'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('مسيرتنا'), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: timeline.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = timeline[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: isDark ? const Color(0xFF7CFF9E).withOpacity(0.2) : Theme.of(context).primaryColor.withOpacity(0.1),
              child: Text(item['year']!, style: TextStyle(color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor)),
            ),
            title: Text(item['event']!, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
          );
        },
      ),
    );
  }
}
