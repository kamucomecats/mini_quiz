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

    if (appState.gradeHistoties.isEmpty) {
      return Center(
        child: Text('BH is empty.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
        ),
        for (var i = 0; i < appState.gradeHistoties.length; i++)
          Card(
            color: theme.colorScheme.primary,
            child: ListTile(
                title: Row(
              children: [
                SizedBox(
                  width: 130,
                  child: Text(
                    appState.quizStr[i],
                    style: TextStyle(fontSize: 30, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 130,
                  child: Text(
                    appState.gradeHistoties[i],
                    style: TextStyle(fontSize: 20, color: Colors.white),
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
