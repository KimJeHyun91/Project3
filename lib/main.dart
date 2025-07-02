import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project3/screens/home/driver_home.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'models/user_model.dart'; // AppUser가 이 안에 있다고 가정
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logistics Client',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      // 기본 routes 대신 onGenerateRoute 사용
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (context) => HomeScreen(user: user),
          );
        }

        if (settings.name == '/driver-home') {
          final user = settings.arguments as AppUser;
          return MaterialPageRoute(
            builder: (context) => DriverHomeScreen(user: user),
          );
        }

        // 기본 경로
        final routeBuilder = appRoutes[settings.name];
        if (routeBuilder != null) {
          return MaterialPageRoute(builder: routeBuilder);
        }

        // 알 수 없는 경로
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
      },
    );
  }
}
