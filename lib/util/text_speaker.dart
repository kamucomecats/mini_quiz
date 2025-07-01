import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class TextSpeaker {
  static final FlutterTts _tts = FlutterTts(); // interruptible用
  static String? _currentInterruptibleSessionId;

  static final FlutterTts _oneShotTts = FlutterTts(); // 単発用
  static String? _currentOneShotSessionId;

  /// 複数テキスト読み上げ（問題文＋選択肢）(長いテキスト、中止あり(NotifyListener))
  static Future<void> speakTextsInterruptible(
    List<String> texts, {
    required String sessionId,
  }) async {
    //別のセッションが開始されたら、現在の読み上げを停止する
    if (_currentInterruptibleSessionId != sessionId) {
      await stop();
      //stop()直後は少し待機したほうが安定することがある
      await Future.delayed(const Duration(milliseconds: 100));
      _currentInterruptibleSessionId = sessionId;
    }

    await _prepareTts(_tts);

    for (final text in texts) {
      //ループの各ステップで、セッションIDが変更されていないか確認する
      if (_currentInterruptibleSessionId != sessionId) return;

      logger.d("speaking: $text");

      //awaitSpeakCompletion(true)は設定済み
      //このawaitで音声再生が完了するまで待機
      try {
        await _tts.speak(text);
      } catch (e) {
        logger.e("TTS error during speak: $e");
        //エラー発生時に、このセッションを中止する
        _currentInterruptibleSessionId = null;
        return;
      }

      //次のテキストを読み上げる前に、セッションがまだ有効か確認
      if (_currentInterruptibleSessionId == sessionId) {
        //テキスト間に自然な間隔をあける
        await Future.delayed(const Duration(milliseconds: 300));
      } else {
        //セッションが無効になっていれば、ループを抜ける
        return;
      }
    }
  }

  /// 単発読み上げ（選択肢にタップしたとき）(短いテキスト、中止あり(単発->単発))
  /// 読み上げテキスト
  /// なし awaitでidをsessionIdに変更、
  static Future<void> speakOneShot(String text) async {
    logger.i("speakOneShot: $text");
    final sessionId = UniqueKey().toString();
    _currentOneShotSessionId = sessionId;

    //既存の単発読み上げを停止
    await _oneShotTts.stop();

    await _prepareTts(_oneShotTts);

    //このセッションが最新のものであれば読み上げを実行
    if (_currentOneShotSessionId == sessionId) {
      await _oneShotTts.speak(text);
    }
  }

  //読み上げ停止
  static Future<void> stop() async {
    logger.i("stop");
    await _tts.stop();
    _currentInterruptibleSessionId = null;
    //念のためoneShotも停止する
    await _oneShotTts.stop();
    _currentOneShotSessionId = null;
  }

  ///読み上げ設定
  ///tts FlutterTts
  ///なし awaitで言語と速度設定
  static Future<void> _prepareTts(FlutterTts tts) async {
    logger.i("prepareTts");
    await tts.setLanguage("en-US");
    await tts.setSpeechRate(0.5);
    //awaitSpeakCompletionをここで設定することでコードをDRY(=don't repeat yourselfに保つ)
    await tts.awaitSpeakCompletion(true);
  }
}
