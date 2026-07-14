import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/data.dart';
import '../widgets/shared_widgets.dart';
import '../utils/formatters.dart';
import 'listing_details_screen.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import '../providers/listing_provider.dart';


class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String _selectedCategory = 'All';
  String _sortOption = 'Price Low→High';
  bool _verifiedOnly = false;
  bool _isSearching = false;
  final _searchCtrl = TextEditingController(text: 'Textbooks');

  final List<String> _categories = ['All', 'Books', 'Clothing', 'Electronics'];
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

  List<Listing> get _filtered {
    final provider = context.read<ListingProvider>();
    var list = provider.listings.toList();
    if (_selectedCategory != 'All') {
      final map = {'Books': 'Textbooks', 'Clothing': 'Clothing', 'Electronics': 'Electronics'};
      list = list.where((l) => l.category == map[_selectedCategory]).toList();
    }
    if (_verifiedOnly) list = list.where((l) => l.isVerified).toList();
    if (_sortOption == 'Price Low→High') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else {
      list.sort((a, b) => b.price.compareTo(a.price));
    }
    return list;
}

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ListingProvider>();
    final items = provider.isLoading ? <Listing>[] : _filtered;
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
                itemBuilder: (_, i) => CategoryChip(
                  label: _categories[i],
                  active: _selectedCategory == _categories[i],
                  onTap: () => setState(() => _selectedCategory = _categories[i]),
                ),
              ),
            ),
          ),
          // Filter row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                _filterChip(_sortOption, onTap: _showSortSheet),
                const SizedBox(width: 8),
                _filterChip('Condition', onTap: () {}),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _verifiedOnly = !_verifiedOnly),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: _verifiedOnly ? AppTheme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                          color: _verifiedOnly ? AppTheme.primary : AppTheme.outlineVariant),
                    ),
                    child: Text('Verified only',
                        style: TextStyle(
                          color: _verifiedOnly ? Colors.white : AppTheme.onSurface,
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
            _sortTile('Price Low→High'),
            _sortTile('Price High→Low'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _sortTile(String label) {
    final selected = _sortOption == label;
    return ListTile(
      onTap: () {
        setState(() => _sortOption = label);
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

