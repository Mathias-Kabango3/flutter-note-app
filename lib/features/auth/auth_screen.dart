import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/auth_form.dart';

import '../../core/constants/app_colors.dart';
import 'auth_controller.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLoginMode = true;

  void _submitAuthForm(String email, String password, String? displayName) {
    ref
        .read(authControllerProvider.notifier)
        .submit(
          email: email,
          password: password,
          displayName: displayName, // Pass the display name
          isLoginMode: _isLoginMode,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLoginMode ? 'Welcome Back!' : 'Create Account',
                  style: GoogleFonts.lato(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoginMode
                      ? 'Sign in to continue'
                      : 'Start your journey with us',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                AuthForm(
                  isLoginMode: _isLoginMode,
                  isLoading: authState.isLoading,
                  onSubmit: _submitAuthForm,
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          setState(() => _isLoginMode = !_isLoginMode);
                        },
                  child: Text(
                    _isLoginMode
                        ? 'Don\'t have an account? Sign Up'
                        : 'Already have an account? Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
