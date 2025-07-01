import 'package:flutter/material.dart';
import 'package:mini_quiz/models/quiz6.dart';
import 'package:mini_quiz/models/quiz_log.dart';
import 'dart:collection';
import 'package:mini_quiz/util/text_speaker.dart';
import 'package:logger/logger.dart';

final logger = Logger();

///状態管理を担う(QA, Opts, Ans, User, Life)
///読み上げを担う
class QuizState extends ChangeNotifier {
  final _quiz = Quiz6();

  int id = 0;
  String mondai = '';
  List<String> options = [];
  String kaisetu = '';
  int lifeCount = 200;

  List<String> get quizStr => _quiz.keys.toList();
  List<String> gradeHistories = [];
  Queue<QuizLog> quizLogs = Queue();
  int get gradeHistoryMax => _quiz.gradeHistoryMax;
  int get quizLogMax => _quiz.quizLogMax;

  QuizLog? newLog;

  ///状態初期化
  void init() {
    _setNext();
  }

  ///User回答後、正誤処理のち更新
  void answer(int index) {
    _sendUserIndex(index);
    _setNext();
  }

  ///更新、id,QA,Opts,Kaisetu,Log
  void _setNext() async {
    await TextSpeaker.stop();
/*    logger.i("Logger 動作確認：情報ログ");
    logger.d("Logger 動作確認：デバッグログ");
    logger.w("Logger 動作確認：警告ログ");
    logger.e("Logger 動作確認：エラーログ");*/
    id = _quiz.getNextMondaiIndex();
    mondai = _quiz.getNextMondai();
    options = _quiz.getNextOptions();
    kaisetu = _quiz.getNextKaisetu();

    newLog = _makeLog(id, mondai, options, kaisetu);
    _enqQuizLog(newLog!);

    debugPrint(id.toString());
    debugPrint(mondai);
    debugPrint(options.toString());
    debugPrint(newLog.toString());

    gradeHistories = _quiz.gradeHistoryToStr();
    _quiz.increment();
    notifyListeners();

    await _speakStrings(["question$id", toReadableText(mondai), ...options]);
  }

  ///正誤判定、ライフ管理、履歴管理、make(データとして生成)->enq(Logに不完全newLogを追加)->(出題・回答)->add()
  ///つくりとしては、未完成のLogが問題+選択肢カードを兼ねているということ、念のためLogは終始、正解選択肢を保持しない
  ///回答int
  ///なし、lifeCount, quizLog,gradeHistory状態書き換え
  void _sendUserIndex(int userAns) {
    var seikai = _quiz.isCorrect(userAns, mondai, options);
    if (!seikai && lifeCount > 0) {
      lifeCount--;
    }
    if (newLog != null) {
      _addQuizLog(userAns, seikai);
    }

    _quiz.gradeHistoryUpdate(mondai, seikai);
  }

  ///データとしてLog型生成(Queueに追加前=画面表示前)
  ///id,問題、選択肢、解説(正答はLog自体に入れない)
  ///なし、すでに出来ている問題を、State自身の保持内容から取り込む
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

  ///quizLogにここでenqueue(=ここで画面に問題が映る)
  ///なし
  ///なし
  void _enqQuizLog(QuizLog newLog) {
    if (quizLogs.length >= quizLogMax) {
      quizLogs.removeLast();
    }
    quizLogs.addFirst(newLog);
  }

  ///元newLog(=現時点での問題quizLog)に回答情報を追加
  ///ユーザー回答int、正誤判定bool
  ///なし、quizLog.first状態書き換え
  void _addQuizLog(int userAns, bool seikai) {
    quizLogs.first.userAns = userAns;
    quizLogs.first.seikai = seikai;
  }

  ///音声関連、非同期処理を含む、おもに読み上げテキストへの事前処理を行う
  ///読み上げ内容List<String>
  ///なし
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
