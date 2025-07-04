import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import 'auth_providers.dart';
import 'service_providers.dart';

final notesStreamProvider = StreamProvider<List<Note>>((ref) {
  final userId = ref.watch(userIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(firestoreServiceProvider).getNotesStream(userId);
});
