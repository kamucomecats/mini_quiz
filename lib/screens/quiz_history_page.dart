import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state1.dart';
import 'package:provider/provider.dart';

class QuizHisPage extends StatelessWidget {
  const QuizHisPage({
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

    if (appState.gradeHistories.isEmpty) {
      return Center(
        child: Text('BH is empty.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
        ),
        for (var i = 0; i < appState.gradeHistories.length; i++)
          Card(
            color: theme.colorScheme.primary,
            child: ListTile(
                title: Row(
              children: [
                SizedBox(
                  width: 130,
                  child: Text(
                    appState.fullQuiz[i].question,
                    style: style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 130,
                  child: Text(
                    appState.gradeHistoriesStr[i],
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
