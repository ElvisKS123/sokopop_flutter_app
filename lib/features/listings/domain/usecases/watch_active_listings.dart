import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';
import 'package:sokopop_flutter_app/features/listings/domain/repositories/listing_repository.dart';

class WatchActiveListings {
  const WatchActiveListings(this._repository);

  final ListingRepository _repository;

  Stream<List<Listing>> call() => _repository.watchActiveListings();
}
