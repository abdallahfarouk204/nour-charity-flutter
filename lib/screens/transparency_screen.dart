import 'package:flutter/material.dart';
import '../data/mock_data.dart';

class TransparencyScreen extends StatelessWidget {
  const TransparencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalDonations = ImpactStats.totalDonations;
    final programExpenses = (totalDonations * 0.7).toInt();
    final adminExpenses = (totalDonations * 0.15).toInt();
    final operationalExpenses = totalDonations - programExpenses - adminExpenses;

    return Scaffold(
      appBar: AppBar(title: const Text('الشفافية'), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: isDark ? const Color(0xFF1A2A22) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('إجمالي التبرعات', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text(formatCurrency(totalDonations), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                    const Divider(height: 24),
                    const Text('توزيع الإنفاق', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildExpenseItem(context, 'البرامج الإغاثية والتنموية', programExpenses, totalDonations, 0.7, isDark),
                    const SizedBox(height: 12),
                    _buildExpenseItem(context, 'التكاليف الإدارية', adminExpenses, totalDonations, 0.15, isDark),
                    const SizedBox(height: 12),
                    _buildExpenseItem(context, 'المصاريف التشغيلية', operationalExpenses, totalDonations, 0.15, isDark),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('التقارير السنوية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildReportItem(context, 'تقرير 2023', 'PDF', '1.2 MB', Icons.picture_as_pdf, Colors.red, isDark),
            _buildReportItem(context, 'تقرير 2022', 'PDF', '1.1 MB', Icons.picture_as_pdf, Colors.red, isDark),
            _buildReportItem(context, 'تقرير 2021', 'PDF', '1.0 MB', Icons.picture_as_pdf, Colors.red, isDark),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: isDark ? const Color(0xFF1A2A22) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoTile(context, 'المستفيدين', formatNumber(ImpactStats.beneficiaries), Icons.people, isDark),
                    _buildInfoTile(context, 'المشاريع', formatNumber(ImpactStats.projectsCount), Icons.folder, isDark),
                    _buildInfoTile(context, 'المتصدقين', formatNumber(ImpactStats.donors), Icons.heart_broken, isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseItem(BuildContext context, String label, int amount, int total, double percentage, bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
            Text('${(percentage * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(value: percentage, backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text('${formatCurrency(amount)} من ${formatCurrency(total)}', style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildReportItem(BuildContext context, String title, String format, String size, IconData icon, Color color, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isDark ? const Color(0xFF1A2A22) : Colors.white,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text('$format • $size', style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade600)),
        trailing: const Icon(Icons.download),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تحميل التقرير (محاكاة)'))),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String label, String value, IconData icon, bool isDark) {
    return Column(
      children: [
        Icon(icon, size: 32, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
        Text(label, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade600)),
      ],
    );
  }
}

String formatCurrency(int amount) {
  if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M ج.م';
  if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K ج.م';
  return '$amount ج.م';
}
String formatNumber(int number) {
  if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
  if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
  return number.toString();
}
