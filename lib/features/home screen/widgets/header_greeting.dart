import 'package:flutter/material.dart';

class HeaderGreeting extends StatelessWidget {
  const HeaderGreeting({
    super.key,
    required this.title,
    required this.subtitle,
    required this.avatarUrl,
  });

  final String title;
  final String subtitle;
  final String avatarUrl;

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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFB0B0B0),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(avatarUrl),
        ),
      ],
    );
  }
}
