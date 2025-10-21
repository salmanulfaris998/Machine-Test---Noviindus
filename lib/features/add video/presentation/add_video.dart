import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:go_router/go_router.dart';

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
              // === AppBar Row ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Add Feeds",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Color(0xFFB32A26), width: 1),
                    ),
                    child: const Text(
                      "Share Post",
                      style: TextStyle(
                        color: Color(0xFFB32A26),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // === Upload Video Section ===
              DottedBorder(
                color: Colors.white24,
                strokeWidth: 1,
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: const [6, 6],
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_call_rounded,
                        size: 60,
                        color: Colors.white60,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Select a video from Gallery",
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // === Add Thumbnail ===
              DottedBorder(
                color: Colors.white24,
                strokeWidth: 1,
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: const [6, 6],
                child: Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 50,
                        color: Colors.white60,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Add a Thumbnail",
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // === Description ===
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

              // === Categories Header ===
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

              // === Chips ===
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _CategoryChip(label: 'Physics'),
                  _CategoryChip(label: 'Artificial Intelligence'),
                  _CategoryChip(label: 'Mathematics'),
                  _CategoryChip(label: 'Chemistry'),
                  _CategoryChip(label: 'Micro Biology'),
                  _CategoryChip(label: 'Lorem ipsum dolor sit gre'),
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

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFB32A26), width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
