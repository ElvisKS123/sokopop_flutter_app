import 'package:flutter/material.dart';
import 'package:sokopop_flutter_app/core/theme/app_theme.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';
import 'package:sokopop_flutter_app/shared/widgets/shared_widgets.dart';
import 'package:sokopop_flutter_app/core/utils/formatters.dart';
import 'package:sokopop_flutter_app/features/listings/presentation/screens/listing_details_screen.dart';
import 'package:sokopop_flutter_app/features/listings/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:sokopop_flutter_app/features/listings/domain/usecases/filter_listings.dart';
import 'package:sokopop_flutter_app/features/listings/presentation/providers/listing_provider.dart';


class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  // Category, sort and verified filters used to be setState fields here.
  // They decide WHICH listings a user sees, which is business logic, so they
  // now live in ListingProvider and the filtering itself is a use case.
  final _searchCtrl = TextEditingController(text: 'Textbooks');

  /// Chip label -> the category value stored on the listing document.
  static const Map<String, String> _categories = {
    'All': 'All',
    'Books': 'Textbooks',
    'Clothing': 'Clothing',
    'Electronics': 'Electronics',
  };

  static const Map<String, ListingSort> _sortOptions = {
    'Price Low→High': ListingSort.priceLowToHigh,
    'Price High→Low': ListingSort.priceHighToLow,
  };
    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListingProvider>().fetchListings();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ListingProvider>();
    // Filtering happens in the FilterListings use case, reached through the
    // provider. This widget just renders whatever it is handed.
    final items = provider.isLoading ? <Listing>[] : provider.visibleListings;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppTheme.outline, size: 20),
                        const SizedBox(width: 8),
                        Text(_searchCtrl.text.isEmpty ? 'Search...' : _searchCtrl.text,
                            style: AppTheme.bodyMd.copyWith(color: AppTheme.onSurface)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {},
                  child: Text('Cancel',
                      style: AppTheme.bodyMd.copyWith(color: AppTheme.primary)),
                ),
              ],
            ),
          ),
          // Category chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 0, 0),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final label = _categories.keys.elementAt(i);
                  final value = _categories.values.elementAt(i);
                  return CategoryChip(
                    label: label,
                    active: provider.category == value,
                    onTap: () => provider.setCategory(value),
                  );
                },
              ),
            ),
          ),
          // Filter row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                _filterChip(_sortLabel(provider.sort), onTap: _showSortSheet),
                const SizedBox(width: 8),
                _filterChip('Condition', onTap: () {}),
                const Spacer(),
                GestureDetector(
                  onTap: provider.toggleVerifiedOnly,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: provider.verifiedOnly ? AppTheme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                          color: provider.verifiedOnly ? AppTheme.primary : AppTheme.outlineVariant),
                    ),
                    child: Text('Verified only',
                        style: TextStyle(
                          color: provider.verifiedOnly ? Colors.white : AppTheme.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
              ],
            ),
          ),
          // Results count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text('${items.length} results found',
                style: AppTheme.bodyMd.copyWith(color: AppTheme.onSurfaceVariant)),
          ),
          // Grid
          Expanded(
            child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) => _BrowseCard(
                listing: items[i],
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ListingDetailsScreen(listing: items[i]))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 16),
          ],
        ),
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sort by', style: AppTheme.headlineSm),
            const SizedBox(height: 16),
            for (final label in _sortOptions.keys) _sortTile(label),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _sortLabel(ListingSort sort) => _sortOptions.entries
      .firstWhere((e) => e.value == sort,
          orElse: () => _sortOptions.entries.first)
      .key;

  Widget _sortTile(String label) {
    final provider = context.watch<ListingProvider>();
    final selected = provider.sort == _sortOptions[label];
    return ListTile(
      onTap: () {
        provider.setSort(_sortOptions[label]!);
        Navigator.pop(context);
      },
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: selected ? AppTheme.primary : AppTheme.outline,
      ),
      title: Text(label, style: AppTheme.bodyLg),
    );
  }
}

class _BrowseCard extends StatefulWidget {
  final Listing listing;
  final VoidCallback onTap;

  const _BrowseCard({required this.listing, required this.onTap});

  @override
  State<_BrowseCard> createState() => _BrowseCardState();
}

class _BrowseCardState extends State<_BrowseCard> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
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
                    widget.listing.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: AppTheme.surfaceContainerLow,
                      child: const Icon(Icons.image_outlined, color: AppTheme.outline),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _saved = !_saved),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _saved ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: _saved ? Colors.red : AppTheme.outline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.listing.title,
                      style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
Text('RWF ${formatPriceWithCommas(widget.listing.price)}',
                      style: AppTheme.priceDisplay.copyWith(fontSize: 15)),
                  if (widget.listing.isVerified) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.verified, color: AppTheme.primary, size: 13),
                        const SizedBox(width: 3),
                        Text('Verified ALU',
                            style: AppTheme.labelMd.copyWith(color: AppTheme.primary)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Price formatting moved to lib/utils/formatters.dart

