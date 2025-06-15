//Providerを注入するだけ

import 'package:flutter/material.dart';
import 'package:mini_quiz/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:mini_quiz/providers/quiz_state.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizState()..init(),
      child: MaterialApp(
        home: const HomePage(),
      ),
    );
  }
}
