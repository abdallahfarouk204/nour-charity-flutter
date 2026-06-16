import 'package:flutter/material.dart';
import 'volunteer_form_screen.dart';

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final volunteerStats = [
      {'value': '2,500+', 'label': 'متطوع نشط', 'icon': Icons.people},
      {'value': '50,000+', 'label': 'ساعة تطوعية', 'icon': Icons.timer},
      {'value': '120+', 'label': 'مجتمع مستفيد', 'icon': Icons.people_alt},
      {'value': '35+', 'label': 'مشروع تطوعي', 'icon': Icons.business_center},
    ];

    final reasons = [
      {'icon': Icons.favorite, 'title': 'أجر عظيم', 'desc': 'التطوع من أعظم أبواب الخير والصدقة الجارية'},
      {'icon': Icons.group, 'title': 'صداقات جديدة', 'desc': 'انضم لمجتمع من المتطوعين المحبين للخير'},
      {'icon': Icons.trending_up, 'title': 'تطوير مهاراتك', 'desc': 'اكتسب خبرات عملية وطوّر مهاراتك المهنية'},
      {'icon': Icons.public, 'title': 'أثر حقيقي', 'desc': 'شاهد تأثيرك المباشر على حياة المحتاجين'},
    ];

    final opportunities = [
      {'icon': Icons.medical_services, 'title': 'طبي', 'desc': 'المشاركة في القوافل الطبية والتوعية الصحية'},
      {'icon': Icons.school, 'title': 'تعليمي', 'desc': 'تعليم الأطفال ومحو الأمية والدروس الخصوصية'},
      {'icon': Icons.people, 'title': 'مجتمعي', 'desc': 'تنمية المجتمعات المحلية والمبادرات الاجتماعية'},
      {'icon': Icons.computer, 'title': 'تقني', 'desc': 'التصميم والبرمجة ودعم البنية التحتية الرقمية'},
      {'icon': Icons.description, 'title': 'إداري', 'desc': 'التنظيم والإدارة والتخطيط للمشاريع'},
      {'icon': Icons.agriculture, 'title': 'ميداني', 'desc': 'التوزيع والإغاثة والعمل الميداني المباشر'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('التطوع'), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context, isDark),
            const SizedBox(height: 32),
            _buildStatsGrid(context, volunteerStats, isDark),
            const SizedBox(height: 48),
            _buildReasonsSection(context, reasons, isDark),
            const SizedBox(height: 48),
            _buildOpportunitiesSection(context, opportunities, isDark),
            const SizedBox(height: 48),
            _buildSignupSection(context, isDark),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0xFF0A1F0F), const Color(0xFF0F2A18)]
              : [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
        ),
      ),
      child: Column(
        children: [
          const Text('كن جزءاً من فريق التغيير', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          Text('انضم إلى آلاف المتطوعين الذين يساهمون في تحسين حياة المحتاجين', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, List<Map<String, dynamic>> stats, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
        children: stats.map((stat) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? const Color(0xFF1A2A22) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(stat['icon'] as IconData, size: 36, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 8),
                  Text(stat['value'] as String, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                  const SizedBox(height: 4),
                  Text(stat['label'] as String, style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54), textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReasonsSection(BuildContext context, List<Map<String, dynamic>> reasons, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Text('لماذا تتطوع معنا؟', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: reasons.map((reason) {
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: isDark ? const Color(0xFF1A2A22) : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(reason['icon'] as IconData, size: 42, color: Theme.of(context).primaryColor),
                      const SizedBox(height: 12),
                      Text(reason['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(reason['desc'] as String, style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunitiesSection(BuildContext context, List<Map<String, dynamic>> opportunities, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Text('فرص التطوع', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: opportunities.map((opp) {
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: isDark ? const Color(0xFF1A2A22) : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(opp['icon'] as IconData, size: 40, color: Theme.of(context).primaryColor),
                      const SizedBox(height: 10),
                      Text(opp['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(opp['desc'] as String, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.black54), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupSection(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? const Color(0xFF1A2A22) : Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)]),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const Text('سجل كمتطوع', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('انضم إلينا واصنع الفرق. سنتواصل معك لتحديد أفضل مجال ووقت للتطوع.', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9)), textAlign: TextAlign.center),
              ],
            ),
          ),
          const VolunteerFormScreen(),
        ],
      ),
    );
  }
}
