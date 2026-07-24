import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'package:sokopop_flutter_app/features/auth/domain/entities/app_user.dart';

/// An [AppUser] that also knows how to be built from Firebase.
/// Entities stay clean; Firebase awareness stops at this file.
class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.isEmailVerified,
  });

  factory UserModel.fromFirebaseUser(fb.User user) => UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
        isEmailVerified: user.emailVerified,
      );
}
