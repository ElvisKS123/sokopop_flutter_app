import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sokopop_flutter_app/core/theme/app_theme.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';
import 'package:sokopop_flutter_app/shared/mock/mock_data.dart';
import 'package:sokopop_flutter_app/shared/widgets/shared_widgets.dart';
import 'package:sokopop_flutter_app/core/utils/formatters.dart';
import 'package:sokopop_flutter_app/features/listings/presentation/providers/listing_provider.dart';
import 'package:sokopop_flutter_app/features/messaging/presentation/screens/chat_screen.dart';
import 'package:sokopop_flutter_app/features/meetup/presentation/screens/meetup_screen.dart';

class ListingDetailsScreen extends StatefulWidget {
  final Listing listing;

  const ListingDetailsScreen({super.key, required this.listing});

  @override
  State<ListingDetailsScreen> createState() => _ListingDetailsScreenState();
}

class _ListingDetailsScreenState extends State<ListingDetailsScreen> {
  int _currentImage = 0;

  bool get _isOwner =>
      FirebaseAuth.instance.currentUser?.uid == widget.listing.sellerId;

  Future<void> _markAsSold() async {
    try {
      await context.read<ListingProvider>().markAsSold(widget.listing.id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing marked as sold!'),
            backgroundColor: AppTheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteListing() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete listing?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await context.read<ListingProvider>().deleteListing(widget.listing.id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing deleted.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.listing;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Listing details',
            style: AppTheme.bodyLg.copyWith(fontWeight: FontWeight.w600)),
        actions: [
          if (_isOwner)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppTheme.onSurface),
              onSelected: (value) {
                if (value == 'sold') _markAsSold();
                if (value == 'delete') _deleteListing();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'sold',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: AppTheme.primary, size: 18),
                      SizedBox(width: 8),
                      Text('Mark as sold'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text('Delete listing', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppTheme.onSurface),
              onPressed: () {},
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            Stack(
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  color: AppTheme.surfaceContainerHigh,
                  child: Image.network(
                    l.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image_outlined, size: 60, color: AppTheme.outline),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('1/4',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.book_outlined, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(l.category.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(l.title, style: AppTheme.headlineSm)),
                      IconButton(
                        icon: const Icon(Icons.ios_share_outlined,
                            color: AppTheme.onSurface),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('RWF ${formatPriceWithCommas(l.price)}',
                      style: AppTheme.priceDisplay.copyWith(fontSize: 22)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _tag(l.condition, Icons.check_circle_outline, AppTheme.primary,
                          AppTheme.secondaryContainer.withOpacity(0.4)),
                      if (l.isNegotiable)
                        _tag('Negotiable', null, AppTheme.onSurface,
                            AppTheme.surfaceContainerHigh),
                      _tag('In-person pickup', null, AppTheme.onSurface,
                          AppTheme.surfaceContainerHigh),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('DESCRIPTION',
                      style: AppTheme.labelMd
                          .copyWith(color: AppTheme.onSurfaceVariant, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Text(l.description, style: AppTheme.bodyMd.copyWith(height: 1.6)),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppTheme.outlineVariant.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: AppTheme.secondaryContainer,
                            child: Text(l.sellerInitials,
                                style: const TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.sellerName,
                                    style: AppTheme.bodyLg
                                        .copyWith(fontWeight: FontWeight.w700)),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Color(0xFFF59E0B), size: 14),
                                    Text(
                                        ' ${l.sellerRating} (${l.sellerReviews} reviews)',
                                        style: AppTheme.labelMd.copyWith(
                                            color: AppTheme.onSurfaceVariant)),
                                  ],
                                ),
                                Text('Verified ALU Student',
                                    style: AppTheme.labelMd
                                        .copyWith(color: AppTheme.primary)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppTheme.outline),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.outlineVariant.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppTheme.surfaceContainerLow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.location_on_outlined,
                              color: AppTheme.outline, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pick-up Location',
                                  style: AppTheme.labelMd
                                      .copyWith(color: AppTheme.onSurfaceVariant)),
                              Text(l.meetupLocation, style: AppTheme.bodyMd),
                            ],
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.map_outlined,
                              color: AppTheme.outline),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        contactName: l.sellerName,
                        listing: l,
                        messages: sampleMessages.first.messages,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Message seller',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MeetupScreen(listing: l)),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(
                        color: AppTheme.outlineVariant, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Meet up',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(String label, IconData? icon, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: 4)
          ],
          Text(label,
              style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}