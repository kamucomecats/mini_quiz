import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state.dart';

class Option extends StatelessWidget {
  const Option({
    super.key,
    required this.appState,
    required this.index,
  });

  final QuizState appState;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith();

    return SizedBox(
      width: 300,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              print('Button pressed!');
              //userIndexは絶対先!!
              appState.answer(index);
            },
            child: FittedBox(
                child: Text(
              appState.options[index],
              style: style,
            ))),
      ),
    );
  }
}
