import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              color: AppTheme.primary,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white),
                      Text('Campus Market',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600)),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: Text('PM',
                        style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 10),
                  const Text('Pierre Michael Angelo',
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('2nd Year · Computer Science',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('Verified ALU student',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            // Stats
Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  _stat('8', 'Sold'),
                  _divider(),
                  _stat('12', 'Bought'),
                  _divider(),
                  _stat('4.9', 'Rating'),
                  _divider(),
                  _stat('14', 'Reviews'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Menu items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _menuItem(
                    Icons.list_alt_outlined,
                    'My listings',
                    'Manage your active listings',
                    AppTheme.secondaryContainer.withOpacity(0.5),
                    AppTheme.primaryContainer,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _menuItem(
                    Icons.bookmark_outline,
                    'Saved items',
                    'Items you\'ve bookmarked',
                    AppTheme.secondaryContainer.withOpacity(0.5),
                    AppTheme.primaryContainer,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _menuItem(
                    Icons.star_outline,
                    'Reviews',
                    'See what others say',
                    AppTheme.surfaceContainerHigh,
                    AppTheme.onSurfaceVariant,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _menuItem(
                    Icons.settings_outlined,
                    'Settings',
                    'Privacy, notifications',
                    AppTheme.surfaceContainerHigh,
                    AppTheme.onSurfaceVariant,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  // Sign out
                  GestureDetector(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.errorContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppTheme.error.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.errorContainer.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.logout, color: AppTheme.error, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text('Sign out',
                              style: TextStyle(
                                  color: AppTheme.error,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Security note
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_outlined,
                            color: AppTheme.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Profile Security',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.onSurface)),
                              const SizedBox(height: 4),
                              Text(
                                'Your account is verified with your official university email. This ensures a safe marketplace for everyone.',
                                style: TextStyle(
                                    color: AppTheme.onSurfaceVariant, fontSize: 13, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: AppTheme.primary, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
        width: 1, height: 30, color: AppTheme.outlineVariant.withOpacity(0.5));
  }

  Widget _menuItem(IconData icon, String title, String subtitle, Color iconBg,
      Color iconColor,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(subtitle,
                      style: TextStyle(
                          color: AppTheme.onSurfaceVariant, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.outline),
          ],
        ),
      ),
    );
  }
}
