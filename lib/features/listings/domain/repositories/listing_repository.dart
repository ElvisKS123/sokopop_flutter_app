import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';

abstract class ListingRepository {
  Stream<List<Listing>> watchActiveListings();
  Stream<List<Listing>> watchListingsBySeller(String sellerId);
  Future<String> createListing(Listing listing);
  Future<void> updateListing(String listingId, Map<String, dynamic> updates);
  Future<void> markAsSold(String listingId);
  Future<void> deleteListing(String listingId);
}
