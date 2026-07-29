import 'package:flutter/material.dart';
import 'package:sokopop_flutter_app/core/theme/app_theme.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';
import 'package:sokopop_flutter_app/shared/mock/mock_data.dart';
import 'package:sokopop_flutter_app/shared/widgets/shared_widgets.dart';
import 'package:sokopop_flutter_app/core/utils/formatters.dart';
import 'package:sokopop_flutter_app/features/listings/presentation/screens/listing_details_screen.dart';
import 'package:sokopop_flutter_app/features/listings/presentation/screens/browse_screen.dart';
import 'package:sokopop_flutter_app/features/messaging/presentation/screens/messages_screen.dart';
import 'package:sokopop_flutter_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:sokopop_flutter_app/features/listings/presentation/screens/create_listing_screen.dart';
import 'package:sokopop_flutter_app/features/profile/presentation/screens/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Textbooks', 'Clothing', 'Electronics', 'Other'];

  List<Listing> get _filteredFeatured {
    if (_selectedCategory == 'All') return sampleListings.take(4).toList();
    return sampleListings
        .where((l) => l.category == _selectedCategory)
        .take(4)
        .toList();
  }

  List<Listing> get _recentListings {
    if (_selectedCategory == 'All') return sampleListings.skip(4).take(4).toList();
    return sampleListings
        .where((l) => l.category == _selectedCategory)
        .skip(2)
        .take(4)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHome(),
          const BrowseScreen(),
          const SizedBox(), // Sell placeholder – modal
          const MessagesScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1 || _currentIndex == 3 || _currentIndex == 4
          ? FloatingActionButton(
              onPressed: () => _showCreateListing(),
              backgroundColor: AppTheme.primary,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHome() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildSearch()),
          SliverToBoxAdapter(child: _buildCategories()),
          SliverToBoxAdapter(child: _buildFeaturedSection()),
          SliverToBoxAdapter(child: _buildRecentSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Good morning ', style: AppTheme.headlineMd),
                    const Text('👋', style: TextStyle(fontSize: 22)),
                  ],
                ),
                Text('What are you looking for today?',
                    style: AppTheme.bodyMd.copyWith(color: AppTheme.onSurfaceVariant)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppTheme.primary),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          ),
          CircleAvatar(
            backgroundColor: AppTheme.primary,
            radius: 18,
            child: const Text('P',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        onTap: () {
          setState(() => _currentIndex = 1);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppTheme.outline, size: 20),
              const SizedBox(width: 10),
              Text('Search textbooks, clothes...',
                  style: AppTheme.bodyMd.copyWith(color: AppTheme.outline)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 0, 0),
      child: SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => CategoryChip(
            label: _categories[i],
            active: _selectedCategory == _categories[i],
            onTap: () => setState(() => _selectedCategory = _categories[i]),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    final items = _filteredFeatured;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('FEATURED\nLISTINGS',
                  style: AppTheme.labelMd.copyWith(
                      color: AppTheme.onSurfaceVariant, letterSpacing: 0.5)),
              TextButton(
                onPressed: () => setState(() => _currentIndex = 1),
                child: Text('View all',
                    style: AppTheme.bodyMd.copyWith(color: AppTheme.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('No listings in this category',
                    style: AppTheme.bodyMd.copyWith(color: AppTheme.outline)),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) => _ListingCard(
                listing: items[i],
                showBadge: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ListingDetailsScreen(listing: items[i])),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentSection() {
    final items = _recentListings;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RECENTLY\nADDED',
              style: AppTheme.labelMd
                  .copyWith(color: AppTheme.onSurfaceVariant, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Center(
              child: Text('No recent listings',
                  style: AppTheme.bodyMd.copyWith(color: AppTheme.outline)),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) => _RecentCard(
                listing: items[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ListingDetailsScreen(listing: items[i])),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_outlined, Icons.home, 'Home', 0),
            _navItem(Icons.search_outlined, Icons.search, 'Browse', 1),
            const SizedBox(width: 48), // FAB gap
            _navItem(Icons.chat_bubble_outline, Icons.chat_bubble, 'Chats', 3),
            _navItem(Icons.person_outline, Icons.person, 'Profile', 4),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, IconData activeIcon, String label, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: isActive
            ? BoxDecoration(
                color: AppTheme.primaryContainer.withOpacity(0.12),
                borderRadius: BorderRadius.circular(999),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : icon,
                color: isActive ? AppTheme.primary : AppTheme.outline, size: 24),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                  color: isActive ? AppTheme.primary : AppTheme.outline,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                )),
          ],
        ),
      ),
    );
  }

  void _showCreateListing() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateListingSheet(),
    );
  }
}

// ---- Listing Card ----
class _ListingCard extends StatelessWidget {
  final Listing listing;
  final bool showBadge;
  final VoidCallback onTap;

  const _ListingCard({required this.listing, this.showBadge = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Stack(
                children: [
                  Image.network(
                    listing.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 120,
                      color: AppTheme.surfaceContainerLow,
                      child: Icon(Icons.image_outlined, color: AppTheme.outline, size: 32),
                    ),
                  ),
                  if (showBadge && listing.isVerified)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: const VerifiedBadge(label: 'ALU Verified'),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.title,
                      style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
Text('RWF ${formatPriceWithCommas(listing.price)}',
                      style: AppTheme.priceDisplay.copyWith(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;

  const _RecentCard({required this.listing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Container(
                height: 80,
                width: double.infinity,
                color: AppTheme.secondaryContainer.withOpacity(0.3),
                child: Center(
                  child: Icon(_categoryIcon(listing.category),
                      color: AppTheme.primaryContainer, size: 36),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.title,
                      style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
Text('RWF ${formatPriceWithCommas(listing.price)}',
                      style: AppTheme.priceDisplay.copyWith(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Textbooks':
        return Icons.book_outlined;
      case 'Electronics':
        return Icons.devices_outlined;
      case 'Clothing':
        return Icons.checkroom_outlined;
      default:
        return Icons.shopping_bag_outlined;
    }
  }
}

// Price formatting moved to lib/utils/formatters.dart

