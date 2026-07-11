import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/data.dart';

class ListingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'listings';

  // CREATE — add a new listing to Firestore
  Future<void> createListing(Listing listing) async {
    try {
      await _db.collection(_collection).add(listing.toMap());
    } catch (e) {
      throw Exception('Failed to create listing: $e');
    }
  }

  // READ — get all active listings as a real-time stream
  Stream<List<Listing>> getListings() {
    return _db
        .collection(_collection)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Listing.fromMap(doc.id, doc.data()))
            .toList());
  }

  // READ — get listings by a specific seller
  Stream<List<Listing>> getListingsBySeller(String sellerId) {
    return _db
        .collection(_collection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Listing.fromMap(doc.id, doc.data()))
            .toList());
  }

  // UPDATE — mark a listing as sold
  Future<void> markAsSold(String listingId) async {
    try {
      await _db
          .collection(_collection)
          .doc(listingId)
          .update({'status': 'sold'});
    } catch (e) {
      throw Exception('Failed to update listing: $e');
    }
  }

  // UPDATE — edit listing details
  Future<void> updateListing(String listingId, Map<String, dynamic> updates) async {
    try {
      await _db
          .collection(_collection)
          .doc(listingId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update listing: $e');
    }
  }

  // DELETE — remove a listing permanently
  Future<void> deleteListing(String listingId) async {
    try {
      await _db
          .collection(_collection)
          .doc(listingId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete listing: $e');
    }
  }
}