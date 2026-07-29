import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sokopop_flutter_app/core/theme/app_theme.dart';
import 'package:sokopop_flutter_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';
import 'package:sokopop_flutter_app/features/listings/presentation/providers/listing_provider.dart';
import 'package:sokopop_flutter_app/features/listings/presentation/screens/listing_details_screen.dart';
import 'package:sokopop_flutter_app/features/profile/presentation/screens/notifications_screen.dart';
import 'package:sokopop_flutter_app/features/auth/presentation/screens/splash_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showMyListings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListingProvider>().fetchListings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final displayName = user?.displayName ?? user?.email ?? 'ALU Student';
    final initials = displayName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase();
    final listingProvider = context.watch<ListingProvider>();
    final myListings = listingProvider.myListings;

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
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Text('Campus Market',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600)),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined,
                            color: Colors.white),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NotificationsScreen())),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: Text(initials,
                        style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 10),
                  Text(displayName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('Verified ALU student',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
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
                  _stat(
                      '${myListings.where((l) => l.isSold).length}', 'Sold'),
                  _divider(),
                  _stat('0', 'Bought'),
                  _divider(),
                  _stat('0.0', 'Rating'),
                  _divider(),
                  _stat('0', 'Reviews'),
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
                    onTap: () =>
                        setState(() => _showMyListings = !_showMyListings),
                  ),
                  if (_showMyListings) ...[
                    const SizedBox(height: 8),
                    if (listingProvider.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      )
                    else if (myListings.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No listings yet'),
                      )
                    else
                      ...myListings.map((listing) => _listingTile(listing)),
                  ],
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
                    onTap: () async {
                      await context.read<AuthProvider>().signOut();
                      if (mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const SplashScreen()),
                          (route) => false,
                        );
                      }
                    },
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
                            child: Icon(Icons.logout,
                                color: AppTheme.error, size: 20),
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
                                    color: AppTheme.onSurfaceVariant,
                                    fontSize: 13,
                                    height: 1.4),
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

  Widget _listingTile(Listing listing) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ListingDetailsScreen(listing: listing),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                listing.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  color: AppTheme.surfaceContainerLow,
                  child: const Icon(Icons.image_outlined,
                      color: AppTheme.outline),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('RWF ${listing.price} · ${listing.status}',
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

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              style:
                  TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
        width: 1,
        height: 30,
        color: AppTheme.outlineVariant.withOpacity(0.5));
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
          border:
              Border.all(color: AppTheme.outlineVariant.withOpacity(0.5)),
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