class OtpVerifyResponse {
  const OtpVerifyResponse({
    required this.status,
    required this.privilege,
    required this.token,
    required this.phone,
  });

  final bool status;
  final bool privilege;
  final TokenPair token;
  final String phone;

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(
      status: json['status'] as bool? ?? false,
      privilege: json['privilege'] as bool? ?? false,
      token: TokenPair.fromJson(json['token'] as Map<String, dynamic>? ?? const {}),
      phone: json['phone'] as String? ?? '',
    );
  }
}

class TokenPair {
  const TokenPair({
    required this.refresh,
    required this.access,
  });

  final String refresh;
  final String access;

  factory TokenPair.fromJson(Map<String, dynamic> json) {
    return TokenPair(
      refresh: json['refresh'] as String? ?? '',
      access: json['access'] as String? ?? '',
    );
  }
}
