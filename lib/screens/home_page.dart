//home画面、最初にこれを出すようにする
//Navigator ＋ Routeなどの形に書き換える可能性あり

import 'package:flutter/material.dart';
import 'package:mini_quiz/providers/quiz_state.dart';
import 'package:provider/provider.dart';
import 'screens.dart';

enum HomePageTab {
  home,
  quiz,
  history,
  note,
  pickup,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedTab = HomePageTab.quiz;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<QuizState>();

    //データロード中に見せる画面
    if (appState.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Widget page;
    switch (selectedTab) {
      case HomePageTab.home:
        page = Placeholder();
        break;
      case HomePageTab.quiz:
        page = QuizPage(
          appState: appState,
        );
        break;
      case HomePageTab.history:
        page = QuizHisPage(
          appState: appState,
        );
        break;
      case HomePageTab.note:
        page = NotePage(
          appState: appState,
        );
        break;
      case HomePageTab.pickup:
        page = PickupPage(
          appState: appState,
        );
        break;
      default:
        throw UnimplementedError('no widget for $selectedTab');
    }

    //データが読み込み中は簡易的なロード画面を見せる

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
                NavigationRailDestination(
                  icon: Icon(Icons.push_pin),
                  label: Text('Pickup'),
                ),
              ],
              selectedIndex: selectedTab.index,
              onDestinationSelected: (index) {
                setState(() {
                  selectedTab = HomePageTab.values[index];
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
