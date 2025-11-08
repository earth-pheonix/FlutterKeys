
import 'package:flutter/services.dart';

class TtsHighlighter {
  static const _events = EventChannel("tts_highlighter_events");

  Stream<Map<String, dynamic>> get wordStream =>
      _events.receiveBroadcastStream().map((event) => Map<String, dynamic>.from(event));
}
