import 'dart:collection';
import 'package:flutter_tts/flutter_tts.dart';

class TextSpeakerQueue {
  static final FlutterTts _tts = FlutterTts();
  static final Queue<String> _queue = Queue<String>();
  static bool _isSpeaking = false;

  static Future<void> enqueue(String text) async {
    _queue.add(text);
    _processQueue();
  }

  static Future<void> _processQueue() async {
    if (_isSpeaking || _queue.isEmpty) return;

    _isSpeaking = true;
    final text = _queue.removeFirst();

    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    await _tts.awaitSpeakCompletion(true);

    await _tts.speak(text);
    _isSpeaking = false;

    if (_queue.isNotEmpty) {
      await _processQueue();
    }
  }

  static Future<void> clearQueue() async {
    _queue.clear();
    await _tts.stop();
    _isSpeaking = false;
  }
}
