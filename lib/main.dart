import 'package:flutter/material.dart';
import 'package:flutter_in_production/ui/chat.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final themeMode = ValueNotifier(ThemeMode.light);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: MyApp.themeMode, 
    builder: (context, mode, child) => MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: mode,
      home: ChatPage(),
      debugShowCheckedModeBanner: false,
    )
  );
}