import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/service_providers.dart';
import '../../services/auth_service.dart';

// Define the state for our controller
class AuthState {
  final bool isLoading;
  final String? errorMessage;

  const AuthState({this.isLoading = false, this.errorMessage});

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? clearError,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError == true
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

// Create the StateNotifier
class AuthController extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthController(this._authService) : super(const AuthState());

  Future<void> submit({
    required String email,
    required String password,
    String? displayName, // Make displayName optional
    required bool isLoginMode,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      if (isLoginMode) {
        await _authService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // Ensure displayName is provided for registration
        if (displayName == null || displayName.isEmpty) {
          throw Exception("Display name is required for registration.");
        }
        await _authService.createUserWithEmailAndPassword(
          displayName: displayName,
          email: email,
          password: password,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AuthState>((ref) {
      final authService = ref.watch(authServiceProvider);
      return AuthController(authService);
    });
