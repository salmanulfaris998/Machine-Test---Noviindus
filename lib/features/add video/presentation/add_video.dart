import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:interview/features/add%20video/data/controller/add_feed_controller.dart';
import 'package:interview/features/add%20video/data/models/add_feed_request.dart';
import 'package:interview/features/add video/widgets/add_video_header.dart';
import 'package:interview/features/add video/widgets/media_upload_card.dart';
import 'package:interview/features/home%20screen/data/controller/category_controller.dart';

class AddFeedsScreen extends ConsumerStatefulWidget {
  const AddFeedsScreen({super.key});

  @override
  ConsumerState<AddFeedsScreen> createState() => _AddFeedsScreenState();
}

class _AddFeedsScreenState extends ConsumerState<AddFeedsScreen> {
  File? _videoFile;
  File? _thumbnailFile;
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploading = false;
  int? _selectedCategoryId;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _videoFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking video: $e')),
        );
      }
    }
  }

  Future<void> _pickThumbnail() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _thumbnailFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking thumbnail: $e')),
        );
      }
    }
  }

  Future<void> _uploadFeed() async {
    if (_videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a video')),
      );
      return;
    }

    if (_thumbnailFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a thumbnail')),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a description')),
      );
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final request = AddFeedRequest(
      video: _videoFile!,
      thumbnail: _thumbnailFile!,
      description: _descriptionController.text.trim(),
      categoryId: _selectedCategoryId!.toString(),
    );

    try {
      await ref.read(addFeedControllerProvider.notifier).uploadFeed(request);

      if (!mounted) return;

      final state = ref.read(addFeedControllerProvider);
      
      state.when(
        data: (response) {
          if (response != null && response.status) {
            // Navigate first, then show snackbar on the previous screen
            Navigator.of(context).pop();
            // Show snackbar after navigation
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response.message.isNotEmpty
                      ? response.message
                      : 'Feed uploaded successfully!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response?.message ?? 'Upload failed'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        loading: () {},
        error: (error, _) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

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
                onShare: _isUploading
                    ? () {}
                    : () {
                        _uploadFeed();
                      },
              ),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: _isUploading ? null : _pickVideo,
                child: MediaUploadCard(
                  icon: Icons.video_call_rounded,
                  label: _videoFile != null
                      ? 'Video selected: ${_videoFile!.path.split('/').last}'
                      : 'Select a video from Gallery',
                  height: 180,
                ),
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: _isUploading ? null : _pickThumbnail,
                child: _thumbnailFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Image.file(
                              _thumbnailFile!,
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const MediaUploadCard(
                        icon: Icons.image_outlined,
                        label: 'Add a Thumbnail',
                        height: 130,
                      ),
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
              TextField(
                controller: _descriptionController,
                enabled: !_isUploading,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your description here...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE4090E)),
                  ),
                ),
              ),
              if (_isUploading)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFE4090E),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Uploading your feed...',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
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

              ref.watch(categoryControllerProvider).when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFE4090E),
                  ),
                ),
                error: (error, _) => Text(
                  'Failed to load categories',
                  style: TextStyle(color: Colors.red.shade400),
                ),
                data: (categories) => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: categories.map((category) {
                    final isSelected = _selectedCategoryId == category.id;
                    return GestureDetector(
                      onTap: _isUploading
                          ? null
                          : () {
                              setState(() {
                                _selectedCategoryId = category.id;
                              });
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE4090E)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE4090E)
                                : const Color(0xFFE4090E).withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          category.title,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
