import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project3/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverHomeScreen extends StatelessWidget {
  final AppUser user;
  const DriverHomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 뒤로가기 시 앱 종료
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('차주 홈'),
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                        (route) => false, // 모든 이전 라우트 제거
                  );
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  Navigator.pushNamed(context, '/carrier/requests');
                },
              ),
              _HomeButton(
                icon: Icons.local_shipping,
                label: '내 배송',
                onTap: () {
                  Navigator.pushNamed(context, '/carrier/ongoing');
                },
              ),
              _HomeButton(
                icon: Icons.history,
                label: '배송 이력',
                onTap: () {
                  Navigator.pushNamed(context, '/carrier/history');
                },
              ),
              _HomeButton(
                icon: Icons.attach_money,
                label: '정산',
                onTap: () {
                  Navigator.pushNamed(context, '/carrier/payment');
                },
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
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 12),
              Text(label, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}