import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_providers.dart';
import '../../providers/notes_providers.dart';
import '../notes/add_edit_note_screen.dart';
import 'widgets/note_card.dart';
import 'widgets/user_profile_menu.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProfileProvider);
    final notes = ref.watch(notesStreamProvider);

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const UserProfileMenu(), // The hover menu for logout
              const SizedBox(width: 12),
              userProfile.when(
                data: (profile) => Text(profile?.displayName ?? 'My Notes'),
                loading: () => const Text('Loading...'),
                error: (_, __) => const Text('My Notes'),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: notes.when(
            data: (noteList) {
              if (noteList.isEmpty) {
                return Center(
                  child: Text(
                    'Nothing here yet.\nTap + to add a note!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: noteList.length,
                itemBuilder: (context, index) =>
                    NoteCard(note: noteList[index]),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text("Error: $e")),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditNoteScreen()),
          ),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
