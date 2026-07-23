/// DOMAIN ENTITY — pure Dart.
///
/// Replaces the raw `firebase_auth.User` that used to leak all the way into
/// the screens. If Firebase is ever swapped out, only the data layer changes.
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isEmailVerified = false,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isEmailVerified;

  /// Used on listing cards and avatars.
  String get initials {
    final source = (displayName?.trim().isNotEmpty ?? false)
        ? displayName!.trim()
        : email;
    if (source.isEmpty) return '?';
    return source
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .take(2)
        .join()
        .toUpperCase();
  }

  /// Falls back through the options a screen would otherwise write itself.
  String get name =>
      (displayName?.trim().isNotEmpty ?? false) ? displayName!.trim() : email;

  /// Campus rule: only @alustudent.com addresses count as verified students.
  bool get isVerifiedStudent => email.endsWith('@alustudent.com');
}
