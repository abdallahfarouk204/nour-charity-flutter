import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolunteerFormScreen extends StatefulWidget {
  const VolunteerFormScreen({super.key});

  @override
  State<VolunteerFormScreen> createState() => _VolunteerFormScreenState();
}

class _VolunteerFormScreenState extends State<VolunteerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedArea = 'طبي';
  final List<String> _areas = ['طبي', 'تعليمي', 'مجتمعي', 'تقني', 'إداري', 'ميداني'];
  final _messageController = TextEditingController();
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'الاسم الكامل',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              validator: (v) => v == null || v.trim().isEmpty ? 'الاسم مطلوب' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'البريد الإلكتروني مطلوب';
                if (!v.contains('@')) return 'أدخل بريداً صحيحاً';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'رقم الهاتف',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'رقم الهاتف مطلوب';
                if (v.length < 10) return 'أدخل رقم صحيح';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedArea,
              decoration: InputDecoration(
                labelText: 'مجال التطوع المفضل',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              dropdownColor: isDark ? const Color(0xFF1A2A22) : null,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              items: _areas.map((area) => DropdownMenuItem(value: area, child: Text(area))).toList(),
              onChanged: (val) => setState(() => _selectedArea = val!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'رسالة (اختياري)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitted ? null : () async {
                if (_formKey.currentState!.validate()) {
                  setState(() => _submitted = true);
                  // محاكاة حفظ البيانات
                  await Future.delayed(const Duration(seconds: 2));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('شكراً لتسجيلك! سنتواصل معك قريباً')),
                  );
                  _nameController.clear();
                  _emailController.clear();
                  _phoneController.clear();
                  _messageController.clear();
                  setState(() => _submitted = false);
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                foregroundColor: isDark ? Colors.black : Colors.white,
              ),
              child: _submitted
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('سجل الآن', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
