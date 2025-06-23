import 'package:flutter/material.dart';
import 'package:mini_quiz/models/quiz6.dart';
import 'package:mini_quiz/models/quiz_log.dart';
import 'dart:collection';
import 'package:mini_quiz/util/text_speaker.dart';

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

  void init() {
    _setNext();
  }

  void answer(int index) {
    _sendUserIndex(index);
    _setNext();
  }

  void _setNext() async {
    await TextSpeaker.stop();

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
    final sessionId = UniqueKey().toString();
    await TextSpeaker.stop();
    await Future.delayed(const Duration(milliseconds: 100));

    await TextSpeaker.speakTextsInterruptible(texts, sessionId: sessionId);
  }

  String toReadableText(String original) {
    return original.replaceAll('___', 'ほにゃらら');
  }
}
