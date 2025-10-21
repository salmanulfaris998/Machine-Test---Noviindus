import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:interview/core/constants/api_constants.dart';
import 'package:interview/features/my%20feeds%20/data/models/my_feed_model.dart';
import 'package:interview/shared/storage_service.dart';

class MyFeedService {
  final StorageService _storageService;

  MyFeedService(this._storageService);

  Future<MyFeedResponse> fetchMyFeeds({int page = 1}) async {
    try {
      final token = _storageService.accessToken;
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.myFeed}?page=$page');
      final response = await http.get(
        uri,
        headers: {
          '${ApiConstants.authorization}': '${ApiConstants.bearer} $token',
          'Content-Type': ApiConstants.contentTypeJson,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return MyFeedResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load my feeds: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to load my feeds: $e');
    }
  }
}
