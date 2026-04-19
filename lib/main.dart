import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodsafe_manila/database/db.dart';
import 'screens/bottom_nav_bar_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/forgotpassword_screen.dart';
import 'services/location_service.dart';

Future<void> main() async {
  await Database.connect();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
  await LocationService.getUserAddress();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/forgot_password': (context) => const ForgotPasswordScreen(),
            '/dashboard': (context) => const BottomNavBarScreen(),
          },
        );
      },
    );
  }
}
