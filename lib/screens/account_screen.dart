import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final Map<String, dynamic> _user = {
    'name': 'أحمد محمد',
    'email': 'ahmed@example.com',
    'phone': '01012345678',
    'totalDonations': 5250,
    'donationCount': 8,
  };

  final List<Map<String, dynamic>> _donations = [
    {'date': '2024-03-01', 'amount': 500, 'project': 'إفطار صائم'},
    {'date': '2024-02-15', 'amount': 1000, 'project': 'كسوة الشتاء'},
    {'date': '2024-01-20', 'amount': 250, 'project': 'علاج مرضى'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('حسابي'), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(isDark),
            const SizedBox(height: 16),
            _buildStatsRow(isDark),
            const SizedBox(height: 24),
            const Text('تاريخ التبرعات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildDonationsList(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? const Color(0xFF1A2A22) : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: isDark ? const Color(0xFF7CFF9E).withOpacity(0.2) : Theme.of(context).primaryColor.withOpacity(0.2),
              child: Icon(Icons.person, size: 35, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_user['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                  const SizedBox(height: 4),
                  Text(_user['email'], style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : Colors.grey.shade600)),
                  Text(_user['phone'], style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    return Row(
      children: [
        _buildStatCard(isDark, 'التبرعات', _user['donationCount'].toString(), Icons.card_giftcard),
        const SizedBox(width: 12),
        _buildStatCard(isDark, 'إجمالي التبرع', '${_user['totalDonations']} ج.م', Icons.attach_money),
      ],
    );
  }

  Widget _buildStatCard(bool isDark, String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: isDark ? const Color(0xFF1A2A22) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(icon, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor)),
              Text(title, style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonationsList(bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _donations.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final donation = _donations[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: isDark ? const Color(0xFF7CFF9E).withOpacity(0.2) : Theme.of(context).primaryColor.withOpacity(0.1),
            child: Text('${index + 1}', style: TextStyle(color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor)),
          ),
          title: Text(donation['project'], style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
          subtitle: Text(donation['date'], style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade600)),
          trailing: Text('${donation['amount']} ج.م', style: const TextStyle(fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}
