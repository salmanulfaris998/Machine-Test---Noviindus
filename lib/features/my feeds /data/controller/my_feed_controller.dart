import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview/features/my%20feeds%20/data/models/my_feed_model.dart';
import 'package:interview/features/my%20feeds%20/data/service/my_feed_service.dart';
import 'package:interview/shared/storage_service.dart';

final myFeedServiceProvider = Provider<MyFeedService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return MyFeedService(storageService);
});

final myFeedControllerProvider =
    StateNotifierProvider<MyFeedController, AsyncValue<MyFeedState>>((ref) {
  final service = ref.watch(myFeedServiceProvider);
  return MyFeedController(service);
});

class MyFeedState {
  final List<MyFeedItem> feeds;
  final bool hasMore;
  final int currentPage;
  final bool isLoadingMore;

  const MyFeedState({
    required this.feeds,
    required this.hasMore,
    required this.currentPage,
    this.isLoadingMore = false,
  });

  MyFeedState copyWith({
    List<MyFeedItem>? feeds,
    bool? hasMore,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return MyFeedState(
      feeds: feeds ?? this.feeds,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class MyFeedController extends StateNotifier<AsyncValue<MyFeedState>> {
  MyFeedController(this._service)
      : super(const AsyncValue<MyFeedState>.loading()) {
    loadFeeds();
  }

  final MyFeedService _service;

  Future<void> loadFeeds({bool refresh = false}) async {
    if (refresh) {
      state = const AsyncValue.loading();
    }

    try {
      final response = await _service.fetchMyFeeds(page: 1);
      state = AsyncValue.data(
        MyFeedState(
          feeds: response.results,
          hasMore: response.next != null,
          currentPage: 1,
        ),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMoreFeeds() async {
    final currentState = state.value;
    if (currentState == null || currentState.isLoadingMore || !currentState.hasMore) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.currentPage + 1;
      final response = await _service.fetchMyFeeds(page: nextPage);
      
      state = AsyncValue.data(
        MyFeedState(
          feeds: [...currentState.feeds, ...response.results],
          hasMore: response.next != null,
          currentPage: nextPage,
          isLoadingMore: false,
        ),
      );
    } catch (e, stack) {
      state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
      // Optionally handle error
    }
  }
}
