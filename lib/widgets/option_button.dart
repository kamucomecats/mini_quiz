import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state.dart';
import 'package:mini_quiz/util/text_speaker.dart';

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
        child: GestureDetector(
          onTapDown: (_) {
            TextSpeaker.speakOneShot(appState.options[index]);
          },
          child: ElevatedButton(
              onPressed: () {
                print('Button pressed!');
                TextSpeaker.stop();//今の音声を中断する
                appState.answer(index);//userIndexを先に
              },
              child: FittedBox(
                  child: Text(
                appState.options[index],
                style: style,
              ))),
        ),
      ),
    );
  }
}
