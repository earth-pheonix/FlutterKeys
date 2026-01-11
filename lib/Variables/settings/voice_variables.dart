import 'package:flutter/widgets.dart';
import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Models/manifest_model.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert'; //json
import 'package:flutter/services.dart'; //root bundle
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterkeysaac/Variables/settings/bookmark_voice.dart';
import 'package:archive/archive_io.dart'; // zip handling 
import 'package:path/path.dart' as p;
 
class Vv4rs{

  static Map<String, String?> myEngineForSSVoiceLang = {};
  static Map<String, String?> myEngineForVoiceLang = {};

  static dynamic saveMyEngineForSSVoiceLang(
    String language, 
    String? systemVoiceName, 
    String? sherpaOnnxVoiceId
  ) async {
    final prefs = await SharedPreferences.getInstance();

    if (systemVoiceName != null){
      return prefs.setString('myEngineForSSVoiceFor_$language', systemVoiceName);
    } 
    else if (sherpaOnnxVoiceId != null){
      return prefs.setString('myEngineForSSVoiceFor_$language', sherpaOnnxVoiceId);
    } 
  }

  static dynamic saveMyEngineForVoiceLang(
    String language, 
    bool sherpaOnnx,
    String engine,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    if (sherpaOnnx = false){
      return prefs.setString('myEngineForVoiceFor_$language', engine);
    } 
    else if (sherpaOnnx = true){
      return prefs.setString('myEngineForVoiceFor_$language', engine);
    } 
  }

//
// System Voice
//

  static List<Map<String, dynamic>> systemVoices = [];
  static Map<String, List<Map<String, dynamic>>> uniqueSystemVoices = {};

  static Future<dynamic> loadSystemVoices(TTSInterface tts) async {
    List<Map<String, dynamic>> allVoices = [];

    for (String lang in Sv4rs.myLanguages) {
      await tts.setLanguage(lang);
      final voiceList = await tts.getVoices();

      for (var v in voiceList) {
        final vm = Map<String, dynamic>.from(v as Map);

        allVoices.add({
          "name": vm["name"] ?? "",
          "identifier": vm["identifier"] ?? vm["voiceIdentifier"] ?? vm["name"],
          "language": vm["language"] ?? vm["locale"] ?? vm["lang"] ?? "",
          "locale": vm["locale"] ?? vm["language"] ?? vm["lang"] ?? "",
        });
      }
    }
     
    return Vv4rs.systemVoices = allVoices;
  }

  static String cleanSystemVoiceLabel(Map voice) {
    final name = voice['name'] ?? 'Unknown';
    final locale = voice['locale'] ?? '';
    return '$name ($locale)';
  }

  static void setupSystemVoicePicker(String language, String dropdownValue){
    //set the language of voices to look for 
        final localePrefix = V4rs.languageToLocalePrefix_(language);
        //get the list of voices
        final filteredVoices = Vv4rs.systemVoices.where((voice) {
          final voiceLang = (voice['language'] ?? '').toString().toLowerCase();
          return voiceLang.startsWith(localePrefix.toLowerCase());
        }).toList();

        //make sure there are no duplicate voices
        final seenVoices = <String>{};
        final unique = filteredVoices.where((voice) {
          final key = '${voice['name']}|${voice['language']}';
          if (seenVoices.contains(key)) {
            return false; // Skip duplicates
          } else {
            seenVoices.add(key);
            return true; // Keep unique voices
          }
        }).toList();

        uniqueSystemVoices[language] = unique;

        //find the current voice
        final currentValue = getSystemValue(language, 'voice');

        //set the voices
        final validVoiceValues = [
          'default',
          ...unique.map((voice) => voice['identifier']!)
        ];

        dropdownValue = (validVoiceValues.contains(currentValue) && (currentValue != null)) 
          ? currentValue 
          : 'default';
  }

  //speak on select voice  
    static Map<String, SystemVoice> speakSelectSystemLanguageVoice = {};  
    
    static Future<void> setSSlanguageVoiceSystem(
      String sslangVoice, 
      String? voice, 
      String? engine, 
      double? pitch,
      double? rate
    ) async {
      speakSelectSystemLanguageVoice[sslangVoice] 
        = SystemVoice(
          voice: voice, 
          engine: engine,
          pitch: pitch,
          rate: rate
        );

      if (speakSelectSystemLanguageVoice[sslangVoice]?.engine != null){
        myEngineForSSVoiceLang[sslangVoice] = speakSelectSystemLanguageVoice[sslangVoice]!.engine!;
        await saveMyEngineForSSVoiceLang(sslangVoice, myEngineForSSVoiceLang[sslangVoice], null);
      }

      await saveSystemSSValue(sslangVoice, "voice", voice);
      await saveSystemSSValue(sslangVoice, "engine", engine);
      await saveSystemSSValue(sslangVoice, "pitch", pitch);
      await saveSystemSSValue(sslangVoice, "rate", rate);
    }
    
    static dynamic getSystemSSValue(String langVoice, String value) {
      if (value == 'voice'){
        return speakSelectSystemLanguageVoice[langVoice]?.voice ?? '';
      } else if (value == 'engine'){
        return speakSelectSystemLanguageVoice[langVoice]?.engine ?? 'sherpa-onnx';
      } else if (value == 'pitch'){
        return speakSelectSystemLanguageVoice[langVoice]?.pitch ?? 1.0;
      } else if (value == 'rate'){
        return speakSelectSystemLanguageVoice[langVoice]?.rate ?? ((Platform.isIOS) ? 0.5 : 1.0);
      }
    }

    static dynamic saveSystemSSValue(String language, String value, dynamic saving) async {
      final prefs = await SharedPreferences.getInstance();

      if (value == 'voice'){
        return prefs.setString('system-tts-forSS-voice-$language', saving);
      } else if (value == 'engine'){
        return prefs.setString('system-tts-forSS-engine-$language', saving);
      } else if (value == 'pitch'){
        return prefs.setDouble('system-tts-forSS-pitch-$language', saving);
      } else if (value == 'rate'){
        return prefs.setDouble('system-tts-forSS-rate-$language', saving);
      } 
    }


  //speaking voice  
    static Map<String, SystemVoice> systemLanguageVoice = {};  
    
    static Future<void> setlanguageVoiceSystem(
      String langVoice, 
      String? voice, 
      String? engine, 
      double? pitch,
      double? rate,
    ) async {
        systemLanguageVoice[langVoice] 
          = SystemVoice(
            voice: voice, 
            engine: engine,
            pitch: pitch,
            rate: rate
          );

        if (systemLanguageVoice[langVoice]?.engine != null){
          myEngineForVoiceLang[langVoice] = systemLanguageVoice[langVoice]!.engine!;
          await saveMyEngineForVoiceLang(langVoice, false, myEngineForVoiceLang[langVoice]!);
        }
        
        await saveSystemValue(langVoice, "voice", voice);
        await saveSystemValue(langVoice, "engine", engine);
        await saveSystemValue(langVoice, "pitch", pitch);
        await saveSystemValue(langVoice, "rate", rate);
    }
    
    static dynamic getSystemValue(String langVoice, String value) {
      if (value == 'voice'){
        return systemLanguageVoice[langVoice]?.voice ?? '';
      } else if (value == 'engine'){
        return systemLanguageVoice[langVoice]?.engine ?? 'sherpa-onnx';
      } else if (value == 'pitch'){
        return systemLanguageVoice[langVoice]?.pitch ?? 1.0;
      } else if (value == 'rate'){
        return systemLanguageVoice[langVoice]?.rate ?? ((Platform.isIOS) ? 0.5 : 1.0);
      }
    }

    static dynamic saveSystemValue(String language, String value, dynamic saving) async {
      final prefs = await SharedPreferences.getInstance();

      if (value == 'voice'){
        return prefs.setString('system-tts-voice-$language', saving);
      } else if (value == 'engine'){
        return prefs.setString('system-tts-engine-$language', saving);
      } else if (value == 'pitch'){
        return prefs.setDouble('system-tts-pitch-$language', saving);
      } else if (value == 'rate'){
        return prefs.setDouble('system-tts-rate-$language', saving);
      } 
    }

//
// Sherpa-Onnx Voices
//

//the dropdown menu tkes the manifest model, and sets the class
  static ManifestModel? sampleSherpaOnnx;
  static int sampleSpeaker = 0;
  
  static List<ManifestModel> downloadedSherpaOnnxLanguageVoice = [];  
  static List<String> downloadedSherpaOnnxLanguageIds = [];  
  static final String _downloadedSherpaOnnxLanguageVoice = "_downloadedSherpaOnnxLanguageVoice";

  static Future<void> savedownloadedSherpaOnnxLanguageVoice (List<String> clearAfterSpeak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_downloadedSherpaOnnxLanguageVoice, downloadedSherpaOnnxLanguageIds);
  } 

  static var openVoices = [];
  static List<ManifestModel> allFilteredSherpaOnnx = [];

  static Map<String, List<ManifestModel>> perLangSherpaOnnxVoices = {};

  //returns list of sherpa-onnxin input lang
  static Future<List<ManifestModel>> filterSherpaOnnxLang(String lang) async {
    print('filterSherpaOnnxLang: start');
    final selectedLang = V4rs.getLangCode(lang);
    print('filterSherpaOnnxLang: selectedLang- $selectedLang');

    List<ManifestModel> allVoices = [];
    print('filterSherpaOnnxLang: all voices- $allVoices');
      for (ManifestModel voice in openVoices){
        print('filterSherpaOnnxLang: in for loop- voice- $voice');
        final voiceLanguage = (voice.language != null) 
          ? voice.language!.substring(0, 2)
          : '';
        final voiceLanguages = [];
          if (voice.languageList != null){
            for (final item in voice.languageList!){
              voiceLanguages.add(item.substring(0, 2));
            }
          }

        if (voice.engine == "sherpa-onnx" && (voiceLanguage == selectedLang || voiceLanguages.contains(selectedLang))) {
          allVoices.add(voice);
        }
      }
      print('filterSherpaOnnxLang: returning');
    return allFilteredSherpaOnnx = allVoices;
  }

  static String cleanSherpaOnnxVoiceLabel(ManifestModel voice) {
    final name = voice.name;
    final locale = 
      (voice.language != null)
      ? voice.language
      : voice.languageList.toString();
    final license = voice.license;
    return '$name ($locale) ($license)';
  }

  static String cleanSherpaOnnxSpeakerLabel(ManifestModel voice) {
    final name = voice.name;
    final sound = voice.sound;
    return '$name ($sound)';
  }

  static Future<List<ManifestModel>> setupSherpaOnnxVoicePicker(String language) async {
    //set the language of voices to look for 
    print('setupSherpaOnnxVoicePicker: starting');
    final voices = await filterSherpaOnnxLang(language);
    print('setupSherpaOnnxVoicePicker: set voices- $voices');

    //setup dropdowns
    return perLangSherpaOnnxVoices[language] = voices;
  }

 //speak on select voice  
    static Map<String, SherpaOnnxVoice> sherpaOnnxSSLanguageVoice = {};  
    
    static Future<void> setSSlanguageVoiceSherpaOnnx(
      String sslangVoice, 
      String? id,
      String? engine, 
      String? tokenPath,
      String? modelPath,
      int? speakerCount,
      int? speakerID,
      double? lengthScale,
      List<dynamic>? speakers,
      String? lexicon,
      String? farFiles,
      String? fstFiles,
      String? voicesBin,
      String? eSpeakPath,
    ) async {
      sherpaOnnxSSLanguageVoice[sslangVoice] 
        = SherpaOnnxVoice(
          id: id,
          engine: engine,
          tokenPath: tokenPath,
          modelVoice: modelPath,
          speakerCount: speakerCount,
          speakerID: speakerID,
          lengthScale: lengthScale,
          speakers: speakers,
          lexicon: lexicon,
          farFiles: farFiles,
          fstFiles: fstFiles,
          voicesBin: voicesBin,
          eSpeakPath: eSpeakPath,
        );

      if(sherpaOnnxSSLanguageVoice[sslangVoice]?.engine != null){
        myEngineForSSVoiceLang[sslangVoice] = sherpaOnnxSSLanguageVoice[sslangVoice]!.engine!;
        await saveMyEngineForSSVoiceLang(sslangVoice, null, myEngineForSSVoiceLang[sslangVoice]);
      }

      await saveSherpaOnnxValue(sslangVoice, "id", id, true);
      await saveSherpaOnnxValue(sslangVoice, "engine", engine, true);
      await saveSherpaOnnxValue(sslangVoice, "tokenPath", tokenPath, true);

      await saveSherpaOnnxValue(sslangVoice, "modelPath", modelPath, true);
      await saveSherpaOnnxValue(sslangVoice, "speakerCount", speakerCount, true);
      await saveSherpaOnnxValue(sslangVoice, "speakerID", speakerID, true);

      await saveSherpaOnnxValue(sslangVoice, "lengthScale", lengthScale, true);
      await saveSherpaOnnxValue(sslangVoice, "speakers", speakers, true);
      await saveSherpaOnnxValue(sslangVoice, "lexicon", lexicon, true);

      await saveSherpaOnnxValue(sslangVoice, "farFiles", farFiles, true);
      await saveSherpaOnnxValue(sslangVoice, "fstFiles", fstFiles, true);
      await saveSherpaOnnxValue(sslangVoice, "voicesBin", voicesBin, true);
      await saveSherpaOnnxValue(sslangVoice, "eSpeakPath", eSpeakPath, true);
    }
    
    static dynamic getSherpaOnnxValue(String langVoice, String value, bool forSS) {
      if (value == 'id'){
        if (forSS){
          return sherpaOnnxSSLanguageVoice[langVoice]?.id; 
        }
        else {
          return sherpaOnnxLanguageVoice[langVoice]?.id;
        }
      } 
      else if (value == 'tokenPath'){
        if (forSS){
          return sherpaOnnxSSLanguageVoice[langVoice]?.tokenPath;
        }
        else {
          return sherpaOnnxLanguageVoice[langVoice]?.tokenPath;
        }
      } 
      else if (value == 'modelVoice'){
        if (forSS){
          return sherpaOnnxSSLanguageVoice[langVoice]?.modelVoice;
        }
        else {
          return sherpaOnnxLanguageVoice[langVoice]?.modelVoice;
        }
      } 
      else if (value == 'engine'){
        if (forSS){
          return sherpaOnnxSSLanguageVoice[langVoice]?.engine ?? 'sherpa-onnx';
        }
        else {
          return sherpaOnnxLanguageVoice[langVoice]?.engine ?? 'sherpa-onnx';
        }
      } 
      else if (value == 'speakerCount'){
        if (forSS){
          return sherpaOnnxSSLanguageVoice[langVoice]?.speakerCount ?? 1;
        }
        else {
          return sherpaOnnxLanguageVoice[langVoice]?.speakerCount ?? 1;
        }
      } 
      else if (value == 'speakerID'){
        if (forSS){
          return sherpaOnnxSSLanguageVoice[langVoice]?.speakerID ?? 0;
        }
        else {
          return sherpaOnnxLanguageVoice[langVoice]?.speakerID ?? 0;
        }
      } 
      else if (value == 'lengthScale'){
        if (forSS){
          return sherpaOnnxSSLanguageVoice[langVoice]?.lengthScale ?? 1.0;
        }
        else {
          return sherpaOnnxLanguageVoice[langVoice]?.lengthScale ?? 1.0;
        }
      } 
      else if (value == 'speakers'){
        if (forSS){
          return sherpaOnnxSSLanguageVoice[langVoice]?.speakers;
        }
        else {
          return sherpaOnnxLanguageVoice[langVoice]?.speakers;
        }
      } 
      else if (value == 'lexicon'){
        if (forSS){
          return sherpaOnnxSSLanguageVoice[langVoice]?.lexicon;
        }
        else {
          return sherpaOnnxLanguageVoice[langVoice]?.lexicon;
        }
      } 
      else if (value == 'farFiles'){
        if (forSS){
          return sherpaOnnxSSLanguageVoice[langVoice]?.farFiles;
        }
        else {
          return sherpaOnnxLanguageVoice[langVoice]?.farFiles;
        }
      } 
      else if (value == 'fstFiles'){
        if (forSS){
          return sherpaOnnxSSLanguageVoice[langVoice]?.fstFiles;
        }
        else {
          return sherpaOnnxLanguageVoice[langVoice]?.fstFiles;
        }
      } 
      else if (value == 'voicesBin'){
        if (forSS){
          return sherpaOnnxSSLanguageVoice[langVoice]?.voicesBin;
        }
        else {
          return sherpaOnnxLanguageVoice[langVoice]?.voicesBin;
        }
      }
      else if (value == 'eSpeakPath'){
        if (forSS){
          return sherpaOnnxSSLanguageVoice[langVoice]?.eSpeakPath;
        }
        else {
          return sherpaOnnxLanguageVoice[langVoice]?.eSpeakPath;
        }
      }
    }

    static dynamic saveSherpaOnnxValue(String language, String value, dynamic saving, bool forSS) async {
      final prefs = await SharedPreferences.getInstance();

      if (value == 'id'){
        if (forSS){
          return prefs.setString('sherpa_onnx-tts-forSS-id-$language', saving);
        } else {
          return prefs.setString('sherpa_onnx-tts-id-$language', saving);
        }
      } 
      else if (value == 'tokenPath'){
        if (forSS){
          return prefs.setString('sherpa_onnx-tts-forSS-tokenPath-$language', saving);
        } else {
          return prefs.setString('sherpa_onnx-tts-tokenPath-$language', saving);
        }
      } 
      else if (value == 'modelVoice'){
        if (forSS){
          
          return prefs.setString('sherpa_onnx-tts-forSS-modelVoice-$language', saving);
        } else {
          
          return prefs.setString('sherpa_onnx-tts-modelVoice-$language', saving);
        }
      } 
      else if (value == 'engine'){
        if (forSS){
          return prefs.setString('sherpa_onnx-tts-forSS-engine-$language', saving);
        } else {
          return prefs.setString('sherpa_onnx-tts-engine-$language', saving);
        }
      } 
      else if (value == 'speakerID'){
        if (forSS){
          
          return prefs.setInt('sherpa_onnx-tts-forSS-speakerID-$language', saving);
        } else {
          
          return prefs.setInt('sherpa_onnx-tts-speakerID-$language', saving);
        }
      } 
      else if (value == 'lengthScale'){
        if (forSS){
          
          return prefs.setDouble('sherpa_onnx-tts-forSS-lengthScale-$language', saving ?? 1.0);
        } else {
          if (saving != null) {
            return prefs.setDouble('sherpa_onnx-tts-lengthScale-$language', saving ?? 1.0);
          }
        }
      }
      else if (value == 'lexicon'){
        if (forSS){
          
          return prefs.setString('sherpa_onnx-tts-forSS-lexicon-$language', saving ?? '');
        } else {
          
          return prefs.setString('sherpa_onnx-tts-lexicon-$language', saving ?? '');
        }
      }
      else if (value == 'farFiles'){
        if (forSS){
          
          return prefs.setString('sherpa_onnx-tts-forSS-farFiles-$language', saving ?? '');
        } else {
          
          return prefs.setString('sherpa_onnx-tts-farFiles-$language', saving ?? '');
        }
      }
      else if (value == 'fstFiles'){
        if (forSS){
          
          return prefs.setString('sherpa_onnx-tts-forSS-fstFiles-$language', saving ?? '');
        } else {
          
          return prefs.setString('sherpa_onnx-tts-fstFiles-$language', saving ?? '');
        }
      }
      else if (value == 'voicesBin'){
        if (forSS){
          
          return prefs.setString('sherpa_onnx-tts-forSS-voicesBin-$language', saving);
        } else {
          
          return prefs.setString('sherpa_onnx-tts-voicesBin-$language', saving);
        }
      }
      else if (value == 'speakerCount'){
        if (forSS){
          
          return prefs.setInt('sherpa_onnx-tts-forSS-speakerCount-$language', saving);
        } else {
          
          return prefs.setInt('sherpa_onnx-tts-speakerCount-$language', saving);
        }
      }
    }

    static dynamic saveDownloadedSherpaOnnxValue(
      String voiceID, 
      String? onnxPath,
      String? voicesBin,
      String? ruleFsts,
      String? ruleFars,
      String? lexicon,
      String? tokenPath,
      String? eSpeakPath,
    ) async {
      final prefs = await SharedPreferences.getInstance();
      if (onnxPath != null && onnxPath.isNotEmpty){
        await prefs.setString('sherpa_onnx-download-onnxPath-$voiceID', onnxPath);
      }
      if (voicesBin != null && voicesBin.isNotEmpty){
        await prefs.setString('sherpa_onnx-download-voicesBin-$voiceID', voicesBin);
      }
      if (ruleFsts != null && ruleFsts.isNotEmpty){
        await prefs.setString('sherpa_onnx-download-ruleFsts-$voiceID', ruleFsts);
      }
      if (ruleFars != null && ruleFars.isNotEmpty){
        await prefs.setString('sherpa_onnx-download-ruleFars-$voiceID', ruleFars);
      }
      if (lexicon != null && lexicon.isNotEmpty){
        await prefs.setString('sherpa_onnx-download-lexicon-$voiceID', lexicon);
      }
      if (tokenPath != null && tokenPath.isNotEmpty){
        await prefs.setString('sherpa_onnx-download-tokenPath-$voiceID', tokenPath);
      }
      if (eSpeakPath != null && eSpeakPath.isNotEmpty){
        await prefs.setString('sherpa_onnx-download-eSpeakPath-$voiceID', eSpeakPath);
      }
    }

  //speaking voice  
    static Map<String, SherpaOnnxVoice> sherpaOnnxLanguageVoice = {}; 
    
    static Future<void> setlanguageVoiceSherpaOnnx(
      String langVoice, 
      String? id,
      String? engine, 
      String? tokenPath,
      String? modelPath,
      int? speakerCount,
      int? speakerID,
      double? lengthScale,
      List<dynamic>? speakers,
      String? lexicon,
      String? farFiles,
      String? fstFiles,
      String? voicesBin,
      String? eSpeakPath,
    ) async {
      sherpaOnnxLanguageVoice[langVoice] 
        = SherpaOnnxVoice(
          id: id,
          tokenPath: tokenPath,
          modelVoice: modelPath,
          speakerCount: speakerCount,
          engine: engine,
          speakerID: speakerID,
          lengthScale: lengthScale,
          speakers: speakers,
          lexicon: lexicon,
          farFiles: farFiles,
          fstFiles: fstFiles,
          voicesBin: voicesBin,
          eSpeakPath: eSpeakPath,
        );
      
      if(sampleSherpaOnnx != null && sampleSherpaOnnx?.engine != null){
        myEngineForVoiceLang[langVoice] = sampleSherpaOnnx?.engine;
        await saveMyEngineForVoiceLang(langVoice, true, myEngineForVoiceLang[langVoice]!);
      }

      await saveSherpaOnnxValue(langVoice, "id", id, false);
      await saveSherpaOnnxValue(langVoice, "tokenPath", tokenPath, false);
      await saveSherpaOnnxValue(langVoice, "modelPath", modelPath, false);
      await saveSherpaOnnxValue(langVoice, "engine", 'sherpa-onnx', false);
      await saveSherpaOnnxValue(langVoice, "speakerID", speakerID, false);
      await saveSherpaOnnxValue(langVoice, "lengthScale", lengthScale, false);
      await saveSherpaOnnxValue(langVoice, "lexicon", lexicon, false);
      await saveSherpaOnnxValue(langVoice, "farFiles", farFiles, false);
      await saveSherpaOnnxValue(langVoice, "fstFiles", fstFiles, false);
      await saveSherpaOnnxValue(langVoice, "voicesBin", voicesBin, false);
      await saveSherpaOnnxValue(langVoice, "eSpeakPath", eSpeakPath, false);
    }
    

// Test phrases
  static const testPhrases = {
    'English': 'Hello, this is a test phrase.',
    '中文': '你好，这是一句测试短语。',
    'Española': 'Hola, esta es una frase de prueba.',
    'Français': 'Bonjour, ceci est une phrase de test.',
    // add more here
  };

//
// Load Voice Manifest
//

  static List<ManifestModel> _parseVoices(dynamic manifestJson) {
    final voicesList = manifestJson["voices"] as List;
    return voicesList.map((v) => ManifestModel.fromJson(v)).toList();
  }

  static Future<List<ManifestModel>> fetchVoiceManifest() async {
    const url = "https://raw.githubusercontent.com/earth-pheonix/Flutterkeys/main/assets/voices/manifest.json";

    try {
      // Try online first
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final manifestJson = json.decode(response.body);
        return _parseVoices(manifestJson);
      } else {
        throw Exception("HTTP error ${response.statusCode}");
      }

    } catch (e) {

      // Load from assets fallback
      final fallback = await rootBundle.loadString("assets/voices/manifest.json");
      final manifestJson = json.decode(fallback);

      return _parseVoices(manifestJson);
    }
  }

//
// Download & Pick voice
//

static ValueNotifier<bool> isDownloading = ValueNotifier(false);
static ValueNotifier<String> downloadMessage = ValueNotifier('');

static void setupIsDownloadingListener(){
  isDownloading.addListener((){
    if (isDownloading.value == false){
      Future.delayed(const Duration(seconds: 5), () {
        downloadMessage.value = '';
      });
    }
  });
}

static late final String globalVocoderPath;

static Future<void> initGlobalVocoder() async {
  final dir = await getApplicationDocumentsDirectory();
  final vocoderFile = File(p.join(dir.path, 'vocos-22khz-univ.onnx'));

  if (!await vocoderFile.exists()) {
    final data = await rootBundle.load(
      'assets/voices/vocos-22khz-univ.onnx',
    );
    await vocoderFile.writeAsBytes(
      data.buffer.asUint8List(),
      flush: true,
    );
  }

  globalVocoderPath = vocoderFile.path;
}

static Future<ManifestModel?> downloadSherpaOnnxVoice(ManifestModel voice) async {
  isDownloading.value = true;
  try {
    downloadMessage.value = 'Download starting...';
    final dir = await getApplicationDocumentsDirectory();
    final savePath = "${dir.path}/sherpaOnnx_models";
    final voiceFolder = "$savePath/${voice.id}"; //model dir
    final onnxPath = "$voiceFolder/${voice.id}.onnx"; //model name
    final voicesBin = "$voiceFolder/${voice.id}-voices.bin"; //voices file if kokoro
    final tokenPath = "$voiceFolder/tokens.txt"; //tokens
    final eSpeakNgFolder = "$voiceFolder/eSpeak-ng"; //data dir
    final listOfFst = [];
    final listOfFar = [];
    final listOfLexicon = [];
    final zipPath = "$voiceFolder/${voice.id}.zip";


    await Directory(savePath).create(recursive: true);
    await Directory(voiceFolder).create(recursive: true);

    
    if (voice.downloadURL == null) {
      downloadMessage.value = 'download URL empty- download failed';
      return null;
    }

    // Download zip
    final zipFile = File(zipPath);

    // 1. Create HTTP client and request
    final client = http.Client();
    final request = http.Request('GET', Uri.parse(voice.downloadURL!));

    // 2. Send the request and get a streamed response
    final response = await client.send(request);

    downloadMessage.value = 'Opening Zip...';

    // 3. Open file sink and pipe the streamed response directly to disk
    final fileSink = zipFile.openWrite();

    downloadMessage.value = 'Getting Data.. (this can take up to 20 minutes)...';

    await response.stream.pipe(fileSink);
    await fileSink.close();

    
    // Unzip
    final inputStream = InputFileStream(zipPath);
    final archive = ZipDecoder().decodeBuffer(inputStream);


    for (final file in archive) {
      final filename = file.name;

      // Skip MacOS resource-fork garbage files
      if (filename.startsWith("__MACOSX") || filename.split('/').last.startsWith("._")) {
        continue;
      }

      // Special handling for .onnx file
      if (file.isFile && filename.toLowerCase().endsWith(".onnx")) {
        if (filename.contains('acoustic')){
          final outFile = File("$voiceFolder/${voice.id}-acoustic.onnx");
          final sink = outFile.openWrite();

          file.decompress();

          final content = file.content;

          if (content is List<int>) {
            sink.add(content);
          }

          await sink.close();
          downloadMessage.value = 'Download starting... .onnx downloaded';
          continue;

        } else if (filename.contains('vocoder')){
          final outFile = File("$voiceFolder/${voice.id}-vocoder.onnx");
          final sink = outFile.openWrite();

          file.decompress();

          final content = file.content;

          if (content is List<int>) {
            sink.add(content);
          }

          await sink.close();
          downloadMessage.value = 'Download starting... .onnx downloaded';
          continue;

        } else {
          final outFile = File(onnxPath);
          final sink = outFile.openWrite();

          file.decompress();

          final content = file.content;

          if (content is List<int>) {
            sink.add(content);
          }

          await sink.close();
          downloadMessage.value = 'Download starting... .onnx downloaded';
          continue;
        }
      }

      // Special handling for voices.bin file
      if (file.isFile &&  filename.toLowerCase().endsWith("voices.bin")) {
        final outFile = File(voicesBin);
        final sink = outFile.openWrite();

        file.decompress();

        final content = file.content;

        if (content is List<int>){
          sink.add(content);
        } 

        await sink.close();
        downloadMessage.value = 'Download starting... voices.bin downloaded';
        continue;
      }

      // Special handling for tokens.txt
      if (file.isFile && filename.toLowerCase().endsWith("tokens.txt")) {
        final outFile = File(tokenPath);
        final sink = outFile.openWrite();

        file.decompress();

        final content = file.content;

        if (content is List<int>){
          sink.add(content);
        } else {
        }

        await sink.close();
        downloadMessage.value = 'Download starting... tokens.txt downloaded';
        continue;
      }

      // extraction of fst + list to save
      if (file.isFile &&  filename.toLowerCase().endsWith(".fst")) {
        final fstPaths = "$voiceFolder/$filename";
        if (file.isFile) {
          final outFile = File(fstPaths);
          final sink = outFile.openWrite();

          file.decompress();

          final content = file.content;

          if (content is List<int>) {
            sink.add(content);   // write bytes directly
          } 

          await sink.close();
          listOfFst.add(fstPaths);

        } else {
          await Directory(fstPaths).create(recursive: true);
        }
        downloadMessage.value = 'Download starting... .fst added';
        continue;
      }

      // extraction of .far + list to save
      if (file.isFile &&  filename.toLowerCase().endsWith(".far")) {
        final farPaths = "$voiceFolder/$filename";
        if (file.isFile) {
          final outFile = File(farPaths);
          final sink = outFile.openWrite();

          file.decompress();

          final content = file.content;

          if (content is List<int>) {
            sink.add(content);   // write bytes directly
          } 

          await sink.close();
          listOfFst.add(farPaths);

        } else {
          await Directory(farPaths).create(recursive: true);
        }
        downloadMessage.value = 'Download starting... .far downloaded';
        continue;
      }

      // extraction of lexicon + list to save
      if (filename.toLowerCase().contains("lexicon") && filename.toLowerCase().endsWith(".txt")) {
        final lexPaths = "$voiceFolder/$filename";
        if (file.isFile) {
          final outFile = File(lexPaths);
          final sink = outFile.openWrite();

          file.decompress();

          final content = file.content;

          if (content is List<int>) {
            sink.add(content);   // write bytes directly
          } 

          await sink.close();
          listOfLexicon.add(lexPaths);
        } else {
          await Directory(lexPaths).create(recursive: true);
        }
        downloadMessage.value = 'Download starting... lexicon.txt downloaded';
        continue;
      }

      // extraction of eSpeak folder
      if (filename.toLowerCase().contains("espeak-ng-data/")) {
        // Find the actual relative path inside the espeak folder
        final startIndex = filename.toLowerCase().indexOf("espeak-ng-data/") + "espeak-ng-data/".length;
        final relative = filename.substring(startIndex); // e.g. "phontab"

        final outPath1 = "$eSpeakNgFolder/$relative";

        if (file.isFile) {
          final outFile = File(outPath1);
          final sink = outFile.openWrite();

          file.decompress();

          final content = file.content;

          if (content is List<int>) {
            sink.add(content);   // write bytes directly
          } else {
          }
          await sink.close();
        } else {
          await Directory(outPath1).create(recursive: true);
        }
        downloadMessage.value = 'Download starting... eSpeak NG added';
        continue;
      }

      // Normal extraction for all other files
      final outPath = "$voiceFolder/$filename";
      if (file.isFile) {
        final outFile = File(outPath);
        final sink = outFile.openWrite();

          file.decompress();

          final content = file.content;

          if (content is List<int>) {
            sink.add(content);   // write bytes directly
          } else {
          }
          await sink.close();
      } else {
        await Directory(outPath).create(recursive: true);
      }
    }

    downloadMessage.value = 'All files downloaded... getting values';

    await zipFile.delete();

    voice.modelPath = onnxPath;
    voice.voicesBin = voicesBin;
    voice.ruleFsts = listOfFst.join(", ");
    voice.ruleFars = listOfFar.join(", ");
    voice.lexicon = listOfLexicon.join(", ");
    voice.tokenPath = tokenPath;
    voice.eSpeakPath = eSpeakNgFolder;

    downloadedSherpaOnnxLanguageVoice.add(voice);

    if (voice.id != null) {
      downloadedSherpaOnnxLanguageIds.add(voice.id!);

      saveDownloadedSherpaOnnxValue(
        voice.id!,
        voice.modelPath,
        voice.voicesBin,
        voice.ruleFsts,
        voice.ruleFars,
        voice.lexicon,
        voice.tokenPath,
        voice.eSpeakPath,
      );
    }

    savedownloadedSherpaOnnxLanguageVoice(downloadedSherpaOnnxLanguageIds);

    isDownloading.value = false;
    downloadMessage.value = 'Done';
    return voice;

  } catch (e) {
    downloadMessage.value = 'Download failed: $e';
    isDownloading.value = false;
    return null;
  }
}


  //
  //LOADING SAVED VALUES
  //

  static Future<void> loadSavedVoiceValues() async {
    final prefs = await SharedPreferences.getInstance();
    // how to clear a value from shared prefs:  
    // await prefs.remove('_downloadedSherpaOnnxLanguageVoice');

    initGlobalVocoder();

    //
    //Get Manifest
    //

      openVoices = await Vv4rs.fetchVoiceManifest();


    //
    //Get downloaded sherpa voice model and token paths
    //

      final ids = prefs.getStringList('_downloadedSherpaOnnxLanguageVoice') ?? [];
      final map = { for (var v in openVoices) v.id!: v };
      downloadedSherpaOnnxLanguageVoice =
          ids.map((id) => map[id]).whereType<ManifestModel>().toList();

      for (final voice in Vv4rs.downloadedSherpaOnnxLanguageVoice) {
        voice.modelPath = prefs.getString('sherpa_onnx-download-onnxPath-${voice.id}');
        voice.voicesBin = prefs.getString('sherpa_onnx-download-voicesBin-${voice.id}');
        voice.ruleFsts = prefs.getString('sherpa_onnx-download-ruleFsts-${voice.id}');
        voice.ruleFars = prefs.getString('sherpa_onnx-download-ruleFars-${voice.id}');
        voice.lexicon = prefs.getString('sherpa_onnx-download-lexicon-${voice.id}');
        voice.tokenPath = prefs.getString('sherpa_onnx-download-tokenPath-${voice.id}');
        voice.eSpeakPath = prefs.getString('sherpa_onnx-download-eSpeakPath-${voice.id}');
      }
    
    
    //
    //Get Selected Voices
    //

    for (final lang in Sv4rs.myLanguages) {

      Vv4rs.myEngineForSSVoiceLang[lang] = prefs.getString('myEngineForSSVoiceFor_$lang');
      Vv4rs.myEngineForVoiceLang[lang] = prefs.getString('myEngineForVoiceFor_$lang');
      
      Vv4rs.systemLanguageVoice[lang] = SystemVoice();
      Vv4rs.systemLanguageVoice[lang]?.voice = prefs.getString('system-tts-voice-$lang');
      Vv4rs.systemLanguageVoice[lang]?.engine = prefs.getString('system-tts-engine-$lang');
      Vv4rs.systemLanguageVoice[lang]?.pitch = prefs.getDouble('system-tts-pitch-$lang');
      Vv4rs.systemLanguageVoice[lang]?.rate = prefs.getDouble('system-tts-rate-$lang');

      Vv4rs.speakSelectSystemLanguageVoice[lang] = SystemVoice();
      Vv4rs.speakSelectSystemLanguageVoice[lang]?.voice = prefs.getString('system-tts-forSS-voice-$lang');
      Vv4rs.speakSelectSystemLanguageVoice[lang]?.engine = prefs.getString('system-tts-forSS-engine-$lang');
      Vv4rs.speakSelectSystemLanguageVoice[lang]?.pitch = prefs.getDouble('system-tts-forSS-pitch-$lang');
      Vv4rs.speakSelectSystemLanguageVoice[lang]?.rate = prefs.getDouble('system-tts-forSS-rate-$lang');
      
      Vv4rs.sherpaOnnxLanguageVoice[lang] = SherpaOnnxVoice();
      Vv4rs.sherpaOnnxLanguageVoice[lang]?.id = prefs.getString('sherpa_onnx-tts-id-$lang');
      Vv4rs.sherpaOnnxLanguageVoice[lang]?.tokenPath = prefs.getString('sherpa_onnx-tts-tokenPath-$lang');
      Vv4rs.sherpaOnnxLanguageVoice[lang]?.modelVoice = prefs.getString('sherpa_onnx-tts-modelVoice-$lang');
      Vv4rs.sherpaOnnxLanguageVoice[lang]?.engine = prefs.getString('sherpa_onnx-tts-engine-$lang');
      Vv4rs.sherpaOnnxLanguageVoice[lang]?.speakerID = prefs.getInt('sherpa_onnx-tts-speakerID-$lang');
      Vv4rs.sherpaOnnxLanguageVoice[lang]?.lengthScale = prefs.getDouble('sherpa_onnx-tts-lengthScale-$lang');
      Vv4rs.sherpaOnnxLanguageVoice[lang]?.lengthScale = prefs.getDouble('sherpa_onnx-tts-lengthScale-$lang');
      Vv4rs.sherpaOnnxLanguageVoice[lang]?.lexicon = prefs.getString('sherpa_onnx-tts-lexicon-$lang');
      Vv4rs.sherpaOnnxLanguageVoice[lang]?.farFiles = prefs.getString('sherpa_onnx-tts-farFiles-$lang');
      Vv4rs.sherpaOnnxLanguageVoice[lang]?.fstFiles = prefs.getString('sherpa_onnx-tts-fstFiles-$lang');
      Vv4rs.sherpaOnnxLanguageVoice[lang]?.voicesBin = prefs.getString('sherpa_onnx-tts-voicesBin-$lang');
      
      Vv4rs.sherpaOnnxSSLanguageVoice[lang] = SherpaOnnxVoice();
      Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.id = prefs.getString('sherpa_onnx-tts-forSS-id-$lang');
      Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.tokenPath = prefs.getString('sherpa_onnx-tts-forSS-tokenPath-$lang');
      Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.modelVoice = prefs.getString('sherpa_onnx-tts-forSS-modelVoice-$lang');
      Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.engine = prefs.getString('sherpa_onnx-tts-forSS-engine-$lang');
      Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.speakerID = prefs.getInt('sherpa_onnx-tts-forSS-speakerID-$lang');
      Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.lengthScale = prefs.getDouble('sherpa_onnx-tts-forSS-lengthScale-$lang');
      Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.lexicon = prefs.getString('sherpa_onnx-tts-forSS-lexicon-$lang');
      Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.farFiles = prefs.getString('sherpa_onnx-tts-forSS-farFiles-$lang');
      Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.fstFiles = prefs.getString('sherpa_onnx-tts-forSS-fstFiles-$lang');
      Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.voicesBin = prefs.getString('sherpa_onnx-tts-forSS-voicesBin-$lang');
      
    //
    //Get Bookmarked Voices
    //
      BVv4rs.loadSavedBookmarkedVoiceValues(lang);
    }
  }
}

class SystemVoice{
  String? voice;
  String? engine;
  double? pitch;
  double? rate;

  SystemVoice({
    this.voice, 
    this.engine,
    this.pitch,
    this.rate
  });
}

class SherpaOnnxVoice{
  String? id; //name of voice, also name of file folder
  String? engine;
  String? modelVoice; //onnx path
  int? speakerCount;
  String? voicesBin; //voices.bin path
  String? fstFiles; //collectuon of fsts file paths seperated by ,
  String? farFiles; //collectuon of fars file paths seperated by ,
  String? lexicon; //collectuon of fars file paths seperated by ,
  String? tokenPath; //token path
  double? lengthScale; //rate
  int? speakerID; //speaker int
  List<dynamic>? speakers;
  String? eSpeakPath;


  SherpaOnnxVoice({
    this.id,
    this.engine,
    this.speakerCount,
    this.voicesBin,
    this.fstFiles,
    this.farFiles,
    this.lexicon,
    this.tokenPath,
    this.modelVoice,
    this.lengthScale,
    this.speakerID,
    this.speakers,
    this.eSpeakPath
  });
}

class DownloadedSherpaOnnx{
  String? onnxPath;
  String? voicesBin;
  String? ruleFsts;
  String? ruleFars;
  String? lexicon;
  String? tokenPath;
  String? eSpeakPath;

  DownloadedSherpaOnnx({
    this.onnxPath,
    this.voicesBin,
    this.lexicon,
    this.tokenPath,
    this.eSpeakPath,
    this.ruleFsts,
    this.ruleFars,
  });
  
}