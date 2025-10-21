import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview/features/auth/data/models/otp_verified.dart';
import 'package:interview/features/auth/data/service/auth_service.dart';
import 'package:interview/shared/storage_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final otpVerifyControllerProvider =
    StateNotifierProvider<OtpVerifyController, AsyncValue<OtpVerifiedResponse?>>(
  (ref) => OtpVerifyController(
    service: ref.read(authServiceProvider),
    storage: ref.read(storageServiceProvider),
  ),
);

class OtpVerifyController
    extends StateNotifier<AsyncValue<OtpVerifiedResponse?>> {
  OtpVerifyController({
    required AuthService service,
    required StorageService storage,
  })  : _service = service,
        _storage = storage,
        super(const AsyncValue<OtpVerifiedResponse?>.data(null));

  final AuthService _service;
  final StorageService _storage;

  Future<void> verifyPhone({
    required String countryCode,
    required String phone,
  }) async {
    state = const AsyncValue.loading();

    try {
      final response = await _service.verifyOtp(
        OtpVerifiedRequest(countryCode: countryCode, phone: phone),
      );
      await _storage.saveCredentials(
        accessToken: response.token.access,
        refreshToken: response.token.refresh,
        phone: response.phone,
      );
      state = AsyncValue.data(response);
    } on AuthException catch (e, stack) {
      state = AsyncValue.error(e, stack);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
