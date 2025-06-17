//状態管理(ChangeNotifierやRiverpodなど)
//クイズの状態(現在の問題、履歴など)
//クイズの更新
//クイズ正誤判定呼び出し
//State(=参照元、ここが一番動く、動的データ全部)
//含まれるもの

import 'package:flutter/material.dart';
import 'package:mini_quiz/models/quiz5.dart';
import 'package:mini_quiz/models/quiz_log.dart';
import 'dart:collection';

class QuizState extends ChangeNotifier {
  final _quiz = Quiz5(); //まだquizとquiz5間で互換性あり

  int id = 0;
  String mondai = ''; //問題文
  List<String> options = []; //選択肢
  int lifeCount = 20; //残りライフ

  List<String> get quizStr => _quiz.keys.toList();
  List<String> gradeHistoties = []; //問題ごとの正誤履歴
  Queue<QuizLog> quizLogs = Queue(); //問題ごとの正誤履歴
  int get gradeHistoryMax => _quiz.gradeHistoryMax; //の保存数
  int get quizLogMax => _quiz.quizLogMax; //の保存数

  void init() {
    _setNext();
  }

  void answer(int index) {
    _sendUserIndex(index);
    _setNext();
  }

  void _setNext() {
    id = _quiz.getNextMondaiIndex();
    mondai = _quiz.getNextMondai();
    options = _quiz.getNextOptions();
    gradeHistoties = _quiz.gradeHistoryToStr();
    _quiz.increment(); //contains update
    notifyListeners();
  }

  //答え終わったあとに必ず通る、option_buttonに呼ばれる
  //正誤判定の呼び出し + 履歴更新の呼び出し + ライフの更新
  void _sendUserIndex(int userAns) {
    var seikai = _quiz.isCorrect(userAns, mondai, options);
    if (seikai == false && lifeCount > 0) {
      lifeCount = lifeCount - 1;
    }
    QuizLog newLog = makeLog(id, mondai, options, userAns, seikai);
    addQuizLog(newLog);
    _quiz.gradeHistoryUpdate(mondai, seikai);
  }

  QuizLog makeLog(
    int id,
    String mondai,
    List<String> options,
    int? userAns,
    bool? seikai,
  ) {
    final newLog = QuizLog(
        id: id,
        mondai: mondai,
        options: options,
        userAns: null,
        seikai: null);
    return newLog;
  }

  void addQuizLog(QuizLog newLog) {
    if (quizLogs.length >= quizLogMax) {
      quizLogs.removeLast();
    }
    quizLogs.addFirst(newLog);
    (quizLogs.elementAt(0).mondai);
  }
}
