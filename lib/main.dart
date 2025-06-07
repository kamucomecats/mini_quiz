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
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Center(
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
    '私は学校に走ります。': 'Ich laufe zur Schule.',
    '私の趣味は女装です。': 'Mein Hobby ist Cross-Dressing.',
    '私は東京出身です。': 'Ich komme aus Tokio.',
    '私の職業は料理人です。': 'Mein Beruf ist Koch.',
    '私の好きな科目は数学です。': 'Mein Lieblingsfach ist Mathematik.',
    '私は図書館にいます。': 'Ich bin in der Bibliothek.',
    '私は財布を探しています。': 'Ich suche meine Brieftasche.',
    '私は電車を待っています。': 'Ich warte auf einen Zug.',
    '私は彼に怒っています。': 'Ich bin wütend auf ihn.',
    '私は風邪をひいています。': 'Ich habe eine Erkältung.',
  };

  List<List<int>> history = [];

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
      print(randValuesIndex[i]);
      randValuesIndex[i].shuffle();
      print(randValuesIndex[i]);
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
