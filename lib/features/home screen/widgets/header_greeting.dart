import 'package:flutter/material.dart';
import 'package:interview/core/constants/app_colors.dart';
import 'package:interview/core/constants/app_sizes.dart';

class HeaderGreeting extends StatelessWidget {
  const HeaderGreeting({
    super.key,
    required this.title,
    required this.subtitle,
    required this.avatarUrl,
    this.onAvatarTap,
    this.onLogoutTap,
  });

  final String title;
  final String subtitle;
  final String avatarUrl;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppSizes.fontMD,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onAvatarTap,
          child: CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(avatarUrl),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: onLogoutTap,
          icon: Icon(
            Icons.logout,
            color: AppColors.textPrimary,
            size: AppSizes.iconMD,
          ),
          tooltip: 'Logout',
        ),
      ],
    );
  }
}
