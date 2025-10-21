import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:interview/core/constants/api_constants.dart';
import 'package:interview/features/add%20video/data/models/add_feed_request.dart';
import 'package:interview/shared/storage_service.dart';

class AddFeedService {
  final StorageService _storageService;

  AddFeedService(this._storageService);

  Future<AddFeedResponse> addFeed(AddFeedRequest request) async {
    try {
      final token = _storageService.accessToken;
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.myFeed}');
      final httpRequest = http.MultipartRequest('POST', uri);

      // Add headers
      httpRequest.headers.addAll({
        '${ApiConstants.authorization}': '${ApiConstants.bearer} $token',
      });

      // Add video file
      final videoFile = await http.MultipartFile.fromPath(
        'video',
        request.video.path,
        filename: request.video.path.split('/').last,
      );
      httpRequest.files.add(videoFile);

      // Add thumbnail file
      final thumbnailFile = await http.MultipartFile.fromPath(
        'image',
        request.thumbnail.path,
        filename: request.thumbnail.path.split('/').last,
      );
      httpRequest.files.add(thumbnailFile);

      // Add description and category
      httpRequest.fields['desc'] = request.description;
      httpRequest.fields['category'] = request.categoryId;

      // Send request
      final streamedResponse = await httpRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return AddFeedResponse.fromJson(jsonData);
      } else {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(
          errorData['message'] ?? 'Failed to upload feed: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to upload feed: $e');
    }
  }
}
