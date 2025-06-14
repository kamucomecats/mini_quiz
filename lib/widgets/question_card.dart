import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state.dart';

class Question extends StatelessWidget {
  const Question({
    super.key,
    required this.appState,
  });

  final QuizState appState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return SizedBox(
      width: 300,
      height: 300,
      child: Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FittedBox(
            child: Text(
              appState.mondai,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}
