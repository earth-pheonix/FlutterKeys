
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'tts_interface.dart';
import 'tts_for_android.dart';
import 'tts_for_ios.dart';
import 'tts_for_web.dart';

class TTSFactory {
  static Future<TTSInterface> getTTS({String? languageCode}) async {
    TTSInterface tts;
    if (kIsWeb) {
      tts = TTSWeb();
    } else if (Platform.isIOS) {
      tts = TTSiOS();
    } else if (Platform.isAndroid) {
      tts = TTSAndroid();
    } else {
      throw UnsupportedError("Unsupported platform");
    }

  if (languageCode != null) {
    await tts.setLanguage(languageCode);
  }

  return tts;
}
}