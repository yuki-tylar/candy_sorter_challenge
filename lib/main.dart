import 'package:candy_sorter/features/candy_sorter/model/game_setting_provider.dart';
import 'package:candy_sorter/features/candy_sorter/view/game_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candy Sorter',
      home: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GameSettingProvider()),
          ],
          child: const GamePage(),
        ),
      ),
    );
  }
}
