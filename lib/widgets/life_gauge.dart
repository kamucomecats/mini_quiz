import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state1.dart';

class LifeGauge extends StatelessWidget {
  const LifeGauge({
    super.key,
    required this.appState,
  });

  final QuizState appState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall;

    return SizedBox(
      width: 300,
      height: 80,
      child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                        Icons.favorite,
                        size: 55,
                        color: Colors.red,
                      ),
                      Text(' × ${appState.lifeCount}',
                      style: style,),
              ],
            ),
          )),
    );
  }
}
