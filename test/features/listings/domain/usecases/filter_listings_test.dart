import 'package:flutter_test/flutter_test.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';
import 'package:sokopop_flutter_app/features/listings/domain/usecases/filter_listings.dart';

/// This test is only possible because filtering moved out of
/// `browse_screen.dart`. When it lived inside the widget it could not be
/// exercised without pumping a whole screen.
void main() {
  const filter = FilterListings();

  Listing make({
    required String id,
    required String title,
    required String category,
    required int price,
    bool isVerified = true,
    DateTime? createdAt,
  }) {
    return Listing(
      id: id,
      title: title,
      category: category,
      price: price,
      condition: 'Good',
      description: 'A test listing',
      sellerName: 'Ada',
      sellerInitials: 'A',
      sellerRating: 5,
      sellerReviews: 1,
      isVerified: isVerified,
      meetupLocation: 'Library',
      imageUrl: '',
      sellerId: 'seller-1',
      createdAt: createdAt,
    );
  }

  final listings = [
    make(id: '1', title: 'Calculus textbook', category: 'Textbooks', price: 5000),
    make(id: '2', title: 'Hoodie', category: 'Clothing', price: 12000, isVerified: false),
    make(id: '3', title: 'USB-C charger', category: 'Electronics', price: 3000),
  ];

  test('returns everything when no filters are applied', () {
    expect(filter(listings).length, 3);
  });

  test('filters by category', () {
    final result = filter(listings, category: 'Clothing');
    expect(result.single.id, '2');
  });

  test('verifiedOnly hides unverified sellers', () {
    final result = filter(listings, verifiedOnly: true);
    expect(result.map((l) => l.id), ['1', '3']);
  });

  test('search matches title and description, case-insensitively', () {
    final result = filter(listings, query: 'CALCULUS');
    expect(result.single.id, '1');
  });

  test('sorts by price low to high', () {
    final result = filter(listings, sort: ListingSort.priceLowToHigh);
    expect(result.map((l) => l.price), [3000, 5000, 12000]);
  });

  test('combines category and sort', () {
    final result = filter(
      listings,
      verifiedOnly: true,
      sort: ListingSort.priceHighToLow,
    );
    expect(result.map((l) => l.id), ['1', '3']);
  });
}
