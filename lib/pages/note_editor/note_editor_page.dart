import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/app/constants/app_constants.dart';
import 'package:notes/app/widgets/glass_container.dart';
import 'package:notes/app/widgets/tag_chip.dart';
import 'package:notes/controllers/categories_controller.dart';
import 'package:notes/controllers/notes_controller.dart';
import 'package:notes/network/model/note_model.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note;

  const NoteEditorPage({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  final notesController = Get.find<NotesController>();
  final categoriesController = Get.find<CategoriesController>();

  String? selectedCategory;
  List<String> selectedTags = [];
  bool isMarkdown = false;
  String? selectedColor;

  final tagInputController = TextEditingController();
  final List<String> colorOptions = AppConstants.noteColors;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    contentController = TextEditingController(text: widget.note?.content ?? '');

    if (widget.note != null) {
      selectedCategory = widget.note!.category;
      selectedTags = List.from(widget.note!.tags);
      isMarkdown = widget.note!.isMarkdown;
      selectedColor = widget.note!.color;
    } else {
      selectedColor = AppConstants.noteColors.first;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    tagInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit Note' : 'New Note'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: _saveNote,
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Input
            TextField(
              controller: titleController,
              style: Theme.of(context).textTheme.displaySmall,
              decoration: InputDecoration(
                hintText: 'Note Title',
                border: InputBorder.none,
                hintStyle: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(color: Colors.grey),
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),

            // Markdown Toggle
            Wrap(
              spacing: 12,
              children: [
                GlassContainer(
                  width: double.infinity,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isMarkdown,
                        onChanged: (value) {
                          setState(() {
                            isMarkdown = value ?? false;
                          });
                        },
                      ),
                      const Text('Markdown'),
                    ],
                  ),
                ),
                GlassContainer(
                  width: double.infinity,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  onTap: _showColorPicker,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _hexToColor(selectedColor ?? '#FFE4B5'),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Color'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Category Selection
            Text('Category', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Obx(
              () => GlassContainer(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String?>(
                  value: selectedCategory,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('No Category'),
                    ),
                    ...categoriesController.categories.map(
                      (category) => DropdownMenuItem(
                        value: category.name,
                        child: Text(category.name),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Tags
            Text('Tags', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            GlassContainer(
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tagInputController,
                      decoration: InputDecoration(
                        hintText: 'Add tag and press space',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color
                                      ?.withOpacity(0.5),
                                ),
                      ),
                      onChanged: (value) {
                        if (value.endsWith(' ')) {
                          final tag = value.trim();
                          if (tag.isNotEmpty && !selectedTags.contains(tag)) {
                            setState(() {
                              selectedTags.add(tag);
                              tagInputController.clear();
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (selectedTags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: selectedTags
                    .map((tag) => TagChip(
                          label: tag,
                          onDelete: () {
                            setState(() {
                              selectedTags.remove(tag);
                            });
                          },
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: AppConstants.paddingLarge),

            // Content
            TextField(
              controller: contentController,
              maxLines: null,
              minLines: 15,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Start typing...',
                border: InputBorder.none,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    if (titleController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a title');
      return;
    }

    if (widget.note != null) {
      final updatedNote = widget.note!.copyWith(
        title: titleController.text,
        content: contentController.text,
        category: selectedCategory,
        tags: selectedTags,
        isMarkdown: isMarkdown,
        color: selectedColor,
      );
      notesController.updateNote(updatedNote);
    } else {
      notesController.createNote(
        title: titleController.text,
        content: contentController.text,
        category: selectedCategory,
        tags: selectedTags,
        isMarkdown: isMarkdown,
        color: selectedColor,
      );
    }

    Get.back();
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Color'),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colorOptions
              .map(
                (color) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                    Get.back();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _hexToColor(color),
                      borderRadius: BorderRadius.circular(8),
                      border: selectedColor == color
                          ? Border.all(width: 3, color: Colors.black)
                          : null,
                    ),
                  ),
                ),
              )
              .toList(),
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
