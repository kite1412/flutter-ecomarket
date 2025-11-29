import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'widgets/main_navigator.dart';
import 'services/mock_store.dart';
import 'screens/auth_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoMarket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green[700],
        ),
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: ValueListenableBuilder<Map<String, dynamic>?>(
        valueListenable: MockStore.instance.currentUser,
        builder: (context, user, _) {
          if (user == null) return const AuthScreen();
          return const MainNavigator();
        },
      ),
    );
  }
}
