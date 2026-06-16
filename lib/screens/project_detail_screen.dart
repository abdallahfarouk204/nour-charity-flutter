import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/mock_data.dart';
import 'donate_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;
  final String heroTag;

  const ProjectDetailScreen({super.key, required this.project, required this.heroTag});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  int _selectedTab = 0;
  int _selectedAmount = 100;
  final List<int> _amounts = [50, 100, 200, 500, 1000, 2000];

  List<Update> get _projectUpdates => updates.where((u) => u.projectId == widget.project.id).toList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = widget.project.progress > 1 ? 1.0 : widget.project.progress;
    final percentage = (progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.heroTag,
              child: CachedNetworkImage(
                imageUrl: widget.project.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 250,
                  color: isDark ? const Color(0xFF0F2A18) : Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 250,
                  color: isDark ? const Color(0xFF0F2A18) : Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, size: 60),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.project.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: isDark ? Colors.white60 : Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(widget.project.location, style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : Colors.grey.shade600)),
                      const SizedBox(width: 16),
                      Icon(Icons.timer, size: 16, color: isDark ? Colors.white60 : Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text('${widget.project.daysLeft} يوم متبقي', style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
            _buildTabs(isDark),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              child: _selectedTab == 0
                  ? _buildOverviewTab(isDark)
                  : _selectedTab == 1
                      ? _buildUpdatesTab(isDark)
                      : _selectedTab == 2
                          ? _buildBudgetTab(isDark)
                          : _buildFaqTab(isDark),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildSidebar(isDark, percentage.toDouble(), progress),
    );
  }

  Widget _buildTabs(bool isDark) {
    final tabs = ['نظرة عامة', 'تحديثات', 'الميزانية', 'الأسئلة'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? (isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? (isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor) : (isDark ? Colors.white70 : Colors.grey.shade700),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOverviewTab(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.project.description,
          style: TextStyle(fontSize: 16, height: 1.6, color: isDark ? Colors.white70 : Colors.black87),
        ),
        const SizedBox(height: 24),
        const Text('أهداف المشروع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ..._getGoals().map((goal) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 20, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(goal, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87))),
                ],
              ),
            )),
      ],
    );
  }

  List<String> _getGoals() {
    return [
      'الوصول إلى الفئات المستهدفة في المناطق الأكثر احتياجاً',
      'توفير الدعم المادي والعيني بشكل مباشر',
      'ضمان الشفافية الكاملة في توزيع التبرعات',
      'متابعة وتقييم الأثر بشكل دوري',
    ];
  }

  Widget _buildUpdatesTab(bool isDark) {
    if (_projectUpdates.isEmpty) {
      return Center(
        child: Text('لا توجد تحديثات حالياً', style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade600)),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _projectUpdates.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final update = _projectUpdates[index];
        return ListTile(
          leading: const Icon(Icons.announcement, color: Colors.teal),
          title: Text(update.title, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
          subtitle: Text(update.date, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade600)),
        );
      },
    );
  }

  Widget _buildBudgetTab(bool isDark) {
    final items = [
      {'label': 'المستلزمات والمواد', 'value': 60},
      {'label': 'النقل والتوزيع', 'value': 20},
      {'label': 'التشغيل والإدارة', 'value': 15},
      {'label': 'الطوارئ والاحتياطي', 'value': 5},
    ];
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['label'] as String, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
                  Text('${item['value']}%', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor)),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: (item['value'] as int) / 100,
                backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFaqTab(bool isDark) {
    final faqs = [
      {'q': 'كيف يمكنني التأكد من وصول تبرعي؟', 'a': 'نلتزم بالشفافية الكاملة وننشر تحديثات دورية عن توزيع التبرعات مع صور وتقارير مفصلة.'},
      {'q': 'هل يمكنني التبرع بشكل شهري؟', 'a': 'نعم، يمكنك إعداد تبرع شهري متكرر لدعم المشروع بشكل مستمر.'},
      {'q': 'هل التبرع معفى من الضرائب؟', 'a': 'نعم، التبرعات معفاة من الضرائب وفقًا للقوانين المصرية ونوفر إيصالات رسمية.'},
    ];
    return Column(
      children: faqs.map((faq) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: isDark ? const Color(0xFF1A2A22) : Colors.grey.shade50,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(faq['q']!, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                const SizedBox(height: 8),
                Text(faq['a']!, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSidebar(bool isDark, double percentage, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2A22) : Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('تم جمع:', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700)),
              Text('${widget.project.raised} ج.م', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الهدف:', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700)),
              Text('${widget.project.goal} ج.م', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress, backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
          const SizedBox(height: 8),
          Text('${(percentage * 100).toInt()}% مكتمل', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700)),
          const Divider(height: 24),
          const Text('اختر المبلغ', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _amounts.map((amount) {
              return ChoiceChip(
                label: Text('$amount ج.م'),
                selected: _selectedAmount == amount,
                onSelected: (selected) => setState(() => _selectedAmount = amount),
                selectedColor: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                labelStyle: TextStyle(color: _selectedAmount == amount ? Colors.black : (isDark ? Colors.white70 : Colors.black87)),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DonateScreen(
                      projectTitle: widget.project.title,
                      projectId: widget.project.id,
                      initialAmount: _selectedAmount.toDouble(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                foregroundColor: isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('تبرع الآن', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share),
            label: const Text('مشاركة المشروع'),
            style: OutlinedButton.styleFrom(foregroundColor: isDark ? Colors.white70 : Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
