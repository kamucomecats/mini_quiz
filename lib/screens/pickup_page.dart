import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state.dart';
import 'package:provider/provider.dart';

class PickupPage extends StatefulWidget {
  const PickupPage({
    required this.appState,
  });

  final QuizState appState;

  ///styleはあとで使うかも
  @override
  State<PickupPage> createState() => _PickupPageState();
}

class _PickupPageState extends State<PickupPage>{
  bool _checked = false;

  @override
  Widget build(BuildContext context){
    final theme = Theme.of(context);

    return ListView.builder(
        itemCount: widget.appState.quizItems[widget.appState.fileName]!.length,
        itemBuilder: (context, index) {
          return Card(
            color: theme.colorScheme.primary,
            child: CheckboxListTile(
              title: Text('${index+1}: ${widget.appState.quizItems[widget.appState.fileName]![index].question}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,                
                ),
                maxLines: 1,
                ),
              secondary: Icon(Icons.beach_access),
              controlAffinity: ListTileControlAffinity.leading,
              value: widget.appState.quizItems[widget.appState.fileName]![index].isSelected,
              onChanged: (bool? value) {
                setState(() {
                  widget.appState.quizItems[widget.appState.fileName]![index].toggleIsSelected();
                });
              },
            ),
          );
        });
        }
}