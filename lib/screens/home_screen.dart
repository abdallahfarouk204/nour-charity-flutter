import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/mock_data.dart';
import 'zakat_screen.dart';
import 'projects_screen.dart';
import 'donate_screen.dart';
import 'project_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final urgentProjects = projects.where((p) => p.featured).toList();
    final recentUpdates = updates.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('نور الخيري'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(context, isDark),
            const SizedBox(height: 24),
            _buildStatsRow(context, isDark),
            const SizedBox(height: 24),
            _buildGiveAreasSection(context, isDark),
            const SizedBox(height: 32),
            _buildUrgentCasesSection(context, isDark, urgentProjects),
            const SizedBox(height: 48),
            _buildQuickDonateSection(context, isDark),
            const SizedBox(height: 48),
            _buildTestimonialsSection(context, isDark),
            const SizedBox(height: 48),
            _buildLatestUpdatesSection(context, isDark, recentUpdates),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A1F0F), Color(0xFF0F2A18)],
              )
            : LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.15),
                  Theme.of(context).primaryColor.withOpacity(0.05),
                ],
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'صدقتك.. حياة لغيرك',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'ساهم في تفريج كرب الأسر المتعففة في مصر، وأغث إخواننا في غزة والسودان. قال تعالى: (وَإِذَا تَطَهَّرْ فَلَا تَنْقُصُّ) نور. جسر الخير بينك وبين المستحقين.',
            style: TextStyle(
              fontSize: 15.5,
              height: 1.7,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => DonateScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7CFF9E),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('تبرع الآن'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ZakatScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? Colors.white : Theme.of(context).primaryColor,
                    side: BorderSide(color: isDark ? Colors.white : Theme.of(context).primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('احسب زكاتك'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, bool isDark) {
    final stats = [
      {'value': formatNumber(ImpactStats.donors), 'label': 'متصدق وثق بنا'},
      {'value': formatNumber(ImpactStats.projectsCount), 'label': 'مشروع تنموي وإغاثي'},
      {'value': formatNumber(ImpactStats.beneficiaries), 'label': 'إنسان تم جبر خاطره'},
      {'value': formatCurrency(ImpactStats.totalDonations), 'label': 'إجمالي الخير المقدم'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: stats.asMap().entries.map((entry) {
          final index = entry.key;
          final s = entry.value;
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + (index * 50)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              width: (MediaQuery.of(context).size.width - 48) / 2,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A2A22) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isDark ? Border.all(color: const Color(0xFF2A3F32), width: 1.5) : null,
                boxShadow: const [
                  BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    s['value']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7CFF9E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s['label']!,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGiveAreasSection(BuildContext context, bool isDark) {
    final areas = [
      {'icon': Icons.home, 'label': 'إعمار البيوت'},
      {'icon': Icons.people, 'label': 'ستر وتزويج'},
      {'icon': Icons.emergency, 'label': 'إغاثة عاجلة'},
      {'icon': Icons.water_drop, 'label': 'سقيا الماء'},
      {'icon': Icons.health_and_safety, 'label': 'الرعاية الصحية'},
      {'icon': Icons.family_restroom, 'label': 'كفالة الأيتام'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'مجالات العطاء',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: areas.length,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 200 + (index * 30)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: const Color(0xFF7CFF9E).withOpacity(0.15),
                      child: Icon(
                        areas[index]['icon'] as IconData,
                        color: const Color(0xFF7CFF9E),
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      areas[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUrgentCasesSection(BuildContext context, bool isDark, List<Project> urgentProjects) {
    if (urgentProjects.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الحالات الأشد احتياجاً',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectsScreen())),
                child: const Text('عرض الكل'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 420,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: urgentProjects.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final project = urgentProjects[index];
              return _buildUrgentCard(context, project, isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUrgentCard(BuildContext context, Project project, bool isDark) {
    final progress = project.progress;
    return SizedBox(
      width: 280,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDark ? const Color(0xFF1A2A22) : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: project.imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 160,
                      color: isDark ? const Color(0xFF0F2A18) : Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 160,
                      color: isDark ? const Color(0xFF0F2A18) : Colors.grey.shade200,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                if (project.isUrgent)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'عاجل',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress > 1 ? 1 : progress,
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency(project.raised),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        'من ${formatCurrency(project.goal)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people, size: 14, color: isDark ? Colors.white60 : Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${project.donorsCount} متبرع',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.grey.shade700,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.timer, size: 14, color: isDark ? Colors.white60 : Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${project.daysLeft} يوم',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DonateScreen(projectTitle: project.title, projectId: project.id),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('تبرع الآن'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickDonateSection(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0A1F0F), const Color(0xFF0F2A18)]
              : [Theme.of(context).primaryColor.withOpacity(0.1), Theme.of(context).primaryColor.withOpacity(0.05)],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'تبرع في ثوانٍ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'خير الناس أنفعهم للناس.. اختر سهمك في الخير',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: quickDonateAmounts.map((amount) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DonateScreen(initialAmount: amount.toDouble()),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF1A2A22) : Colors.white,
                  foregroundColor: isDark ? Colors.white : Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('$amount ج.م'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'قالوا عن نور',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: testimonials.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final t = testimonials[index];
              return SizedBox(
                width: 280,
                child: Card(
                  color: isDark ? const Color(0xFF1A2A22) : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.format_quote, size: 30, color: Colors.grey),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            t.text,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isDark ? const Color(0xFF7CFF9E).withOpacity(0.2) : Theme.of(context).primaryColor.withOpacity(0.1),
                              child: Text(
                                t.avatarInitial,
                                style: TextStyle(color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    t.role,
                                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLatestUpdatesSection(BuildContext context, bool isDark, List<Update> updates) {
    if (updates.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'آخر التحديثات',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('عرض الكل'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: updates.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final u = updates[index];
            return Card(
              color: isDark ? const Color(0xFF1A2A22) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.announcement, color: Colors.teal),
                title: Text(u.title, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                subtitle: Text(u.date, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade700)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            );
          },
        ),
      ],
    );
  }
}

String formatNumber(int number) {
  if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
  if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
  return number.toString();
}

String formatCurrency(int amount) {
  if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M ج.م';
  if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K ج.م';
  return '$amount ج.م';
}
