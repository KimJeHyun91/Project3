// lib/screens/order/order_form_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/order_model.dart';

class OrderFormScreen extends StatefulWidget {
  const OrderFormScreen({super.key});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _pickupAddressController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _itemCategoryController = TextEditingController();
  final _weightController = TextEditingController();
  final _sizeController = TextEditingController();
  final _suggestedPriceController = TextEditingController();
  DateTime? _desiredPickupTime;

  List<String> _selectedConditions = [];
  String _selectedVehicleType = '1톤 트럭';

  final List<String> _vehicleOptions = [
    '다마스/라보', '1톤 트럭', '2.5톤 트럭', '5톤 윙바디'
  ];

  final List<String> _specialOptions = [
    '냉장', '냉동', '리프트 필요', '파손주의'
  ];

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time == null) return;

    setState(() {
      _desiredPickupTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _desiredPickupTime != null) {
      final newOrder = Order(
        id: const Uuid().v4(),
        senderId: 'test_user',
        pickupAddress: _pickupAddressController.text.trim(),
        deliveryAddress: _deliveryAddressController.text.trim(),
        itemCategory: _itemCategoryController.text.trim(),
        weight: double.tryParse(_weightController.text.trim()) ?? 0.0,
        size: _sizeController.text.trim(),
        specialConditions: _selectedConditions,
        vehicleType: _selectedVehicleType,
        desiredPickupTime: _desiredPickupTime!,
        suggestedPrice: double.tryParse(_suggestedPriceController.text.trim()) ?? 0.0,
        status: '대기 중',
      );

      await FirebaseFirestore.instance.collection('orders').doc(newOrder.id).set(newOrder.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('화물이 등록되었습니다.')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _pickupAddressController.dispose();
    _deliveryAddressController.dispose();
    _itemCategoryController.dispose();
    _weightController.dispose();
    _sizeController.dispose();
    _suggestedPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('화물 등록')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _pickupAddressController,
                decoration: const InputDecoration(labelText: '출발지 주소'),
                validator: (value) => value == null || value.isEmpty ? '출발지 주소를 입력하세요' : null,
              ),
              TextFormField(
                controller: _deliveryAddressController,
                decoration: const InputDecoration(labelText: '도착지 주소'),
                validator: (value) => value == null || value.isEmpty ? '도착지 주소를 입력하세요' : null,
              ),
              TextFormField(
                controller: _itemCategoryController,
                decoration: const InputDecoration(labelText: '화물 품목'),
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: '무게 (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(labelText: '크기 (가로x세로x높이)'),
              ),
              Wrap(
                spacing: 8.0,
                children: _specialOptions.map((option) {
                  final selected = _selectedConditions.contains(option);
                  return FilterChip(
                    label: Text(option),
                    selected: selected,
                    onSelected: (bool value) {
                      setState(() {
                        if (value) {
                          _selectedConditions.add(option);
                        } else {
                          _selectedConditions.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: _selectedVehicleType,
                items: _vehicleOptions.map((v) {
                  return DropdownMenuItem(value: v, child: Text(v));
                }).toList(),
                onChanged: (value) => setState(() => _selectedVehicleType = value!),
                decoration: const InputDecoration(labelText: '차량 종류 선택'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(_desiredPickupTime == null
                        ? '상차 일시 선택'
                        : DateFormat('yyyy-MM-dd HH:mm').format(_desiredPickupTime!)),
                  ),
                  ElevatedButton(
                    onPressed: _pickDateTime,
                    child: const Text('선택'),
                  )
                ],
              ),
              TextFormField(
                controller: _suggestedPriceController,
                decoration: const InputDecoration(labelText: '희망 운송료 (₩)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('등록하기'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
