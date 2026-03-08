import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'history_screen.dart';
import 'models_screen.dart';
import 'settings_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    const ChatScreen(),
    HistoryScreen(
      onSessionSelected: () {
        setState(() => _currentIndex = 0);
      },
    ),
    const ModelsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.borderColor, width: 0.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: AppTheme.bgCard,
          indicatorColor: AppTheme.accentPurple.withAlpha(30),
          surfaceTintColor: Colors.transparent,
          height: 65,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                color: _currentIndex == 0
                    ? AppTheme.accentPurple
                    : AppTheme.textMuted,
              ),
              selectedIcon: const Icon(
                Icons.chat_bubble_rounded,
                color: AppTheme.accentPurple,
              ),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.history_rounded,
                color: _currentIndex == 1
                    ? AppTheme.accentPurple
                    : AppTheme.textMuted,
              ),
              selectedIcon: const Icon(
                Icons.manage_history_rounded,
                color: AppTheme.accentPurple,
              ),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.download_rounded,
                color: _currentIndex == 2
                    ? AppTheme.accentPurple
                    : AppTheme.textMuted,
              ),
              selectedIcon: const Icon(
                Icons.download_done_rounded,
                color: AppTheme.accentPurple,
              ),
              label: 'Models',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings_outlined,
                color: _currentIndex == 3
                    ? AppTheme.accentPurple
                    : AppTheme.textMuted,
              ),
              selectedIcon: const Icon(
                Icons.settings_rounded,
                color: AppTheme.accentPurple,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
