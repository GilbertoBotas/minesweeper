import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minesweeper/constants/colors.dart';
import 'package:minesweeper/pages/game_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.PRIMARY, systemNavigationBarColor: AppColors.PRIMARY));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}
