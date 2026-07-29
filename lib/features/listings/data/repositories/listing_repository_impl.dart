import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sokopop_flutter_app/core/error/auth_error_mapper.dart';
import 'package:sokopop_flutter_app/core/error/failures.dart';
import 'package:sokopop_flutter_app/features/listings/data/datasources/listing_remote_data_source.dart';
import 'package:sokopop_flutter_app/features/listings/data/models/listing_model.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';
import 'package:sokopop_flutter_app/features/listings/domain/repositories/listing_repository.dart';

class ListingRepositoryImpl implements ListingRepository {
  const ListingRepositoryImpl({required ListingRemoteDataSource remote})
      : _remote = remote;

  final ListingRemoteDataSource _remote;

  /// Stream errors are converted too, so the provider never surfaces a raw
  /// `[cloud_firestore/permission-denied] …` string to the user.
  @override
  Stream<List<Listing>> watchActiveListings() async* {
    try {
      yield* _remote.watchActiveListings();
    } on FirebaseException catch (e) {
      throw ServerFailure(messageForFirestoreCode(e.code));
    }
  }

  @override
  Stream<List<Listing>> watchListingsBySeller(String sellerId) async* {
    try {
      yield* _remote.watchListingsBySeller(sellerId);
    } on FirebaseException catch (e) {
      throw ServerFailure(messageForFirestoreCode(e.code));
    }
  }

  @override
  Future<String> createListing(Listing listing) =>
      _guard(() => _remote.createListing(ListingModel.fromEntity(listing)));

  @override
  Future<void> updateListing(String listingId, Map<String, dynamic> updates) =>
      _guard(() => _remote.updateListing(listingId, updates));

  @override
  Future<void> markAsSold(String listingId) =>
      _guard(() => _remote.markAsSold(listingId));

  @override
  Future<void> deleteListing(String listingId) =>
      _guard(() => _remote.deleteListing(listingId));

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw const PermissionFailure();
      }
      if (e.code == 'unavailable') {
        throw const NetworkFailure();
      }
      throw ServerFailure(messageForFirestoreCode(e.code));
    } on Failure {
      rethrow;
    } catch (_) {
      throw const ServerFailure();
    }
  }
}
