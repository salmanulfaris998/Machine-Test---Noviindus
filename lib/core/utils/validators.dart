class Validators {
  /// Validates phone number (10 digits)
  static bool isValidPhoneNumber(String phone) {
    if (phone.isEmpty) return false;
    final phoneRegex = RegExp(r'^\d{10}$');
    return phoneRegex.hasMatch(phone);
  }

  /// Validates OTP (4 or 6 digits)
  static bool isValidOtp(String otp, {int length = 4}) {
    if (otp.isEmpty) return false;
    final otpRegex = RegExp('^\\d{$length}\$');
    return otpRegex.hasMatch(otp);
  }

  /// Validates email
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validates URL
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Checks if string is not empty
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validates minimum length
  static bool hasMinLength(String value, int minLength) {
    return value.length >= minLength;
  }

  /// Validates maximum length
  static bool hasMaxLength(String value, int maxLength) {
    return value.length <= maxLength;
  }
}
