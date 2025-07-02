import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/driver_home.dart';
import 'screens/request/request_screen.dart';
import 'screens/request/request_list_screen.dart';
import 'screens/request/request_detail_screen.dart';
import 'screens/tracking/tracking_screen.dart';
import 'screens/driver/driver_request_list_page.dart';
import 'screens/driver/driver_request_detail_page.dart';

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
    if (args is! DeliveryRequest) {
      return _errorRoute('요청 정보가 잘못되었습니다.');
    }
    return MaterialPageRoute(builder: (_) => RequestDetailScreen(request: args));
  },

  '/tracking': (settings) {
    final args = settings.arguments;
    if (args is! String) {
      return _errorRoute('배송 ID가 없습니다.');
    }
    return MaterialPageRoute(builder: (_) => TrackingScreen(requestId: args));
  },

  '/driver/requests': (_) => MaterialPageRoute(builder: (_) => const DriverRequestListPage()),

  '/driver/request-detail': (settings) {
    final args = settings.arguments;
    if (args is! DocumentSnapshot) {
      return _errorRoute('잘못된 접근입니다.');
    }
    return MaterialPageRoute(builder: (_) => DriverRequestDetailPage(requestDoc: args));
  },
};

MaterialPageRoute _errorRoute(String message) {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text('오류')),
      body: Center(child: Text(message)),
    ),
  );
}