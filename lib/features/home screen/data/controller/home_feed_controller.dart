import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview/features/home screen/data/model/home_feed_model.dart';
import 'package:interview/features/home screen/data/service/home_feed_service.dart';

final homeFeedServiceProvider = Provider<HomeFeedService>((ref) {
  return HomeFeedService();
});

final homeFeedControllerProvider =
    StateNotifierProvider<HomeFeedController, AsyncValue<HomeFeedResponse>>(
  (ref) => HomeFeedController(ref.read(homeFeedServiceProvider)),
);

class HomeFeedController extends StateNotifier<AsyncValue<HomeFeedResponse>> {
  HomeFeedController(this._service)
      : super(const AsyncValue<HomeFeedResponse>.loading()) {
    fetchHomeFeed();
  }

  final HomeFeedService _service;

  Future<void> fetchHomeFeed() async {
    state = const AsyncValue.loading();
    try {
      final response = await _service.fetchHomeFeed();
      state = AsyncValue.data(response);
    } on HomeFeedException catch (e, stack) {
      state = AsyncValue.error(e, stack);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
