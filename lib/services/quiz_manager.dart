import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'dart:collection';
import 'package:mini_quiz/models/quiz_item.dart';
import 'package:mini_quiz/providers/quiz_state.dart';

class QuizManager {
  List<QuizItem> items = [];
  final random = Random();

  Future<void> loadQuizData() async {
    //jsonをStringとして取り込み
    final String jsonString =
        await rootBundle.loadString('assets/quizzes/quiz1.json');

    //そのStringをDartのListに変換
    final List<dynamic> jsonList = json.decode(jsonString);

    //elementごとにfromJsonを掛け、各mapをQuizItemリスト化
    items = jsonList.map((e) => QuizItem.fromJson(e)).toList();
    //logger.i(items[0].question);
  }

  int get length => items.length;

  final gradeHistoryMax = 3;
  final quizLogMax = 10;

  var count = 0;
  final size = 5;
  //gudge just before quiz
  //return 0 when correct
  bool isCorrect(int id, int userAns, List<String> optionsInQuiz) {
    var countPrevious = count - 1;
    if (countPrevious == -1) countPrevious = size - 1;

    logger.i(items[id].options);
    logger.i(optionsInQuiz);
    logger.i(userAns);
    if (items[id].options[0] == optionsInQuiz[userAns]) {
      return true;
    }
    return false;
  }

  //正誤履歴の初期化、全部の問題をboolの空queue(=未回答)で埋める
  List<Queue<bool>> gradeHistoriesInit() =>
      List.generate(items.length, (_) => Queue<bool>());

  ///履歴更新
  ///gradeHistory List<Queue<bool>>
  ///更新リスト
  List<dynamic> gradeHistoryUpdate(
      int id, bool seikai, List<dynamic> gradeHistories) {
    if (gradeHistories[id].length >= gradeHistoryMax) {
      gradeHistories[id].removeLast();
    }
    gradeHistories[id].addFirst(seikai);
    return gradeHistories;
  }

  ///成績のString化
  ///履歴
  ///履歴
  List<String> gradeHistoryToStr(List<Queue<bool>> gradeHistories) {
    List<String> gradeHistoryStrs = [];
    for (int i = 0; i < items.length; i++) {
      String gradeHistoryStr = '';
      for (int j = 0; j < gradeHistories[i].length; j++) {
        final value = gradeHistories[i].elementAt(j);
        if (gradeHistories[i].elementAt(j)) {
          gradeHistoryStr += value ? '✅' : '❌';
        }
      }
      for (int j = 0; j < gradeHistoryMax - gradeHistories[i].length; j++) {
        gradeHistoryStr += '⬛';
      }
      gradeHistoryStrs.add(gradeHistoryStr);
    }
    return gradeHistoryStrs;
  }
}
