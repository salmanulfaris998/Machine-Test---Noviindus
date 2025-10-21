import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

final videoFeedManagerProvider =
    ChangeNotifierProvider.autoDispose<VideoFeedManager>((ref) {
  final manager = VideoFeedManager();
  ref.onDispose(manager.dispose);
  return manager;
});

class VideoFeedManager extends ChangeNotifier {
  final Map<int, VideoPlayerController> _controllers = {};
  final Map<int, Future<void>> _initializations = {};
  int? _currentFeedId;

  int? get currentFeedId => _currentFeedId;

  VideoPlayerController? controllerFor(int feedId) => _controllers[feedId];

  Future<void>? initializationFor(int feedId) => _initializations[feedId];

  Future<void> ensureInitialized(int feedId, String videoUrl) {
    final trimmedUrl = videoUrl.trim();
    if (trimmedUrl.isEmpty) {
      return Future.value();
    }

    final existing = _initializations[feedId];
    if (existing != null) {
      return existing;
    }

    final controller =
        VideoPlayerController.networkUrl(Uri.parse(trimmedUrl));
    _controllers[feedId] = controller;

    final initialization = controller.initialize().then((_) {
      controller.setLooping(false);
    });

    _initializations[feedId] = initialization;
    _attachCompletionListener(feedId, controller);
    return initialization;
  }

  Future<void> play(int feedId, String videoUrl) async {
    final trimmedUrl = videoUrl.trim();
    if (trimmedUrl.isEmpty) {
      return;
    }

    final previousId = _currentFeedId;
    if (previousId != null && previousId != feedId) {
      final previousController = _controllers[previousId];
      if (previousController != null) {
        await previousController.pause();
        await previousController.seekTo(Duration.zero);
      }
    }

    await ensureInitialized(feedId, trimmedUrl);

    final controller = _controllers[feedId];
    if (controller == null) {
      return;
    }

    await controller.play();
    _currentFeedId = feedId;
    notifyListeners();
  }

  Future<void> pause(int feedId) async {
    final controller = _controllers[feedId];
    if (controller == null) {
      return;
    }

    await controller.pause();
    notifyListeners();
  }

  Future<void> togglePlay(int feedId, String videoUrl) async {
    final controller = _controllers[feedId];
    if (controller != null && controller.value.isInitialized) {
      if (controller.value.isPlaying) {
        await controller.pause();
        notifyListeners();
        return;
      }
    }

    await play(feedId, videoUrl);
  }

  Future<void> seek(int feedId, Duration position) async {
    final controller = _controllers[feedId];
    if (controller == null) {
      return;
    }

    await controller.seekTo(position);
  }

  Future<void> disposeController(int feedId) async {
    final controller = _controllers.remove(feedId);
    _initializations.remove(feedId);
    await controller?.dispose();
    if (_currentFeedId == feedId) {
      _currentFeedId = null;
      notifyListeners();
    }
  }

  void stopAll() {
    for (final controller in _controllers.values) {
      controller.pause();
      controller.seekTo(Duration.zero);
    }
    _currentFeedId = null;
    notifyListeners();
  }

  void _attachCompletionListener(int feedId, VideoPlayerController controller) {
    controller.addListener(() {
      final value = controller.value;
      if (!value.isInitialized) {
        return;
      }

      if (!value.isPlaying &&
          value.position >= value.duration &&
          value.duration != Duration.zero) {
        controller.seekTo(Duration.zero);
        if (_currentFeedId == feedId) {
          _currentFeedId = null;
          notifyListeners();
        }
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _initializations.clear();
    _currentFeedId = null;
    super.dispose();
  }
}
