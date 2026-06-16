import 'package:flutter/material.dart';
import 'confirmation_screen.dart';
import '../data/mock_data.dart';

class DonateScreen extends StatefulWidget {
  final String? projectTitle;
  final int? projectId;
  final double? initialAmount;

  const DonateScreen({super.key, this.projectTitle, this.projectId, this.initialAmount});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Step 0
  int? _selectedAmountPreset;
  final TextEditingController _customAmountController = TextEditingController();
  String _donationType = 'sadaqah';
  int? _selectedProjectId;
  bool _isRecurring = false;

  // Step 1
  bool _isAnonymous = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final Map<String, String?> _errors = {};

  // Step 2
  String _paymentMethod = 'card';
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _expiryDate = TextEditingController();
  final TextEditingController _cvv = TextEditingController();
  final TextEditingController _cardHolderName = TextEditingController();

  double get _donationAmount {
    if (_selectedAmountPreset != null) return _selectedAmountPreset!.toDouble();
    if (_customAmountController.text.isNotEmpty) {
      return double.tryParse(_customAmountController.text) ?? 0.0;
    }
    return 0.0;
  }

  String _getDonationTypeLabel() {
    switch (_donationType) {
      case 'zakat': return 'زكاة مال';
      case 'sadaqah': return 'صدقة جارية';
      case 'kafala': return 'كفالة يتيم';
      default: return 'تبرع عام';
    }
  }

  String? _getSelectedProjectTitle() {
    if (_selectedProjectId == null) return null;
    for (var p in projects) {
      if (p.id == _selectedProjectId) {
        return p.title;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.projectId != null) {
      _selectedProjectId = widget.projectId;
    }
    if (widget.initialAmount != null && widget.initialAmount! > 0) {
      final amountInt = widget.initialAmount!.toInt();
      if (quickDonateAmounts.contains(amountInt)) {
        _selectedAmountPreset = amountInt;
      } else {
        _customAmountController.text = amountInt.toString();
      }
    }
  }

  bool _validateStep(int step) {
    _errors.clear();
    if (step == 0) {
      if (_donationAmount <= 0) _errors['amount'] = 'الرجاء إدخال مبلغ صحيح';
    } else if (step == 1) {
      if (!_isAnonymous) {
        if (_nameController.text.trim().isEmpty) _errors['name'] = 'الاسم مطلوب';
        if (_emailController.text.trim().isNotEmpty && !_emailController.text.contains('@')) {
          _errors['email'] = 'البريد الإلكتروني غير صحيح';
        }
        if (_phoneController.text.trim().isEmpty) _errors['phone'] = 'رقم الهاتف مطلوب';
      }
    } else if (step == 2) {
      if (_paymentMethod == 'card') {
        if (_cardNumber.text.trim().length < 16) _errors['cardNumber'] = 'رقم البطاقة غير صحيح';
        if (_expiryDate.text.trim().isEmpty) _errors['expiry'] = 'تاريخ الانتهاء مطلوب';
        if (_cvv.text.trim().length < 3) _errors['cvv'] = 'CVV غير صحيح';
        if (_cardHolderName.text.trim().isEmpty) _errors['cardHolder'] = 'الاسم على البطاقة مطلوب';
      }
    }
    setState(() {});
    return _errors.isEmpty;
  }

  void _nextStep() {
    if (_validateStep(_currentStep)) {
      setState(() { if (_currentStep < 2) _currentStep++; });
    }
  }

  void _prevStep() {
    setState(() { if (_currentStep > 0) _currentStep--; });
  }

  void _submitDonation() {
    if (_validateStep(2)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmationScreen(
            amount: _donationAmount,
            method: _paymentMethod == 'card' ? 'بطاقة ائتمان' : (_paymentMethod == 'wallet' ? 'محفظة إلكترونية' : 'تحويل بنكي'),
            projectTitle: _getSelectedProjectTitle() ?? (widget.projectTitle ?? 'عام'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: AppBar(title: const Text('تبرع الآن'), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildStepperForm(isDark)),
                Expanded(flex: 1, child: _buildOrderSummary(isDark)),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(child: _buildStepperForm(isDark)),
                const SizedBox(height: 16, child: Divider()),
                _buildOrderSummary(isDark),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildStepperForm(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Stepper(
              currentStep: _currentStep,
              onStepContinue: _nextStep,
              onStepCancel: _currentStep > 0 ? _prevStep : null,
              steps: [
                Step(title: const Text('اختر المبلغ والنوع'), content: _buildAmountTypeStep(), isActive: _currentStep >= 0),
                Step(title: const Text('بيانات المتبرع'), content: _buildDonorInfoStep(isDark), isActive: _currentStep >= 1),
                Step(title: const Text('طريقة الدفع'), content: _buildPaymentStep(isDark), isActive: _currentStep >= 2),
              ],
              controlsBuilder: (context, details) => Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    if (_currentStep > 0) ElevatedButton(onPressed: details.onStepCancel, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), child: const Text('السابق')),
                    const SizedBox(width: 12),
                    ElevatedButton(onPressed: details.onStepContinue, child: Text(_currentStep == 2 ? 'إتمام التبرع' : 'التالي')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('المبلغ', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: quickDonateAmounts.map((amount) => ChoiceChip(
            label: Text('$amount ج.م'),
            selected: _selectedAmountPreset == amount && _customAmountController.text.isEmpty,
            onSelected: (selected) {
              setState(() {
                _selectedAmountPreset = selected ? amount : null;
                if (selected) _customAmountController.clear();
              });
            },
          )).toList(),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _customAmountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'مبلغ آخر', border: OutlineInputBorder()),
          onChanged: (value) => setState(() => _selectedAmountPreset = null),
        ),
        if (_errors.containsKey('amount')) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_errors['amount']!, style: const TextStyle(color: Colors.red))),
        const SizedBox(height: 20),
        const Text('نوع الخير', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: donationTypes.map((type) => FilterChip(
            label: Text(type['name']!),
            selected: _donationType == type['id'],
            onSelected: (selected) => setState(() => _donationType = type['id']!),
          )).toList(),
        ),
        const SizedBox(height: 20),
        const Text('توجيه التبرع (اختياري)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int?>(
          value: _selectedProjectId,
          hint: const Text('اختر مشروعاً'),
          items: [
            const DropdownMenuItem(value: null, child: Text('تبرع عام (حيثما دعت الحاجة)')),
            ...projects.map((p) => DropdownMenuItem(value: p.id, child: Text(p.title))),
          ],
          onChanged: (value) => setState(() => _selectedProjectId = value),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Checkbox(value: _isRecurring, onChanged: (value) => setState(() => _isRecurring = value ?? false)),
            const Text('كفالة شهرية (تبرع متكرر)'),
          ],
        ),
      ],
    );
  }

  Widget _buildDonorInfoStep(bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(value: _isAnonymous, onChanged: (value) => setState(() => _isAnonymous = value ?? false)),
            const Text('تبرع مجهول (لا أريد ذكر اسمي)'),
          ],
        ),
        if (!_isAnonymous) ...[
          TextField(controller: _nameController, decoration: InputDecoration(labelText: 'الاسم الكامل', errorText: _errors['name'])),
          const SizedBox(height: 12),
          TextField(controller: _emailController, decoration: InputDecoration(labelText: 'البريد الإلكتروني (اختياري)', errorText: _errors['email'])),
          const SizedBox(height: 12),
          TextField(controller: _phoneController, decoration: InputDecoration(labelText: 'رقم الهاتف', errorText: _errors['phone'])),
        ],
      ],
    );
  }

  Widget _buildPaymentStep(bool isDark) {
    return Column(
      children: [
        Wrap(
          spacing: 12,
          children: paymentMethods.map((method) => FilterChip(
            avatar: Icon(method['icon'] == 'credit_card' ? Icons.credit_card : (method['icon'] == 'wallet' ? Icons.wallet : Icons.account_balance), size: 18),
            label: Text(method['name']!),
            selected: _paymentMethod == method['id'],
            onSelected: (selected) => setState(() => _paymentMethod = method['id']!),
          )).toList(),
        ),
        const SizedBox(height: 20),
        if (_paymentMethod == 'card') ...[
          TextField(controller: _cardNumber, decoration: InputDecoration(labelText: 'رقم البطاقة', errorText: _errors['cardNumber']), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: TextField(controller: _expiryDate, decoration: InputDecoration(labelText: 'تاريخ الانتهاء (MM/YY)', errorText: _errors['expiry']))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: _cvv, decoration: InputDecoration(labelText: 'CVV', errorText: _errors['cvv']), obscureText: true)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(controller: _cardHolderName, decoration: InputDecoration(labelText: 'الاسم على البطاقة', errorText: _errors['cardHolder'])),
        ],
        if (_paymentMethod == 'wallet') const Text('ستتلقى رسالة تأكيد على هاتفك مع تعليمات الدفع.', style: TextStyle(fontSize: 12)),
        if (_paymentMethod == 'bank') const Text('سيتم توجيهك إلى بوابة البنك بعد تأكيد الطلب.', style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildOrderSummary(bool isDark) {
    final projectName = _getSelectedProjectTitle() ?? (widget.projectTitle ?? 'عام');
    return Card(
      margin: const EdgeInsets.all(16),
      color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ملخص التبرع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (projectName != 'عام') Text('المشروع: $projectName', style: const TextStyle(fontSize: 14)),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('المبلغ'), Text('${_donationAmount.toStringAsFixed(0)} ج.م', style: const TextStyle(fontWeight: FontWeight.bold))]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('نوع الخير'), Text(_getDonationTypeLabel())]),
            if (_isRecurring) const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('التكرار'), Text('شهري')]),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.bold)), Text('${_donationAmount.toStringAsFixed(0)} ج.م', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))]),
            const SizedBox(height: 12),
            if (_donationAmount > 0) ElevatedButton(onPressed: _submitDonation, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)), child: const Text('تأكيد التبرع')),
          ],
        ),
      ),
    );
  }
}
