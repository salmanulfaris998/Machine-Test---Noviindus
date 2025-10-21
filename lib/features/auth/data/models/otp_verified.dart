class OtpVerifiedRequest {
  const OtpVerifiedRequest({
    required this.countryCode,
    required this.phone,
  });

  final String countryCode;
  final String phone;

  Map<String, String> toFormData() => {
        'country_code': countryCode,
        'phone': phone,
      };
}

class OtpVerifiedResponse {
  const OtpVerifiedResponse({
    required this.status,
    required this.privilege,
    required TokenPair token,
    required this.phone,
  }) : token = token;

  final bool status;
  final bool privilege;
  final TokenPair token;
  final String phone;

  factory OtpVerifiedResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifiedResponse(
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
