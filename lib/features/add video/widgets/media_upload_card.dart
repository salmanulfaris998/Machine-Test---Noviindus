import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class MediaUploadCard extends StatelessWidget {
  const MediaUploadCard({
    super.key,
    required this.icon,
    required this.label,
    required this.height,
  });

  final IconData icon;
  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.white24,
      strokeWidth: 1,
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      dashPattern: const [6, 6],
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: height * 0.33,
              color: Colors.white60,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
