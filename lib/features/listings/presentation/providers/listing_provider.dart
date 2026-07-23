import 'package:flutter/material.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';
import 'package:sokopop_flutter_app/features/listings/data/datasources/listing_remote_data_source.dart';

class ListingProvider extends ChangeNotifier {
  final ListingService _service = ListingService();

  List<Listing> _listings = [];
  bool _isLoading = false;
  String? _error;

  List<Listing> get listings => _listings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Subscribe to real-time listings from Firestore
  void fetchListings() {
    _isLoading = true;
    notifyListeners();

    _service.getListings().listen(
      (data) {
        _listings = data;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // CREATE
  Future<void> createListing(Listing listing) async {
    try {
      await _service.createListing(listing);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // UPDATE — mark as sold
  Future<void> markAsSold(String listingId) async {
    try {
      await _service.markAsSold(listingId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // UPDATE — edit listing
  Future<void> updateListing(String listingId, Map<String, dynamic> updates) async {
    try {
      await _service.updateListing(listingId, updates);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // DELETE
  Future<void> deleteListing(String listingId) async {
    try {
      await _service.deleteListing(listingId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}