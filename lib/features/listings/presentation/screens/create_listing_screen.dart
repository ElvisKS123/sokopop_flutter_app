import 'package:flutter/material.dart';
import 'package:sokopop_flutter_app/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:sokopop_flutter_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:sokopop_flutter_app/features/listings/presentation/providers/listing_provider.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';

class CreateListingSheet extends StatefulWidget {
  const CreateListingSheet({super.key});

  @override
  State<CreateListingSheet> createState() => _CreateListingSheetState();
}

class _CreateListingSheetState extends State<CreateListingSheet> {
  final _titleCtrl = TextEditingController();
  final _priceCtrl = TextEditingController(text: '0');
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  String _selectedCategory = 'Textbooks / Electronics / Clothing';
  String _selectedCondition = '';

  final List<String> _conditions = ['New', 'Like New', 'Good', 'Fair'];

  Future<void> _postListing() async {
    // Title / condition / price rules now live in the CreateListing use case,
    // so this method only gathers input and reports the outcome.
    final listings = context.read<ListingProvider>();
    final user = context.read<AuthProvider>().currentUser;

    final listing = Listing(
      id: '',
      title: _titleCtrl.text.trim(),
      category: _selectedCategory == 'Textbooks / Electronics / Clothing'
          ? 'Other'
          : _selectedCategory,
      price: int.tryParse(_priceCtrl.text.trim()) ?? 0,
      condition: _selectedCondition,
      description: _descCtrl.text.trim(),
      sellerName: user?.name ?? 'ALU Student',
      sellerInitials: user?.initials ?? 'AS',
      sellerRating: 0.0,
      sellerReviews: 0,
      isVerified: user?.isVerifiedStudent ?? false,
      meetupLocation: _locationCtrl.text.trim(),
      imageUrl:
          'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=400&h=300&fit=crop',
      sellerId: user?.id ?? '',
      status: 'active',
      // createdAt is written by the server, not this device's clock.
    );

    final success = await listings.createListing(listing);
    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listing posted successfully! 🎉'),
          backgroundColor: AppTheme.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(listings.error ?? 'Could not post listing.')),
      );
      listings.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      maxChildSize: 0.97,
      minChildSize: 0.5,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Handle + header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.onSurface),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text('New listing', style: AppTheme.bodyLg.copyWith(fontWeight: FontWeight.w700)),
                    ElevatedButton(
                      onPressed: context.watch<ListingProvider>().isMutating
                          ? null
                          : _postListing,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: context.watch<ListingProvider>().isMutating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Post',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo area
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppTheme.outlineVariant, style: BorderStyle.solid),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_photo_alternate_outlined,
                                color: AppTheme.primary, size: 36),
                            const SizedBox(height: 8),
                            Text('+ Add photos', style: AppTheme.bodyMd.copyWith(color: AppTheme.primary, fontWeight: FontWeight.w600)),
                            Text('(up to 5)', style: AppTheme.labelMd.copyWith(color: AppTheme.outline)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _photoSlot(),
                          const SizedBox(width: 8),
                          _photoSlot(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _field('Title', 'What are you selling?', _titleCtrl),
                      const SizedBox(height: 16),
                      // Category dropdown
                      Text('Category',
                          style: AppTheme.labelMd.copyWith(color: AppTheme.onSurfaceVariant)),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: _showCategorySheet,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.outlineVariant),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_selectedCategory,
                                  style: AppTheme.bodyMd.copyWith(color: AppTheme.onSurface)),
                              const Icon(Icons.keyboard_arrow_down, color: AppTheme.outline),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _field('Price (RWF)', '0', _priceCtrl, keyboardType: TextInputType.number),
                      const SizedBox(height: 16),
                      // Condition
                      Text('Condition',
                          style: AppTheme.labelMd.copyWith(color: AppTheme.onSurfaceVariant)),
                      const SizedBox(height: 8),
                      Row(
                        children: _conditions
                            .map((c) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedCondition = c),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: _selectedCondition == c ? AppTheme.primary : Colors.white,
                                        borderRadius: BorderRadius.circular(999),
                                        border: Border.all(
                                          color: _selectedCondition == c
                                              ? AppTheme.primary
                                              : AppTheme.outlineVariant,
                                        ),
                                      ),
                                      child: Text(c,
                                          style: TextStyle(
                                            color: _selectedCondition == c
                                                ? Colors.white
                                                : AppTheme.onSurface,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      // Description
                      Text('Description',
                          style: AppTheme.labelMd.copyWith(color: AppTheme.onSurfaceVariant)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _descCtrl,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Describe your item, condition...',
                          hintStyle: AppTheme.bodyMd.copyWith(color: AppTheme.outline),
                          filled: true,
                          fillColor: AppTheme.surfaceContainerLow,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.outlineVariant),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.outlineVariant),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Meet-up location
                      Text('Meet-up location',
                          style: AppTheme.labelMd.copyWith(color: AppTheme.onSurfaceVariant)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _locationCtrl,
                        decoration: InputDecoration(
                          hintText: 'e.g. ALU Library',
                          hintStyle: AppTheme.bodyMd.copyWith(color: AppTheme.outline),
                          prefixIcon: const Icon(Icons.location_on_outlined,
                              color: AppTheme.outline, size: 18),
                          filled: true,
                          fillColor: AppTheme.surfaceContainerLow,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.outlineVariant),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.outlineVariant),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Trust tip
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryContainer.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.shield_outlined,
                                color: AppTheme.primary, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Trust & Safety Tip',
                                      style: TextStyle(
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Always meet in public campus locations and verify the item before completing the payment.',
                                    style: TextStyle(
                                        color: AppTheme.onSurfaceVariant, fontSize: 12, height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _photoSlot() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: const Icon(Icons.image_outlined, color: AppTheme.outline, size: 24),
    );
  }

  Widget _field(String label, String hint, TextEditingController ctrl,
      {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.labelMd.copyWith(color: AppTheme.onSurfaceVariant)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTheme.bodyMd.copyWith(color: AppTheme.outline),
            filled: true,
            fillColor: AppTheme.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }

  void _showCategorySheet() {
    final categories = ['Textbooks', 'Electronics', 'Clothing', 'Sports', 'Other'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text('Select Category', style: AppTheme.headlineSm),
          ),
          ...categories.map((c) => ListTile(
                leading: const Icon(Icons.category_outlined, color: AppTheme.primary),
                title: Text(c),
                trailing: _selectedCategory == c
                    ? const Icon(Icons.check, color: AppTheme.primary)
                    : null,
                onTap: () {
                  setState(() => _selectedCategory = c);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}