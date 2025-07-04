import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_providers.dart';
import '../../providers/service_providers.dart';
import '../../services/firestore_service.dart';

class NotesController {
  final FirestoreService _firestoreService;
  final String? _userId;

  NotesController(this._firestoreService, this._userId);

  Future<void> addNote({required String title, required String content}) async {
    if (_userId == null) throw Exception('User not logged in.');
    await _firestoreService.addNote(
      userId: _userId,
      title: title,
      content: content,
    );
  }

  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    if (_userId == null) throw Exception('User not logged in.');
    await _firestoreService.updateNote(
      userId: _userId,
      noteId: noteId,
      title: title,
      content: content,
    );
  }

  Future<void> deleteNote({required String noteId}) async {
    if (_userId == null) throw Exception('User not logged in.');
    await _firestoreService.deleteNote(userId: _userId, noteId: noteId);
  }
}

final notesControllerProvider = Provider((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final userId = ref.watch(userIdProvider);
  return NotesController(firestoreService, userId);
});
