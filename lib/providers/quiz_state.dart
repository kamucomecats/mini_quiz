//状態管理(ChangeNotifierやRiverpodなど)
//クイズの状態(現在の問題、履歴など)
//クイズの更新
//クイズ正誤判定呼び出し
//State(=参照元、ここが一番動く、動的データ全部)
//含まれるもの

import 'package:flutter/material.dart';
import 'package:mini_quiz/models/quiz6.dart';
import 'package:mini_quiz/models/quiz_log.dart';
import 'dart:collection';
import 'package:mini_quiz/util/text_speaker.dart';

class QuizState extends ChangeNotifier {
  final _quiz = Quiz6(); //まだquizとquiz5間で互換性あり

  int id = 0;
  String mondai = ''; //問題文
  List<String> options = []; //選択肢
  String kaisetu = ''; //解説文
  int lifeCount = 200; //残りライフ

  List<String> get quizStr => _quiz.keys.toList();
  List<String> gradeHistories = []; //問題ごとの正誤履歴
  Queue<QuizLog> quizLogs = Queue(); //問題ごとの正誤履歴
  int get gradeHistoryMax => _quiz.gradeHistoryMax; //の保存数
  int get quizLogMax => _quiz.quizLogMax; //の保存数

  void init() {
    _setNext();
  }

  QuizLog? newLog;

  void answer(int index) {
    _sendUserIndex(index);
    _setNext();
  }

  void _setNext() async {
    id = _quiz.getNextMondaiIndex();
    mondai = _quiz.getNextMondai();
    options = _quiz.getNextOptions();
    kaisetu = _quiz.getNextKaisetu();
    newLog = _makeLog(id, mondai, options, kaisetu);
    _enqQuizLog(newLog!);
    print(id);
    print(mondai);
    print(options);
    print(newLog);
    gradeHistories = _quiz.gradeHistoryToStr();
    _quiz.increment(); //contains update
    notifyListeners();
    await _speakStrings(["question$id", toReadableText(mondai), ...options]);
  }

  //答え終わったあとに必ず通る、option_buttonに呼ばれる
  //正誤判定の呼び出し + 履歴更新の呼び出し + ライフの更新
  void _sendUserIndex(int userAns) {
    var seikai = _quiz.isCorrect(userAns, mondai, options);
    if (seikai == false && lifeCount > 0) {
      lifeCount--;
    }
    if (newLog != null) {
      _addQuizLog(userAns, seikai);
    }

    _quiz.gradeHistoryUpdate(mondai, seikai);
  }

  QuizLog _makeLog(
      int id, String mondai, List<String> options, String kaisetu) {
    QuizLog newLog = QuizLog(
        id: id,
        mondai: mondai,
        options: options,
        kaisetu: kaisetu,
        userAns: null,
        seikai: null);
    return newLog;
  }

  void _enqQuizLog(QuizLog newLog) {
    if (quizLogs.length >= quizLogMax) {
      quizLogs.removeLast();
    }
    quizLogs.addFirst(newLog);
  }

  void _addQuizLog(int userAns, bool seikai) {
    quizLogs.first.userAns = userAns;
    quizLogs.first.seikai = seikai;
  }

  Future<void> _speakStrings(List<String> texts) async {
    await TextSpeaker.stop();

    Future.delayed(const Duration(milliseconds: 100));

    for (final text in texts) {
      await TextSpeaker.speak(text);
      print('nowReading:$text');
      await Future.delayed(Duration(seconds: 1));
    }
  }

  String toReadableText(String original) {
    return original.replaceAll('___', 'blank');
  }
}
