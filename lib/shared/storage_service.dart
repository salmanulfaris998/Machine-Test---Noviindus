import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _phoneKey = 'auth_phone';

  static Future<StorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  String? get accessToken => _prefs.getString(_tokenKey);

  String? get refreshToken => _prefs.getString(_refreshTokenKey);

  String? get savedPhone => _prefs.getString(_phoneKey);

  Future<void> saveCredentials({
    required String accessToken,
    required String refreshToken,
    required String phone,
  }) async {
    await Future.wait([
      _prefs.setString(_tokenKey, accessToken),
      _prefs.setString(_refreshTokenKey, refreshToken),
      _prefs.setString(_phoneKey, phone),
    ]);
  }

  Future<void> clearCredentials() async {
    await Future.wait([
      _prefs.remove(_tokenKey),
      _prefs.remove(_refreshTokenKey),
      _prefs.remove(_phoneKey),
    ]);
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden');
});
