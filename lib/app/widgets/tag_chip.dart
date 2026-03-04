import 'package:flutter/material.dart';
import 'package:notes/app/widgets/glass_container.dart';

class TagChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Color? backgroundColor;
  final bool isSelected;

  const TagChip({
    Key? key,
    required this.label,
    this.onTap,
    this.onDelete,
    this.backgroundColor,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: double.infinity,
      height: 32,
      padding: EdgeInsets.only(
        left: 12,
        right: onDelete != null ? 4 : 12,
        top: 4,
        bottom: 4,
      ),
      margin: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          if (onDelete != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDelete,
              child: const Icon(Icons.close, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}
