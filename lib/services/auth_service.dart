import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<AppUser?> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut(); // 중복 로그인 방지

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;
      final userRef = _db.collection('users').doc(user.uid);

      final snapshot = await userRef.get();

      if (!snapshot.exists) {
        // 🔰 최초 로그인 시 balance = 0 포함
        await userRef.set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoUrl': user.photoURL,
          'role': 'shipper',
          'balance': 0,
        });
      } else {
        // 🔁 기존 유저는 balance는 유지하고 나머지 정보만 merge
        await userRef.set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoUrl': user.photoURL,
          'role': snapshot.data()?['role'] ?? 'shipper',
        }, SetOptions(merge: true));
      }

      return AppUser(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        role: snapshot.data()?['role'] ?? 'shipper',
        balance: snapshot.data()?['balance'] ?? 0,
      );
    } catch (e) {
      print('❗ 로그인 중 오류 발생: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}
