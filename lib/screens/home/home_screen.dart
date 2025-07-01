import 'package:flutter/material.dart';
import 'package:project3/models/user_model.dart';

class HomeScreen extends StatelessWidget {
  final AppUser user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('화주 홈'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 로그아웃 처리
            },
          )
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
              icon: Icons.add_box,
              label: '배송 요청',
              onTap: () {
                Navigator.pushNamed(context, '/request');
              },
            ),
            _HomeButton(
              icon: Icons.list_alt,
              label: '요청 목록',
              onTap: () {
                Navigator.pushNamed(context, '/requestList');
              },
            ),
            _HomeButton(
              icon: Icons.route,
              label: '경로 지정',
              onTap: () {
                Navigator.pushNamed(context, '/route');
              },
            ),
            _HomeButton(
              icon: Icons.track_changes,
              label: '배송 추적',
              onTap: () {
                Navigator.pushNamed(context, '/tracking');
              },
            ),
          ],
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
