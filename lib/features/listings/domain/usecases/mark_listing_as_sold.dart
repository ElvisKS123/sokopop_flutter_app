import 'package:sokopop_flutter_app/core/error/failures.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';
import 'package:sokopop_flutter_app/features/listings/domain/repositories/listing_repository.dart';

class MarkListingAsSold {
  const MarkListingAsSold(this._repository);

  final ListingRepository _repository;

  Future<void> call({
    required Listing listing,
    required String? currentUserId,
  }) {
    if (!listing.isOwnedBy(currentUserId)) {
      throw const PermissionFailure(
        'You can only mark your own listings as sold.',
      );
    }
    if (listing.isSold) {
      throw const ValidationFailure('This listing is already sold.');
    }
    return _repository.markAsSold(listing.id);
  }
}
