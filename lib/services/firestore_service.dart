import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';
import '../models/user_profile.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // User Profile Methods
  Future<void> createUserProfile({
    required String uid,
    required String displayName,
    required String email,
  }) async {
    await _db.collection('users').doc(uid).set({
      'displayName': displayName,
      'email': email,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<UserProfile> userProfileStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => UserProfile.fromFirestore(snap.data()!, snap.id));
  }

  // Note Methods
  Stream<List<Note>> getNotesStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addNote({
    required String userId,
    required String title,
    required String content,
  }) async {
    await _db.collection('users').doc(userId).collection('notes').add({
      'title': title,
      'content': content,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> updateNote({
    required String userId,
    required String noteId,
    required String title,
    required String content,
  }) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .update({'title': title, 'content': content});
  }

  Future<void> deleteNote({
    required String userId,
    required String noteId,
  }) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }
}
