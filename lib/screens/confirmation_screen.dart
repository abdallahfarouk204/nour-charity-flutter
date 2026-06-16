import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html; // فقط للويب – يمكن استبداله لاحقاً لتوافق الهواتف
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;

class ConfirmationScreen extends StatelessWidget {
  final double amount;
  final String method;
  final String? projectTitle;

  const ConfirmationScreen({
    super.key,
    required this.amount,
    required this.method,
    this.projectTitle,
  });

  // توليد رقم إيصال وهمي
  String get _receiptNumber => 'NRR-${DateTime.now().millisecondsSinceEpoch}';

  // توليد ملف PDF للإيصال
  Future<Uint8List> _generateReceiptPdf() async {
    final pdf = pw.Document();
    final isDark = false; // PDF عادي بلون فاتح
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('نور الخيري', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('إيصال التبرع', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('رقم الإيصال: $_receiptNumber'),
            pw.Text('التاريخ: ${DateTime.now().toLocal().toString().substring(0, 16)}'),
            pw.SizedBox(height: 20),
            pw.Text('المبلغ: ${amount.toStringAsFixed(0)} ج.م'),
            pw.Text('طريقة الدفع: $method'),
            if (projectTitle != null) pw.Text('المشروع: $projectTitle'),
            pw.SizedBox(height: 30),
            pw.Text('جزاك الله خيراً', style: pw.TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
    return pdf.save();
  }

  // تحميل الإيصال (للويب)
  Future<void> _downloadReceipt() async {
    final pdfBytes = await _generateReceiptPdf();
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'receipt_${_receiptNumber}.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  // مشاركة الإيصال (للويب فقط – تستخدم Share API)
  Future<void> _shareReceipt() async {
    final text = 'تبرعت بمبلغ ${amount.toStringAsFixed(0)} ج.م لصالح نور الخيري${projectTitle != null ? ' لمشروع $projectTitle' : ''}. جزاكم الله خيراً. #نور_الخيري';
    await Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تأكيد التبرع'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة النجاح
              Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              Text(
                'تم استلام تبرعك بنجاح',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'جزاك الله خيراً',
                style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.black54),
              ),
              const SizedBox(height: 24),

              // بطاقة الإيصال
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('إيصال التبرع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(thickness: 1),
                      _buildReceiptRow('رقم الإيصال', _receiptNumber),
                      _buildReceiptRow('التاريخ', DateTime.now().toLocal().toString().substring(0, 16)),
                      _buildReceiptRow('المبلغ', '${amount.toStringAsFixed(0)} ج.م'),
                      _buildReceiptRow('طريقة الدفع', method),
                      if (projectTitle != null) _buildReceiptRow('المشروع', projectTitle!),
                      const SizedBox(height: 10),
                      Text(
                        'تبرعك يساهم في تغيير حياة الكثيرين',
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black45, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // أزرار الإجراءات
              if (!isSmallScreen)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _downloadReceipt,
                      icon: const Icon(Icons.download),
                      label: const Text('تحميل الإيصال'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _shareReceipt,
                      icon: const Icon(Icons.share),
                      label: const Text('مشاركة'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _downloadReceipt,
                      icon: const Icon(Icons.download),
                      label: const Text('تحميل الإيصال'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size(double.infinity, 48)),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _shareReceipt,
                      icon: const Icon(Icons.share),
                      label: const Text('مشاركة'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 48)),
                    ),
                  ],
                ),
              const SizedBox(height: 20),

              // أزرار التنقل
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                    child: const Text('العودة للرئيسية'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // العودة إلى شاشة التبرع
                    },
                    child: const Text('تبرع مرة أخرى'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
