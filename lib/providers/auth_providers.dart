import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import 'service_providers.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final userIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).value?.uid;
});

final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final userId = ref.watch(userIdProvider);
  if (userId == null) return Stream.value(null);
  return ref.watch(firestoreServiceProvider).userProfileStream(userId);
});
