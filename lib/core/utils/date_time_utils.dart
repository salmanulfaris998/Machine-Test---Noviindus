import 'package:interview/core/constants/app_strings.dart';

class DateTimeUtils {
  /// Converts a DateTime to a relative time string (e.g., "5 minutes ago")
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? AppStrings.yearAgo : AppStrings.yearsAgo}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? AppStrings.monthAgo : AppStrings.monthsAgo}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? AppStrings.dayAgo : AppStrings.daysAgo}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? AppStrings.hourAgo : AppStrings.hoursAgo}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? AppStrings.minuteAgo : AppStrings.minutesAgo}';
    } else {
      return AppStrings.justNow;
    }
  }

  /// Formats duration in MM:SS format
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// Formats duration in HH:MM:SS format
  static String formatDurationWithHours(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
