import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/mock_data.dart';
import 'donate_screen.dart';
import 'project_detail_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  // البحث والفلتر والترتيب
  String _searchQuery = '';
  int? _selectedProgramId; // null يعني الكل
  String _sortBy = 'newest'; // 'newest', 'mostFunded', 'endingSoon'

  // قائمة البرامج لعناصر الفلتر
  final List<Program> _programs = programs;

  // المشاريع المفلترة والمرتبة
  List<Project> get _filteredAndSortedProjects {
    // 1. تصفية حسب البحث
    var filtered = projects.where((project) {
      final matchesSearch = _searchQuery.isEmpty ||
          project.title.contains(_searchQuery) ||
          project.description.contains(_searchQuery);
      final matchesProgram = _selectedProgramId == null ||
          project.programId == _selectedProgramId;
      return matchesSearch && matchesProgram;
    }).toList();

    // 2. ترتيب
    switch (_sortBy) {
      case 'mostFunded':
        filtered.sort((a, b) => (b.raised / b.goal).compareTo(a.raised / a.goal));
        break;
      case 'endingSoon':
        filtered.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
        break;
      default: // 'newest'
        filtered.sort((a, b) => b.id.compareTo(a.id));
        break;
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projectsList = _filteredAndSortedProjects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المشاريع'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          // شريط البحث والفلتر والترتيب
          _buildSearchAndFilters(isDark),
          const SizedBox(height: 8),
          // قائمة المشاريع
          Expanded(
            child: projectsList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد مشاريع مطابقة',
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                              _selectedProgramId = null;
                              _sortBy = 'newest';
                            });
                          },
                          child: const Text('عرض الكل'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: projectsList.length,
                    itemBuilder: (context, index) {
                      final project = projectsList[index];
                      return _buildProjectCard(context, project, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // شريط البحث والفلتر والترتيب
  Widget _buildSearchAndFilters(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // مربع البحث
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'ابحث عن مشروع...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
            ),
          ),
          const SizedBox(height: 12),
          // صف الفلتر والترتيب
          Row(
            children: [
              // فلتر البرامج (Dropdown)
              Expanded(
                child: DropdownButtonFormField<int?>(
                  value: _selectedProgramId,
                  hint: const Text('جميع البرامج'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  ),
                  items: [
                    const DropdownMenuItem<int?>(value: null, child: Text('الكل')),
                    ..._programs.map((program) => DropdownMenuItem<int?>(
                          value: program.id,
                          child: Text(program.name),
                        )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedProgramId = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              // ترتيب (Sort)
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _sortBy,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'newest', child: Text('الأحدث')),
                    DropdownMenuItem(value: 'mostFunded', child: Text('الأكثر تمويلاً')),
                    DropdownMenuItem(value: 'endingSoon', child: Text('ينتهي قريباً')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // بطاقة المشروع (أفقية كما في الموقع)
  Widget _buildProjectCard(BuildContext context, Project project, bool isDark) {
    final progress = project.progress > 1 ? 1.0 : project.progress;
    final percentage = (progress * 100).toInt();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProjectDetailScreen(project: project, heroTag: 'project_${project.id}'),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 16),
        color: isDark ? const Color(0xFF1A2A22) : Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المشروع (جهة اليمين أو اليسار حسب اللغة)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: project.imageUrl,
                height: 160,
                width: 140,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 160,
                  width: 140,
                  color: isDark ? const Color(0xFF0F2A18) : Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 160,
                  width: 140,
                  color: isDark ? const Color(0xFF0F2A18) : Colors.grey.shade200,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            // محتوى البطاقة
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان المشروع
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
                    // الوصف (مختصر)
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
                    // الموقع
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: isDark ? Colors.white60 : Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          project.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // شريط التقدم والنسبة
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$percentage%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              '${project.daysLeft} يوم',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white60 : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                          color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // عدد المتبرعين وزر التبرع
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DonateScreen(projectTitle: project.title, projectId: project.id),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            backgroundColor: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                            foregroundColor: isDark ? Colors.black : Colors.white,
                          ),
                          child: const Text('تبرع الآن'),
                        ),
                      ],
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
}
