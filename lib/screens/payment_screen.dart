import 'package:flutter/material.dart';
import 'confirmation_screen.dart';

class PaymentScreen extends StatelessWidget {
  final double amount;
  final String charityType;
  final String? projectTitle;
  final bool isMonthly;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.charityType,
    this.projectTitle,
    required this.isMonthly,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String _selectedMethod = 'بطاقة ائتمان';
    final List<String> _paymentMethods = ['بطاقة ائتمان', 'فودافون كاش', 'تحويل بنكي'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الدفع'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: isDark ? const Color(0xFF1A2A22) : null,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ملخص التبرع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                    const SizedBox(height: 8),
                    Text('المبلغ: ${amount.toStringAsFixed(0)} ج.م', style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.black54)),
                    Text('نوع الخير: $charityType', style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.black54)),
                    if (projectTitle != null) Text('المشروع: $projectTitle', style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.black54)),
                    if (isMonthly) Text('كفالة شهرية', style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.black54)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('طريقة الدفع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedMethod,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              dropdownColor: isDark ? const Color(0xFF1A2A22) : null,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              items: _paymentMethods.map((method) {
                return DropdownMenuItem(value: method, child: Text(method));
              }).toList(),
              onChanged: (value) => _selectedMethod = value!,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Simulate payment success
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmationScreen(
                      amount: amount,
                      method: _selectedMethod,
                      projectTitle: projectTitle,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                foregroundColor: isDark ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('تأكيد الدفع'),
            ),
          ],
        ),
      ),
    );
  }
}
