import 'package:flutter/material.dart';

class FeaturedPostCard extends StatelessWidget {
  const FeaturedPostCard({
    super.key,
    required this.authorName,
    required this.timeAgo,
    required this.authorAvatarUrl,
    required this.bannerImageUrl,
    required this.description,
    this.onMorePressed,
    this.onPlayPressed,
  });

  final String authorName;
  final String timeAgo;
  final String authorAvatarUrl;
  final String bannerImageUrl;
  final String description;
  final VoidCallback? onMorePressed;
  final VoidCallback? onPlayPressed;

  @override
  Widget build(BuildContext context) {
    final dividerColor = Colors.white.withOpacity(0.08);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage:
                        authorAvatarUrl.trim().isNotEmpty
                            ? NetworkImage(authorAvatarUrl)
                            : null,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    child: authorAvatarUrl.trim().isEmpty
                        ? Text(
                            authorName.isNotEmpty
                                ? authorName.trim()[0].toUpperCase()
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
                          authorName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          timeAgo,
                          style: const TextStyle(
                            color: Color(0xFFB5B5B5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onMorePressed,
                    icon: const Icon(Icons.more_horiz, color: Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: bannerImageUrl.trim().isNotEmpty
                          ? Image.network(
                              bannerImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) =>
                                  _buildFallbackBanner(authorName),
                            )
                          : _buildFallbackBanner(authorName),
                    ),
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
                    GestureDetector(
                      onTap: onPlayPressed,
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
              ),
              const SizedBox(height: 24),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFFC6C6C6),
                  fontSize: 15,
                  height: 1.6,
                ),
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

  Widget _buildFallbackBanner(String title) {
    return Container(
      color: Colors.white.withOpacity(0.05),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.image_not_supported_outlined,
            color: Colors.white54,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            title.isNotEmpty ? title : 'No preview available',
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
