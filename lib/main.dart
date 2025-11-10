import 'package:flutter/material.dart';
import 'widgets/main_navigator.dart';

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
      home: const MainNavigator(),
    );
  }
}
