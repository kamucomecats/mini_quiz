import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextSpeaker {
  static final FlutterTts _tts = FlutterTts(); // interruptible用
  static String? _currentInterruptibleSessionId;

  static final FlutterTts _oneShotTts = FlutterTts(); // OneShot用
  static String? _currentOneShotSessionId;

  static Future<void> speakTextsInterruptible(
    List<String> texts, {
    required String sessionId,
  }) async {
    if (_currentInterruptibleSessionId != sessionId) {
      await stop();
      await Future.delayed(const Duration(milliseconds: 100));
      _currentInterruptibleSessionId = sessionId;
    }

    await _prepareTts(_tts);

    for (final text in texts) {
      if (_currentInterruptibleSessionId != sessionId) return;

      debugPrint("🔊 Speaking: $text");

      final completer = Completer<void>();
      final stopwatch = Stopwatch()..start();

      _tts.setCompletionHandler(() {
        if (!completer.isCompleted) completer.complete();
        debugPrint("✅ Completed: $text");
        debugPrint(
            "🕒 Time since last speak start: ${stopwatch.elapsedMilliseconds} ms");
      });

      _tts.setErrorHandler((msg) {
        debugPrint("❌ TTS Error: $msg");
        if (!completer.isCompleted) completer.complete();
      });

      await _tts.speak(text);

      try {
        await completer.future.timeout(const Duration(seconds: 10),
            onTimeout: () {
          debugPrint("⏰ Timeout waiting for: $text");
          _tts.setCompletionHandler(() {}); // nullは禁止
          return;
        });
      } catch (_) {
        // タイムアウトが発生しても継続
      }

      if (_currentInterruptibleSessionId == sessionId) {
        await Future.delayed(const Duration(milliseconds: 300));
      } else {
        return;
      }
    }
  }

  static Future<void> speakOneShot(String text) async {
    final sessionId = UniqueKey().toString();
    _currentOneShotSessionId = sessionId;

    await _prepareTts(_oneShotTts);
    await _oneShotTts.awaitSpeakCompletion(true);
    await _oneShotTts.stop();

    if (_currentOneShotSessionId == sessionId) {
      await _oneShotTts.speak(text);
    }
  }

  static Future<void> stop() async {
    await _tts.stop();
    _currentInterruptibleSessionId = null;
  }

  static Future<void> _prepareTts(FlutterTts tts) async {
    await tts.setLanguage("en-US");
    await tts.setSpeechRate(0.5);
  }
}
