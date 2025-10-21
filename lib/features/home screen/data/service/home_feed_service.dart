import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:interview/features/home screen/data/model/home_feed_model.dart';

class HomeFeedService {
  HomeFeedService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String _baseUrl = 'https://frijo.noviindus.in/api';

  Future<HomeFeedResponse> fetchHomeFeed() async {
    final uri = Uri.parse('$_baseUrl/home');
    final response = await _client.get(uri);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      return HomeFeedResponse.fromJson(data);
    }

    throw HomeFeedException(
      message: 'Failed to load home feed. (${response.statusCode})',
      statusCode: response.statusCode,
      body: response.body,
    );
  }
}

class HomeFeedException implements Exception {
  HomeFeedException({required this.message, this.statusCode, this.body});

  final String message;
  final int? statusCode;
  final String? body;

  @override
  String toString() =>
      'HomeFeedException(message: $message, statusCode: $statusCode, body: $body)';
}
