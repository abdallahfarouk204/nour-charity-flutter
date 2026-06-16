import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/zakat_screen.dart';
import 'screens/account_screen.dart';
import 'screens/login_screen.dart';
import 'screens/transparency_screen.dart';
import 'screens/give_areas_screen.dart';
import 'screens/volunteer_screen.dart';
import 'screens/team_screen.dart';
import 'screens/timeline_screen.dart';
import 'screens/donate_screen.dart';
import 'screens/volunteer_form_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/about_screen.dart';
import 'screens/project_detail_screen.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const NourCharityApp(),
    ));

class NourCharityApp extends StatelessWidget {
  const NourCharityApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'نور الخيري',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    ProjectsScreen(),
    ZakatScreen(),
    AccountScreen(),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('نور الخيري'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.menu, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: Icon(Icons.brightness_6, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
            onSelected: (ThemeMode mode) {
              if (mode == ThemeMode.light) themeProvider.toggleTheme(false);
              else if (mode == ThemeMode.dark) themeProvider.toggleTheme(true);
              else themeProvider.setSystemMode();
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Row(children: [Icon(Icons.light_mode), SizedBox(width: 12), Text('فاتح')]),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Row(children: [Icon(Icons.dark_mode), SizedBox(width: 12), Text('داكن')]),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Row(children: [Icon(Icons.brightness_auto), SizedBox(width: 12), Text('حسب النظام')]),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: isDark ? const Color(0xFF0A1F0F) : Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A2A22) : Theme.of(context).primaryColor,
                ),
                child: const Text('نور الخيري', style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
              ListTile(
                leading: Icon(Icons.home, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                title: Text('الرئيسية', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 0);
                },
              ),
              ListTile(
                leading: Icon(Icons.folder, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                title: Text('المشاريع', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 1);
                },
              ),
              ListTile(
                leading: Icon(Icons.calculate, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                title: Text('حاسبة الزكاة', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 2);
                },
              ),
              ListTile(
                leading: Icon(Icons.person, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                title: Text('حسابي', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 3);
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.card_giftcard, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                title: Text('تبرع', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DonateScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.login, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                title: Text('تسجيل الدخول', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.volunteer_activism, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                title: Text('التطوع', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const VolunteerScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.health_and_safety, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                title: Text('مجالات العطاء', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const GiveAreasScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.people, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                title: Text('فريق العمل', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TeamScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.timeline, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                title: Text('مسيرتنا', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TimelineScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.pie_chart, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                title: Text('الشفافية', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TransparencyScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_mail, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                title: Text('اتصل بنا', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline, color: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor),
                title: Text('من نحن', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
                },
              ),
            ],
          ),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: isDark ? const Color(0xFF0A1F0F) : Colors.white,
        selectedItemColor: isDark ? const Color(0xFF7CFF9E) : Theme.of(context).primaryColor,
        unselectedItemColor: isDark ? Colors.white60 : Colors.grey,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), label: 'المشاريع'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate_outlined), label: 'الزكاة'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'حسابي'),
        ],
      ),
    );
  }
}
