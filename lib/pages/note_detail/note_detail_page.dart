import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:notes/app/constants/app_constants.dart';
import 'package:notes/app/helper/app_helper.dart';
import 'package:notes/app/widgets/glass_container.dart';
import 'package:notes/app/widgets/tag_chip.dart';
import 'package:notes/controllers/alarm_controller.dart';
import 'package:notes/controllers/notes_controller.dart';
import 'package:notes/network/model/note_model.dart';
import 'package:notes/pages/note_editor/note_editor_page.dart';

class NoteDetailPage extends StatefulWidget {
  final Note note;

  const NoteDetailPage({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final notesController = Get.find<NotesController>();
  final alarmController = Get.find<AlarmController>();
  late Note currentNote;
  bool showMarkdown = false;

  @override
  void initState() {
    super.initState();
    currentNote = widget.note;
    showMarkdown = currentNote.isMarkdown;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentNote.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Edit'),
                  onTap: () {
                    Get.to(() => NoteEditorPage(note: currentNote))?.then((_) {
                      // Reload the note
                      final updatedNote =
                          notesController.notes.firstWhereOrNull(
                        (n) => n.id == currentNote.id,
                      );
                      if (updatedNote != null) {
                        setState(() {
                          currentNote = updatedNote;
                        });
                      }
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text('Delete'),
                  onTap: () {
                    _showDeleteConfirmation();
                  },
                ),
                PopupMenuItem(
                  child: const Text('Share'),
                  onTap: () {
                    _shareNote();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metadata
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Created: ${AppHelper.formatDate(currentNote.createdAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Modified: ${AppHelper.formatDateTime(currentNote.updatedAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${AppHelper.getWordCount(currentNote.content)} words',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${AppHelper.getCharacterCount(currentNote.content)} chars',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Category & Tags
            if (currentNote.category != null ||
                currentNote.tags.isNotEmpty) ...[
              if (currentNote.category != null)
                GlassContainer(
                  width: double.infinity,
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(currentNote.category ?? ''),
                ),
              if (currentNote.tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: currentNote.tags
                      .map((tag) => TagChip(label: tag))
                      .toList(),
                ),
              const SizedBox(height: AppConstants.paddingLarge),
            ],

            // Action Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                GlassContainer(
                  width: double.infinity,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  onTap: () {
                    setState(() {
                      showMarkdown = !showMarkdown;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        showMarkdown ? Icons.visibility : Icons.code,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        showMarkdown ? 'View' : 'Code',
                      ),
                    ],
                  ),
                ),
                GlassContainer(
                  width: null,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  onTap: () {
                    notesController.togglePin(currentNote);
                    setState(() {
                      currentNote = currentNote.copyWith(
                        isPinned: !currentNote.isPinned,
                      );
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        currentNote.isPinned
                            ? Icons.push_pin
                            : Icons.push_pin_outlined,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentNote.isPinned ? 'Unpin' : 'Pin',
                      ),
                    ],
                  ),
                ),
                GlassContainer(
                  width: null,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  onTap: _showSetAlarmDialog,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule),
                      const SizedBox(width: 8),
                      Text(
                        'Alarm',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Content
            if (currentNote.isMarkdown && showMarkdown)
              MarkdownBody(data: currentNote.content)
            else
              SelectableText(
                currentNote.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notesController.deleteNote(currentNote.id);
              Get.back();
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _shareNote() {
    // Implement share functionality
    Get.snackbar('Share', 'Sharing feature coming soon!');
  }

  void _showSetAlarmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Set Time'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  final now = DateTime.now();
                  final alarmTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    time.hour,
                    time.minute,
                  );

                  if (alarmTime.isBefore(now)) {
                    alarmTime.add(const Duration(days: 1));
                  }

                  alarmController.createAlarm(
                    noteId: currentNote.id,
                    alarmTime: alarmTime,
                  );
                  Get.back();
                }
              },
            ),
          ],
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
}
