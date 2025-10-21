class HomeFeedResponse {
  const HomeFeedResponse({
    required this.user,
    required this.banners,
    required this.categoryDict,
    required this.results,
    required this.status,
    required this.next,
  });

  final List<dynamic> user;
  final List<BannerItem> banners;
  final List<HomeCategory> categoryDict;
  final List<HomeFeedItem> results;
  final bool status;
  final bool next;

  factory HomeFeedResponse.fromJson(Map<String, dynamic> json) {
    return HomeFeedResponse(
      user: (json['user'] as List<dynamic>? ?? []),
      banners: (json['banners'] as List<dynamic>? ?? [])
          .map((banner) => BannerItem.fromJson(banner as Map<String, dynamic>))
          .toList(),
      categoryDict: (json['category_dict'] as List<dynamic>? ?? [])
          .map((category) =>
              HomeCategory.fromJson(category as Map<String, dynamic>))
          .toList(),
      results: (json['results'] as List<dynamic>? ?? [])
          .map((result) =>
              HomeFeedItem.fromJson(result as Map<String, dynamic>))
          .toList(),
      status: json['status'] as bool? ?? false,
      next: json['next'] as bool? ?? false,
    );
  }
}

class BannerItem {
  const BannerItem({
    required this.id,
    required this.title,
    required this.image,
  });

  final int id;
  final String title;
  final String image;

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

class HomeCategory {
  const HomeCategory({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;

  factory HomeCategory.fromJson(Map<String, dynamic> json) {
    return HomeCategory(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
    );
  }
}

class HomeFeedItem {
  const HomeFeedItem({
    required this.id,
    required this.description,
    required this.image,
    required this.video,
    required this.likes,
    required this.dislikes,
    required this.bookmarks,
    required this.hide,
    required this.createdAt,
    required this.follow,
    required this.user,
  });

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

  factory HomeFeedItem.fromJson(Map<String, dynamic> json) {
    return HomeFeedItem(
      id: json['id'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      video: json['video'] as String? ?? '',
      likes: (json['likes'] as List<dynamic>? ?? [])
          .map((item) => int.tryParse(item.toString()) ?? 0)
          .toList(),
      dislikes: (json['dislikes'] as List<dynamic>? ?? [])
          .map((item) => int.tryParse(item.toString()) ?? 0)
          .toList(),
      bookmarks: (json['bookmarks'] as List<dynamic>? ?? [])
          .map((item) => int.tryParse(item.toString()) ?? 0)
          .toList(),
      hide: (json['hide'] as List<dynamic>? ?? [])
          .map((item) => int.tryParse(item.toString()) ?? 0)
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      follow: json['follow'] as bool? ?? false,
      user: FeedUser.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class FeedUser {
  const FeedUser({
    required this.id,
    required this.name,
    required this.image,
  });

  final int id;
  final String name;
  final String? image;

  factory FeedUser.fromJson(Map<String, dynamic> json) {
    return FeedUser(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
    );
  }
}
