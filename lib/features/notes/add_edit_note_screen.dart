import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../models/note.dart';
import '../../providers/auth_providers.dart';
import '../../providers/service_providers.dart';

class AddEditNoteScreen extends ConsumerStatefulWidget {
  /// The note to be edited. If null, a new note will be created.
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  ConsumerState<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends ConsumerState<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _isLoading = false;

  // Check if we are in "edit" mode
  bool get _isEditMode => widget.note != null;

  @override
  void initState() {
    super.initState();
    // Pre-fill the controllers if we are editing an existing note
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    // Validate the form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final userId = ref.read(userIdProvider);
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: User not logged in.'),
          backgroundColor: AppColors.error,
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      if (_isEditMode) {
        // --- UPDATE EXISTING NOTE ---
        await firestoreService.updateNote(
          userId: userId,
          noteId: widget.note!.id!,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
        );
      } else {
        // --- ADD NEW NOTE ---
        await firestoreService.addNote(
          userId: userId,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
        );
      }
      // If successful, pop the screen to go back to the HomeScreen
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Note' : 'Add Note'),
        actions: [
          // Show a loading indicator in place of the save button while saving
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else
            IconButton(
              onPressed: _saveNote,
              icon: const Icon(Icons.save_as_outlined),
              tooltip: 'Save Note',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Title Field ---
              TextFormField(
                controller: _titleController,
                autofocus: !_isEditMode,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: InputBorder.none,
                  labelStyle: TextStyle(fontSize: 24),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // --- Content Field ---
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  style: const TextStyle(fontSize: 18, height: 1.5),
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Start writing your note here...',
                    border: InputBorder.none,
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Content cannot be empty.';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
