//状態管理(ChangeNotifierやRiverpodなど)
//クイズの状態(現在の問題、履歴など)
//クイズの更新
//クイズ正誤判定呼び出し

import 'package:flutter/material.dart';
import 'package:mini_quiz/models/quiz.dart';
import 'package:mini_quiz/models/quiz5.dart';

class QuizState extends ChangeNotifier {
  final _quiz = Quiz5(); //まだquizとquiz5間で互換性あり

  String mondai = ''; //問題文
  List<String> options = []; //選択肢

  List<String> get quizStr => _quiz.keys.toList();
  List<String> bookHistory = []; //問題ごとの正誤履歴
  int get bookHistoryMax => _quiz.bookHistoryMax; //の保存数

  void init() {
    _setNext();
  }

  void answer(int index) {
    _sendUserIndex(index);
    _setNext();
  }

  void _setNext() {
    mondai = _quiz.getNextMondai();
    options = _quiz.getNextOptions();
    bookHistory = _quiz.bookHistoryToStr();
    _quiz.increment(); //contains update
    notifyListeners();
  }

  void _sendUserIndex(int index) {
    var seikai = _quiz.gudge(index, mondai, options);
    _quiz.quizHistoryUpdate(index, mondai, options, seikai);
    _quiz.bookHistoryUpdate(mondai, seikai);
  }
}
