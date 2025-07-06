import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirestoreService _firestoreService;

  AuthService(this._firebaseAuth, this._firestoreService);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found for that email.');
        case 'wrong-password':
          throw Exception('Incorrect password. Please try again.');
        case 'invalid-email':
          throw Exception('Email address is invalid.');
        case 'user-disabled':
          throw Exception('This user account has been disabled.');
        default:
          throw Exception('Login failed. ${e.message}');
      }
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await _firestoreService.createUserProfile(
          uid: user.uid,
          displayName: displayName,
          email: email,
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('This email is already registered. Try logging in.');
        case 'invalid-email':
          throw Exception('Email format is invalid.');
        case 'weak-password':
          throw Exception('Password is too weak. Try a stronger one.');
        default:
          throw Exception('Registration failed. ${e.message}');
      }
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
