import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/request/request_screen.dart';
import 'screens/request/request_list_screen.dart';
import 'screens/request/request_detail_screen.dart';
import 'screens/tracking/tracking_screen.dart';
// import 'screens/route/route_screen.dart'; // 카카오 지도 연동 보류 중

import 'models/user_model.dart';
import 'models/delivery_request_model.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => LoginScreen(),
  '/select-role': (context) => const RoleSelectionScreen(),
  '/home': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as AppUser;
    return HomeScreen(user: args);
  },
  // '/driver-home': (context) => const DriverHomeScreen(),
  '/request': (context) => const RequestScreen(),
  '/requestList': (context) => const RequestListScreen(),
  '/request-detail': (context) {
    final requestId = ModalRoute.of(context)!.settings.arguments as String;
    return RequestDetailScreen(requestId: requestId);
  },
  '/tracking': (context) {
    final requestId = ModalRoute.of(context)!.settings.arguments as String;
    return TrackingScreen(requestId: requestId);
  },
  // '/route': (context) => const RouteScreen(), // 보류
};