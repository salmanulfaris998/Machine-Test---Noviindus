import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:interview/core/constants/app_colors.dart';
import 'package:interview/core/constants/app_sizes.dart';
import 'package:interview/core/constants/app_strings.dart';
import 'package:interview/core/utils/date_time_utils.dart';
import 'package:interview/core/utils/image_utils.dart';
import 'package:interview/features/my%20feeds%20/data/controller/my_feed_controller.dart';
import 'package:interview/features/home%20screen/widgets/video_feed_item.dart';

class MyFeedsScreen extends ConsumerStatefulWidget {
  const MyFeedsScreen({super.key});

  @override
  ConsumerState<MyFeedsScreen> createState() => _MyFeedsScreenState();
}

class _MyFeedsScreenState extends ConsumerState<MyFeedsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(myFeedControllerProvider.notifier).loadMoreFeeds();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(myFeedControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.myFeeds,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppSizes.font2XL,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: AppColors.textPrimary),
            onPressed: () => context.push('/add-feed'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(myFeedControllerProvider.notifier).loadFeeds(refresh: true);
        },
        color: AppColors.primary,
        child: feedState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
          error: (error, stack) => LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: AppSizes.iconXL * 1.3,
                          color: AppColors.white50,
                        ),
                        const SizedBox(height: AppSizes.paddingMD),
                        Text(
                          AppStrings.failedToLoadFeed,
                          style: TextStyle(
                            color: AppColors.white80,
                            fontSize: AppSizes.fontLG,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(myFeedControllerProvider.notifier).loadFeeds(refresh: true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          data: (state) {
            if (state.feeds.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.video_library_outlined,
                              size: AppSizes.iconXL * 1.3,
                              color: AppColors.white30,
                            ),
                            const SizedBox(height: AppSizes.paddingMD),
                            Text(
                              AppStrings.noFeedsYet,
                              style: TextStyle(
                                color: AppColors.white80,
                                fontSize: AppSizes.fontXL,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSizes.paddingSM),
                            Text(
                              AppStrings.startSharingVideos,
                              style: TextStyle(
                                color: AppColors.white50,
                                fontSize: AppSizes.fontMD,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => context.push('/add-feed'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              icon: const Icon(Icons.add),
                              label: Text(AppStrings.addYourFirstFeed),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16),
              separatorBuilder: (context, index) => const SizedBox(height: 0),
              itemCount: state.feeds.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.feeds.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }

                final feed = state.feeds[index];
                final avatarUrl = feed.user.image?.trim();
                final thumbnailUrl = feed.image.trim();
                final videoUrl = feed.video.trim();
                final userName = feed.user.name ?? 'User ${feed.user.id}';
                final fallbackAvatar = ImageUtils.getFallbackAvatar(userName);
                final fallbackThumbnail = ImageUtils.getFallbackImage(feed.description);

                return VideoFeedItem(
                  feedId: feed.id,
                  authorName: userName,
                  timeAgo: feed.createdAt != null
                      ? DateTimeUtils.timeAgo(feed.createdAt!)
                      : AppStrings.justNow,
                  authorAvatarUrl: (avatarUrl != null && avatarUrl.isNotEmpty)
                      ? avatarUrl
                      : fallbackAvatar,
                  thumbnailUrl:
                      thumbnailUrl.isNotEmpty ? thumbnailUrl : fallbackThumbnail,
                  videoUrl: videoUrl,
                  description: feed.description,
                  likeCount: feed.likes.length,
                  isFollowing: feed.follow,
                  onLikePressed: () {
                    // TODO: Implement like API call
                    debugPrint('Like pressed for feed ${feed.id}');
                  },
                  onFollowPressed: () {
                    // TODO: Implement follow API call
                    debugPrint('Follow pressed for user ${feed.user.id}');
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
