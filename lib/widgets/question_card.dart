import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state.dart';
import 'responsive_text.dart';

class Question extends StatefulWidget {
  const Question({
    super.key,
    required this.appState,
    required this.index,
  });

  final QuizState appState;
  final int index;

  @override
  State<Question> createState() => _Questionstate();
}

class _Questionstate extends State<Question> {
  bool _showExplain = false;
  int? _lastquestionid;

  void _toggleExplain() {
    setState(() {
      _showExplain = !_showExplain;
    });
  }

  @override
  void didUpdateWidget(covariant Question oldWidget) {
    super.didUpdateWidget(oldWidget);

    final currentId = widget.appState.quizLogs.elementAt(widget.index).id;
    if (_lastquestionid != currentId) {
      setState(() {
        _showExplain = false;
        _lastquestionid = currentId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _lastquestionid = widget.appState.quizLogs.elementAt(widget.index).id;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    final qLog = widget.appState.quizLogs.elementAt(widget.index);
    if (qLog.seikai == null && _showExplain) {
      _showExplain = false;
    }

    Color cardColor;

    if (qLog.seikai == null) {
      cardColor = theme.colorScheme.primary;
    } else if (qLog.seikai == true) {
      cardColor = Colors.green;
    } else {
      cardColor = Colors.red;
    }

    return InkWell(
      onTap: qLog.seikai != null ? _toggleExplain : null,
      child: SizedBox(
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
                      'No.${qLog.id}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ResponsiveText(
                    text: qLog.mondai,
                    baseStyle: style,
                    maxFontSize: style.fontSize ?? 30,
                    minFontSize: 24,
                  ),
                  qLog.seikai != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              qLog.options[qLog.userAns!],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Noto Sans Japanese'),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  if (_showExplain)
                    Text(
                      qLog.kaisetu,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'NotoSans', fontWeight: FontWeight.w900),
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
