import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interview/features/add video/widgets/add_video_header.dart';
import 'package:interview/features/add video/widgets/category_chip.dart';
import 'package:interview/features/add video/widgets/media_upload_card.dart';

class AddFeedsScreen extends StatelessWidget {
  const AddFeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddVideoHeader(
                onBack: () => context.pop(),
                onShare: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share action coming soon'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              const MediaUploadCard(
                icon: Icons.video_call_rounded,
                label: 'Select a video from Gallery',
                height: 180,
              ),

              const SizedBox(height: 24),

              const MediaUploadCard(
                icon: Icons.image_outlined,
                label: 'Add a Thumbnail',
                height: 130,
              ),

              const SizedBox(height: 28),

              const Text(
                "Add Description",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Lorem ipsum dolor sit amet consectetur. Congue nec lectus eget fringilla urna viverra integer justo vitae. "
                "Tincidunt cum pellentesque ipsum mi. Posuere at diam lorem est pharetra. Ac suspendisse lorem vel vestibulum non volutpat faucibus",
                style: TextStyle(color: Colors.white54, height: 1.5),
              ),

              const SizedBox(height: 18),
              Container(height: 1, color: Colors.white10),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Categories This Project",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: const [
                      Text(
                        "View All",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white54,
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  CategoryChip(label: 'Physics'),
                  CategoryChip(label: 'Artificial Intelligence'),
                  CategoryChip(label: 'Mathematics'),
                  CategoryChip(label: 'Chemistry'),
                  CategoryChip(label: 'Micro Biology'),
                  CategoryChip(label: 'Lorem ipsum dolor sit gre'),
                ],
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
