import 'package:flutter/widgets.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/settings/voice_variables.dart';

class BVv4rs{
  //system, sherpa-onnx, delete a bookmark, load

  static ValueNotifier<Map<String, int>> bookmarkedCount = ValueNotifier({});

  static Map<String, List<dynamic>> bookmarkedVoices = {}; 
  
  static Future<void> savebookmarkedCount (int bookmarkedCount, String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("bookmarkedCount-$lang", bookmarkedCount);
  } 


//
//System
//

  static String findSystemVoiceName(String language, String? voice) {
    if (voice == null){
      return '';
    }
    final localePrefix = V4rs.languageToLocalePrefix_(language);

    final filteredVoices = Vv4rs.systemVoices.where((v) {
      final voiceLang = (v['language'] ?? '').toString().toLowerCase();
      return voiceLang.startsWith(localePrefix.toLowerCase());
    }).toList();

    // Remove duplicates
    final seenVoices = <String>{};
    final uniqueVoices = filteredVoices.where((v) {
      final key = '${v['name']}|${v['language']}';
      return seenVoices.add(key);
    }).toList();

    // Handle default explicitly
    if (voice == 'default') {
      return 'Default';
    }

    // Find the matching voice map
    final selectedVoice = uniqueVoices.firstWhere(
      (v) => v['identifier'] == voice,
      orElse: () => {},
    );

    if (selectedVoice.isEmpty) {
      return 'Unknown Voice';
    }

    return Vv4rs.cleanSystemVoiceLabel(selectedVoice);
  }


  static Future<void> setBookmarkedVoiceSystem(
    String langVoice, 
    String? voice, 
    String? engine, 
    double? pitch,
    double? rate
  ) async {
    //add
      if (bookmarkedVoices[langVoice] == null){
        bookmarkedVoices[langVoice] = [];
      }
      bookmarkedVoices[langVoice]!.add(
        SystemVoice(
          voice: voice, 
          engine: engine,
          pitch: pitch,
          rate: rate
        )
      );


    //set the count
      bookmarkedCount.value = Map.from(bookmarkedCount.value)..[langVoice] = (bookmarkedVoices[langVoice]?.length ?? 0);
      await savebookmarkedCount(bookmarkedCount.value[langVoice]!, langVoice);

      final int index = (bookmarkedVoices[langVoice]?.length ?? 1) - 1;
      await saveBookmarkedSystemValue(langVoice, "voice", voice, index);
      await saveBookmarkedSystemValue(langVoice, "engine", engine, index);
      await saveBookmarkedSystemValue(langVoice, "pitch", pitch, index);
      await saveBookmarkedSystemValue(langVoice, "rate", rate, index);
  }

  static dynamic saveBookmarkedSystemValue(String language, String value, dynamic saving, int number) async {
    final prefs = await SharedPreferences.getInstance();

    if (value == 'voice'){
      return prefs.setString('system-tts-voice-bookmark-$language-$number', saving);
    } else if (value == 'engine'){
      return prefs.setString('engine-bookmark-$language-$number', saving);
    } else if (value == 'pitch'){
      return prefs.setDouble('system-tts-pitch-bookmark-$language-$number', saving);
    } else if (value == 'rate'){
      return prefs.setDouble('system-tts-rate-bookmark-$language-$number', saving);
    } 
  }

//
// Sherpa-Onnx
//


    static String findSherpaVoiceName(String language, String voiceID) {
      for (final voice in Vv4rs.perLangSherpaOnnxVoices[language]!){
        if (voice.id == Vv4rs.sherpaOnnxLanguageVoice[language]?.id){
           final locale = 
            (voice.language != null)
            ? voice.language
            : voice.languageList.toString();
          return '${voice.name} ($locale)';
        } 
      } 
      return '';
    }



    static Future<void> setBookmarkedVoiceSherpaOnnx(
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
      //set the value
      if (bookmarkedVoices[langVoice] == null){
        bookmarkedVoices[langVoice] = [];
      }
        bookmarkedVoices[langVoice]!.add(
          SherpaOnnxVoice(
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
          ),
        );

        //set the count
        bookmarkedCount.value = Map.from(bookmarkedCount.value)..[langVoice] = (bookmarkedVoices[langVoice]?.length ?? 0);
        savebookmarkedCount(bookmarkedCount.value[langVoice]!, langVoice);

        final int index = (bookmarkedVoices[langVoice]?.length ?? 1) - 1;
        await saveBookmarkedSherpaOnnxValue(langVoice, "id", id, false, index);
        await saveBookmarkedSherpaOnnxValue(langVoice, "tokenPath", tokenPath, false, index);
        await saveBookmarkedSherpaOnnxValue(langVoice, "modelPath", modelPath, false, index);
        await saveBookmarkedSherpaOnnxValue(langVoice, "engine", engine, false, index);
        await saveBookmarkedSherpaOnnxValue(langVoice, "speakerID", speakerID, false, index);
        await saveBookmarkedSherpaOnnxValue(langVoice, "lengthScale", lengthScale, false, index);
        await saveBookmarkedSherpaOnnxValue(langVoice, "lexicon", lexicon, false, index);
        await saveBookmarkedSherpaOnnxValue(langVoice, "farFiles", farFiles, false, index);
        await saveBookmarkedSherpaOnnxValue(langVoice, "fstFiles", fstFiles, false, index);
        await saveBookmarkedSherpaOnnxValue(langVoice, "voicesBin", voicesBin, false, index);
        await saveBookmarkedSherpaOnnxValue(langVoice, "eSpeakPath", eSpeakPath, false, index);
    }
    

    static dynamic saveBookmarkedSherpaOnnxValue(String language, String value, dynamic saving, bool forSS, int i) async {
      final prefs = await SharedPreferences.getInstance();

      if (value == 'id'){
        if (forSS){
          return prefs.setString('sherpa_onnx-tts-forSS-id-bookmark-$language-$i', saving);
        } else {
          return prefs.setString('sherpa_onnx-tts-id-bookmark-$language-$i', saving);
        }
      } 
      else if (value == 'tokenPath'){
        if (forSS){
          return prefs.setString('sherpa_onnx-tts-forSS-tokenPath-bookmark-$language-$i', saving);
        } else {
          return prefs.setString('sherpa_onnx-tts-tokenPath-bookmark-$language-$i', saving);
        }
      } 
      else if (value == 'modelVoice'){
        if (forSS){
          return prefs.setString('sherpa_onnx-tts-forSS-modelVoice-bookmark-$language-$i', saving);
        } else {
          return prefs.setString('sherpa_onnx-tts-modelVoice-bookmark-$language-$i', saving);
        }
      } 
      else if (value == 'engine'){
        if (forSS){
          return prefs.setString('sherpa_onnx-tts-forSS-engine-bookmark-$language-$i', saving);
        } else {
          return prefs.setString('engine-bookmark-$language-$i', saving);
        }
      } 
      else if (value == 'speakerID'){
        if (forSS){
          return prefs.setInt('sherpa_onnx-tts-forSS-speakerID-bookmark-$language-$i', saving);
        } else {
          return prefs.setInt('sherpa_onnx-tts-speakerID-bookmark-$language-$i', saving);
        }
      } 
      else if (value == 'lengthScale'){
        if (forSS){
          return prefs.setDouble('sherpa_onnx-tts-forSS-lengthScale-bookmark-$language-$i', saving ?? 0.0);
        } else {
          if (saving != null) {
            return prefs.setDouble('sherpa_onnx-tts-lengthScale-bookmark-$language-$i', saving ?? 0.0);
          }
        }
      }
      else if (value == 'lexicon'){
        if (forSS){
          return prefs.setString('sherpa_onnx-tts-forSS-lexicon-bookmark-$language-$i', saving ?? '');
        } else {
          return prefs.setString('sherpa_onnx-tts-lexicon-bookmark-$language-$i', saving ?? '');
        }
      }
      else if (value == 'farFiles'){
        if (forSS){
          return prefs.setString('sherpa_onnx-tts-forSS-farFiles-bookmark-$language-$i', saving ?? '');
        } else {
          return prefs.setString('sherpa_onnx-tts-farFiles-bookmark-$language-$i', saving ?? '');
        }
      }
      else if (value == 'fstFiles'){
        if (forSS){
          return prefs.setString('sherpa_onnx-tts-forSS-fstFiles-bookmark-$language-$i', saving ?? '');
        } else {
          return prefs.setString('sherpa_onnx-tts-fstFiles-bookmark-$language-$i', saving ?? '');
        }
      }
      else if (value == 'voicesBin'){
        if (forSS){
          return prefs.setString('sherpa_onnx-tts-forSS-voicesBin-bookmark-$language-$i', saving);
        } else {
          return prefs.setString('sherpa_onnx-tts-voicesBin-bookmark-$language-$i', saving);
        }
      }
      else if (value == 'speakerCount'){
        if (forSS){
          return prefs.setInt('sherpa_onnx-tts-forSS-speakerCount-bookmark-$language-$i', saving);
        } else {
          return prefs.setInt('sherpa_onnx-tts-speakerCount-bookmark-$language-$i', saving);
        }
      }
    }

//
//Delete a bookmark
//
  
  static Future<void> deleteBookmarked(int delete, String lang) async {
    if (bookmarkedVoices[lang] != null) {
      bookmarkedVoices[lang]!.removeAt(delete);
      await rewriteBookmarkedVoices(lang);

      bookmarkedCount.value = Map.from(bookmarkedCount.value)..[lang] = bookmarkedVoices[lang]!.length;
      await savebookmarkedCount(bookmarkedCount.value[lang]!, lang);
    }
  }

  static Future<void> rewriteBookmarkedVoices(String lang) async {
    await clearBookmarkedPrefs(lang);

    int index = 0;
    if (bookmarkedVoices[lang] != null){
      for (final entry in bookmarkedVoices[lang]!) {
        if (entry is SherpaOnnxVoice){
          await saveBookmarkedSherpaOnnxValue(lang, "id", entry.id, false, index);
          await saveBookmarkedSherpaOnnxValue(lang, "engine", entry.engine, false, index);
          await saveBookmarkedSherpaOnnxValue(lang, "tokenPath", entry.tokenPath, false, index);
          await saveBookmarkedSherpaOnnxValue(lang, "modelPath", entry.modelVoice, false, index);
          await saveBookmarkedSherpaOnnxValue(lang, "speakerID", entry.speakerID, false, index);
          await saveBookmarkedSherpaOnnxValue(lang, "lengthScale", entry.lengthScale, false, index);
          await saveBookmarkedSherpaOnnxValue(lang, "lexicon", entry.lexicon, false, index);
          await saveBookmarkedSherpaOnnxValue(lang, "farFiles", entry.farFiles, false, index);
          await saveBookmarkedSherpaOnnxValue(lang, "fstFiles", entry.fstFiles, false, index);
          await saveBookmarkedSherpaOnnxValue(lang, "voicesBin", entry.voicesBin, false, index);
          await saveBookmarkedSherpaOnnxValue(lang, "eSpeakPath", entry.eSpeakPath, false, index);
        } else 
        if (entry is SystemVoice){
          await saveBookmarkedSystemValue(lang, "voice", entry.voice, index);
          await saveBookmarkedSystemValue(lang, "engine", entry.engine, index);
          await saveBookmarkedSystemValue(lang, "pitch", entry.pitch ?? 1.0, index);
          await saveBookmarkedSystemValue(lang, "rate", entry.rate ?? 0.5, index);
        }

        index++;
      }
    }
  }

  static Future<void> clearBookmarkedPrefs(String lang) async {
    final prefs = await SharedPreferences.getInstance();

    final count = prefs.getInt('bookmarkedCount-$lang') ?? 0;

    for (int i = 0; i < count; i++) {
      await prefs.remove('system-tts-voice-bookmark-$lang-$i');
      await prefs.remove('engine-bookmark-$lang-$i');
      await prefs.remove('system-tts-pitch-bookmark-$lang-$i');
      await prefs.remove('system-tts-rate-bookmark-$lang-$i');
      await prefs.remove('sherpa_onnx-tts-id-bookmark-$lang-$i');
      await prefs.remove('sherpa_onnx-tts-tokenPath-bookmark-$lang-$i');
      await prefs.remove('sherpa_onnx-tts-modelVoice-bookmark-$lang-$i');
      await prefs.remove('engine-bookmark-$lang-$i');
      await prefs.remove('sherpa_onnx-tts-speakerID-bookmark-$lang-$i');
      await prefs.remove('sherpa_onnx-tts-lengthScale-bookmark-$lang-$i');
      await prefs.remove('sherpa_onnx-tts-lexicon-bookmark-$lang-$i');
      await prefs.remove('sherpa_onnx-tts-farFiles-bookmark-$lang-$i');
      await prefs.remove('sherpa_onnx-tts-fstFiles-bookmark-$lang-$i');
      await prefs.remove('sherpa_onnx-tts-voicesBin-bookmark-$lang-$i');
    }
  }


//
//Load
//

  static Future<void> loadSavedBookmarkedVoiceValues(String lang) async {
    
    final prefs = await SharedPreferences.getInstance();

    bookmarkedCount.value[lang] = (prefs.getInt('bookmarkedCount-$lang') ?? 0);
    for (int i=0; i< (bookmarkedCount.value[lang] ?? 0); i ++){

      if (bookmarkedVoices[lang] == null){
        bookmarkedVoices[lang] = [];
      }

      final String engine = prefs.getString('engine-bookmark-$lang-$i') ?? '';
      
      if (engine == 'system'){
        bookmarkedVoices[lang]!.add(
          SystemVoice(
            engine: prefs.getString('engine-bookmark-$lang-$i'),
            voice: prefs.getString('system-tts-voice-bookmark-$lang-$i'),
            pitch: prefs.getDouble('system-tts-pitch-bookmark-$lang-$i'),
            rate: prefs.getDouble('system-tts-rate-bookmark-$lang-$i'),
          ),
        );
      } else if (engine == 'sherpa-onnx'){
        bookmarkedVoices[lang]!.add(
          SherpaOnnxVoice(
            id: prefs.getString('sherpa_onnx-tts-id-bookmark-$lang-$i'),
            tokenPath: prefs.getString('sherpa_onnx-tts-tokenPath-bookmark-$lang-$i'),
            modelVoice: prefs.getString('sherpa_onnx-tts-modelVoice-bookmark-$lang-$i'),
            engine: prefs.getString('sherpa_onnx-tts-engine-bookmark-$lang-$i'),
            speakerID: prefs.getInt('sherpa_onnx-tts-speakerID-bookmark-$lang-$i'),
            lengthScale: prefs.getDouble('sherpa_onnx-tts-lengthScale-bookmark-$lang-$i'),
            lexicon: prefs.getString('sherpa_onnx-tts-lexicon-bookmark-$lang-$i'),
            farFiles: prefs.getString('sherpa_onnx-tts-farFiles-bookmark-$lang-$i'),
            fstFiles: prefs.getString('sherpa_onnx-tts-fstFiles-bookmark-$lang-$i'),
            voicesBin: prefs.getString('sherpa_onnx-tts-voicesBin-bookmark-$lang-$i'),
          )
        );
      }
    }
  
  }
}

                    