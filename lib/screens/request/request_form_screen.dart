import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      final pickup = _pickupController.text;
      final dropoff = _dropoffController.text;
      final description = _descriptionController.text;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인이 필요합니다.')),
        );
        return;
      }

      try {
        await FirebaseFirestore.instance.collection('delivery_requests').add({
          'pickup': pickup,
          'dropoff': dropoff,
          'description': description,
          'uid': user.uid,
          'pickupTime': Timestamp.now(),
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('배송 요청이 등록되었습니다.')),
        );

        _formKey.currentState!.reset();
      } catch (e) {
        debugPrint('Error saving request: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('저장 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('배송 요청')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _pickupController,
                decoration: const InputDecoration(labelText: '픽업 위치'),
                validator: (value) => value == null || value.isEmpty ? '필수 항목입니다.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dropoffController,
                decoration: const InputDecoration(labelText: '도착 위치'),
                validator: (value) => value == null || value.isEmpty ? '필수 항목입니다.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: '요청 설명'),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _submitRequest,
                  child: const Text('요청 제출'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
