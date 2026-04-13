import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/internship_provider.dart';
import 'providers/application_provider.dart';
import 'utils/app_theme.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => InternshipProvider()),
        ChangeNotifierProvider(create: (_) => ApplicationProvider()),
      ],
      child: const InternshipHubApp(),
    ),
  );
}

class InternshipHubApp extends StatelessWidget {
  const InternshipHubApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internship Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
