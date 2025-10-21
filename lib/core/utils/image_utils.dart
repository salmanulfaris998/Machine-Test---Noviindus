class ImageUtils {
  /// Generates a fallback avatar URL using ui-avatars.com
  static String getFallbackAvatar(String name, {
    int size = 200,
    String background = 'E4090E',
    String color = 'FFFFFF',
  }) {
    final encodedName = Uri.encodeComponent(name);
    return 'https://ui-avatars.com/api/?name=$encodedName&size=$size&background=$background&color=$color';
  }

  /// Generates a fallback image URL
  static String getFallbackImage(String text, {
    int size = 512,
    String background = '1F1F1F',
    String color = 'FFFFFF',
  }) {
    final encodedText = Uri.encodeComponent(text);
    return 'https://ui-avatars.com/api/?name=$encodedText&size=$size&background=$background&color=$color';
  }

  /// Checks if URL is a valid image URL
  static bool isValidImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    
    final lowerUrl = url.toLowerCase();
    return lowerUrl.endsWith('.jpg') ||
        lowerUrl.endsWith('.jpeg') ||
        lowerUrl.endsWith('.png') ||
        lowerUrl.endsWith('.gif') ||
        lowerUrl.endsWith('.webp') ||
        lowerUrl.contains('image');
  }

  /// Checks if URL is a valid video URL
  static bool isValidVideoUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    
    final lowerUrl = url.toLowerCase();
    return lowerUrl.endsWith('.mp4') ||
        lowerUrl.endsWith('.mov') ||
        lowerUrl.endsWith('.avi') ||
        lowerUrl.endsWith('.mkv') ||
        lowerUrl.contains('video');
  }
}
