import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_quiz/models/quiz_item.dart';
import 'package:mini_quiz/models/quiz_log.dart';
import 'package:mini_quiz/services/quiz_manager.dart';
import 'dart:collection';
import 'package:mini_quiz/util/text_speaker.dart';
import 'package:logger/logger.dart';
import 'dart:math';

final logger = Logger();

///状態管理を担う(QA, Opts, Ans, User, Life)
///読み上げを担う
class QuizState extends ChangeNotifier {
  //ロード画面表示用
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  //Managerの引き出し
  final quizManager = QuizManager();
  final random = Random();

  int id = 0;
  String question = '';
  List<String> options = [];
  String explanation = '';
  int lifeCount = 200;

  List<QuizItem> get fullQuiz => quizManager.items;
  List<Queue<bool>> gradeHistories = [];
  List<String> gradeHistoriesStr = [];
  Queue<QuizLog> quizLogs = Queue();
  int get gradeHistoryMax => quizManager.gradeHistoryMax;
  int get quizLogMax => quizManager.quizLogMax;

  QuizLog? newLog;

  ///状態初期化
  Future<void> init() async {
    await quizManager.loadQuizData();
    gradeHistories = quizManager.gradeHistoriesInit();
    await _setNext();
    _isLoading = false;
    notifyListeners();
    await _speakStrings(
        ["question${id + 1}", toReadableText(question), ...options]);
  }

  ///User回答後、正誤処理のち更新
  void answer(int index) {
    _sendUserIndex(index);
    _setNext();
    }

  ///更新、id,QA,Opts,Kaisetu,Log
  Future<void> _setNext() async {
    await TextSpeaker.stop();
    var randIndex = random.nextInt(fullQuiz.length);
    final randQuiz = fullQuiz[randIndex];

    id = randIndex;
    question = randQuiz.question;
    options = List<String>.from(randQuiz.options);
    explanation = randQuiz.explanation;

    options.shuffle();
    
    newLog = _makeLog(id, question, options, explanation);
    _enqQuizLog(newLog!);

    gradeHistoriesStr = quizManager.gradeHistoryToStr(gradeHistories);
    notifyListeners();
    await _speakStrings(
        ["question${id + 1}", toReadableText(question), ...options]);
  }

  ///多数のパラメータ制御
  ///引数：回答
  ///なし
  void _sendUserIndex(int userAns) {
    var seikai = quizManager.isCorrect(id, userAns, options);
    if (!seikai && lifeCount > 0) {
      lifeCount--;
    }
    if (newLog != null) {
      _addQuizLog(userAns, seikai);
    }

    quizManager.gradeHistoryUpdate(id, seikai, gradeHistories);
  }

  ///データとしてLog型生成
  ///引数：id,問題、選択肢、解説
  ///返り値：なし
  QuizLog _makeLog(
      int id, String mondai, List<String> options, String kaisetu) {
    return QuizLog(
      id: id,
      mondai: mondai,
      options: options,
      kaisetu: kaisetu,
      userAns: null,
      seikai: null,
    );
  }

  ///quizLogにここでenqueue
  ///なし
  ///なし
  void _enqQuizLog(QuizLog newLog) {
    if (quizLogs.length >= quizLogMax) {
      quizLogs.removeLast();
    }
    quizLogs.addFirst(newLog);
  }

  ///最新quizLogに回答情報を追加
  ///引数：ユーザー回答&正誤判定
  ///返り値なし
  void _addQuizLog(int userAns, bool seikai) {
    quizLogs.first.userAns = userAns;
    quizLogs.first.seikai = seikai;
  }

  ///テキスト事前処理
  ///引数：読み上げ内容
  ///返り値：なし
  Future<void> _speakStrings(List<String> texts) async {
    final sessionId = UniqueKey().toString();
    await TextSpeaker.stop();
    await Future.delayed(const Duration(milliseconds: 100));

    await TextSpeaker.speakTextsInterruptible(texts, sessionId: sessionId);
  }

  String toReadableText(String original) {
    return original.replaceAll('___', 'ほにゃらら');
  }
}
