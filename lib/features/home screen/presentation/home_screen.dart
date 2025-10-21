import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:interview/features/home%20screen/data/controller/category_controller.dart';
import 'package:interview/features/home%20screen/data/controller/home_feed_controller.dart';
import 'package:interview/features/home%20screen/widgets/category_chip.dart';
import 'package:interview/features/home%20screen/widgets/video_feed_item.dart';
import 'package:interview/features/home%20screen/widgets/header_greeting.dart';
import 'package:interview/shared/storage_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoryControllerProvider);
    final feedState = ref.watch(homeFeedControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 76,
        height: 76,
        child: FloatingActionButton(
          onPressed: () => context.push('/add-feed'),
          backgroundColor: const Color(0xFFE4090E),
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 36, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: HeaderGreeting(
                  title: 'Hello Maria',
                  subtitle: 'Welcome back to Section',
                  avatarUrl:
                      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
                  onAvatarTap: () async {
                    await ref.read(storageServiceProvider).clearCredentials();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 48,
                child: categoriesState.when(
                  loading: () => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) => Container(
                      width: 96,
                      margin: EdgeInsets.only(right: index == 3 ? 0 : 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.redAccent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Failed to load categories',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(categoryControllerProvider.notifier)
                                .loadCategories();
                          },
                          icon: const Icon(Icons.refresh,
                              color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  data: (categories) => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == categories.length - 1 ? 0 : 12,
                        ),
                        child: CategoryChip(
                          label: category.title,
                          isActive: index == 0,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Latest Posts',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              feedState.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Failed to load feed',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(homeFeedControllerProvider.notifier)
                              .fetchHomeFeed();
                        },
                        icon:
                            const Icon(Icons.refresh, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                data: (feed) {
                  final posts = feed.results;
                  if (posts.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'No posts available yet.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 0),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final avatarUrl = post.user.image?.trim();
                      final thumbnailUrl = post.image.trim();
                      final videoUrl = post.video.trim();
                      final fallbackAvatar =
                          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(post.user.name)}';
                      final fallbackThumbnail =
                          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(post.description)}&size=512&background=1F1F1F&color=FFFFFF';
                      
                      return VideoFeedItem(
                        feedId: post.id,
                        authorName: post.user.name,
                        timeAgo: post.createdAt != null
                            ? _timeAgo(post.createdAt!)
                            : 'Just now',
                        authorAvatarUrl:
                            (avatarUrl != null && avatarUrl.isNotEmpty)
                                ? avatarUrl
                                : fallbackAvatar,
                        thumbnailUrl:
                            thumbnailUrl.isNotEmpty ? thumbnailUrl : fallbackThumbnail,
                        videoUrl: videoUrl,
                        description: post.description,
                        likeCount: post.likes.length,
                        isFollowing: post.follow,
                        onLikePressed: () {
                          // TODO: Implement like API call
                          debugPrint('Like pressed for post ${post.id}');
                        },
                        onFollowPressed: () {
                          // TODO: Implement follow API call
                          debugPrint('Follow pressed for user ${post.user.id}');
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

String _timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays >= 1) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}
