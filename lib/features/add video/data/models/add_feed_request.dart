import 'dart:io';

class AddFeedRequest {
  final File video;
  final File thumbnail;
  final String description;
  final String categoryId;

  const AddFeedRequest({
    required this.video,
    required this.thumbnail,
    required this.description,
    required this.categoryId,
  });
}

class AddFeedResponse {
  final bool status;
  final String message;
  final FeedData? data;

  const AddFeedResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory AddFeedResponse.fromJson(Map<String, dynamic> json) {
    return AddFeedResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? FeedData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class FeedData {
  final int id;
  final String description;
  final String image;
  final String video;

  const FeedData({
    required this.id,
    required this.description,
    required this.image,
    required this.video,
  });

  factory FeedData.fromJson(Map<String, dynamic> json) {
    return FeedData(
      id: json['id'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      video: json['video'] as String? ?? '',
    );
  }
}
