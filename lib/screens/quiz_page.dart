import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state.dart';
import 'package:mini_quiz/widgets/question_card.dart';
import 'package:mini_quiz/widgets/option_button.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({
    super.key,
    required this.appState,
  });

  final QuizState appState;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Question(appState: appState),
          Option(
            appState: appState,
            index: 0,
          ),
          Option(
            appState: appState,
            index: 1,
          ),
          Option(
            appState: appState,
            index: 2,
          ),
          Option(
            appState: appState,
            index: 3,
          ),
        ],
      ),
    );
  }
}
