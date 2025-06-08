import 'dart:collection';
import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Mini_quiz',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  final quiz = Quiz();

  String mondai = '';
  List<String> options = [];

  MyAppState() {
    getNext();
  }

  void getNext() {
    mondai = quiz.getNextMondai();
    options = quiz.getNextOptions();
    quiz.increment();
    notifyListeners();
  }

  void sendUserIndex(int index) {
    var seikai = quiz.gudge(index, mondai, options);
    quiz.quizHistoryUpdate(index, mondai, options, seikai);
    quiz.bookHistoryUpdate(mondai, seikai);
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

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
        page = Placeholder();
        break;
      case 3:
        page = Placeholder();
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

class QuizPage extends StatelessWidget {
  const QuizPage({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Question(appState: appState),
          Option(
            appState: appState,
            index: 0,
          ),
          Option(
            appState: appState,
            index: 1,
          ),
          Option(
            appState: appState,
            index: 2,
          ),
          Option(
            appState: appState,
            index: 3,
          ),
        ],
      ),
    );
  }
}

class Question extends StatelessWidget {
  const Question({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return SizedBox(
      width: 300,
      height: 300,
      child: Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FittedBox(
            child: Text(
              appState.mondai,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  const Option({
    super.key,
    required this.appState,
    required this.index,
  });

  final MyAppState appState;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith();

    return SizedBox(
      width: 300,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              //userIndexは絶対先!!
              appState.sendUserIndex(index);
              appState.getNext();
            },
            child: FittedBox(
                child: Text(
              appState.options[index],
              style: style,
            ))),
      ),
    );
  }
}

//外部から見たら、getNextするだけでとにかくStringが返ってくるのが理想
//外から呼ぶものを1つに絞る
//呼ばれるのはgetNextMondai()、getNextOptions()、increment()
//3つにしたのは外で扱いやすいと思ったから!
//3つは出題のたびに必ず、同時に、一度に呼ぶ

class Quiz {
  Quiz() {
    mapToList(quiz);
    update();
  }

  final Map<String, String> quiz = {
    '1': 'one',
    '2': 'two',
    '3': 'three',
    '4': 'four',
    '5': 'five',
    '6': 'six',
    '7': 'seven',
    '8': 'eight',
    '9': 'nine',
  };

  /*  '私は学校に走ります。': 'Ich laufe zur Schule.',
    '私の趣味は女装です。': 'Mein Hobby ist Cross-Dressing.',
    '私は東京出身です。': 'Ich komme aus Tokio.',
    '私の職業は料理人です。': 'Mein Beruf ist Koch.',
    '私の好きな科目は数学です。': 'Mein Lieblingsfach ist Mathematik.',
    '私は図書館にいます。': 'Ich bin in der Bibliothek.',
    '私は財布を探しています。': 'Ich suche meine Brieftasche.',
    '私は電車を待っています。': 'Ich warte auf einen Zug.',
    '私は彼に怒っています。': 'Ich bin wütend auf ihn.',
    '私は風邪をひいています。': 'Ich habe eine Erkältung.',*/

  //0-dim is quizIndex
  //1-dim is recent correct ans rate(10 times)
  List<List<int>> seigoHyo = [];

  Queue<Map<String, List<String>>> quizHistory = Queue();
  Queue<bool> seikaiHistory = Queue();
  final quizHistoryMax = 100;
  final bookHistoryMax = 5;

  //gudge just before quiz
  bool gudge(int userAns, String mondai, List<String> options) {
    var countPrevious = count - 1;
    if (countPrevious == -1) countPrevious = size - 1;

    if (quiz[mondai] == options[userAns]) {
      return true;
    }
    return false;
  }

  //quizHistory
  void quizHistoryUpdate(
      int userAns, String mondai, List<String> options, bool seikai) {
    if (quizHistory.length >= quizHistoryMax) {
      quizHistory.removeLast();
      seikaiHistory.removeLast();
    }
    quizHistory.addFirst({mondai: options});
    seikaiHistory.addFirst(seikai);
  }

  //should not accessed before instance initialize
  late List<Queue<bool>> bookHistory =
      List.generate(quiz.length, (_) => Queue<bool>());

  //bookHistory
  void bookHistoryUpdate(String mondai, bool seikai) {
    var index = keys.indexOf(mondai);
    if (bookHistory[index].length >= bookHistoryMax) {
      bookHistory[index].removeLast();
    }
    bookHistory[index].addFirst(seikai);
    print(bookHistory);
  }

  List keys = [];
  List values = [];

  //make keys and values
  void mapToList(quiz) {
    keys = quiz.keys.toList();
    values = quiz.values.toList();
    return;
  }

  var size = 5;
  var count = 0;
  final optionsNum = 4;

  //randKeysのあとで呼ぶ
  String getNextMondai() {
    return randKeys[count];
  }

  //randKeysのあとで呼ぶ
  List<String> getNextOptions() {
    return randValues[count];
  }

  //count進数制御、update
  void increment() {
    count++;
    if (count >= size) {
      count = 0;
      update();
    }
  }

  List<String> randKeys = [];
  List<List<String>> randValues = [];

  //randKeys and randOptions update
  void update() {
    //randKeyUpdate
    List<int> randKeysIndex = List.generate(quiz.length, (i) => i).toList();
    randKeysIndex.shuffle();
    randKeysIndex = randKeysIndex.take(size).toList();
    randKeys = [];
    for (int i = 0; i < size; i++) {
      randKeys.add(keys[randKeysIndex[i]]);
    }

    //randOptionsUpdate
    List<List<int>> randValuesIndex = [];
    for (int i = 0; i < size; i++) {
      var candidates = List.generate(quiz.length, (i) => i).toList()
        ..remove(randKeysIndex[i]);
      candidates.shuffle();

      randValuesIndex.add(candidates.take(optionsNum - 1).toList());
      randValuesIndex[i].add(randKeysIndex[i]);
      randValuesIndex[i].shuffle();
    }
    randValues = [];
    for (int i = 0; i < size; i++) {
      List<String> randValuesMini = [];
      for (int j = 0; j < randValuesIndex[i].length; j++) {
        randValuesMini.add(values[randValuesIndex[i][j]]);
      }
      randValues.add(randValuesMini);
    }
    return;
  }
}
