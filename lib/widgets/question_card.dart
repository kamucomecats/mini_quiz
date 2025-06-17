import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state.dart';
import 'responsive_text.dart';

class Question extends StatelessWidget {
  const Question({
    super.key,
    required this.appState,
    required this.index,
  });

  final QuizState appState;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    Color cardColor;

    print('card');

    if (appState.quizLogs.elementAt(index).seikai == null) {
      cardColor = theme.colorScheme.primary;
    } else if (appState.quizLogs.elementAt(index).seikai == true) {
      cardColor = Colors.red;
    } else {
      cardColor = Colors.blue;
    }

    return SizedBox(
      width: 300,
      child: Card(
        color: cardColor,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 30,
                  child: Text(
                    'No.${appState.quizLogs.elementAt(index).id}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                ResponsiveText(
                  text: appState.quizLogs.elementAt(index).mondai,
                  baseStyle: style,
                  maxFontSize: style.fontSize ?? 30,
                  minFontSize: 24,
                ),
                appState.quizLogs.elementAt(index).seikai != null
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(appState.quizLogs.elementAt(index).userAns.toString(),
                    style: TextStyle(color: Colors.white ,
                    fontSize: 24),),
                  ],
                )
                : SizedBox.shrink(),
              ],
            )),
      ),
    );
  }
}
