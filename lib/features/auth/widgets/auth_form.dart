import 'package:flutter/material.dart';
import '../../../../utils/validators.dart';

class AuthForm extends StatefulWidget {
  final bool isLoginMode;
  final bool isLoading;
  // Callback now includes the optional displayName
  final void Function(String email, String password, String? displayName)
  onSubmit;

  const AuthForm({
    super.key,
    required this.isLoginMode,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (isValid) {
      widget.onSubmit(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        // Only pass the display name if we are in sign up mode
        widget.isLoginMode ? null : _displayNameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show Display Name field only in Sign Up mode
              if (!widget.isLoginMode)
                TextFormField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(labelText: 'Display Name'),
                  keyboardType: TextInputType.name,
                  validator: Validators.displayName,
                ),
              if (!widget.isLoginMode) const SizedBox(height: 20),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: Validators.password,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: widget.isLoading ? null : _trySubmit,
                  child: widget.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )
                      : Text(widget.isLoginMode ? 'Login' : 'Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
