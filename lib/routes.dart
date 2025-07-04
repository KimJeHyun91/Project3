import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project3/screens/driver/driver_history_page.dart';
import 'package:project3/screens/driver/driver_ongoing_page.dart';
import 'package:project3/screens/driver/driver_payment_page.dart';
import 'package:project3/screens/tracking/tracking_list_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/driver_home.dart';
import 'screens/request/request_screen.dart';
import 'screens/request/request_list_screen.dart';
import 'screens/request/request_detail_screen.dart';
import 'screens/driver/driver_request_list_page.dart';
import 'screens/driver/driver_request_detail_page.dart';
import 'screens/payment/payment_topup_screen.dart';
import 'screens/payment/payment_transfer_screen.dart';
import 'screens/payment/payment_screen.dart';
import 'screens/payment/payment_test_screen.dart';
import 'models/user_model.dart';
import 'models/delivery_request_model.dart';

final Map<String, RouteFactory> appRoutes = {
  '/login': (_) => MaterialPageRoute(builder: (_) => LoginScreen()),

  '/select-role': (_) => MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),

  '/home': (settings) {
    final args = settings.arguments;
    if (args is! AppUser) {
      return _errorRoute('사용자 정보가 누락되었습니다.');
    }
    return MaterialPageRoute(builder: (_) => HomeScreen(user: args));
  },

  '/driver-home': (settings) {
    final args = settings.arguments;
    if (args is! AppUser) {
      return _errorRoute('사용자 정보가 누락되었습니다.');
    }
    return MaterialPageRoute(builder: (_) => DriverHomeScreen(user: args));
  },

  '/request': (_) => MaterialPageRoute(builder: (_) => const RequestScreen()),

  '/requestList': (_) => MaterialPageRoute(builder: (_) => const RequestListScreen()),

  '/request-detail': (settings) {
    final args = settings.arguments;
    if (args is! String) {
      return _errorRoute('요청 정보가 잘못되었습니다.');
    }
    return MaterialPageRoute(builder: (_) => RequestDetailScreen(requestId: args));
  },

  '/payment': (_) => MaterialPageRoute(builder: (_) => const PaymentScreen()),
  '/payment-topup': (_) => MaterialPageRoute(builder: (_) => const PaymentTopUpScreen()),
  '/payment-transfer': (_) => MaterialPageRoute(builder: (_) => const PaymentTransferScreen()),
  '/payment-test': (settings) {
    final args = settings.arguments;
    final amount = (args is int) ? args : 100000;
    return MaterialPageRoute(
      builder: (_) => PaymentTestScreen(amount: amount),
    );
  },
  '/tracking': (_) => MaterialPageRoute(builder: (_) => const TrackingListScreen()),
  '/driver/requests': (_) => MaterialPageRoute(builder: (_) => const DriverRequestListPage()),

  '/driver/request-detail': (settings) {
    final args = settings.arguments;
    if (args is! DocumentSnapshot) {
      return _errorRoute('잘못된 접근입니다.');
    }
    return MaterialPageRoute(builder: (_) => DriverRequestDetailPage(requestDoc: args));
  },

  '/driver/ongoing': (_) => MaterialPageRoute(builder: (_) => const DriverOngoingPage()),
  '/driver/history': (_) => MaterialPageRoute(builder: (_) => const DriverHistoryPage()),
  '/driver/payment': (_) => MaterialPageRoute(builder: (_) => const DriverPaymentPage()),
};

MaterialPageRoute _errorRoute(String message) {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text('오류')),
      body: Center(child: Text(message)),
    ),
  );
}
