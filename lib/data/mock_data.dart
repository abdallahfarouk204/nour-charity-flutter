// lib/data/mock_data.dart
// بيانات وهمية مطابقة للموقع الأصلي (React) – بدون API أو صور حقيقية

import 'package:flutter/material.dart';

/// الإحصائيات الرئيسية (Impact Stats)
class ImpactStats {
  static const totalDonations = 45750000;
  static const beneficiaries = 85400;
  static const projectsCount = 120;
  static const donors = 15300;
}

/// نموذج البرنامج (Program)
class Program {
  final int id;
  final String name;
  final String nameEn;
  final String icon;
  final Color color;

  Program({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.icon,
    required this.color,
  });
}

/// نموذج المشروع (Project)
class Project {
  final int id;
  final int programId;
  final String program;
  final String programEn;
  final String title;
  final String titleEn;
  final String description;
  final String descriptionEn;
  final String location;
  final String locationEn;
  final int goal;
  final int raised;
  final int donorsCount;
  final int daysLeft;
  final int donationAmount; // مبلغ التبرع المقترح
  final String imageUrl; // رابط صورة وهمي (يمكن استبداله لاحقاً)
  final String status; // 'active', 'completed', 'pending'
  final bool featured; // هل هو ضمن "الحالات الأشد احتياجاً"

  Project({
    required this.id,
    required this.programId,
    required this.program,
    required this.programEn,
    required this.title,
    required this.titleEn,
    required this.description,
    required this.descriptionEn,
    required this.location,
    required this.locationEn,
    required this.goal,
    required this.raised,
    required this.donorsCount,
    required this.daysLeft,
    required this.donationAmount,
    required this.imageUrl,
    required this.status,
    required this.featured,
  });

  double get progress => raised / goal;
  bool get isUrgent => daysLeft <= 10;
}

/// نموذج التحديث (Update)
class Update {
  final int id;
  final int projectId;
  final String title;
  final String titleEn;
  final String date;
  final String icon; // font awesome class (مؤقت)

  Update({
    required this.id,
    required this.projectId,
    required this.title,
    required this.titleEn,
    required this.date,
    required this.icon,
  });
}

/// نموذج الشهادة (Testimonial)
class Testimonial {
  final int id;
  final String name;
  final String nameEn;
  final String role;
  final String roleEn;
  final String text;
  final String textEn;
  final String avatarInitial; // أول حرف من الاسم

  Testimonial({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.role,
    required this.roleEn,
    required this.text,
    required this.textEn,
    required this.avatarInitial,
  });
}

/// قائمة البرامج (مطابقة لـ programs في mockData.js)
final List<Program> programs = [
  Program(
    id: 1,
    name: 'كفالة الأيتام',
    nameEn: 'Orphan Sponsorship',
    icon: 'fa-solid fa-children',
    color: const Color(0xFF0B6B6B),
  ),
  Program(
    id: 2,
    name: 'الرعاية الصحية',
    nameEn: 'Healthcare',
    icon: 'fa-solid fa-hospital',
    color: const Color(0xFF1E9E54),
  ),
  Program(
    id: 3,
    name: 'سقيا الماء',
    nameEn: 'Water Projects',
    icon: 'fa-solid fa-faucet-drip',
    color: const Color(0xFF3498DB),
  ),
  Program(
    id: 4,
    name: 'الإغاثة العاجلة (غزة والسودان)',
    nameEn: 'Emergency Relief (Gaza & Sudan)',
    icon: 'fa-solid fa-hand-holding-medical',
    color: const Color(0xFFC0392B),
  ),
  Program(
    id: 5,
    name: 'ستر وتزويج',
    nameEn: 'Marriage Support',
    icon: 'fa-solid fa-ring',
    color: const Color(0xFF8E44AD),
  ),
  Program(
    id: 6,
    name: 'إعمار البيوت',
    nameEn: 'House Renovation',
    icon: 'fa-solid fa-house-chimney',
    color: const Color(0xFFD35400),
  ),
];

/// قائمة المشاريع (مطابقة لـ projects في mockData.js)
final List<Project> projects = [
  Project(
    id: 1,
    programId: 1,
    program: 'كفالة الأيتام',
    programEn: 'Orphan Sponsorship',
    title: 'كفالة 500 يتيم في الصعيد',
    titleEn: 'Sponsor 500 Orphans in Upper Egypt',
    description:
        'كفالة شهرية شاملة (تعليم، صحة، غذاء) للأيتام في قرى قنا وسوهاج. قال ﷺ: (أنا وكافل اليتيم في الجنة كهاتين).',
    descriptionEn:
        'Comprehensive monthly sponsorship (education, health, food) for orphans in the villages of Qena and Sohag.',
    location: 'قنا وسوهاج',
    locationEn: 'Qena & Sohag',
    goal: 1500000,
    raised: 850000,
    donorsCount: 1240,
    daysLeft: 45,
    donationAmount: 500,
    imageUrl: 'https://picsum.photos/id/100/400/200', // صورة وهمية
    status: 'active',
    featured: false,
  ),
  Project(
    id: 2,
    programId: 4,
    program: 'الإغاثة العاجلة',
    programEn: 'Emergency Relief',
    title: 'إغاثة طبية عاجلة لمستشفيات غزة',
    titleEn: 'Emergency Medical Aid for Gaza Hospitals',
    description:
        'توفير المستلزمات الطبية والأدوات الجراحية للمستشفيات الميدانية في قطاع غزة.',
    descriptionEn:
        'Providing medical supplies and surgical equipment to field hospitals in the Gaza Strip.',
    location: 'غزة، فلسطين',
    locationEn: 'Gaza, Palestine',
    goal: 5000000,
    raised: 3750000,
    donorsCount: 8500,
    daysLeft: 7,
    donationAmount: 1000,
    imageUrl: 'https://picsum.photos/id/101/400/200',
    status: 'active',
    featured: true,
  ),
  Project(
    id: 3,
    programId: 2,
    program: 'الرعاية الصحية',
    programEn: 'Healthcare',
    title: 'دعم مراكز غسيل الكلى',
    titleEn: 'Dialysis Center Support',
    description:
        'توفير جلسات غسيل كلى لغير القادرين. تكلفة الجلسة الواحدة 750 جنيه تساهم في إنقاذ حياة.',
    descriptionEn:
        'Providing dialysis sessions for those unable to afford them. Each session costs 750 EGP and helps save a life.',
    location: 'القاهرة والجيزة',
    locationEn: 'Cairo & Giza',
    goal: 600000,
    raised: 120000,
    donorsCount: 150,
    daysLeft: 60,
    donationAmount: 750,
    imageUrl: 'https://picsum.photos/id/102/400/200',
    status: 'active',
    featured: false,
  ),
  Project(
    id: 4,
    programId: 6,
    program: 'إعمار البيوت',
    programEn: 'House Renovation',
    title: 'أسقف تحمي من البرد والمطر',
    titleEn: 'Roofing Project',
    description:
        'تركيب أسقف آمنة لـ 50 منزل متهالك في القرى الفقيرة قبل دخول الشتاء.',
    descriptionEn:
        'Installing safe roofs for 50 dilapidated houses in poor villages before winter arrives.',
    location: 'المنيا وبني سويف',
    locationEn: 'Minya & Beni Suef',
    goal: 400000,
    raised: 380000,
    donorsCount: 620,
    daysLeft: 5,
    donationAmount: 2000,
    imageUrl: 'https://picsum.photos/id/103/400/200',
    status: 'active',
    featured: true,
  ),
  Project(
    id: 5,
    programId: 4,
    program: 'الإغاثة العاجلة',
    programEn: 'Emergency Relief',
    title: 'سلات غذائية للاجئين السودانيين',
    titleEn: 'Food Baskets for Sudan Refugees',
    description:
        'توفير سلات غذائية تكفي الأسرة لمدة شهر للإخوة السودانيين النازحين.',
    descriptionEn:
        'Providing monthly food baskets for displaced Sudanese families.',
    location: 'الحدود المصرية السودانية',
    locationEn: 'Egypt-Sudan Border',
    goal: 2000000,
    raised: 450000,
    donorsCount: 310,
    daysLeft: 30,
    donationAmount: 200,
    imageUrl: 'https://picsum.photos/id/104/400/200',
    status: 'active',
    featured: true,
  ),
  Project(
    id: 6,
    programId: 3,
    program: 'سقيا الماء',
    programEn: 'Water Projects',
    title: 'حفر 10 آبار ارتوازية',
    titleEn: 'Drilling 10 Artesian Wells',
    description:
        'صدقة جارية توفر الماء العذب لقرى بأكملها تعاني من نقص المياه.',
    descriptionEn:
        'An ongoing charity providing clean water to entire villages suffering from water scarcity.',
    location: 'مطروح والوادي الجديد',
    locationEn: 'Matrouh & New Valley',
    goal: 800000,
    raised: 800000,
    donorsCount: 1100,
    daysLeft: 0,
    donationAmount: 5000,
    imageUrl: 'https://picsum.photos/id/105/400/200',
    status: 'completed',
    featured: false,
  ),
  Project(
    id: 7,
    programId: 5,
    program: 'ستر وتزويج',
    programEn: 'Marriage Support',
    title: 'تجهيز 20 عروسة يتيمة',
    titleEn: 'Marriage Support for 20 Orphan Brides',
    description:
        'المساهمة في جهاز 20 فتاة يتيمة لإتمام زواجهن وإدخال السرور على قلوبهن.',
    descriptionEn:
        'Contributing to the wedding preparations of 20 orphan girls to complete their marriages and bring joy to their hearts.',
    location: 'الفيوم',
    locationEn: 'Fayoum',
    goal: 300000,
    raised: 150000,
    donorsCount: 280,
    daysLeft: 25,
    donationAmount: 1500,
    imageUrl: 'https://picsum.photos/id/106/400/200',
    status: 'active',
    featured: false,
  ),
];

/// قائمة التحديثات (Updates)
final List<Update> updates = [
  Update(
    id: 1,
    projectId: 2,
    title: 'وصول قافلة المساعدات الثالثة إلى غزة',
    titleEn: '3rd Aid Convoy Reaches Gaza',
    date: '2024-02-10',
    icon: 'fa-solid fa-truck-medical',
  ),
  Update(
    id: 2,
    projectId: 4,
    title: 'الانتهاء من تسقيف 30 منزلاً في بني سويف',
    titleEn: '30 Homes Roofed in Beni Suef',
    date: '2024-02-05',
    icon: 'fa-solid fa-house-chimney',
  ),
  Update(
    id: 3,
    projectId: 1,
    title: 'حفل تكريم المتفوقين من الأيتام المكفولين',
    titleEn: 'Honoring Top Orphan Students',
    date: '2024-01-28',
    icon: 'fa-solid fa-award',
  ),
];

/// قائمة الشهادات (Testimonials)
final List<Testimonial> testimonials = [
  Testimonial(
    id: 1,
    name: 'أحمد محمد',
    nameEn: 'Ahmed Mohamed',
    role: 'متبرع منتظم',
    roleEn: 'Regular Donor',
    text:
        'تجربتي مع نور كانت رائعة. أستطيع متابعة كل تبرعاتي ومعرفة أين تذهب أموالي بشفافية كاملة.',
    textEn:
        'My experience with Nour has been amazing. I can track all my donations and know exactly where my money goes with full transparency.',
    avatarInitial: 'أ',
  ),
  Testimonial(
    id: 2,
    name: 'سارة أحمد',
    nameEn: 'Sara Ahmed',
    role: 'مديرة مشروع',
    roleEn: 'Project Manager',
    text:
        'بفضل دعمكم استطعنا توفير كسوة الشتاء لأكثر من 500 أسرة. شكرًا لكل من ساهم في هذا العمل الخيري.',
    textEn:
        'Thanks to your support, we were able to provide winter clothing for over 500 families. Thank you to everyone who contributed.',
    avatarInitial: 'س',
  ),
  Testimonial(
    id: 3,
    name: 'محمد علي',
    nameEn: 'Mohamed Ali',
    role: 'متطوع',
    roleEn: 'Volunteer',
    text:
        'كمتطوع في نور، أشهد يوميًا على التأثير الحقيقي الذي تحدثه تبرعاتكم في حياة المحتاجين.',
    textEn:
        'As a volunteer at Nour, I witness daily the real impact your donations make in the lives of those in need.',
    avatarInitial: 'م',
  ),
];

/// قائمة مبالغ التبرع السريع (مطابقة لـ donationAmounts)
final List<int> quickDonateAmounts = [50, 100, 200, 500, 1000, 2000];

/// أنواع التبرع (للاستخدام في DonateScreen)
final List<Map<String, String>> donationTypes = [
  {'id': 'zakat', 'name': 'زكاة مال', 'nameEn': 'Zakat al-Mal'},
  {'id': 'sadaqah', 'name': 'صدقة جارية', 'nameEn': 'Sadaqah Jariyah'},
  {'id': 'kafala', 'name': 'كفالة يتيم', 'nameEn': 'Orphan Sponsorship'},
  {'id': 'general', 'name': 'تبرع عام', 'nameEn': 'General Donation'},
];

/// طرق الدفع (للاستخدام في DonateScreen)
final List<Map<String, String>> paymentMethods = [
  {'id': 'card', 'name': 'بطاقة ائتمان', 'nameEn': 'Credit Card', 'icon': 'credit_card'},
  {'id': 'wallet', 'name': 'محفظة إلكترونية', 'nameEn': 'E-Wallet', 'icon': 'wallet'},
  {'id': 'bank', 'name': 'تحويل بنكي', 'nameEn': 'Bank Transfer', 'icon': 'account_balance'},
];
