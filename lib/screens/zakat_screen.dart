import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ---------- Live prices (from goldapi.io) ----------
  Map<String, double> _prices = {
    'gold24k': 3000.0,
    'gold21k': 2625.0,
    'gold18k': 2250.0,
    'silver': 35.0,
  };
  bool _isLoadingPrices = true;
  bool _pricesLive = false;
  String? _lastUpdated;

  // ---------- Cash tab ----------
  double _cash = 0.0;

  // ---------- Gold tab (multiple entries) ----------
  List<Map<String, dynamic>> _goldEntries = [
    {'id': 1, 'grams': 0.0, 'karat': 24}
  ];
  int _nextGoldId = 2;

  // ---------- Silver tab ----------
  double _silverGrams = 0.0;

  // ---------- Crops tab ----------
  double _cropKg = 0.0;
  String _irrigation = 'natural'; // 'natural', 'mixed', 'irrigated'
  final List<String> _irrigationOptions = ['natural', 'mixed', 'irrigated'];

  // ---------- Calculation results ----------
  double _totalZakat = 0.0;
  double _cashZakat = 0.0;
  double _goldZakat = 0.0;
  double _silverZakat = 0.0;
  double _cropsZakatKg = 0.0;
  double _nisabValue = 0.0;

  // ---------- Nisab constants ----------
  static const double nisabGoldGrams = 85.0; // 85 grams of gold

  // ---------- Fetch live prices ----------
  Future<void> _fetchPrices() async {
    setState(() => _isLoadingPrices = true);
    try {
      // Replace with your actual API key from https://goldapi.io/
      const apiKey = 'goldapi-xxxxxxxx-xxxxxx-xxxxxx-xxxxxx';
      final url = Uri.parse('https://www.goldapi.io/api/XAU/EGP');
      final response = await http.get(url, headers: {'x-access-token': apiKey});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final double price24k = data['price']?.toDouble() ?? 3000.0;
        setState(() {
          _prices['gold24k'] = price24k;
          _prices['gold21k'] = price24k * 21 / 24;
          _prices['gold18k'] = price24k * 18 / 24;
          _prices['silver'] = data['silver']?.toDouble() ?? 35.0;
          _pricesLive = true;
          _lastUpdated = DateTime.now().toLocal().toString().substring(0, 16);
        });
      } else {
        throw Exception('Failed to load prices');
      }
    } catch (e) {
      // Fallback to default prices (already set)
      setState(() {
        _pricesLive = false;
        _lastUpdated = DateTime.now().toLocal().toString().substring(0, 16);
      });
    } finally {
      setState(() => _isLoadingPrices = false);
    }
  }

  // ---------- Gold helpers ----------
  void _addGoldEntry() {
    setState(() {
      _goldEntries.add({'id': _nextGoldId++, 'grams': 0.0, 'karat': 24});
    });
  }

  void _removeGoldEntry(int id) {
    if (_goldEntries.length > 1) {
      setState(() {
        _goldEntries.removeWhere((e) => e['id'] == id);
      });
    }
  }

  void _updateGoldEntry(int id, String field, dynamic value) {
    setState(() {
      final index = _goldEntries.indexWhere((e) => e['id'] == id);
      if (index != -1) {
        _goldEntries[index][field] = value;
      }
    });
  }

  // ---------- Calculate all ----------
  void _calculateZakat() {
    // Calculate total cash value
    final cashAmount = _cash;

    // Calculate total gold value
    double goldValue = 0.0;
    for (var entry in _goldEntries) {
      final grams = entry['grams'] as double;
      final karat = entry['karat'] as int;
      double pricePerGram;
      switch (karat) {
        case 24:
          pricePerGram = _prices['gold24k']!;
          break;
        case 21:
          pricePerGram = _prices['gold21k']!;
          break;
        case 18:
          pricePerGram = _prices['gold18k']!;
          break;
        default:
          pricePerGram = _prices['gold24k']!;
      }
      goldValue += grams * pricePerGram;
    }

    // Silver value
    final silverValue = _silverGrams * (_prices['silver'] ?? 35.0);

    // Nisab threshold (value of 85g of 24K gold)
    _nisabValue = nisabGoldGrams * (_prices['gold24k'] ?? 3000.0);

    // Zakat calculations (2.5% only if wealth >= nisab)
    final totalWealth = cashAmount + goldValue + silverValue;
    if (totalWealth >= _nisabValue) {
      _cashZakat = cashAmount * 0.025;
      _goldZakat = goldValue * 0.025;
      _silverZakat = silverValue * 0.025;
    } else {
      _cashZakat = _goldZakat = _silverZakat = 0.0;
    }

    // Crops Zakat (based on irrigation)
    double cropsZakatKg = 0.0;
    if (_cropKg > 0) {
      double rate;
      switch (_irrigation) {
        case 'natural':
          rate = 0.10;
          break;
        case 'mixed':
          rate = 0.075;
          break;
        case 'irrigated':
          rate = 0.05;
          break;
        default:
          rate = 0.10;
      }
      cropsZakatKg = _cropKg * rate;
    }
    _cropsZakatKg = cropsZakatKg;

    _totalZakat = _cashZakat + _goldZakat + _silverZakat;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchPrices();
    // Initial calculation after prices load
    _fetchPrices().then((_) => _calculateZakat());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ---------- UI Helpers ----------
  String _getIrrigationLabel(String type) {
    final isEn = false; // will be replaced by localization later
    switch (type) {
      case 'natural':
        return isEn ? 'Natural (Rain-fed)' : 'طبيعي (أمطار)';
      case 'mixed':
        return isEn ? 'Mixed (Rain + Machine)' : 'مشترك (طبيعي + صناعي)';
      case 'irrigated':
        return isEn ? 'Artificial (Machines)' : 'صناعي (بالآلات)';
      default:
        return '';
    }
  }

  String _getIrrigationSubtitle(String type) {
    final isEn = false;
    switch (type) {
      case 'natural':
        return isEn ? '10% Zakat — No cost' : 'يستحق 10% زكاة — بدون تكلفة ري';
      case 'mixed':
        return isEn ? '7.5% Zakat' : 'يستحق 7.5% زكاة';
      case 'irrigated':
        return isEn ? '5% Zakat — Irrigation cost' : 'يستحق 5% زكاة — تكلفة ري';
      default:
        return '';
    }
  }

  void _showRulesModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'شرح طريقة حساب الزكاة',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                ),
              ),
              const SizedBox(height: 20),
              _buildRuleSection(
                context,
                icon: Icons.scale,
                title: 'النِّصاب (الحد الأدنى)',
                content: 'النصاب هو الحد الأدنى من المال الذي تجب فيه الزكاة، ويعادل قيمة 85 جرام من الذهب عيار 24.\n\nإذا بلغت أموالك (نقد + ذهب + فضة) هذا الحد وحال عليها الحول، وجبت فيها الزكاة.',
              ),
              _buildRuleSection(
                context,
                icon: Icons.money,
                title: 'زكاة النقود والأموال',
                content: 'تُحسب بنسبة 2.5% من إجمالي المبالغ النقدية والمدخرات البنكية التي بلغت النصاب وحال عليها الحول.\n\nالزكاة = إجمالي النقود × 2.5%',
              ),
              _buildRuleSection(
                context,
                icon: Icons.workspace_premium,
                title: 'زكاة الذهب',
                content: 'تُحسب بنسبة 2.5% من القيمة السوقية الحالية للذهب. يتم ضرب الوزن بالجرامات في سعر الجرام حسب العيار (24، 21، أو 18).\n\nالزكاة = (الوزن × سعر الجرام) × 2.5%',
              ),
              _buildRuleSection(
                context,
                icon: Icons.diamond,
                title: 'زكاة الفضة',
                content: 'تُحسب بنسبة 2.5% من القيمة السوقية الحالية للفضة. يتم ضرب الوزن بالجرامات في سعر الجرام الحالي.\n\nالزكاة = (الوزن × سعر الجرام) × 2.5%',
              ),
              _buildRuleSection(
                context,
                icon: Icons.agriculture,
                title: 'زكاة الزروع والثمار',
                content: 'تُحسب حسب طريقة الري. زكاة الزروع تُخرج من المحصول نفسه (بالكيلوجرامات) وليس بالنقود.\n\n• ري طبيعي (بالأمطار): 10%\n• ري مشترك: 7.5%\n• ري صناعي (بالآلات): 5%',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('فهمت', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleSection(BuildContext context, {required IconData icon, required String title, required String content}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: 10),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54)),
        ],
      ),
    );
  }

  // ---------- Tab Builders ----------
  Widget _buildCashTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('أدخل إجمالي النقود والأموال السائلة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'المبلغ (ج.م)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    onChanged: (value) {
                      _cash = double.tryParse(value) ?? 0.0;
                      _calculateZakat();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ..._goldEntries.map((entry) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ذهب ${entry['id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (_goldEntries.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeGoldEntry(entry['id']),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'الوزن (جرام)', border: OutlineInputBorder()),
                      onChanged: (value) {
                        _updateGoldEntry(entry['id'], 'grams', double.tryParse(value) ?? 0.0);
                        _calculateZakat();
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: entry['karat'],
                      decoration: const InputDecoration(labelText: 'العيار', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 24, child: Text('24K')),
                        DropdownMenuItem(value: 21, child: Text('21K')),
                        DropdownMenuItem(value: 18, child: Text('18K')),
                      ],
                      onChanged: (value) {
                        _updateGoldEntry(entry['id'], 'karat', value);
                        _calculateZakat();
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          ElevatedButton.icon(
            onPressed: _addGoldEntry,
            icon: const Icon(Icons.add),
            label: const Text('إضافة ذهب آخر'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200, foregroundColor: Colors.black),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.grey.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('سعر جرام الذهب (عيار 24)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${_prices['gold24k']?.toStringAsFixed(2)} ج.م', style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor)),
                  if (_pricesLive)
                    const Text('(أسعار حية من goldapi.io)', style: TextStyle(fontSize: 12))
                  else
                    const Text('(أسعار تقديرية)', style: TextStyle(fontSize: 12, color: Colors.orange)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSilverTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('أدخل وزن الفضة بالجرامات', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'الوزن (جرام)', border: OutlineInputBorder()),
                    onChanged: (value) {
                      _silverGrams = double.tryParse(value) ?? 0.0;
                      _calculateZakat();
                    },
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('سعر جرام الفضة', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('${_prices['silver']?.toStringAsFixed(2)} ج.م', style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('أدخل وزن المحصول واختر طريقة الري', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'وزن المحصول (كجم)', border: OutlineInputBorder()),
                    onChanged: (value) {
                      _cropKg = double.tryParse(value) ?? 0.0;
                      _calculateZakat();
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('طريقة الري', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._irrigationOptions.map((type) {
                    return RadioListTile<String>(
                      title: Text(_getIrrigationLabel(type)),
                      subtitle: Text(_getIrrigationSubtitle(type), style: const TextStyle(fontSize: 12)),
                      value: type,
                      groupValue: _irrigation,
                      onChanged: (value) {
                        setState(() {
                          _irrigation = value!;
                          _calculateZakat();
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('حاسبة الزكاة'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showRulesModal,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(text: 'النقود', icon: Icon(Icons.money)),
            Tab(text: 'الذهب', icon: Icon(Icons.workspace_premium)),
            Tab(text: 'الفضة', icon: Icon(Icons.diamond)),
            Tab(text: 'الزروع', icon: Icon(Icons.agriculture)),
          ],
        ),
      ),
      body: _isLoadingPrices
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCashTab(),
                _buildGoldTab(),
                _buildSilverTab(),
                _buildCropsTab(),
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('إجمالي الزكاة المستحقة', style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 4),
            Text('${_totalZakat.toStringAsFixed(2)} ج.م', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            if (_cropsZakatKg > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'زكاة الزروع: ${_cropsZakatKg.toStringAsFixed(1)} كجم',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            if (_totalZakat == 0 && (_cash > 0 || _goldEntries.any((e) => e['grams'] > 0) || _silverGrams > 0))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '⚠️ أموالك أقل من النصاب (${_nisabValue.toStringAsFixed(0)} ج.م)',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
