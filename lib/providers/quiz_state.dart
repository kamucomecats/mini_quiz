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

  QuizLog? newLog;

  void answer(int index) {
    print('answer');
    _sendUserIndex(index);
    _setNext();
  }

  void _setNext() {
    print('setNext');
    id = _quiz.getNextMondaiIndex();
    mondai = _quiz.getNextMondai();
    options = _quiz.getNextOptions();
    newLog = _makeLog(id, mondai, options);
    _enqQuizLog(newLog!);
    print(id);
    print(mondai);
    print(options);
    print(newLog);
    gradeHistoties = _quiz.gradeHistoryToStr();
    _quiz.increment(); //contains update
    notifyListeners();
  }

  //答え終わったあとに必ず通る、option_buttonに呼ばれる
  //正誤判定の呼び出し + 履歴更新の呼び出し + ライフの更新
  void _sendUserIndex(int userAns) {
    print('sendUserIndex');
    var seikai = _quiz.isCorrect(userAns, mondai, options);
    if (seikai == false && lifeCount > 0) {
      lifeCount = lifeCount - 1;
    }
    if (newLog != null) {
      _addQuizLog(userAns, seikai);
    }

    _quiz.gradeHistoryUpdate(mondai, seikai);
  }

  QuizLog _makeLog(int id, String mondai, List<String> options) {
    print('make');
    QuizLog newLog = QuizLog(
        id: id, mondai: mondai, options: options, userAns: null, seikai: null);
    return newLog;
  }

  void _enqQuizLog(QuizLog newLog) {
    print('enq');
    if (quizLogs.length >= quizLogMax) {
      quizLogs.removeLast();
    }
    quizLogs.addFirst(newLog);
  }

  void _addQuizLog(int userAns, bool seikai) {
    print('add');
    quizLogs.first.userAns = userAns;
    quizLogs.first.seikai = seikai;
  }
}

/*
[ボタン押下]
↓
answer()
  └ sendUserIndex()
      └ _addQuizLog() ← 既存の最後のログにuserAnsとseikaiを設定
  └ _setNext()
      ├ _makeLog() ← 次の問題のログを空で作る
      ├ _enqQuizLog() ← quizLogsに積む（先頭に）
      └ notifyListeners() ← UI再描画

[ListView.builderにより、quizLogsの要素数だけ"card"出力]

現在デバッグ中です。
OnPressed(option_button.dart)トリガーの動きの一連に取り組んでいます。
狙いとしては、quizLogに解いた問題データをどんどん追加していくのですが、
これを問題カード(履歴を兼ねる)に直接対応させています。

カードと対応したquizLogsには[問題、選択肢、回答、正誤]を格納します。
はじめに問題Aが出題される->もちろん[回答]と[正誤]は未確定->null
ユーザー回答受け取り->quizLogs.last.userAns...によってデータ追加
という形を取っています。
問題は、カードが内部で余計に追加されていそうなところです。
ログを見るとおり、Cardの増え方が思ったのと違います。(1個ずつ多いはず)
answerなど呼び出し回数をカウントし、デバッグに取り組んでいるところです。

参考メッセージ：Another exception was thrown: RangeError (index): Index out of range: index should be less than 2: 2

*/