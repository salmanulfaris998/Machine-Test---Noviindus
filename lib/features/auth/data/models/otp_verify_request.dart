class OtpVerifyRequest {
  const OtpVerifyRequest({
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
