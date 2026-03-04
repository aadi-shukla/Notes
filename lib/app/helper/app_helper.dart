import 'package:uuid/uuid.dart';

class AppHelper {
  static const uuid = Uuid();

  static String generateId() {
    return uuid.v4();
  }

  static String formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final noteDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (noteDate == today) {
      return 'Today';
    } else if (noteDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  static String truncateText(String text, {int maxLength = 100}) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  static List<String> extractHashtags(String text) {
    final RegExp hashtagRegExp = RegExp(r'#(\w+)');
    final matches = hashtagRegExp.allMatches(text);
    return matches.map((match) => match.group(1) ?? '').toList();
  }

  static int getWordCount(String text) {
    return text.trim().split(RegExp(r'\s+')).length;
  }

  static int getCharacterCount(String text) {
    return text.length;
  }
}
