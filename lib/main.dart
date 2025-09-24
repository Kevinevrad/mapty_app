import 'package:flutter/material.dart';
import 'package:mapty_app/pages/home_page.dart';
import 'package:mapty_app/theme/custum_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: brandSecondary),
        primaryColor: primaryColor,
      ),
      home: const HomePage(),
    );
  }
}
