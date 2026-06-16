import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('English / العربية', style: TextStyle(color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone_android, size: 80, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
              const SizedBox(height: 20),
              if (!_isOtpSent) ...[
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.phone, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                  ),
                  validator: (v) => v!.length < 10 ? 'أدخل رقم صحيح' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isOtpSent = true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('إرسال رمز التحقق'),
                ),
              ] else ...[
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'رمز التحقق (أي 4 أرقام)',
                    labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.vpn_key, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                  ),
                  validator: (v) => v!.length != 4 ? 'أدخل 4 أرقام' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_otpController.text.length == 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('تسجيل الدخول'),
                ),
                TextButton(
                  onPressed: () => setState(() => _isOtpSent = false),
                  child: Text('تغيير رقم الهاتف', style: TextStyle(color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
