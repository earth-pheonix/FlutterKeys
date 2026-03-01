
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/highlight_message_window.dart';
import 'package:flutterkeysaac/Variables/history.dart';
import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/search_variables.dart';
import 'package:flutterkeysaac/Variables/settings/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Variables/fonts/font_variables.dart';
import 'package:flutterkeysaac/Variables/export_variables.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Variables/settings/voice_variables.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:flutterkeysaac/Variables/settings/speak_on_select.dart';
import 'package:flutterkeysaac/Variables/sherpa_onnx_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;

class V4rs {

//dimenssion, onboarding, message window, search, boardset variables
//storage chest, 
//interface font, language stuff, navigation variables, sub folders, functions for saving, 
//speak functions, showOr helper, button type map, special gestures, 
//json, loading saved values

//
//Dimensions
//

  static bool xSmallModeWidth = false;
  static bool xSmallModeHeight = false;
  static bool xSmallMode = false;
  static bool smallEditorMode = false;
  static bool isLandscape = true;

  static double keyboardheight = 0.0;
  static final String _keyboardheight = "keyboardheight";  

  static double paddingValue(double padding){
    if (xSmallModeWidth || xSmallModeHeight){
      return (padding / 3).roundToDouble();
    } else {
      return padding;
    }
  }
  static double editorPaddingValue(double padding){
    if (smallEditorMode){
      return (padding / 3).roundToDouble();
    } else {
      return padding;
    }
  }

  static double fontValue(double size){
    if (xSmallModeWidth || xSmallModeHeight){
      return (size - 5).roundToDouble();
    } else {
      return size;
    }
  }

//
//Onboarding
//
  static ValueNotifier<bool> doOnboarding = ValueNotifier(true);
  static final String _doOnboarding = "doOnboarding";

//
//Message window variables
//

  //for sherpa-onnx
  static double? wordsPerMinute; 
  static Duration? pauseMoment;
  static String? currentSpeakingFile;
  static bool isVoiceLoaded = false; 

  static bool changedMWfromButton = false;

  static  ValueNotifier<String> message = ValueNotifier("");

  static ValueNotifier<bool> wasPaused = ValueNotifier(false);

  static ValueNotifier<bool> theIsSpeaking = ValueNotifier(false);

  static bool clearAfterSpeak = true;
  static final String _clearAfterSpeak = "_clearAfterSpeak";

  static Future<void> saveClearAfterSpeak (bool clearAfterSpeak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_clearAfterSpeak, clearAfterSpeak);
  } 

  static bool showLanguageSelectorSlider = true;
  static final String _showLanguageSelectorSlider = "_showLanguageSelectorSlider";

  static Future<void> saveshowLanguageSelectorSlider (bool showLanguageSelectorSlider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showLanguageSelectorSlider, showLanguageSelectorSlider);
  } 

  static bool showScrollButtons = true;
  static final String _showScrollButtons = "_showScrollButtons";

  static Future<void> saveshowScrollButtons (bool showScrollButtons) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showScrollButtons, showScrollButtons);
  } 

//
//search
//
  static BoardObjects? thisBoard;
  static ValueNotifier<List<String>> searchPathUUIDS = ValueNotifier([]);

  static bool isSearchPath(List<String> uuids, BoardObjects? obj){
    if (obj != null) {
      if (uuids.contains(obj.id) || uuids.contains(obj.linkToUUID)){
        return true;
      } 
    }
    return false;
  }

  static bool isSearchPathNav(List<String> uuids, NavObjects? obj){
    if (obj != null) {
      if (uuids.contains(obj.linkToUUID)){
        return true;
      } 
    }
    return false;
  }

  static void updateSearchPath(List<String> map, String location){
    if (SeV4rs.openSearch.value) {
      if (map.contains(location)){
        map.remove(location);
      }
      if (map.isEmpty){
        SeV4rs.openSearch.value = false;
        SeV4rs.findAndPick.value = false;
      }
      V4rs.searchPathUUIDS.value = List.from(map);
    }
  }

//
//boardset variables
//

static File? currentFile;
static final String _currentFile = "currentFile";

static Future<void> saveCurrentFileSelection (File currentFile) async {
    final prefs = await SharedPreferences.getInstance();
    final fileName = p.basename(currentFile.path);
    await prefs.setString(_currentFile, fileName);
  } 

static List<File> myBoardsets = [];
static final String _myBoardsets = "myBoardsets";

static Future<void> saveMyBoardsets (List<File> myBoardsets) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList(_myBoardsets, myBoardsets.map((f) => basename(f.path)).toList());
}

//
//storage chest 
//
  static bool isStoringOpen = true;
  static final String _isStoringOpen = "_isStoringOpen";

  static Future<void> saveIsStoringOpen (bool isStoringOpen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isStoringOpen, isStoringOpen);
  } 

  static String storedMessage = '';
  static final String _storedMessage = "_storedMessage";

  static Future<void> saveStoredMessage (String storedMessage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storedMessage, storedMessage);
  }

//
//language stuff (more in settings variables)
//
  static List <String> allInterfaceLanguages = ['English', ];

  static ValueNotifier<String> selectedLanguage = ValueNotifier(interfaceLanguage);
  static final String _selectedLanguage = "selectedLanguage";

  static String interfaceLanguage = "English";
  static final String _interfaceLanguage = "interfaceLangauge";
  
  static String languageToLocalePrefix_(String language) {
    switch (language.toLowerCase()) {
      case 'english':
        return 'en';
      case 'española':
        return 'es';
      case 'français':
        return 'fr';
      case '中文':
        return 'zh';
      default:
        return '';
    }
  }

//
//Navigation variables 
//
  static ValueNotifier<bool> showExpandPage = ValueNotifier(false);
  static ValueNotifier<bool> showSettings = ValueNotifier(false);
  
  static int syncIndex = 0;

  static void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

//
//Pinned Page
//

  static String pinnedPageLinkedUUID = '';
  static String pinnedPageLabel = '';
  static final String _pinnedPageLinkedUUID = "pinnedPageLinkedUUID";
  static final String _pinnedPageLabel = "pinnedPageLabel";

  static Future<void> savePinnedPageInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinnedPageLinkedUUID, pinnedPageLinkedUUID);
    await prefs.setString(_pinnedPageLabel, pinnedPageLabel);
  } 


//
//sub folders
//
  static bool primaryUseSubFolders = true;
  static final String _primaryUseSubFolders = "primaryUseSubFolders";

   static Future<void> saveUseSubFolders (bool primaryUseSubFolders) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_primaryUseSubFolders, primaryUseSubFolders);
  } 


// 
//Functions for saving values
//
  static Future<void> savekeyboardheight (double keyboardheight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyboardheight, keyboardheight);
  } 

  static Future<void> saveSelectedLang (String selectedLanguage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLanguage, selectedLanguage);
  } 

  static Future<void> saveInterfaceLang (String interfaceLangauge) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_interfaceLanguage, interfaceLangauge);
  } 

  static Future<void> setOnboardingCompleteStatus(bool doOnboarding) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_doOnboarding, doOnboarding);
  }

//
//Speak functions
// 
  static List<Map<String, String>> identifyLanguageSegments(String text, String defaultLanguage) {
    String normalizePeriods(String text) {
      return text.replaceAll(RegExp(r'[。．܂܁﹒։۔።᠃᠉⳹⳾]'), '.');
    }
    final normalized = normalizePeriods(text).toLowerCase();
    final tagRegExp = RegExp(r'\.([a-z]{2,3})\.(.*?)\.([a-z]{2,3})\.', dotAll: true);
    
    final segments = <Map<String, String>>[];
    int lastMatch = 0;
    for (final match in tagRegExp.allMatches(normalized)) {
      final langStart = match.start;
      final langEnd = match.end;

      if (langStart > lastMatch) {
        segments.add ({
          'lang': defaultLanguage,
          'text': normalizePeriods(text.substring(lastMatch, langStart)),
        });
      }
      final openTag = match.group(1);
      final closeTag = match.group(3);

      if (openTag == closeTag) {
        final String language = getLangName(openTag!);
        segments.add ({
          'lang': language,
          'text': normalizePeriods(match.group(2) ?? ''),
        });
      }
      lastMatch = langEnd;
    }
    if (lastMatch < text.length) {
        segments.add ({
          'lang': defaultLanguage,
          'text': normalizePeriods(text.substring(lastMatch)),
        });
      }
    return segments;
  } 

  static Map<String, String> langCodeToName = {
    'en': 'English',
    'zh': '中文',
    'es': 'Española',
    'fr': 'Français',
  };

  static Map<String, String> langNameToCode = {
    'English': 'en',
    '中文': 'zh',
    'Española': 'es',
    'Français': 'fr',
  };

  static String getLangName(String code) {
    return langCodeToName[code] ?? code;
  }

  static String getLangCode(String lang) {
    return langNameToCode[lang] ?? lang;
  }

  static Future<void> messageWindowSpeak (
    String text, 
    String deafultLang, 
    TTSInterface tts,
    Map<String, sherpa_onnx.OfflineTts?>? sherpaOnnxSynth,
    Future<void> Function() init,
    AudioPlayer player,
  ) async {
    if (text != '' && HistoryV4rs.useHistory){
      HistoryV4rs.messageHistory.add(text);
      HistoryV4rs.saveMessageHistory(HistoryV4rs.messageHistory);
      if (HistoryV4rs.openHistory.value == true){
        HistoryV4rs.messageHistoryPages.value = HistoryV4rs.getMessageHistoryPages();
      }
    }

    final segments = identifyLanguageSegments(text, deafultLang);
    
    for (final langKey in sherpaOnnxSynth!.keys) {
      if (sherpaOnnxSynth[langKey] != null) {
        await init();
      }
    }

    //setup highlight offset
    HV4rs.resetHighlightStart();
    HV4rs.enableHighlighting.value = true;
    int cumulativeStart = 0;

    for (final segment in segments) {
      //multilingual handling
      final lang = segment['lang']!;
      final langName = getLangName(lang);
      String segmentText = segment['text']!;

      //pronunciation excemptions 
      const Map<String, String> pronunciationExceptions = {
        "I": "eye",
        "Pheonix" : "Phoenix",
      };
      if (pronunciationExceptions.containsKey(segmentText.trim())) {
        segmentText = pronunciationExceptions[segmentText.trim()]!;
      }

      //set highlight offset
      HV4rs.setHighlightStart(cumulativeStart);

      //
      //System Engine
      //
      if (Vv4rs.myEngineForVoiceLang[lang] == "system") {
        //set voice properties
        final voiceID = Vv4rs.getSystemValue(langName, 'voice');
        final rate = Vv4rs.getSystemValue(langName, 'rate');
        final pitch = Vv4rs.getSystemValue(langName, 'pitch');
      
        //for system engines set up WPM based highlighting or callback based
        if (Platform.isIOS){
          HV4rs.useWPM.value = false;
        } else {
          HV4rs.useWPM.value = true;
          HV4rs.currentWPM = (150 * rate).toDouble();
        }
      
        //find selected voice
        final allVoices = await tts.getVoices();
        final matchingVoice = allVoices.firstWhere(
          (v) => v['identifier'] == voiceID,
          orElse: () => <String, String>{},
        );
        final voiceName = matchingVoice['name'] ?? 'default';

        //if found set
        HV4rs.subscribeWordStream(tts);
        if (voiceName != null) {
          await tts.setVoice({
            'identifier': voiceID ?? 'default',
          });
          await tts.setRate(rate);
          await tts.setPitch(pitch);
          await tts.speak(segmentText);
        }
      } 

      //
      //Sherpa Onnx Engine
      //
      else {
        await SherpaOnnxV4rs.speak(false, lang, segmentText, player);
      }

      //move offset to next segment
      cumulativeStart += segmentText.length;
    }

    //cleanup
    HV4rs.resetHighlightStart();
    if (clearAfterSpeak == true && !wasPaused.value) {
      message.value = "";
    }
    HV4rs.enableHighlighting.value = false;
 } 

  static Future<void> mwSpeakWithSSRestore(
    String text, 
    String lang, 
    TTSInterface tts,
    Map<String, sherpa_onnx.OfflineTts?>? sherpaOnnxSynth,
    Future<void> Function() init,
    AudioPlayer player,
  ) async {
  // Save SS voice settings
  final currentSSVoice = Vv4rs.getSystemSSValue(lang, 'voice');
  final currentSSRate = Vv4rs.getSystemSSValue(lang, 'rate');
  final currentSSPitch = Vv4rs.getSystemSSValue(lang, 'pitch');

  // Call MW speak (uses regular voices)
  wasPaused.value = false;
  await messageWindowSpeak(text, lang, tts, sherpaOnnxSynth, init, player);

  // Validate voice ID before restoring
  final allVoices = await tts.getVoices();
  final voiceIDs = allVoices.map((v) => v['identifier']).toSet();

  final shouldRestoreVoice =
      currentSSVoice != null && currentSSVoice != 'default' && voiceIDs.contains(currentSSVoice);

  if (shouldRestoreVoice) {
    await tts.setVoice({'identifier': currentSSVoice});
    await tts.setRate(currentSSRate);
    await tts.setPitch(currentSSPitch);
  } 
}

// speak on select 
  static Future<void> speakOnSelect (
    String text, 
    String deafultLang, 
    TTSInterface tts,
    Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth,
    Future<void> Function() init,
    AudioPlayer playerForSS,
  ) async {

   final segments = identifyLanguageSegments(text, deafultLang);
     
    for (final langKey in speakSelectSherpaOnnxSynth!.keys) {
      if (speakSelectSherpaOnnxSynth[langKey] != null) {
        await init();
      }
    }
     
    for (final segment in segments) {
      final lang = segment['lang']!;
      String segmentText = segment['text']!;

      //pronounciation exception code start
      const Map<String, String> pronunciationExceptions = {
      "I": "eye",
      "Pheonix" : "Phoenix",
       };

      if (pronunciationExceptions.containsKey(segmentText.trim())) {
        segmentText = pronunciationExceptions[segmentText.trim()]!;
      }
      //pronouncistaion exception code end 

      final langName = getLangName(lang);

      if (Vv4rs.myEngineForSSVoiceLang[lang] == "system"){
        final voiceID = Sv4rs.useDifferentVoiceforSS 
          ? Vv4rs.getSystemSSValue(langName, 'voice') 
          : Vv4rs.getSystemValue(langName, 'voice');
        final rate = Sv4rs.useDifferentVoiceforSS 
          ? Vv4rs.getSystemSSValue(langName, 'rate') 
          : Vv4rs.getSystemValue(langName, 'rate');
        final pitch = Sv4rs.useDifferentVoiceforSS 
          ? Vv4rs.getSystemSSValue(langName, 'pitch') 
          : Vv4rs.getSystemValue(langName, 'pitch');

        final allVoices = await tts.getVoices();

        final matchingVoice = allVoices.firstWhere(
          (v) => v['identifier'] == voiceID,
          orElse: () => <String, String>{},
        );

        final voiceName = matchingVoice['name'] ?? 'default';

        if (voiceName != null) {
          await tts.setVoice({
            'identifier': voiceID ?? 'default',
          });
          await tts.setRate(rate);
          await tts.setPitch(pitch);
          await tts.speak(segmentText);
          V4rs.theIsSpeaking.value = false;
        }
    } else {
      await SherpaOnnxV4rs.speak(true, lang, text, playerForSS);
    }
  }
 } 

  //
  //helpers for speak on select checkboxes  
  //
    //anything over 1 is true
    static bool intToBool(int value) => value != 1;
    //true = 2, false = 1
    static int boolToInt2(bool value) => value ? 2 : 1;
    //true = 3, false = 1
    static int boolToInt3(bool value) => value ? 3 : 1;


//
//showOr helper
//
  static bool showOrAsBool(int showOr) {
    if (showOr == 1) { return true; } else
    if (showOr == 2) { return false; } else
    {return true;}
  }

//
//use sub folders helpers
//
   static bool useSubFoldersAsBool(int useSubFolders) {
    if (useSubFolders == 1) { return true; } else
    if (useSubFolders == 2) { return false; } else
    if (useSubFolders == 3) {return primaryUseSubFolders;} else
    {return true;}
  }

//
//button
//

static void addToMessage(BoardObjects obj){
  V4rs.changedMWfromButton = true;
  V4rs.message.value = V4rs.message.value + (obj.message ?? '');
  if (HistoryV4rs.trackTaps){
    
  }
  V4rs.changedMWfromButton = false;
}

static Map<String, int> buttonTypeMap = {
  'button': 1,
  'pocket folder': 2,
  'folder': 3,
  'audio tile' : 4,
  'typing key': 5,
  'grammar button': 6,
};
static String typeToLabel(int type) {
  const labels = {
    1: 'button',
    2: 'pocket folder',
    3: 'folder',
    4: 'audio tile',
    5: 'typing key',
    6: 'grammar button',
  };

  return labels[type] ?? 'unknown';
}

//
//special gestures
//
  static bool useSwipeUpShortcut = false;
  static final String _useSwipeUpShortcut = 'useSwipeUpShortcut';
  static Future<void> saveuseSwipeUpShortcut (bool useSwipeUpShortcut) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useSwipeUpShortcut, useSwipeUpShortcut);
  } 

  static bool useLongTapOr = false;
   static final String _useLongTapOr = 'useLongTapOr';
  static Future<void> saveuseLongTapOr (bool useLongTapOr) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useLongTapOr, useLongTapOr);
  } 

  static int longTapDuration = 700;
   static final String _longTapDuration = 'longTapDuration';
  static Future<void> savelongTapDuration (int longTapDuration) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_longTapDuration, longTapDuration);
  } 

  static int doubleTapClickSpeed = 400;
  static final String _doubleTapClickSpeed = 'doubleTapClickSpeed';
  static Future<void> savedoubleTapClickSpeed (int doubleTapClickSpeed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_doubleTapClickSpeed, doubleTapClickSpeed);
  } 


//
// json
//
static Future<Root> loadRootData() async {
  if (currentFile != null) { 
    final file = currentFile;

    final jsonString = await file!.readAsString();
    final jsonMap = jsonDecode(jsonString);
    
    return Root.fromJson(jsonMap);

  } else {
  // Path for local copy
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/magma_vocab.json');

  if (await file.exists()) {
    // load from local copy if it exists
    final jsonString = await file.readAsString();
    final jsonMap = jsonDecode(jsonString);

    currentFile = file;
    saveCurrentFileSelection(currentFile!);

    if (!myBoardsets.contains(file)){
      myBoardsets.add(file);
      saveMyBoardsets(myBoardsets);
    }

    return Root.fromJson(jsonMap);
  } else {
    // load from bundled asset if it doesnt
    final jsonString = await rootBundle.loadString('lib/Json/magma_vocab.json');
    final jsonMap = jsonDecode(jsonString);

    // save local copy
    await file.writeAsString(jsonString);

    currentFile = file;
    saveCurrentFileSelection(currentFile!);

    if (!myBoardsets.contains(file)){
      myBoardsets.add(file);
      saveMyBoardsets(myBoardsets);
    }

    return Root.fromJson(jsonMap);
  }
}
}

static Future<Root> simpleLoadRootData() async {
  // Path for local copy
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/magma_vocab.json');

  if (await file.exists()) {
    // load from local copy if it exists
    final jsonString = await file.readAsString();
    final jsonMap = jsonDecode(jsonString);
    
    return Root.fromJson(jsonMap);
  } else {
    // load from bundled asset if it doesnt
    final jsonString = await rootBundle.loadString('lib/Json/magma_vocab.json');
    final jsonMap = jsonDecode(jsonString);

    // save local copy
    await file.writeAsString(jsonString);

    return Root.fromJson(jsonMap);
  }
}

static Future<Root> loadJsonTemplates() async {
  // Path for local copy
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/templates.json');

  if (await file.exists()) {
    // load from local copy
    final jsonString = await file.readAsString();
    final jsonMap = jsonDecode(jsonString);
    return Root.fromJson(jsonMap);
  } else {
    // load from bundled asset
    final jsonString = await rootBundle.loadString('lib/Json/templates.json');
    final jsonMap = jsonDecode(jsonString);

    // save local copy
    await file.writeAsString(jsonString);
    return Root.fromJson(jsonMap);
  }
}

static Future<void> deleteLocalCopy() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/magma_vocab.json');

  if (await file.exists()) {
    await file.delete();
    currentFile = null;
    myBoardsets.clear();
    saveMyBoardsets(myBoardsets);
    
    await loadRootData();
    ExV4rs.fileToExport = currentFile;
  } 
}

static Future<void> deleteLocalCopytemplates() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/templates.json');

  if (await file.exists()) {
    await file.delete();
  } 
}

static Future<File> resolveImageFile(String relativePath) async {
  final dir = await getApplicationDocumentsDirectory();
  return File(p.join(dir.path, relativePath));
}
  
  //
  //LOADING SAVED VALUES
  //

  static bool variablesReady = false;

  static Future<void> loadSavedValues() async {
    variablesReady = false;
    final prefs = await SharedPreferences.getInstance();
    // how to clear a value from shared prefs:  
    //await prefs.remove('myBoardsets');
    //clear all values from prefs
   //await prefs.clear();

    //reset Json on load
    deleteLocalCopy(); 
    deleteLocalCopytemplates();

    await Fv4rs.loadSavedFontValues(); 
    await Cv4rs.loadSavedColorValues();
    await Bv4rs.loadSavedBoardsetValues();
    await ExV4rs.loadSavedExportValues();
    await Vv4rs.loadSavedVoiceValues();
    await BSSv4rs.loadSavedBookmarkedSSValues();
    await HistoryV4rs.loadSavedHistoryValues();

    //load the boardsets
    final myBoardsetNames = prefs.getStringList(_myBoardsets);
    if (myBoardsetNames != null) {
      final dir = await getApplicationDocumentsDirectory();
       myBoardsets = prefs.getStringList(_myBoardsets)?.map((file) => File('${dir.path}/$file')).toList() ?? [];
    }

    final filename = prefs.getString(_currentFile);
    if (filename != null) {
      final dir = await getApplicationDocumentsDirectory();
      currentFile = File('${dir.path}/$filename');
    }

    //load pinned page info
    pinnedPageLinkedUUID = prefs.getString(_pinnedPageLinkedUUID) ?? '';
    pinnedPageLabel = prefs.getString(_pinnedPageLabel) ?? '';


    //all the other variables to load
    
    showScrollButtons = prefs.getBool(_showScrollButtons) ?? true;
    showLanguageSelectorSlider = prefs.getBool(_showLanguageSelectorSlider) ?? true;

    doOnboarding.value = prefs.getBool(_doOnboarding) ?? true; // Default to true if not set
    keyboardheight = prefs.getDouble(_keyboardheight) ?? 250.0;

    Sv4rs.useDifferentVoiceforSS = prefs.getBool(Sv4rs.useDifferentVoiceforSS_) ?? false;
    Sv4rs.speakInterfaceButtonsOnSelect = prefs.getBool(Sv4rs.speakInterfaceButtonsOnSelect_) ?? false;

    interfaceLanguage = prefs.getString(_interfaceLanguage) ?? 'English';
    selectedLanguage.value = prefs.getString(_selectedLanguage) ?? interfaceLanguage;


    Sv4rs.alertCount = prefs.getInt(Sv4rs.alertCount_) ?? 3;
    Sv4rs.firstAlert = prefs.getString(Sv4rs.firstAlert_) ?? '.en. I have something to say .en.';
    Sv4rs.secondAlert = prefs.getString(Sv4rs.secondAlert_) ?? '.en. one second .en.';
    Sv4rs.thirdAlert = prefs.getString(Sv4rs.thirdAlert_) ?? '.en. I made a mistake .en.';
    
    useSwipeUpShortcut = prefs.getBool(_useSwipeUpShortcut) ?? false;
    useLongTapOr = prefs.getBool(_useLongTapOr) ?? false;
    longTapDuration = prefs.getInt(_longTapDuration) ?? longTapDuration;
    doubleTapClickSpeed = prefs.getInt(_doubleTapClickSpeed) ?? doubleTapClickSpeed;
    
    final storedLangs = prefs.getStringList('my_languages');
    Sv4rs.myLanguages = storedLangs?.toSet() ?? {'English'};
    Sv4rs.useLanguageOverlays = prefs.getBool(Sv4rs.useLanguageOverlays_) ?? false;

    isStoringOpen = prefs.getBool(_isStoringOpen) ?? true;
    storedMessage = prefs.getString(_storedMessage) ?? '';

    primaryUseSubFolders = prefs.getBool(_primaryUseSubFolders) ?? true;

    Sv4rs.pickFromEngine = prefs.getString(Sv4rs.pickFromEngine_) ?? 'sherpa-onnx';
    
    variablesReady = true;
  }

}
