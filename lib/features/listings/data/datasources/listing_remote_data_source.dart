import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sokopop_flutter_app/features/listings/data/models/listing_model.dart';

/// The only file in the listings feature that imports `cloud_firestore`.
///
/// Same queries as the original `services/listing_service.dart`; the
/// difference is that it no longer wraps errors in `Exception('Failed to â€¦: $e')`
/// â€” raw codes now travel up to the repository, which knows how to word them.
abstract class ListingRemoteDataSource {
  Stream<List<ListingModel>> watchActiveListings();
  Stream<List<ListingModel>> watchListingsBySeller(String sellerId);
  Future<String> createListing(ListingModel listing);
  Future<void> updateListing(String listingId, Map<String, dynamic> updates);
  Future<void> markAsSold(String listingId);
  Future<void> deleteListing(String listingId);
}

class ListingRemoteDataSourceImpl implements ListingRemoteDataSource {
  const ListingRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _db = firestore;

  final FirebaseFirestore _db;

  static const _collection = 'listings';

  CollectionReference<Map<String, dynamic>> get _listings =>
      _db.collection(_collection);

  // READ â€” all active listings, live
  @override
  Stream<List<ListingModel>> watchActiveListings() {
    return _listings
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ListingModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  // READ â€” one seller's listings, live
  @override
  Stream<List<ListingModel>> watchListingsBySeller(String sellerId) {
    return _listings
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ListingModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  // CREATE
  @override
  Future<String> createListing(ListingModel listing) async {
    final ref = await _listings.add(listing.toMap());
    return ref.id;
  }

  // UPDATE
  @override
  Future<void> updateListing(
    String listingId,
    Map<String, dynamic> updates,
  ) {
    return _listings.doc(listingId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // UPDATE â€” mark as sold
  @override
  Future<void> markAsSold(String listingId) {
    return _listings.doc(listingId).update({
      'status': 'sold',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // DELETE
  @override
  Future<void> deleteListing(String listingId) =>
      _listings.doc(listingId).delete();
}
