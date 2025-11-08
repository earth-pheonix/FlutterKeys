import 'package:flutter_test/flutter_test.dart';
import 'package:tts_highlighter/tts_highlighter.dart';
import 'package:tts_highlighter/tts_highlighter_platform_interface.dart';
import 'package:tts_highlighter/tts_highlighter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTtsHighlighterPlatform
    with MockPlatformInterfaceMixin
    implements TtsHighlighterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TtsHighlighterPlatform initialPlatform = TtsHighlighterPlatform.instance;

  test('$MethodChannelTtsHighlighter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTtsHighlighter>());
  });

  test('getPlatformVersion', () async {
    TtsHighlighter ttsHighlighterPlugin = TtsHighlighter();
    MockTtsHighlighterPlatform fakePlatform = MockTtsHighlighterPlatform();
    TtsHighlighterPlatform.instance = fakePlatform;

    expect(ttsHighlighterPlugin, '42');
  });
}
