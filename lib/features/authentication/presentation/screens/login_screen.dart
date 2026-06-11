import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  final AuthProvider authProvider;

  const LoginScreen({super.key, required this.authProvider});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: widget.authProvider.isLoading
                  ? null
                  : () async {
                      await widget.authProvider.signIn(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (widget.authProvider.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(widget.authProvider.error!),
                          ),
                        );
                      }
                    },
              child: widget.authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}