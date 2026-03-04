import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/app/constants/app_constants.dart';
import 'package:notes/app/widgets/empty_state.dart';
import 'package:notes/app/widgets/glass_container.dart';
import 'package:notes/app/widgets/note_card.dart';
import 'package:notes/controllers/alarm_controller.dart';
import 'package:notes/controllers/categories_controller.dart';
import 'package:notes/controllers/notes_controller.dart';
import 'package:notes/controllers/search_controller.dart' as search;
import 'package:notes/controllers/theme_controller.dart';
import 'package:notes/pages/note_editor/note_editor_page.dart';
import 'package:notes/pages/note_detail/note_detail_page.dart';
import 'package:notes/pages/search/search_page.dart';
import 'package:notes/pages/settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final notesController = Get.find<NotesController>();
  final categoriesController = Get.find<CategoriesController>();
  final searchController = Get.find<search.NoteSearchController>();
  final alarmController = Get.find<AlarmController>();
  final themeController = Get.find<ThemeController>();

  final searchInputController = TextEditingController();

  @override
  void dispose() {
    searchInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Get.to(() => const SettingsPage());
              },
              child: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async => notesController.loadAllNotes(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SearchPage());
                    },
                    child: GlassContainer(
                      width: double.infinity,
                      height: 56,
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                size: 24,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withOpacity(0.6),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Search notes...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color
                                            ?.withOpacity(0.6),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),

                  // Quick Stats
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStatCard(
                          context,
                          Icons.note,
                          '${notesController.getTotalNotes()}',
                          'Notes',
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          context,
                          Icons.tag,
                          '${categoriesController.getTotalCategories()}',
                          'Categories',
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          context,
                          Icons.notifications,
                          '${alarmController.getActiveAlarmCount()}',
                          'Alarms',
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          context,
                          Icons.pin,
                          '${notesController.pinnedNotes.length}',
                          'Pinned',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),

                  // Pinned Notes Section
                  if (notesController.pinnedNotes.isNotEmpty) ...[
                    Text(
                      'Pinned Notes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ...notesController.pinnedNotes.map(
                      (note) => NoteCard(
                        note: note,
                        onTap: () {
                          Get.to(
                            () => NoteDetailPage(note: note),
                            transition: Transition.fadeIn,
                          );
                        },
                        onPinTap: () => notesController.togglePin(note),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                  ],

                  // All Notes Section
                  Text(
                    'All Notes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  if (notesController.notes.isEmpty)
                    EmptyState(
                      icon: Icons.note_outlined,
                      title: 'No notes yet',
                      message: AppConstants.emptyNotesMessage,
                      actionLabel: 'Create Note',
                      onActionPressed: () {
                        Get.to(() => const NoteEditorPage());
                      },
                    )
                  else
                    ...notesController.notes.map(
                      (note) => NoteCard(
                        note: note,
                        onTap: () {
                          Get.to(
                            () => NoteDetailPage(note: note),
                            transition: Transition.fadeIn,
                          );
                        },
                        onLongPress: () {
                          _showNoteOptions(context, note);
                        },
                        onPinTap: () => notesController.togglePin(note),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const NoteEditorPage());
        },
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GlassContainer(
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showNoteOptions(BuildContext context, note) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Get.back();
                Get.to(() => NoteEditorPage(note: note));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Get.back();
                _showDeleteConfirmation(context, note);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Get.back();
                // Implement share functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, note) {
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
              notesController.deleteNote(note.id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
