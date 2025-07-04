import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/cargonation.png',
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: Image.network(
                'https://developers.google.com/identity/images/g-logo.png',
                height: 24,
              ),
              label: const Text("Google 로그인"),
              onPressed: () async {
                final appUser = await _authService.signInWithGoogle();
                if (appUser != null && context.mounted) {
                  _handleLoginAfterAuth(context, appUser);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLoginAfterAuth(BuildContext context, AppUser user) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final doc = await docRef.get();


    if (!doc.exists) {
      await docRef.set(user.toMap());
    }

    final data = (await docRef.get()).data();
    final role = data?['role'];

    if (role == null) {
      Navigator.pushReplacementNamed(context, '/select-role');
    } else if (role == 'shipper') {
      Navigator.pushReplacementNamed(context, '/home', arguments: AppUser.fromMap(data!));
    } else if (role == 'driver') {
      Navigator.pushReplacementNamed(context, '/driver-home', arguments: AppUser.fromMap(data!));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효하지 않은 사용자 역할입니다.')),
      );
      await _authService.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
