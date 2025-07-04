import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project3/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverHomeScreen extends StatelessWidget {
  final AppUser user;
  const DriverHomeScreen({super.key, required this.user});

  Future<int> fetchUserBalance(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return (doc.data()?['balance'] ?? 0) as int;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(); // 뒤로가기 시 앱 종료
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('차주 홈'),
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
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(), // 실시간 구독
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                  final balance = data['balance'] ?? 0;

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${user.displayName ?? "사용자"} 기사님, 안녕하세요!',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          '잔액: ${balance.toString()}원',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 4 / 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _HomeButton(
                      icon: Icons.inbox,
                      label: '요청 주문',
                      onTap: () {
                        Navigator.pushNamed(context, '/driver/requests');
                      },
                    ),
                    _HomeButton(
                      icon: Icons.local_shipping,
                      label: '내 배송',
                      onTap: () {
                        Navigator.pushNamed(context, '/driver/ongoing');
                      },
                    ),
                    _HomeButton(
                      icon: Icons.history,
                      label: '배송 이력',
                      onTap: () {
                        Navigator.pushNamed(context, '/driver/history');
                      },
                    ),
                    _HomeButton(
                      icon: Icons.attach_money,
                      label: '정산',
                      onTap: () {
                        Navigator.pushNamed(context, '/driver/payment');
                      },
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
      splashColor: Colors.red.withOpacity(0.2),
      child: Card(
        elevation: 4,
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
              Icon(icon, size: 40, color: Colors.red),
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