import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview/features/add%20video/data/models/add_feed_request.dart';
import 'package:interview/features/add%20video/data/service/add_feed_service.dart';
import 'package:interview/shared/storage_service.dart';

final addFeedServiceProvider = Provider<AddFeedService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return AddFeedService(storageService);
});

final addFeedControllerProvider =
    StateNotifierProvider<AddFeedController, AsyncValue<AddFeedResponse?>>((ref) {
  final service = ref.watch(addFeedServiceProvider);
  return AddFeedController(service);
});

class AddFeedController extends StateNotifier<AsyncValue<AddFeedResponse?>> {
  final AddFeedService _service;

  AddFeedController(this._service) : super(const AsyncValue.data(null));

  Future<void> uploadFeed(AddFeedRequest request) async {
    state = const AsyncValue.loading();
    try {
      final response = await _service.addFeed(request);
      state = AsyncValue.data(response);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
