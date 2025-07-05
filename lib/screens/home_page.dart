//home画面、最初にこれを出すようにする
//Navigator ＋ Routeなどの形に書き換える可能性あり

import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state1.dart';
import 'package:provider/provider.dart';
import 'screens.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<QuizState>();

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = Placeholder();
        break;
      case 1:
        page = QuizPage(
          appState: appState,
        );
        break;
      case 2:
        page = QuizHisPage(
          appState: appState,
        );
        break;
      case 3:
        page = NotePage(
          appState: appState,
        );
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.whatshot),
                  label: Text('Quiz'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history),
                  label: Text('History'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.book),
                  label: Text('Note'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
              child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page)),
        ],
      ),
    );
  }
}
