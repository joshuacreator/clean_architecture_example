import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';

class AuthForm extends StatelessWidget {
  final AuthProvider authProvider;
  final bool isLogin;
  final VoidCallback onToggleMode;

  const AuthForm({
    super.key,
    required this.authProvider,
    required this.isLogin,
    required this.onToggleMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (authProvider.error != null)
          Text(
            authProvider.error!,
            style: const TextStyle(color: Colors.red),
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onToggleMode,
          child: Text(isLogin ? 'Switch to Sign Up' : 'Switch to Login'),
        ),
      ],
    );
  }
}