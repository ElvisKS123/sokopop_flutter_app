import 'package:flutter_test/flutter_test.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';

/// `isOwnedBy` used to be written inline in listing_details_screen.dart as
/// `FirebaseAuth.instance.currentUser?.uid == widget.listing.sellerId`.
/// As a method on the entity it can be tested without Firebase or a widget.
void main() {
  const listing = Listing(
    id: 'l1',
    title: 'Calculus textbook',
    category: 'Textbooks',
    price: 5000,
    condition: 'Good',
    description: 'Barely used',
    sellerName: 'Ada',
    sellerInitials: 'A',
    sellerRating: 5,
    sellerReviews: 2,
    isVerified: true,
    meetupLocation: 'Library',
    imageUrl: '',
    sellerId: 'seller-1',
  );

  test('the seller owns their own listing', () {
    expect(listing.isOwnedBy('seller-1'), isTrue);
  });

  test('another signed-in user does not own it', () {
    expect(listing.isOwnedBy('seller-2'), isFalse);
  });

  test('a signed-out user owns nothing', () {
    expect(listing.isOwnedBy(null), isFalse);
    expect(listing.isOwnedBy(''), isFalse);
  });

  test('status helpers read the status field', () {
    expect(listing.isActive, isTrue);
    expect(listing.isSold, isFalse);
  });

  test('copyWith changes only what it is given', () {
    final updated = listing.copyWith(title: 'Calculus textbook (2nd ed)');
    expect(updated.title, 'Calculus textbook (2nd ed)');
    expect(updated.price, 5000);
    expect(updated.sellerId, 'seller-1');
  });
}
