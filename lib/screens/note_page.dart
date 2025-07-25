import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state.dart';
import 'package:provider/provider.dart';

class NotePage extends StatelessWidget {
  const NotePage({
    required this.appState,
  });

  final QuizState appState;

  ///styleはあとで使うかも
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<QuizState>();
    final theme = Theme.of(context);
/*    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
*/

    return ListView.builder(
        itemCount: appState.gradeHistories.length,
        itemBuilder: (context, index) {
          return Card(
            color: theme.colorScheme.primary,
            child: ListTile(
                title:Text(
                    appState.gradeHistoriesStr[index],
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                subtitle:Text(
                    appState.fullQuiz[index].question,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
          );
        });
  }
}
