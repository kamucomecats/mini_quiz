import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state.dart';
import 'package:provider/provider.dart';

class NotePage extends StatelessWidget {
  const NotePage({
    required this.appState,
  });

  final QuizState appState;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<QuizState>();
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    if (appState.bookHistory.isEmpty) {
      return Center(
        child: Text('BH is empty.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
        ),
        for (var i = 0; i < appState.bookHistory.length; i++)
          Card(
            color: theme.colorScheme.primary,
            child: ListTile(
                title: Row(
              children: [
                Text(
                  appState.quizStr[i],
                  style: style,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
                SizedBox(
                  width: 130,
                  child: Text(
                    appState.bookHistory[i],
                    style: style,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            )),
          ),
      ],
    );
  }
}
