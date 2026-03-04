import 'package:flutter/material.dart';
import 'package:notes/app/widgets/glass_container.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final Color? bgColor;

  const SearchBar({
    Key? key,
    required this.controller,
    this.hintText = 'Search notes...',
    required this.onChanged,
    this.onClear,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onChanged,
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                onClear?.call();
              },
              child: const Icon(Icons.close),
            ),
        ],
      ),
    );
  }
}
