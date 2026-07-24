/// DOMAIN ENTITY — pure Dart.
///
/// No Firestore, no JSON, no Flutter. Serialisation lives in
/// `data/models/listing_model.dart`, so this class does not have to change
/// when the database schema does.
class Listing {
  final String id;
  final String title;
  final String category;
  final int price;
  final String condition;
  final String description;
  final String sellerName;
  final String sellerInitials;
  final double sellerRating;
  final int sellerReviews;
  final bool isVerified;
  final String meetupLocation;
  final String imageUrl;
  final bool isNegotiable;
  final String sellerId;
  final String status;
  final DateTime? createdAt;

  const Listing({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.condition,
    required this.description,
    required this.sellerName,
    required this.sellerInitials,
    required this.sellerRating,
    required this.sellerReviews,
    required this.isVerified,
    required this.meetupLocation,
    required this.imageUrl,
    this.isNegotiable = false,
    this.sellerId = '',
    this.status = 'active',
    this.createdAt,
  });

  Listing copyWith({
    String? id,
    String? title,
    String? category,
    int? price,
    String? condition,
    String? description,
    String? meetupLocation,
    String? status,
    bool? isNegotiable,
  }) {
    return Listing(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      price: price ?? this.price,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      sellerName: sellerName,
      sellerInitials: sellerInitials,
      sellerRating: sellerRating,
      sellerReviews: sellerReviews,
      isVerified: isVerified,
      meetupLocation: meetupLocation ?? this.meetupLocation,
      imageUrl: imageUrl,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      sellerId: sellerId,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  bool get isSold => status == 'sold';
  bool get isActive => status == 'active';

  /// Business rule: only the seller may edit or delete a listing.
  bool isOwnedBy(String? userId) =>
      userId != null && userId.isNotEmpty && sellerId == userId;
}
