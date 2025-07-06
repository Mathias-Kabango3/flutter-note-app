#FLutter-Note-App

##Modern notes-taking app built with Flutter and powered by Firebase for authentication and data storage. It uses Riverpod for state management and demonstrates clean, scalable architecture using a feature-first folder structure.

##Features
- Firebase Authentication (Email & Password)

- Real-time note storage with Cloud Firestore

- Google Fonts for a modern UI

- Flushbar for user-friendly notifications

- Clean folder structure with separation of concerns

- Powered by flutter_riverpod for robust state management

##Folder Structure
- lib/
  ├── core/               # App-wide constants, themes, and utilities
  ├── features/           # Feature-specific logic (auth, notes, home)
  ├── models/             # App data models (Note, UserProfile)
  ├── providers/          # Riverpod providers (auth, notes)
  ├── services/           # Firebase service classes
  ├── utils/              # Helpers and shared utilities
  └── main.dart           # Entry point

#Dependencies
```
flutter:
  sdk: flutter
cupertino_icons: ^1.0.8
flutter_riverpod: ^2.6.1
firebase_core: ^3.15.1
firebase_auth: ^5.6.2
cloud_firestore: ^5.6.11
google_fonts: ^6.2.1
another_flushbar: ^1.10.30
```

#Getting Started
1. Clone the repo
- git clone https://github.com/Mathias-Kabango3/flutter-note-app.git
- cd flutter-note-app

2. Install dependencies
`flutter pub get`

4. Firebase Setup
 - Create a Firebase project at console.firebase.google.com

 - Enable Authentication (Email/Password)

 - Enable Cloud Firestore

 - Add Android/iOS apps to the Firebase project

 - Download google-services.json (for Android) and/or GoogleService-Info.plist (for iOS) into the appropriate folders

 - Run: `flutterfire configure`
   
4. Run the app
  `flutter run`



