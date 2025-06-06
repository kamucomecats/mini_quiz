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
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text('A random idea:'),
          Text(appState.current.asLowerCase),
          ElevatedButton(
              onPressed: () {
                print('button pressed!');
              },
              child: Text('next'))
        ],
      ),
    );
  }
}

class Questions {
  final Map<String, String> quizMap = {
    'ringo': 'apple',
    'mikan': 'orange',
    'misosiru': 'soup',
    'megane': 'glasses',
  };
}

//first bring key-list
//make ans-list
//ans-list[]->get-answer->get-dummyでindexを4つそろえる
//ans->question->option
//dummy->option
//という流れにするか、保守性でもっと簡単な動きにする

//mapToList生成 called only once and make Map easy to access
//ans-list生成　void->list<int>A
//index(including dummy)生成     List<int>A[]->List<List<int>>B
//question生成  List<int>A[]->List<String>C
//option生成    List<List<int>>B[]->List(List<String>>D (contains dummy-options)

class Quiz {
  //copy questions map
  final quizMap = Questions().quizMap;
  final size = 3; //length of quiz
  
  //first bring key-list
  late final keys = mapToList(quizMap);

  //make ans-list
  late final ansList = geneAns(size);

  //ans-list->generate 4-options-list
  late final indexList = geneIndexList(ansList);

  //ans-list->generate String version (=questionList)
  late final questionList = geneQuestion(ansList, keys);

  //4-options-list->generate String version(=option)
  late final option = geneOption(indexList, keys);

  //questionListは問題文の List<String>
  //optionは選択肢の List<List<String>>
  //重複なしでN個問題を生成したら、
  //n/N問目としてappStateに保持するという構想

  String getQuestion() {
    var random = Random();
    var randomIndex = random.nextInt(quizMap.length);
    var keys = mapToList(quizMap);
    return quizMap[keys[randomIndex]]!;
  }

  List<int> geneAns(int size) {
    List<int> ansList = List.generate(quizMap.length, (i) => i);
    ansList.shuffle();
    var result = ansList.take(size).toList();
    return result;
  }

  //generate 4 options
  //(4つ選択肢のリスト)のリストをint(問題番号)で返す
  List<List<int>> geneIndexList(List<int> ansList) {
    List<List<int>> result = [];
    for (int j = 0; j < ansList.length; j++) {
      List<int> resultMini = [];
      var indexList = List.generate(quizMap.length, (i) => i)
        ..remove(ansList[j]);

      //shuffle and get 3 options
      indexList.shuffle();
      resultMini.add(ansList[j]);
      resultMini.addAll(indexList.take(3).toList());
      resultMini.shuffle();
      result.add(resultMini);
    }
    return result;
  }

  List<String> geneQuestion(List<int> ansList, List<String> keys) {
    List<String> result = [];
    for (int i = 0; i < size; i++) {
      result.add(keys[ansList[i]]);
    }
    return result;
  }

  List<List<String>> geneOption(List<List<int>> indexList, List<String> keys) {
    List<List<String>> result = [];
    for (int i = 0; i < size; i++) {
      List<String> resultMini = [];
      for (int j = 0; j < 4; j++) {
        resultMini.add(keys[indexList[i][j]]);
      }
      result.add(resultMini);
    }
    return result;
  }

  //be called once
  List<String> mapToList(Map<String, String> map) {
    List<String> keys = map.keys.toList();
    return keys;
  }

  String indexToKey(int i) {
    return 'ringo';
  }
}
