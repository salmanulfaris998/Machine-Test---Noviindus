class MyFeedResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<MyFeedItem> results;

  const MyFeedResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory MyFeedResponse.fromJson(Map<String, dynamic> json) {
    final resultsList = json['results'] as List<dynamic>? ?? [];
    return MyFeedResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: resultsList
          .map((item) => MyFeedItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MyFeedItem {
  final int id;
  final String description;
  final String image;
  final String video;
  final List<int> likes;
  final List<int> dislikes;
  final List<int> bookmarks;
  final List<int> hide;
  final DateTime? createdAt;
  final bool follow;
  final FeedUser user;

  const MyFeedItem({
    required this.id,
    required this.description,
    required this.image,
    required this.video,
    required this.likes,
    required this.dislikes,
    required this.bookmarks,
    required this.hide,
    this.createdAt,
    required this.follow,
    required this.user,
  });

  factory MyFeedItem.fromJson(Map<String, dynamic> json) {
    return MyFeedItem(
      id: json['id'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      video: json['video'] as String? ?? '',
      likes: (json['likes'] as List<dynamic>?)?.cast<int>() ?? [],
      dislikes: (json['dislikes'] as List<dynamic>?)?.cast<int>() ?? [],
      bookmarks: (json['bookmarks'] as List<dynamic>?)?.cast<int>() ?? [],
      hide: (json['hide'] as List<dynamic>?)?.cast<int>() ?? [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      follow: json['follow'] as bool? ?? false,
      user: FeedUser.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class FeedUser {
  final int id;
  final String? name;
  final String? image;

  const FeedUser({
    required this.id,
    this.name,
    this.image,
  });

  factory FeedUser.fromJson(Map<String, dynamic> json) {
    return FeedUser(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String?,
      image: json['image'] as String?,
    );
  }
}
