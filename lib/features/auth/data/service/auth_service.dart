import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:interview/features/auth/data/models/otp_verify_request.dart';
import 'package:interview/features/auth/data/models/otp_verify_response.dart';

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String _baseUrl = 'https://frijo.noviindus.in/api';

  Future<OtpVerifyResponse> verifyOtp(OtpVerifyRequest request) async {
    final uri = Uri.parse('$_baseUrl/otp_verified');

    final response = await _client.post(
      uri,
      headers: {
        'Accept': 'application/json',
      },
      body: request.toFormData(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> jsonBody =
          json.decode(response.body) as Map<String, dynamic>;
      return OtpVerifyResponse.fromJson(jsonBody);
    }

    throw AuthException(
      message: 'Failed to verify OTP. (${response.statusCode})',
      statusCode: response.statusCode,
      body: response.body,
    );
  }
}

class AuthException implements Exception {
  AuthException({required this.message, this.statusCode, this.body});

  final String message;
  final int? statusCode;
  final String? body;

  @override
  String toString() =>
      'AuthException(message: $message, statusCode: $statusCode, body: $body)';
}
