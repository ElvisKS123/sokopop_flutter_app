import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';

/// How the browse feed is sorted. Was a `String _sortOption` held in a widget.
enum ListingSort { newest, priceLowToHigh, priceHighToLow }

/// The category / verified-only / search filtering that browse_screen used to
/// do inline with `setState`. Pure function, no Flutter import, unit-testable.
class FilterListings {
  const FilterListings();

  List<Listing> call(
    List<Listing> listings, {
    String category = 'All',
    bool verifiedOnly = false,
    String query = '',
    ListingSort sort = ListingSort.newest,
  }) {
    final trimmedQuery = query.trim().toLowerCase();

    final filtered = listings.where((listing) {
      if (category != 'All' && listing.category != category) return false;
      if (verifiedOnly && !listing.isVerified) return false;
      if (trimmedQuery.isNotEmpty) {
        final haystack =
            '${listing.title} ${listing.description} ${listing.category}'
                .toLowerCase();
        if (!haystack.contains(trimmedQuery)) return false;
      }
      return true;
    }).toList();

    switch (sort) {
      case ListingSort.priceLowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
      case ListingSort.priceHighToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
      case ListingSort.newest:
        filtered.sort((a, b) {
          final aDate = a.createdAt;
          final bDate = b.createdAt;
          if (aDate == null && bDate == null) return 0;
          if (aDate == null) return 1;
          if (bDate == null) return -1;
          return bDate.compareTo(aDate);
        });
    }

    return filtered;
  }
}
