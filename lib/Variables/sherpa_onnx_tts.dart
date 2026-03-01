
import 'package:flutterkeysaac/Variables/settings/voice_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/highlight_message_window.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import "dart:io";
import 'dart:isolate';
import 'package:wav/wav.dart';

//supports vits, kokoro, matcha, kitten

class SherpaOnnxV4rs {

  static Isolate? ttsIsolate;
  static SendPort? _ttsSendPort;
  static final ReceivePort _receivePort = ReceivePort();
  static Future<void>? _isStarted;
  static bool isVoiceLoading = true;
  static bool isVoiceSSLoading = true;

  late final String globalVocoderPath;

  static Future<sherpa_onnx.OfflineTts> createOfflineTtsInIsolate(
    String voiceId,
    String lang,
    String base,
  ) async {

    final modelOnnx = p.join(base, "$voiceId.onnx");
    final voicesBin = p.join(base, "$voiceId-voices.bin");
    final tokens = p.join(base, "tokens.txt");
    final espeak = p.join(base, "eSpeak-ng");
    final acoustic = p.join(base, 'voice.id-acoustic.onnx');
    final vocodor = p.join(base, 'voice.id-vocodor.onnx');

    final dir = Directory(base);
    final entries = await dir.list(recursive: true).toList();

    final ruleFsts = entries
        .where((e) => e.path.endsWith(".fst"))
        .map((e) => e.path)
        .join(",");

    final ruleFars = entries
        .where((e) => e.path.endsWith(".far"))
        .map((e) => e.path)
        .join(",");

    final lexicons = entries
        .where((e) => p.basename(e.path).contains("lexicon"))
        .map((e) => e.path)
        .join(",");

    final hasVoicesBin = File(voicesBin).existsSync();
    final isKokoro = hasVoicesBin && voiceId.toLowerCase().startsWith('kokoro');
    final isKitten = hasVoicesBin && voiceId.toLowerCase().startsWith('kitten');

    final espeakDir = Directory(p.join(base, "eSpeak-ng"));
    final isEspeakEmpty = !espeakDir.existsSync() || espeakDir.listSync().isEmpty;
    final isMatcha = isEspeakEmpty;
    final isMultiMatcha = isEspeakEmpty && Directory(vocodor).existsSync();

    late final sherpa_onnx.OfflineTtsVitsModelConfig vits;
    late final sherpa_onnx.OfflineTtsKokoroModelConfig kokoro;
    late final sherpa_onnx.OfflineTtsMatchaModelConfig matcha;
    late final sherpa_onnx.OfflineTtsKittenModelConfig kitten;

    if (isKokoro) {
      kokoro = sherpa_onnx.OfflineTtsKokoroModelConfig(
        model: modelOnnx,
        voices: voicesBin,
        tokens: tokens,
        dataDir: espeak,
        lexicon: lexicons,
      );
      kitten = sherpa_onnx.OfflineTtsKittenModelConfig(); //unused
      matcha = sherpa_onnx.OfflineTtsMatchaModelConfig(); //unused
      vits = sherpa_onnx.OfflineTtsVitsModelConfig(); // unused
    } else if (isKitten) {
      kokoro = sherpa_onnx.OfflineTtsKokoroModelConfig(); //unused
      kitten = sherpa_onnx.OfflineTtsKittenModelConfig(
        model: modelOnnx,
        voices: voicesBin,
        tokens: tokens,
        dataDir: espeak,
      ); //unused
      matcha = sherpa_onnx.OfflineTtsMatchaModelConfig(); //unused
      vits = sherpa_onnx.OfflineTtsVitsModelConfig(); // unused
    } else if (isMultiMatcha){
      kokoro = sherpa_onnx.OfflineTtsKokoroModelConfig(); // unused
      kitten = sherpa_onnx.OfflineTtsKittenModelConfig(); //unused
      matcha = sherpa_onnx.OfflineTtsMatchaModelConfig(
        acousticModel: acoustic,
        vocoder: vocodor,
        tokens: tokens,
        dataDir: '',
        lexicon: lexicons,
      );
      vits = sherpa_onnx.OfflineTtsVitsModelConfig(); // unused
    } else if (isMatcha){
      kokoro = sherpa_onnx.OfflineTtsKokoroModelConfig(); //unused
      kitten = sherpa_onnx.OfflineTtsKittenModelConfig(); //unused
      matcha = sherpa_onnx.OfflineTtsMatchaModelConfig(
        acousticModel: modelOnnx,
        vocoder: Vv4rs.globalVocoderPath,
        tokens: tokens,
        dataDir: '',
        lexicon: lexicons,
      );
      vits = sherpa_onnx.OfflineTtsVitsModelConfig(); // unused    
    } else {
      kokoro = sherpa_onnx.OfflineTtsKokoroModelConfig(); // unused
      kitten = sherpa_onnx.OfflineTtsKittenModelConfig(); //unused
      matcha = sherpa_onnx.OfflineTtsMatchaModelConfig(); //unused
      vits = sherpa_onnx.OfflineTtsVitsModelConfig(
        model: modelOnnx,
        tokens: tokens,
        lexicon: lexicons,
        dataDir: espeak,
      );
    }

    final modelConfig = sherpa_onnx.OfflineTtsModelConfig(
      vits: vits, //settings for vits models
      kokoro: kokoro, //settings for kokoro models
      matcha: matcha, //settings for matcha models
      kitten: kitten, //settting for kitten models
      numThreads: 2, //number of cpu threads allowed
      debug: true, //print info? yes or no
      provider: 'cpu', //what hardware backend to use
    );

    final config = sherpa_onnx.OfflineTtsConfig(
      model: modelConfig, //vits, kokoro, matcha
      ruleFsts: 
        (isMatcha || isMultiMatcha || (isKokoro && lang != '中文')) 
        ? ''
        : ruleFsts, 
      ruleFars: 
        (isMatcha || isMultiMatcha || (isKokoro && lang != '中文')) 
        ? ''
        : ruleFars,
      maxNumSenetences: 1, //sentance count for proccess per call
    );


    final tts = sherpa_onnx.OfflineTts(config);

    return tts;
    }

  static Future<void> loadSherpaOnnxEngine(String lang) async {
    await start();

    if (Vv4rs.myEngineForVoiceLang[lang] == 'sherpa-onnx' &&
        Vv4rs.sherpaOnnxLanguageVoice[lang] != null) {

      final voiceId = Vv4rs.sherpaOnnxLanguageVoice[lang]!.id!;
      final base = await getModelBasePath(voiceId);

      final responsePort = ReceivePort();

      _ttsSendPort!.send({
        'type': 'load',
        'lang': lang,
        'voiceId': voiceId,
        'basePath': base,
        'replyPort': responsePort.sendPort,
      });
      isVoiceLoading = true;
      await responsePort.first;
      isVoiceLoading = false;
      responsePort.close();
    }
  }
  
  static Future<void> loadSherpaOnnxSSEngine(String lang) async {
    await start();

    if (Vv4rs.myEngineForSSVoiceLang[lang] == 'sherpa-onnx' &&
        Vv4rs.sherpaOnnxSSLanguageVoice[lang] != null) {

      final voiceId = Vv4rs.sherpaOnnxSSLanguageVoice[lang]!.id!;
      final base = await getModelBasePath(voiceId);

      final responsePort = ReceivePort();

      _ttsSendPort!.send({
        'type': 'load',
        'lang': lang,
        'voiceId': voiceId,
        'basePath': base,
        'replyPort': responsePort.sendPort,
      });

      isVoiceSSLoading = true;
      await responsePort.first;
      isVoiceSSLoading = false;
      responsePort.close();
    }
  }

  static void ttsIsolateEntry(SendPort mainSendPort,) async {
    final port = ReceivePort();
    mainSendPort.send(port.sendPort);

    sherpa_onnx.initBindings();

    final Map<String, sherpa_onnx.OfflineTts> models = {};

    await for (final message in port) {
      if (message is Map) {
        final type = message['type'];

        if (type == 'load') {
          try {
            final lang = message['lang'];
            final voiceId = message['voiceId'];
            final basePath = message['basePath'];
            final SendPort reply = message['replyPort'];

            models[lang]?.free();

            final tts = await createOfflineTtsInIsolate(
              voiceId,
              lang,
              basePath,
            );

            models[lang] = tts;

            reply.send(true);
          } catch (e) {
            message['replyPort']?.send(false);
          }
        }

        if (type == 'synthesize') {
          final lang = message['lang'];
          final text = message['text'];
          final sid = message['sid'];
          final speed = message['speed'];
          final reply = message['replyPort'] as SendPort;


          final model = models[lang];
          if (model == null) {
            reply.send(null);
            continue;
          }

          final audio = model.generate(
            text: text,
            sid: sid,
            speed: speed,
          );

          reply.send({
            'samples': audio.samples,
            'sampleRate': audio.sampleRate,
          });
        }

        if (type == 'validate') {
          final reply = message['replyPort'] as SendPort;
          try {
            final voiceId = message['voiceId'];
            final lang = message['lang'];
            final basePath = message['basePath'];

            // Attempt to create the engine. 
            // If paths are wrong or files are corrupt, this throws.
            final testTts = await createOfflineTtsInIsolate(voiceId, lang, basePath);

            final int count = testTts.numSpeakers;
            Map<int, String> speakerTable = {};

            for (int i = 0; i < (count > 0 ? count : 1); i++) {
              speakerTable[i] = "Speaker $i"; 
            }

            // If we got here, it's valid. Free it immediately to save memory.
            testTts.free(); 
            reply.send({
              'success': true, 
              'speakerCount': count,
              'speakerTable': speakerTable, 
            });
          } catch (e) {
            reply.send({'success': false, 'error': e.toString()});
          }
        }
      }
    }
  }

  static Future<String> getModelBasePath(String voiceId) async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, "sherpaOnnx_models", voiceId);
  }

  static Future<void> start() async {
    if (_isStarted != null){
      return _isStarted;
    }
    final completer = Completer<void>();
    _isStarted = completer.future;

    ttsIsolate = await Isolate.spawn(
      ttsIsolateEntry,
      _receivePort.sendPort,
    );

    _ttsSendPort = await _receivePort.first as SendPort;
    completer.complete();
  }

  static Future<String> generateWaveFilename([String suffix = '']) async {
    final Directory directory = await getApplicationSupportDirectory();
    DateTime now = DateTime.now();
    final filename =
        '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}$suffix.wav';
    return p.join(directory.path, filename);
  }

  static Future<String> boostWavVolume(String inputPath, double gain) async {
    try {
      // 1. Load the wav file
      final wav = await Wav.readFile(inputPath);

      // 2. Apply gain to every sample in every channel
      for (var channel in wav.channels) {
        for (var i = 0; i < channel.length; i++) {
          // Multiply the sample by our gain
          double boosted = channel[i] * gain;
          
          // Clamp the value between -1.0 and 1.0 to prevent digital "wrapping"
          // (This is our basic safety limiter)
          channel[i] = boosted.clamp(-1.0, 1.0);
        }
      }

      // 3. Save to a new path
      final outputPath = inputPath.replaceAll('.wav', '_boosted.wav');
      await wav.writeFile(outputPath);
      
      return outputPath;
    } catch (e) {
      return inputPath; // Fallback to original if something fails
    }
  }

  static Future<void> speak(
    bool forSS,
    String lang, 
    String text,
    AudioPlayer player,
  ) async {
    if ((forSS && isVoiceSSLoading) || (!forSS && isVoiceLoading)){
      return;
    }
    await player.stop();

    final speakerID = (forSS) 
      ? Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.speakerID
      : Vv4rs.sherpaOnnxLanguageVoice[lang]?.speakerID;
    final rate = (forSS) 
      ? Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.lengthScale
      : Vv4rs.sherpaOnnxLanguageVoice[lang]?.lengthScale;
    final volumeBoost = (forSS)
      ? Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.volumeBoost
      : Vv4rs.sherpaOnnxLanguageVoice[lang]?.volumeBoost;
  
    final responsePort = ReceivePort();

    _ttsSendPort!.send({
      'type': 'synthesize',
      'lang': lang,
      'text': text,
      'sid': speakerID ?? 0,
      'speed': rate ?? 1.0,
      'replyPort': responsePort.sendPort,
    });
    
    final result = await responsePort.first;
    responsePort.close();

    if (result == null) return;

    final samples = result['samples'];
    final sampleRate = result['sampleRate'];

    final suffix = '-sid-${speakerID ?? 0}-speed-${(rate ?? 1.0).toStringAsPrecision(2)}';
    final filename = await generateWaveFilename(suffix);

      final wav = sherpa_onnx.writeWave(
        filename: filename,
        samples: samples,
        sampleRate: sampleRate,
      );

    if (wav) {
      //set file
      V4rs.currentSpeakingFile = await boostWavVolume(filename, volumeBoost ?? 1.0);

      //set wpm for highlighting
      double time = samples.length / sampleRate; //in seconds
      double minutes = time / 60;
      int wordCount(String text) {
        return text
          .trim()
          .split(RegExp(r'\s+'))
          .length;
        }
      HV4rs.currentWPM = wordCount(text)/minutes;
      HV4rs.useWPM.value = true;

      //set listener for completer
      final completer = Completer<void>();
      player.onPlayerComplete.listen((event) {
        if (!completer.isCompleted) completer.complete();
      });

      //speak
      V4rs.theIsSpeaking.value = true;
      HV4rs.subscribeWordStream(null);
      await player.play(DeviceFileSource(V4rs.currentSpeakingFile!));
      await completer.future; 

      //cleanup
      V4rs.theIsSpeaking.value = false;
      HV4rs.useWPM.value = false;
    }
  }

  static Future<void> pause(
    AudioPlayer player, //ensure same player as speak!
  ) async {
    V4rs.pauseMoment = await player.getCurrentPosition();
    await player.stop();
  }

  static Future<void> resume(
    AudioPlayer player, //ensure same player as speak!
  ) async {
      if (V4rs.pauseMoment != null){
      await player.setSource(DeviceFileSource(V4rs.currentSpeakingFile!));
      await player.seek(V4rs.pauseMoment!);
      await player.resume();
    }
  }

  static Future<void> rewind(
    AudioPlayer player, //ensure same player as speak!
  ) async {
    if (V4rs.currentSpeakingFile != null) {
      player.stop;
      await player.play(DeviceFileSource(V4rs.currentSpeakingFile!));
    }
  }

 static Future<bool> isValidModel(String voiceId, String lang) async {
    await start(); 

    final base = await getModelBasePath(voiceId);
    final responsePort = ReceivePort();

    try {
      _ttsSendPort!.send({
        'type': 'validate',
        'lang': lang,
        'voiceId': voiceId,
        'basePath': base,
        'replyPort': responsePort.sendPort,
      });

      final result = await responsePort.first.timeout(
        const Duration(seconds: 10),
        onTimeout: () => {'success': false, 'error': 'Timeout'},
      );

      if (result['success'] == true) {
        Vv4rs.downloadMessage.value = ("Voice is valid.");
        Vv4rs.importingSpeakerCount = result['speakerCount'] ?? 1;
        Vv4rs.importingSpeakers = result['speakerTable'] ?? {};
        return true;
      } else {
        Vv4rs.downloadMessage.value = "Error: voice validation failed: ${result['error']}";
        return false;
      }
    } catch (e) {
      Vv4rs.downloadMessage.value = "Error: Not Valid Model: $e";
      return false;
    } finally {
      responsePort.close();
    }
  }
}
