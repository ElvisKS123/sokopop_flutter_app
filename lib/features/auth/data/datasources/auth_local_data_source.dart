import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences lives behind its own data source.
///
/// It used to sit inside the auth repository next to the Firebase calls, which
/// meant "remember the last email" and "sign the user in" were the same class's
/// job. Splitting them means the theme/settings work can reuse this pattern
/// without touching auth at all.
abstract class AuthLocalDataSource {
  Future<void> cacheLastEmail(String email);
  Future<String?> getLastEmail();
  Future<void> clearLastEmail();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl();

  static const _lastEmailKey = 'last_email';

  @override
  Future<void> cacheLastEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastEmailKey, email);
  }

  @override
  Future<String?> getLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastEmailKey);
  }

  @override
  Future<void> clearLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastEmailKey);
  }
}
