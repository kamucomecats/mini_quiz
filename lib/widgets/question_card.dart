import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state.dart';
import 'responsive_text.dart';

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
      child: Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                width: 300,
                height: 30,
                child: Text('No.243',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),),
              ),
              ResponsiveText(
                text: appState.mondai,
                 baseStyle: style,
                 maxFontSize: style.fontSize ?? 30,
                 minFontSize: 24,),
            ],
          )
        ),
      ),
    );
  }
}
