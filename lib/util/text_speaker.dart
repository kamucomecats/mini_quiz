import 'package:flutter_tts/flutter_tts.dart';

class TextSpeaker {
  static final FlutterTts _tts = FlutterTts()
    ..setLanguage("en-US")
    ..setSpeechRate(0.5)
    ..setPitch(1.0)
    ..awaitSpeakCompletion(true);

  static Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
    await Future.delayed(Duration(milliseconds: 50));
    await _tts.stop();
  }
}
