import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview/features/auth/data/models/otp_verify_request.dart';
import 'package:interview/features/auth/data/models/otp_verify_response.dart';
import 'package:interview/features/auth/data/service/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final otpVerifyControllerProvider =
    StateNotifierProvider<OtpVerifyController, AsyncValue<OtpVerifyResponse?>>(
  (ref) => OtpVerifyController(ref.read(authServiceProvider)),
);

class OtpVerifyController
    extends StateNotifier<AsyncValue<OtpVerifyResponse?>> {
  OtpVerifyController(this._service)
      : super(const AsyncValue<OtpVerifyResponse?>.data(null));

  final AuthService _service;

  Future<void> verifyPhone({
    required String countryCode,
    required String phone,
  }) async {
    state = const AsyncValue.loading();

    try {
      final response = await _service.verifyOtp(
        OtpVerifyRequest(countryCode: countryCode, phone: phone),
      );
      state = AsyncValue.data(response);
    } on AuthException catch (e, stack) {
      state = AsyncValue.error(e, stack);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
