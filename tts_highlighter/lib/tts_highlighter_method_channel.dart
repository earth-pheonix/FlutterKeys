import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tts_highlighter_platform_interface.dart';

/// An implementation of [TtsHighlighterPlatform] that uses method channels.
class MethodChannelTtsHighlighter extends TtsHighlighterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tts_highlighter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
