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
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Question(appState: appState);
                  },
                )),
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
          ),
        ],
      ),
    );
  }
}
