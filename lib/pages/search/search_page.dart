import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/app/constants/app_constants.dart';
import 'package:notes/app/widgets/empty_state.dart';
import 'package:notes/app/widgets/note_card.dart';
import 'package:notes/controllers/notes_controller.dart';
import 'package:notes/controllers/search_controller.dart' as search;
import 'package:notes/pages/note_detail/note_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = Get.find<search.NoteSearchController>();
  final notesController = Get.find<NotesController>();
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
        title: const Text('Search Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            TextField(
              controller: searchInputController,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                searchController.search(query);
              },
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Expanded(
              child: Obx(
                () {
                  if (searchController.searchQuery.isEmpty) {
                    return EmptyState(
                      icon: Icons.search,
                      title: 'Start Searching',
                      message: 'Type something to search your notes',
                    );
                  }

                  if (searchController.isSearching.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (searchController.searchResults.isEmpty) {
                    return EmptyState(
                      icon: Icons.inbox,
                      title: 'No Results',
                      message: AppConstants.emptySearchMessage,
                    );
                  }

                  return ListView.builder(
                    itemCount: searchController.searchResults.length,
                    itemBuilder: (context, index) {
                      final note = searchController.searchResults[index];
                      return NoteCard(
                        note: note,
                        onTap: () {
                          Get.to(
                            () => NoteDetailPage(note: note),
                            transition: Transition.fadeIn,
                          );
                        },
                        onPinTap: () => notesController.togglePin(note),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
