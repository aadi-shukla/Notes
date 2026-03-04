import 'package:flutter/material.dart';
import 'package:notes/app/helper/app_helper.dart';
import 'package:notes/app/themes/app_theme.dart';
import 'package:notes/app/widgets/glass_container.dart';
import 'package:notes/network/model/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onPinTap;
  final bool showCategory;

  const NoteCard({
    Key? key,
    required this.note,
    required this.onTap,
    this.onLongPress,
    this.onPinTap,
    this.showCategory = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColorOpacity = isDark ? 0.15 : 0.25;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        width: double.infinity,
        height: 150,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _hexToColor(note.color ?? '#FFE4B5')
                  .withOpacity(cardColorOpacity),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            note.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          if (showCategory && note.category != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                note.category!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onPinTap,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          note.isPinned
                              ? Icons.push_pin
                              : Icons.push_pin_outlined,
                          size: 20,
                          color: note.isPinned
                              ? (isDark
                                  ? AppTheme.darkPrimary
                                  : AppTheme.lightPrimary)
                              : (isDark
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.lightTextSecondary),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        AppHelper.formatDateTime(note.updatedAt),
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (note.isMarkdown) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (isDark
                                  ? AppTheme.darkPrimary
                                  : AppTheme.lightPrimary)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'MD',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _hexToColor(String hexString) {
    hexString = hexString.replaceAll('#', '');
    if (hexString.length == 6) {
      return Color(int.parse('FF$hexString', radix: 16));
    }
    return Colors.grey;
  }
}
