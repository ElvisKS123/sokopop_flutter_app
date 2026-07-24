import 'package:sokopop_flutter_app/core/error/failures.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';
import 'package:sokopop_flutter_app/features/listings/domain/repositories/listing_repository.dart';

class DeleteListing {
  const DeleteListing(this._repository);

  final ListingRepository _repository;

  Future<void> call({
    required Listing listing,
    required String? currentUserId,
  }) {
    if (!listing.isOwnedBy(currentUserId)) {
      throw const PermissionFailure('You can only delete your own listings.');
    }
    return _repository.deleteListing(listing.id);
  }
}
