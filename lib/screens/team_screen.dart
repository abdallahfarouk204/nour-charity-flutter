import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  final List<Map<String, String>> team = const [
    {'name': 'أ. سارة علي', 'role': 'مدير التطوير'},
    {'name': 'م. خالد عبدالله', 'role': 'مدير البرامج'},
    {'name': 'أ. فاطمة حسن', 'role': 'المدير التنفيذي'},
    {'name': 'د. أحمد محمود', 'role': 'رئيس مجلس الإدارة'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('فريق العمل'), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: team.length,
        itemBuilder: (context, index) {
          final member = team[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: isDark ? const Color(0xFF1A2A22) : null,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isDark ? const Color(0xFF7CFF9E).withOpacity(0.2) : Theme.of(context).primaryColor.withOpacity(0.1),
                child: Text(member['name']![0], style: TextStyle(color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor)),
              ),
              title: Text(member['name']!, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              subtitle: Text(member['role']!, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade700)),
            ),
          );
        },
      ),
    );
  }
}
