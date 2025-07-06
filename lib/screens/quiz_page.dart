import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state.dart';
import 'package:mini_quiz/widgets/question_card.dart';
import 'package:mini_quiz/widgets/option_button.dart';
import 'package:mini_quiz/widgets/life_gauge.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({
    super.key,
    required this.appState,
  });

  final QuizState appState;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          LifeGauge(appState: appState),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: ListView.builder(
                  reverse: true,
                  itemCount: appState.quizLogs.length,
                  itemBuilder: (context, index) {
                    return Question(
                      appState: appState,
                      index: index,
                    );
                  },
                )),
                ...List.generate(
                    4, (i) => Option(appState: appState, index: i)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
