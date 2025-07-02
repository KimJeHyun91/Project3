import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _senderNameController = TextEditingController();
  final _senderPhoneController = TextEditingController();
  final _pickupAddressController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _weightController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _priceController = TextEditingController();

  String? _selectedItem;
  String? _selectedVehicleType;
  DateTime? _pickupTime;
  bool _isRefrigerated = false;
  bool _needsLift = false;
  bool _isFragile = false;

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _pickupTime != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인이 필요합니다.')),
        );
        return;
      }

      try {
        await FirebaseFirestore.instance.collection('delivery_requests').doc(const Uuid().v4()).set({
          'senderName': _senderNameController.text.trim(),
          'senderPhone': _senderPhoneController.text.trim(),
          'pickupAddress': _pickupAddressController.text.trim(),
          'deliveryAddress': _deliveryAddressController.text.trim(),
          'pickupTime': Timestamp.fromDate(_pickupTime!),
          'itemDescription': _itemDescriptionController.text.trim(),
          'itemType': _selectedItem ?? '',
          'vehicleType': _selectedVehicleType ?? '',
          'weight': _weightController.text.trim(),
          'width': _widthController.text.trim(),
          'height': _heightController.text.trim(),
          'length': _lengthController.text.trim(),
          'price': int.tryParse(_priceController.text.trim()) ?? 0,
          'isRefrigerated': _isRefrigerated,
          'needsLift': _needsLift,
          'isFragile': _isFragile,
          'status': '요청됨',
          'createdAt': Timestamp.now(),
          'uid': user.uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('배송 요청이 등록되었습니다.')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (time == null) return;

    setState(() {
      _pickupTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  void dispose() {
    _senderNameController.dispose();
    _senderPhoneController.dispose();
    _pickupAddressController.dispose();
    _deliveryAddressController.dispose();
    _itemDescriptionController.dispose();
    _weightController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _lengthController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('배송 요청')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _senderNameController,
                decoration: _inputDecoration('보내는 사람 이름'),
                validator: (value) => value == null || value.isEmpty ? '이름을 입력하세요' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _senderPhoneController,
                decoration: _inputDecoration('연락처'),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? '연락처를 입력하세요' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pickupAddressController,
                decoration: _inputDecoration('출발지'),
                validator: (value) => value == null || value.isEmpty ? '주소를 입력하세요' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _deliveryAddressController,
                decoration: _inputDecoration('도착지'),
                validator: (value) => value == null || value.isEmpty ? '주소를 입력하세요' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('품목 선택'),
                value: _selectedItem,
                items: const [
                  DropdownMenuItem(value: '이사짐', child: Text('이사짐')),
                  DropdownMenuItem(value: '공산품', child: Text('공산품')),
                  DropdownMenuItem(value: '농산물', child: Text('농산물')),
                ],
                onChanged: (val) => setState(() => _selectedItem = val),
                validator: (value) => value == null ? '품목을 선택하세요' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('차량 종류 선택'),
                value: _selectedVehicleType,
                items: const [
                  DropdownMenuItem(value: '1톤 트럭', child: Text('1톤 트럭')),
                  DropdownMenuItem(value: '5톤 윙바디', child: Text('5톤 윙바디')),
                  DropdownMenuItem(value: '다마스/라보', child: Text('다마스/라보')),
                ],
                onChanged: (val) => setState(() => _selectedVehicleType = val),
                validator: (value) => value == null ? '차량을 선택하세요' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: _inputDecoration('희망 운임 (원)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? '희망 운임을 입력하세요' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _weightController,
                decoration: _inputDecoration('무게 (kg/톤)'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _widthController,
                      decoration: _inputDecoration('가로(cm)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _lengthController,
                      decoration: _inputDecoration('세로(cm)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      decoration: _inputDecoration('높이(cm)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                title: const Text('냉장/냉동 필요'),
                value: _isRefrigerated,
                onChanged: (val) => setState(() => _isRefrigerated = val ?? false),
              ),
              CheckboxListTile(
                title: const Text('리프트 필요'),
                value: _needsLift,
                onChanged: (val) => setState(() => _needsLift = val ?? false),
              ),
              CheckboxListTile(
                title: const Text('파손 주의'),
                value: _isFragile,
                onChanged: (val) => setState(() => _isFragile = val ?? false),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _pickupTime == null
                          ? '픽업 시간 선택'
                          : DateFormat('yyyy-MM-dd HH:mm').format(_pickupTime!),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickDateTime,
                    child: const Text('시간 선택'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _itemDescriptionController,
                decoration: _inputDecoration('물품 설명'),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF439395),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _submit,
                child: const Text('배차신청', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
