import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tts_highlighter_method_channel.dart';

abstract class TtsHighlighterPlatform extends PlatformInterface {
  /// Constructs a TtsHighlighterPlatform.
  TtsHighlighterPlatform() : super(token: _token);

  static final Object _token = Object();

  static TtsHighlighterPlatform _instance = MethodChannelTtsHighlighter();

  /// The default instance of [TtsHighlighterPlatform] to use.
  ///
  /// Defaults to [MethodChannelTtsHighlighter].
  static TtsHighlighterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TtsHighlighterPlatform] when
  /// they register themselves.
  static set instance(TtsHighlighterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
