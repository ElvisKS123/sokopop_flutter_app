import 'package:sokopop_flutter_app/core/error/failures.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';
import 'package:sokopop_flutter_app/features/listings/domain/repositories/listing_repository.dart';

/// The "is this listing postable?" rules used to be `if` statements inside
/// `create_listing_screen.dart`. They live here now, so the same rules apply
/// no matter which screen posts a listing.
class CreateListing {
  const CreateListing(this._repository);

  final ListingRepository _repository;

  Future<String> call(Listing listing) {
    if (listing.title.trim().isEmpty) {
      throw const ValidationFailure('Please enter a title.');
    }
    if (listing.title.trim().length > 80) {
      throw const ValidationFailure('Title is too long (80 characters max).');
    }
    if (listing.condition.trim().isEmpty) {
      throw const ValidationFailure('Please select a condition.');
    }
    if (listing.price < 0) {
      throw const ValidationFailure('Price cannot be negative.');
    }
    if (listing.sellerId.isEmpty) {
      throw const ValidationFailure('You must be signed in to post a listing.');
    }

    return _repository.createListing(listing);
  }
}
