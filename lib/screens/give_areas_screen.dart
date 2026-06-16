import 'package:flutter/material.dart';
import 'projects_screen.dart';

class GiveAreasScreen extends StatelessWidget {
  const GiveAreasScreen({super.key});

  final List<Map<String, dynamic>> areas = const [
    {'title': 'الرعاية الصحية', 'icon': Icons.health_and_safety, 'raised': '120K', 'projects': '1'},
    {'title': 'الإغاثة العاجلة', 'icon': Icons.emergency, 'raised': '850K', 'projects': '1'},
    {'title': 'سقيا الماء', 'icon': Icons.water_drop, 'raised': '4200K', 'projects': '2'},
    {'title': 'كفالة الأيتام', 'icon': Icons.family_restroom, 'raised': '500K', 'projects': '3'},
    {'title': 'إعمار البيوت', 'icon': Icons.home, 'raised': '300K', 'projects': '1'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('مجالات العطاء'), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: areas.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final area = areas[index];
          return GestureDetector(
            onTap: () {
              // عند النقر، ننتقل إلى شاشة المشاريع (يمكن تعديل الوجهة لاحقًا)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProjectsScreen()),
              );
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: isDark ? const Color(0xFF1A2A22) : null,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isDark ? const Color(0xFF7CFF9E).withOpacity(0.2) : Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Icon(area['icon'], color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(area['title'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                          const SizedBox(height: 4),
                          Text('تم جمع ${area['raised']} ج.م - ${area['projects']} مشروع نشط',
                               style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade700)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
