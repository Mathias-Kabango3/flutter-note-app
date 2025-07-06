import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart'; // Import your colors
import '../../../models/note.dart';
import '../../notes/add_edit_note_screen.dart';
// Import the notes controller to call the delete method
import '../../notes/notes_controller.dart';

class NoteCard extends ConsumerWidget {
  final Note note;
  const NoteCard({super.key, required this.note});

  // --- NEW METHOD TO SHOW THE DIALOG ---
  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Delete Note'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to permanently delete this note?'),
                Text('This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
            FilledButton(
              // Using FilledButton for the destructive action
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Delete'),
              onPressed: () async {
                // Check if the note has an ID before proceeding
                if (note.id != null) {
                  try {
                    // Call the delete method from our NotesController
                    await ref
                        .read(notesControllerProvider)
                        .deleteNote(noteId: note.id!);
                    // Dismiss the dialog
                    // ignore: use_build_context_synchronously
                    Navigator.of(dialogContext).pop();
                  } catch (e) {
                    // Handle potential errors during deletion
                    // ignore: use_build_context_synchronously
                    Navigator.of(dialogContext).pop();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(
          note.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.textSecondary,
              ),
              tooltip: 'Edit Note',
              onPressed: () {
                // This navigation remains the same
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditNoteScreen(note: note),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              tooltip: 'Delete Note',
              // --- UPDATE THE ONPRESSED CALLBACK ---
              // Instead of deleting directly, call our new dialog method
              onPressed: () => _showDeleteConfirmationDialog(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}
