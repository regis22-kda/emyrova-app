import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

/// Bottom navigation bar for Emyrova
class AppBottomNavBar extends StatelessWidget {
  final String currentPath;

  const AppBottomNavBar({
    super.key,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getIndexForPath(currentPath),
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: AppStrings.navHome,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.videogame_asset_outlined),
          activeIcon: Icon(Icons.videogame_asset),
          label: AppStrings.navPlay,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          activeIcon: Icon(Icons.history),
          label: AppStrings.navHistory,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: AppStrings.navProfile,
        ),
      ],
    );
  }

  int _getIndexForPath(String path) {
    if (path == '/') return 0;
    if (path.contains('/play') || path.contains('/question') || 
        path.contains('/roulette') || path.contains('/this-or-that') ||
        path.contains('/whos-more-likely')) return 1;
    if (path.contains('/history')) return 2;
    if (path.contains('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/play');
        break;
      case 2:
        context.go('/history');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}
