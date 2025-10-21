import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:interview/features/home%20screen/presentation/providers/video_feed_manager.dart';

class VideoFeedItem extends ConsumerStatefulWidget {
  const VideoFeedItem({
    super.key,
    required this.feedId,
    required this.authorName,
    required this.timeAgo,
    required this.authorAvatarUrl,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.description,
    required this.likeCount,
    required this.isFollowing,
    this.onMorePressed,
    this.onLikePressed,
    this.onFollowPressed,
  });

  final int feedId;
  final String authorName;
  final String timeAgo;
  final String authorAvatarUrl;
  final String thumbnailUrl;
  final String videoUrl;
  final String description;
  final int likeCount;
  final bool isFollowing;
  final VoidCallback? onMorePressed;
  final VoidCallback? onLikePressed;
  final VoidCallback? onFollowPressed;

  @override
  ConsumerState<VideoFeedItem> createState() => _VideoFeedItemState();
}

class _VideoFeedItemState extends ConsumerState<VideoFeedItem> {
  bool _showControls = true;
  late bool _isLiked;
  late int _likeCount;
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    _likeCount = widget.likeCount;
    _isFollowing = widget.isFollowing;
  }

  @override
  void dispose() {
    // Dispose controller when widget is removed
    ref.read(videoFeedManagerProvider).disposeController(widget.feedId);
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dividerColor = Colors.white.withOpacity(0.08);
    final manager = ref.watch(videoFeedManagerProvider);
    final controller = manager.controllerFor(widget.feedId);
    final isCurrentlyPlaying = manager.currentFeedId == widget.feedId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author header
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: widget.authorAvatarUrl.trim().isNotEmpty
                        ? NetworkImage(widget.authorAvatarUrl)
                        : null,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    child: widget.authorAvatarUrl.trim().isEmpty
                        ? Text(
                            widget.authorName.isNotEmpty
                                ? widget.authorName.trim()[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.authorName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.timeAgo,
                          style: const TextStyle(
                            color: Color(0xFFB5B5B5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onMorePressed,
                    icon: const Icon(Icons.more_horiz, color: Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Video player or thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: controller != null && controller.value.isInitialized
                    ? _buildVideoPlayer(controller, isCurrentlyPlaying)
                    : _buildThumbnail(),
              ),

              const SizedBox(height: 24),

              // Description
              Text(
                widget.description,
                style: const TextStyle(
                  color: Color(0xFFC6C6C6),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              // Action buttons (Like and Follow)
              Row(
                children: [
                  // Like button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLiked = !_isLiked;
                        _likeCount += _isLiked ? 1 : -1;
                      });
                      widget.onLikePressed?.call();
                    },
                    child: Row(
                      children: [
                        Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? const Color(0xFFE4090E) : Colors.white70,
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _likeCount.toString(),
                          style: TextStyle(
                            color: _isLiked ? const Color(0xFFE4090E) : Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Follow button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFollowing = !_isFollowing;
                      });
                      widget.onFollowPressed?.call();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _isFollowing
                            ? Colors.white.withOpacity(0.1)
                            : const Color(0xFFE4090E),
                        borderRadius: BorderRadius.circular(20),
                        border: _isFollowing
                            ? Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              )
                            : null,
                      ),
                      child: Text(
                        _isFollowing ? 'Following' : 'Follow',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        Divider(
          color: dividerColor,
          thickness: 1,
          height: 32,
        ),
      ],
    );
  }

  Widget _buildThumbnail() {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Thumbnail image
          Positioned.fill(
            child: widget.thumbnailUrl.trim().isNotEmpty
                ? Image.network(
                    widget.thumbnailUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.white.withOpacity(0.05),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: const Color(0xFFE4090E),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stack) =>
                        _buildFallbackThumbnail(),
                  )
                : _buildFallbackThumbnail(),
          ),

          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.transparent,
                    Colors.black.withOpacity(0.35),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // Play button
          GestureDetector(
            onTap: () {
              if (widget.videoUrl.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Video unavailable for this post'),
                    backgroundColor: Color(0xFFE4090E),
                  ),
                );
                return;
              }
              ref
                  .read(videoFeedManagerProvider)
                  .play(widget.feedId, widget.videoUrl);
            },
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.18),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                size: 42,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(
      VideoPlayerController controller, bool isCurrentlyPlaying) {
    final aspectRatio = controller.value.aspectRatio > 0
        ? controller.value.aspectRatio
        : 16 / 10;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video player
          VideoPlayer(controller),

          // Controls overlay
          GestureDetector(
            onTap: _toggleControls,
            child: AnimatedOpacity(
              opacity: _showControls || !controller.value.isPlaying ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Stack(
                  children: [
                    // Center play/pause button
                    if (!controller.value.isPlaying)
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            ref
                                .read(videoFeedManagerProvider)
                                .togglePlay(widget.feedId, widget.videoUrl);
                          },
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.18),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.6),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    // Bottom controls
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _VideoControls(
                        controller: controller,
                        feedId: widget.feedId,
                        videoUrl: widget.videoUrl,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackThumbnail() {
    return Container(
      color: Colors.white.withOpacity(0.05),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.videocam_outlined,
            color: Colors.white54,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            widget.authorName.isNotEmpty
                ? widget.authorName
                : 'No preview available',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VideoControls extends ConsumerStatefulWidget {
  const _VideoControls({
    required this.controller,
    required this.feedId,
    required this.videoUrl,
  });

  final VideoPlayerController controller;
  final int feedId;
  final String videoUrl;

  @override
  ConsumerState<_VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends ConsumerState<_VideoControls> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        final position = value.position;
        final duration = value.duration;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar
              VideoProgressIndicator(
                widget.controller,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(vertical: 4),
                colors: VideoProgressColors(
                  playedColor: const Color(0xFFE4090E),
                  bufferedColor: Colors.white.withOpacity(0.3),
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ),

              // Controls row
              Row(
                children: [
                  // Play/Pause button
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      ref
                          .read(videoFeedManagerProvider)
                          .togglePlay(widget.feedId, widget.videoUrl);
                    },
                    icon: Icon(
                      value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Time display
                  Text(
                    '${_formatDuration(position)} / ${_formatDuration(duration)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  // Fullscreen button
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => _FullscreenVideoPlayer(
                            controller: widget.controller,
                            feedId: widget.feedId,
                            videoUrl: widget.videoUrl,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _FullscreenVideoPlayer extends ConsumerWidget {
  const _FullscreenVideoPlayer({
    required this.controller,
    required this.feedId,
    required this.videoUrl,
  });

  final VideoPlayerController controller;
  final int feedId;
  final String videoUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio > 0
                    ? controller.value.aspectRatio
                    : 16 / 9,
                child: VideoPlayer(controller),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _VideoControls(
                controller: controller,
                feedId: feedId,
                videoUrl: videoUrl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
