import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:interview/features/home%20screen/widgets/category_chip.dart';
import 'package:interview/features/home%20screen/widgets/featured_post_card.dart';
import 'package:interview/features/home%20screen/widgets/header_greeting.dart';
import 'package:interview/shared/storage_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 76,
        height: 76,
        child: FloatingActionButton(
          onPressed: () {
            context.push('/add-feed');
          },
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
              // Header Greeting with padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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

              // Category Chips
              SizedBox(
                height: 48,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    CategoryChip(label: 'Explore', isActive: true),
                    CategoryChip(label: 'Trending'),
                    CategoryChip(label: 'All Categories'),
                    CategoryChip(label: 'Physics'),
                    CategoryChip(label: 'Chemistry'),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Featured Post Card full width (no gray borders)
              const FeaturedPostCard(
                authorName: 'Anagha Krishna',
                timeAgo: '5 days ago',
                authorAvatarUrl:
                    'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=200&q=80',
                bannerImageUrl:
                    'https://images.unsplash.com/photo-1523580846011-d3a5bc25702b?auto=format&fit=crop&w=900&q=80',
                description:
                    'Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucibus facilisis tellus. At vitae dis commodo sollicitudin elementum suspendisse...',
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
