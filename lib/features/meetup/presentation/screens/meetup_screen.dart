import 'package:flutter/material.dart';
import 'package:sokopop_flutter_app/core/theme/app_theme.dart';
import 'package:sokopop_flutter_app/models/data.dart';
import 'package:sokopop_flutter_app/core/utils/formatters.dart';
import 'package:sokopop_flutter_app/features/messaging/presentation/screens/chat_screen.dart';

class MeetupScreen extends StatefulWidget {
  final Listing listing;

  const MeetupScreen({super.key, required this.listing});

  @override
  State<MeetupScreen> createState() => _MeetupScreenState();
}

class _MeetupScreenState extends State<MeetupScreen> {
  bool _markedComplete = false;

  // Price formatting moved to lib/utils/formatters.dart


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
        title: Text('Meet-up', style: TextStyle(color: AppTheme.onSurface, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppTheme.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary,
                border: Border.all(color: AppTheme.secondaryContainer, width: 6),
              ),
              child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 42),
            ),
            const SizedBox(height: 20),
            Text('Meet-up confirmed!',
                style: TextStyle(
                    fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.onSurface)),
            const SizedBox(height: 8),
            Text(
              'Your exchange with ${l.sellerName.split(' ').first} has been arranged.\nMark complete after swap.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 28),

            // Details card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  _detailRow('Item', l.title, isTitle: true),
                  _divider(),
_detailRow('Price agreed', 'RWF ${formatPriceWithCommas(3200)}', isPrice: true),
                  _divider(),
                  _detailRow('Meet at', l.meetupLocation.split(',').first),
                  _divider(),
                  _detailRow('Time', 'Today, 2:00 PM'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Mark complete
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _markedComplete
                    ? null
                    : () {
                        setState(() => _markedComplete = true);
                        _showCompleteDialog(context);
                      },
                icon: Icon(_markedComplete ? Icons.check_circle : Icons.check, size: 20),
                label: Text(
                  _markedComplete ? 'Marked as complete ✓' : 'Mark as complete',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _markedComplete ? AppTheme.primaryContainer : AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Message button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
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
                label: Text('Message ${l.sellerName.split(' ').first}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.onSurface,
                  side: const BorderSide(color: AppTheme.outlineVariant, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'After exchange, you\'ll be prompted to leave a review.',
              style: TextStyle(color: AppTheme.outline, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Map placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    color: AppTheme.surfaceContainerHigh,
                    child: const Center(
                      child: Icon(Icons.map_outlined, size: 60, color: AppTheme.outline),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: AppTheme.primary, size: 16),
                            const SizedBox(width: 4),
                            Text('View on Map',
                                style: TextStyle(
                                    color: AppTheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isTitle = false, bool isPrice = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: isPrice ? AppTheme.primary : AppTheme.onSurface,
                fontWeight: isPrice || isTitle ? FontWeight.w800 : FontWeight.w600,
                fontSize: isPrice ? 17 : 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, indent: 18, endIndent: 18);

  void _showCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Exchange complete! 🎉', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'Would you like to leave a review for the seller? Your feedback helps the community.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Skip', style: TextStyle(color: AppTheme.outline)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showReviewSheet(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Leave review'),
          ),
        ],
      ),
    );
  }

  void _showReviewSheet(BuildContext context) {
    int _stars = 5;
    final _reviewCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Leave a review', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('How was your experience with ${widget.listing.sellerName}?',
                  style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () => setModalState(() => _stars = i + 1),
                    child: Icon(
                      i < _stars ? Icons.star : Icons.star_outline,
                      color: const Color(0xFFF59E0B),
                      size: 36,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _reviewCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Share details about your experience...',
                  hintStyle: TextStyle(color: AppTheme.outline, fontSize: 13),
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
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Review submitted! Thank you 🙏'),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Submit review', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
