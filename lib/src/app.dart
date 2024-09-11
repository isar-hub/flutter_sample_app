import 'package:flutter/material.dart';
import 'package:sample_project/src/ui/image_screen.dart';


class App extends StatelessWidget {
  const App({super.key});


  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        home: const Scaffold(
          body: ImageScreen(),
        ),
      );
  }
}