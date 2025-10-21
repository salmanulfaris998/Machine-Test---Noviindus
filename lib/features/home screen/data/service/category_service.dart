import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:interview/features/home screen/data/model/category_model.dart';

class CategoryService {
  CategoryService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String _baseUrl = 'https://frijo.noviindus.in/api';

  Future<CategoryListResponse> fetchCategories() async {
    final uri = Uri.parse('$_baseUrl/category_list');

    final response = await _client.get(uri);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> jsonBody =
          json.decode(response.body) as Map<String, dynamic>;
      return CategoryListResponse.fromJson(jsonBody);
    }

    throw CategoryException(
      message: 'Failed to load categories. (${response.statusCode})',
      statusCode: response.statusCode,
      body: response.body,
    );
  }
}

class CategoryException implements Exception {
  CategoryException({required this.message, this.statusCode, this.body});

  final String message;
  final int? statusCode;
  final String? body;

  @override
  String toString() =>
      'CategoryException(message: $message, statusCode: $statusCode, body: $body)';
}
