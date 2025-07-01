import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';
import '../auth/role_selection_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: Image.asset("assets/google_logo.png", height: 24),
          label: Text("Google 로그인"),
          onPressed: () async {
            final user = await _authService.signInWithGoogle();
            if (user != null && context.mounted) {
              Navigator.pushReplacementNamed(context, '/select-role');
            }
          },
        ),
      ),
    );
  }
}