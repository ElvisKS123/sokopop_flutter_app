import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:sokopop_flutter_app/core/error/failures.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';
import 'package:sokopop_flutter_app/features/listings/domain/usecases/create_listing.dart';
import 'package:sokopop_flutter_app/features/listings/domain/usecases/delete_listing.dart';
import 'package:sokopop_flutter_app/features/listings/domain/usecases/filter_listings.dart';
import 'package:sokopop_flutter_app/features/listings/domain/usecases/mark_listing_as_sold.dart';
import 'package:sokopop_flutter_app/features/listings/domain/usecases/update_listing.dart';
import 'package:sokopop_flutter_app/features/listings/domain/usecases/watch_active_listings.dart';

/// Owns everything the browse/home screens used to hold in `setState`:
/// the listings, the loading flag, the error, AND the category / verified /
/// sort / search filters.
class ListingProvider extends ChangeNotifier {
  ListingProvider({
    required WatchActiveListings watchActiveListings,
    required CreateListing createListingUseCase,
    required UpdateListing updateListingUseCase,
    required MarkListingAsSold markAsSoldUseCase,
    required DeleteListing deleteListingUseCase,
    required FilterListings filterListings,
  })  : _watchActiveListings = watchActiveListings,
        _createListing = createListingUseCase,
        _updateListing = updateListingUseCase,
        _markAsSold = markAsSoldUseCase,
        _deleteListing = deleteListingUseCase,
        _filterListings = filterListings;

  final WatchActiveListings _watchActiveListings;
  final CreateListing _createListing;
  final UpdateListing _updateListing;
  final MarkListingAsSold _markAsSold;
  final DeleteListing _deleteListing;
  final FilterListings _filterListings;

  // ---- state ------------------------------------------------------------
  List<Listing> _listings = [];
  bool _isLoading = false;
  bool _isMutating = false;
  String? _error;

  String _category = 'All';
  bool _verifiedOnly = false;
  String _query = '';
  ListingSort _sort = ListingSort.newest;

  String? _currentUserId;

  StreamSubscription<List<Listing>>? _subscription;

  // ---- reads ------------------------------------------------------------
  List<Listing> get listings => _listings;
  bool get isLoading => _isLoading;
  bool get isMutating => _isMutating;
  String? get error => _error;

  String get category => _category;
  bool get verifiedOnly => _verifiedOnly;
  String get query => _query;
  ListingSort get sort => _sort;

  /// What the browse feed should actually render. The filtering itself lives
  /// in a use case, so it can be unit-tested without a widget.
  List<Listing> get visibleListings => _filterListings(
        _listings,
        category: _category,
        verifiedOnly: _verifiedOnly,
        query: _query,
        sort: _sort,
      );

  List<Listing> get myListings =>
      _listings.where((l) => l.isOwnedBy(_currentUserId)).toList();

  bool isOwner(Listing listing) => listing.isOwnedBy(_currentUserId);

  /// Kept in sync by `ChangeNotifierProxyProvider` in `app.dart`.
  void updateCurrentUser(String? userId) {
    if (_currentUserId == userId) return;
    _currentUserId = userId;
    notifyListeners();
  }

  // ---- READ -------------------------------------------------------------
  /// Safe to call from `initState` on more than one screen.
  ///
  /// The original version called `.listen()` every time and never stored or
  /// cancelled the subscription, so navigating back and forth stacked live
  /// listeners that all wrote to the same list.
  void fetchListings({bool force = false}) {
    if (_subscription != null && !force) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _watchActiveListings().listen(
      (data) {
        _listings = data;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (Object e) {
        _error = e is Failure ? e.message : 'Could not load listings.';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // ---- filters ----------------------------------------------------------
  void setCategory(String value) {
    if (_category == value) return;
    _category = value;
    notifyListeners();
  }

  void toggleVerifiedOnly() {
    _verifiedOnly = !_verifiedOnly;
    notifyListeners();
  }

  void setQuery(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  void setSort(ListingSort value) {
    if (_sort == value) return;
    _sort = value;
    notifyListeners();
  }

  // ---- CREATE / UPDATE / DELETE ----------------------------------------
  Future<bool> createListing(Listing listing) =>
      _mutate(() => _createListing(listing));

  Future<bool> updateListing(Listing listing, Map<String, dynamic> updates) {
    return _mutate(() => _updateListing(
          listing: listing,
          updates: updates,
          currentUserId: _currentUserId,
        ));
  }

  Future<bool> markAsSold(Listing listing) => _mutate(
        () => _markAsSold(listing: listing, currentUserId: _currentUserId),
      );

  Future<bool> deleteListing(Listing listing) => _mutate(
        () => _deleteListing(listing: listing, currentUserId: _currentUserId),
      );

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  /// Returns true on success. On failure [error] holds a message that is
  /// already worded for a snackbar — no more `Exception: Failed to create
  /// listing: [cloud_firestore/permission-denied] …` reaching the user.
  Future<bool> _mutate(Future<void> Function() action) async {
    _isMutating = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      _isMutating = false;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      _error = failure.message;
      _isMutating = false;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Something went wrong. Please try again.';
      _isMutating = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
