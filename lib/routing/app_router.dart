import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_pet_companion_pro/presentation/features/home/home_screen.dart';
import 'package:ai_pet_companion_pro/presentation/features/pet/pet_screen.dart';
import 'package:ai_pet_companion_pro/presentation/features/shop/shop_screen.dart';
import 'package:ai_pet_companion_pro/presentation/features/inventory/inventory_screen.dart';
import 'package:ai_pet_companion_pro/presentation/features/quests/quest_screen.dart';
import 'package:ai_pet_companion_pro/presentation/features/minigames/minigames_screen.dart';
import 'package:ai_pet_companion_pro/presentation/features/settings/settings_screen.dart';

class AppRouter {
  final GoRouter router;

  AppRouter()
      : router = GoRouter(
          initialLocation: '/home',
          routes: [
            ShellRoute(
              builder: (context, state, child) => _ShellScreen(child: child),
              routes: [
                GoRoute(
                  path: '/home',
                  pageBuilder: (context, state) => _buildPage(
                    const HomeScreen(),
                    state,
                  ),
                ),
                GoRoute(
                  path: '/pet',
                  pageBuilder: (context, state) => _buildPage(
                    const PetScreen(),
                    state,
                  ),
                ),
                GoRoute(
                  path: '/shop',
                  pageBuilder: (context, state) => _buildPage(
                    const ShopScreen(),
                    state,
                  ),
                ),
                GoRoute(
                  path: '/inventory',
                  pageBuilder: (context, state) => _buildPage(
                    const InventoryScreen(),
                    state,
                  ),
                ),
                GoRoute(
                  path: '/quests',
                  pageBuilder: (context, state) => _buildPage(
                    const QuestsScreen(),
                    state,
                  ),
                ),
                GoRoute(
                  path: '/minigames',
                  pageBuilder: (context, state) => _buildPage(
                    const MinigamesScreen(),
                    state,
                  ),
                ),
                GoRoute(
                  path: '/settings',
                  pageBuilder: (context, state) => _buildPage(
                    const SettingsScreen(),
                    state,
                  ),
                ),
              ],
            ),
          ],
        );

  static Page<dynamic> _buildPage(Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

class _ShellScreen extends StatefulWidget {
  final Widget child;

  const _ShellScreen({required this.child});

  @override
  State<_ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<_ShellScreen> {
  int _currentIndex = 0;

  final _destinations = const [
    ('Home', Icons.home_rounded),
    ('Pet', Icons.pets_rounded),
    ('Shop', Icons.shopping_bag_rounded),
    ('Games', Icons.sports_esports_rounded),
    ('Settings', Icons.settings_rounded),
  ];

  final _routes = [
    '/home',
    '/pet',
    '/shop',
    '/minigames',
    '/settings',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouterState.of(context).uri.toString();
    final index = _routes.indexWhere((r) => location.startsWith(r));
    if (index != -1 && index != _currentIndex) {
      _currentIndex = index;
    }
  }

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTap,
            backgroundColor: isDark
                ? const Color(0xFF1A1A2E).withValues(alpha: 0.95)
                : Colors.white.withValues(alpha: 0.95),
            selectedItemColor: const Color(0xFF6C63FF),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            items: _destinations
                .map((d) => BottomNavigationBarItem(
                      icon: Icon(d.$2),
                      activeIcon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C63FF)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(d.$2),
                      ),
                      label: d.$1,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
