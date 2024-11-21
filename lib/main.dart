import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Fancy App',
          theme: themeProvider.currentTheme,
          debugShowCheckedModeBanner: false,
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return authProvider.isAuthenticated 
                  ? const MainScaffold()
                  : const LoginScreen();
            },
          ),
        );
      },
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      drawer: _buildDrawer(authProvider, themeProvider),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: themeProvider.accentColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.shifting,
      ),
    );
  }

  Widget _buildDrawer(AuthProvider authProvider, ThemeProvider themeProvider) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(authProvider.username ?? 'Guest'),
            accountEmail: Text(authProvider.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: themeProvider.accentColor,
              child: Text(
                authProvider.username != null 
                  ? authProvider.username![0].toUpperCase() 
                  : 'G',
                style: const TextStyle(fontSize: 40.0, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _selectedIndex = 3;
              });
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              authProvider.logout();
            },
          ),
        ],
      ),
    );
  }
}