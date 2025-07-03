import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:project3/models/user_model.dart';

class HomeScreen extends StatelessWidget {
  final AppUser user;
  const HomeScreen({super.key, required this.user});

  Future<int> fetchUserBalance(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return (doc.data()?['balance'] ?? 0) as int;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(); // 뒤로가기 누르면 앱 종료
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('화주 홈'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                        (route) => false,
                  );
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 💰 사용자 잔액 표시
              FutureBuilder<int>(
                future: fetchUserBalance(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Text('잔액 불러오기 실패');
                  }

                  final balance = snapshot.data ?? 0;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${user.displayName ?? "사용자"}님, 안녕하세요!',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          '잔액: ${balance.toString()}원',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              /// 📦 기능 버튼 그리드
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 4 / 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _HomeButton(
                      icon: Icons.add_box,
                      label: '배송 요청',
                      onTap: () => Navigator.pushNamed(context, '/request'),
                    ),
                    _HomeButton(
                      icon: Icons.list_alt,
                      label: '요청 목록',
                      onTap: () => Navigator.pushNamed(context, '/requestList'),
                    ),
                    _HomeButton(
                      icon: Icons.payments,
                      label: '결제 관리',
                      onTap: () => Navigator.pushNamed(context, '/payment'),
                    ),
                    _HomeButton(
                      icon: Icons.track_changes,
                      label: '배송 추적',
                      onTap: () => Navigator.pushNamed(context, '/tracking'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HomeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.teal.withOpacity(0.2),
      child: Card(
        elevation: 6,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
