class UserProfile {
  final String uid;
  final String displayName;
  final String email;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
  });

  factory UserProfile.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return UserProfile(
      uid: documentId,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
