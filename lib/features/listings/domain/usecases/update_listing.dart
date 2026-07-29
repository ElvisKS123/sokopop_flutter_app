import 'package:sokopop_flutter_app/core/error/failures.dart';
import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';
import 'package:sokopop_flutter_app/features/listings/domain/repositories/listing_repository.dart';

class UpdateListing {
  const UpdateListing(this._repository);

  final ListingRepository _repository;

  /// [currentUserId] is checked here as well as in the security rules —
  /// the rules are the real defence, this just fails fast with a clear message.
  Future<void> call({
    required Listing listing,
    required Map<String, dynamic> updates,
    required String? currentUserId,
  }) {
    if (!listing.isOwnedBy(currentUserId)) {
      throw const PermissionFailure('You can only edit your own listings.');
    }
    if (updates.containsKey('sellerId') || updates.containsKey('createdAt')) {
      throw const ValidationFailure('That field cannot be changed.');
    }
    return _repository.updateListing(listing.id, updates);
  }
}
