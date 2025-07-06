import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state.dart';
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
        child: Text('GradeHistory is empty.'),
      );
    }

    return ListView.builder(
        itemCount: appState.gradeHistories.length,
        itemBuilder: (context, index) {
          return Card(
            color: theme.colorScheme.primary,
            child: ListTile(
                title: Row(
              children: [
                SizedBox(
                  width: 130,
                  child: Text(
                    appState.fullQuiz[index].question,
                    style: style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 130,
                  child: Text(
                    appState.gradeHistoriesStr[index],
                    style: style,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            )),
          );
        });
  }
}
