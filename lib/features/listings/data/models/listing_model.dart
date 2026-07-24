import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sokopop_flutter_app/features/listings/domain/entities/listing.dart';

/// A [Listing] that also knows how to serialise itself.
///
/// `toMap`/`fromMap` used to live on the entity, which meant every screen
/// showing a listing also pulled in Firestore's `Timestamp`. That knowledge
/// stops here now.
class ListingModel extends Listing {
  const ListingModel({
    required super.id,
    required super.title,
    required super.category,
    required super.price,
    required super.condition,
    required super.description,
    required super.sellerName,
    required super.sellerInitials,
    required super.sellerRating,
    required super.sellerReviews,
    required super.isVerified,
    required super.meetupLocation,
    required super.imageUrl,
    super.isNegotiable,
    super.sellerId,
    super.status,
    super.createdAt,
  });

  /// Convert Firestore data back to a Listing object.
  factory ListingModel.fromMap(String id, Map<String, dynamic> map) {
    return ListingModel(
      id: id,
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0).toInt(),
      condition: map['condition'] ?? '',
      description: map['description'] ?? '',
      sellerName: map['sellerName'] ?? '',
      sellerInitials: map['sellerInitials'] ?? '',
      sellerRating: (map['sellerRating'] ?? 0.0).toDouble(),
      sellerReviews: (map['sellerReviews'] ?? 0).toInt(),
      isVerified: map['isVerified'] ?? false,
      meetupLocation: map['meetupLocation'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isNegotiable: map['isNegotiable'] ?? false,
      sellerId: map['sellerId'] ?? '',
      status: map['status'] ?? 'active',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ListingModel.fromEntity(Listing listing) => ListingModel(
        id: listing.id,
        title: listing.title,
        category: listing.category,
        price: listing.price,
        condition: listing.condition,
        description: listing.description,
        sellerName: listing.sellerName,
        sellerInitials: listing.sellerInitials,
        sellerRating: listing.sellerRating,
        sellerReviews: listing.sellerReviews,
        isVerified: listing.isVerified,
        meetupLocation: listing.meetupLocation,
        imageUrl: listing.imageUrl,
        isNegotiable: listing.isNegotiable,
        sellerId: listing.sellerId,
        status: listing.status,
        createdAt: listing.createdAt,
      );

  /// Convert a Listing to a Map for Firestore.
  ///
  /// `createdAt` is a SERVER timestamp, not `DateTime.now()`. The previous
  /// version wrote the phone's clock, so a device with the wrong time would
  /// sort to the top of the browse feed forever.
  Map<String, dynamic> toMap() => <String, dynamic>{
        'title': title,
        'category': category,
        'price': price,
        'condition': condition,
        'description': description,
        'sellerName': sellerName,
        'sellerInitials': sellerInitials,
        'sellerRating': sellerRating,
        'sellerReviews': sellerReviews,
        'isVerified': isVerified,
        'meetupLocation': meetupLocation,
        'imageUrl': imageUrl,
        'isNegotiable': isNegotiable,
        'sellerId': sellerId,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
