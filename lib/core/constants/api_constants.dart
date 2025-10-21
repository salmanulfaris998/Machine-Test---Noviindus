class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://frijo.noviindus.in/api';

  // Endpoints
  static const String login = '/login';
  static const String otpVerify = '/otp_verify';
  static const String home = '/home';
  static const String categoryList = '/category_list';
  static const String myFeed = '/my_feed';

  // Headers
  static const String contentTypeJson = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
