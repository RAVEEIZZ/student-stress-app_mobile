import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import '../app/routes.dart';
import '../core/theme/app_colors.dart';
import '../features/notification/providers/notification_provider.dart';

class BottomNavShell extends StatefulWidget {
  final Widget child;

  const BottomNavShell({super.key, required this.child});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _currentIndex = 0;

  static const _routes = [
    AppRoutes.dashboard,
    AppRoutes.questionnaire,
    AppRoutes.history,
    AppRoutes.notification,
  ];

  void _onTap(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      context.go(_routes[index]);
    }
  }

  @override
  void didUpdateWidget(BottomNavShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync selected index with current route
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _routes.length; i++) {
      if (location == _routes[i]) {
        if (_currentIndex != i) {
          setState(() => _currentIndex = i);
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = context.watch<NotificationProvider>().unreadCount;

    return Scaffold(
      body: widget.child,
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Iconsax.home_2,
                  activeIcon: Iconsax.home_2,
                  label: 'Home',
                  isActive: _currentIndex == 0,
                  onTap: () => _onTap(0),
                ),
                _NavItem(
                  icon: Iconsax.clipboard_text,
                  activeIcon: Iconsax.clipboard_text,
                  label: 'Kuesioner',
                  isActive: _currentIndex == 1,
                  onTap: () => _onTap(1),
                ),
                _NavItem(
                  icon: Iconsax.clock,
                  activeIcon: Iconsax.clock,
                  label: 'Riwayat',
                  isActive: _currentIndex == 2,
                  onTap: () => _onTap(2),
                ),
                _NavItem(
                  icon: Iconsax.notification,
                  activeIcon: Iconsax.notification,
                  label: 'Notifikasi',
                  isActive: _currentIndex == 3,
                  onTap: () => _onTap(3),
                  badgeCount: unreadCount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int badgeCount;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? AppColors.primary : AppColors.textHint,
                  size: 22,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      width: badgeCount > 9 ? 18 : 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: AppColors.surface,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          badgeCount > 9 ? '9+' : '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
