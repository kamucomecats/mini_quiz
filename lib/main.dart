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
    print(mondai);
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
            Text('A random AAAAAAAAA idea:'),
            Question(appState: appState),
            ElevatedButton(
                onPressed: () {
                  appState.getNext();
                  print('button pressed!');
                },
                child: Text('next'))
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

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          appState.mondai,
          style: style,
        ),
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
    '俺が今食べたいものは': '唐揚げ',
    '夏の旬といえば': 'スイカ',
    'あなたの好物': 'コロッケ',
    '寒いときにおいしい': 'おでん',
    '家のは格別な': 'ホイル焼き',
    'たまに食べたい': 'ちまき',
    '食べ物の王様': 'カレー',
    '週3で食べたい': 'ホットドッグ',
  };

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
    var randKeysIndex = List.generate(quiz.length, (i) => i).toList();
    randKeysIndex.shuffle();
    randKeysIndex = randKeysIndex.take(size).toList();
    randKeys = [];
    for (int i = 0; i < size; i++) {
      randKeys.add(keys[randKeysIndex[i]]);
    }

    //randOptionsUpdate
    var randValuesIndex = [];
    for (int i = 0; i < size; i++) {
      var candidates = List.generate(quiz.length, (i) => i).toList()
        ..remove(randKeysIndex[i]);
      randValuesIndex.add(candidates.take(optionsNum - 1).toList());
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
