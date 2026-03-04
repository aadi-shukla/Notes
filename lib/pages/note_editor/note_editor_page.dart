import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/app/constants/app_constants.dart';
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
            Container(
              width: double.infinity,
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.15)
                      : Colors.black.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: TextField(
                  controller: titleController,
                  textAlignVertical: TextAlignVertical.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  decoration: InputDecoration(
                    hintText: 'Note Title',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintStyle:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.grey.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Markdown Toggle and Color Picker
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.15)
                            : Colors.black.withOpacity(0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isMarkdown = !isMarkdown;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Transform.scale(
                                scale: 1.1,
                                child: Checkbox(
                                  value: isMarkdown,
                                  onChanged: (value) {
                                    setState(() {
                                      isMarkdown = value ?? false;
                                    });
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Markdown',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.15)
                            : Colors.black.withOpacity(0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showColorPicker,
                        borderRadius: BorderRadius.circular(20),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color:
                                      _hexToColor(selectedColor ?? '#FFE4B5'),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color
                                            ?.withOpacity(0.3) ??
                                        Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Color',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Category Selection
            Text('Category',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 8),
            Obx(
              () => Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.15)
                        : Colors.black.withOpacity(0.1),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButton<String?>(
                      value: selectedCategory,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      icon: const Icon(Icons.arrow_drop_down),
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
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Tags
            Text('Tags',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.15)
                      : Colors.black.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: tagInputController,
                          decoration: InputDecoration(
                            hintText: 'Add tag and press space',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
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
                              if (tag.isNotEmpty &&
                                  !selectedTags.contains(tag)) {
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
            Text('Content',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.15)
                      : Colors.black.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: contentController,
                maxLines: null,
                minLines: 15,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
                decoration: InputDecoration(
                  hintText: 'Start typing...',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.withOpacity(0.5),
                        height: 1.5,
                      ),
                ),
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
        title: const Text('Choose Note Color'),
        contentPadding: const EdgeInsets.all(20),
        content: SizedBox(
          width: double.maxFinite,
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
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
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _hexToColor(color),
                        borderRadius: BorderRadius.circular(12),
                        border: selectedColor == color
                            ? Border.all(
                                width: 4,
                                color: Theme.of(context).primaryColor,
                              )
                            : Border.all(
                                width: 1,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                        boxShadow: selectedColor == color
                            ? [
                                BoxShadow(
                                  color: _hexToColor(color).withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: selectedColor == color
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 32,
                            )
                          : null,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
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
