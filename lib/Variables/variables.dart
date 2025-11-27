
import 'package:flutterkeysaac/Variables/color_variables.dart';
import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterkeysaac/Variables/settings_variable.dart';
import 'package:flutterkeysaac/Variables/search_variables.dart';
import 'package:flutterkeysaac/Variables/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Variables/more_font_variables.dart';
import 'package:flutterkeysaac/Variables/export_variables.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;


class V4rs {

//dimenssion, onboarding, message window, search, boardset variables
//storage chest, 
//interface font, language stuff, navigation variables, sub folders, functions for saving, 
//speak functions, showOr helper, button type map, special gestures, 
//json, loading saved values

//
//Dimensions
//
  static double screenheight = 0.0;
  static final String _screenheight = "screenheight";
  
  static double screenwidth = 0.0;
  static final String _screenwidth = "screenwidth";

  static double keyboardheight = 0.0;
  static final String _keyboardheight = "keyboardheight";  

//
//Onboarding
//
  static ValueNotifier<bool> doOnboarding = ValueNotifier(true);
  static final String _doOnboarding = "doOnboarding";

//
//Message window variables
//
  static bool changedMWfromButton = false;

  static  ValueNotifier<String> message = ValueNotifier("");

  static ValueNotifier<bool> wasPaused = ValueNotifier(false);

  static bool highlightAsSpoken = !kIsWeb && Platform.isIOS;
  static final String _highlightAsSpoken = "highlightAsSpoken";

  static Future<void> saveHighlightAsSpoken (bool highlightAsSpoken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_highlightAsSpoken, highlightAsSpoken);
  } 

  static final highlightStart = ValueNotifier<int>(0);
  
  static void resetHighlightStart() {
    highlightStart.value = 0;
  }

  static void setHighlightStart(int where){
    highlightStart.value += where;
  }

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
//interface font settings 
//
  static TextStyle get interfacelabelStyle =>  TextStyle(color: V4rs.interfaceFontColor, fontSize: 16, fontFamily: '');

  //font family
  static String interfaceFont = 'Default';
  static final String _interfaceFont = "interfaceFont";

   static Future<void> saveInterfaceFont (String interfaceFont) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_interfaceFont, interfaceFont);
  } 

  //interfaceFontSize
  static double interfaceFontSize = 16;
  static final String _interfaceFontSize = "interfaceFontSize";

   static Future<void> saveInterfaceFontSize (double interfaceFontSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_interfaceFontSize, interfaceFontSize);
  } 
  //interfaceFontWeight
  static int interfaceFontWeight = 400;
  static final String _interfaceFontWeight = "interfaceFontweight";

   static Future<void> saveInterfaceFontWeight (int interfaceFontWeight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_interfaceFontWeight, interfaceFontWeight);
  } 

  //interfaceFontItalics
  static bool interfaceFontItalics = false;
  static final String _interfaceFontItalics = "interfaceFontItalics";

   static Future<void> saveInterfaceFontItalics (bool interfaceFontItalics) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_interfaceFontItalics, interfaceFontItalics);
  } 

   //interfaceFontColor
  static Color interfaceFontColor = Cv4rs.themeColor1;
  static final String _interfaceFontColor = "interfaceFontColor";

   static Future<void> saveInterfaceFontColor (Color interfaceFontColor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_interfaceFontColor, interfaceFontColor.toARGB32());
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
  static Future<void> savescreenheight(double screenheight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_screenheight, screenheight);
  } 
  static Future<void> savescreenwidth (double screenwidth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_screenwidth, screenwidth);
  } 
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
        segments.add ({
          'lang': openTag!,
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

  static String getLangName(String code) {
    return langCodeToName[code] ?? code;
  }

  static Future<void> universalSpeak (String text, String deafultLang, TTSInterface tts,) async {
   final segments = identifyLanguageSegments(text, deafultLang);
     for (final segment in segments) {
      final lang = segment['lang']!;
      final segmentText = segment['text']!;

      final langName = getLangName(lang);
      final voiceID = Sv4rs.getLangVoice(langName);
      final rate = Sv4rs.getLangRate(langName);
      final pitch = Sv4rs.getLangPitch(langName);

      final allVoices = await tts.getVoices();

      final matchingVoice = allVoices.firstWhere(
        (v) => v['identifier'] == voiceID,
        orElse: () => <String, String>{},
      );

      final voiceName = matchingVoice['name'] ?? 'default';

    if (voiceName != null) {
     // await tts.setLanguage(lang);
      await tts.setVoice({
        'identifier': voiceID ?? 'default',
      });
      await tts.setRate(rate);
      await tts.setPitch(pitch);
      
      await tts.speak(segmentText);

      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return tts.isSpeaking.value;
      });
    }
  }
 } 

  static Future<void> universalSpeakWithSSRestore(String text, String lang, TTSInterface tts) async {
    // Save SS voice settings
    final currentSSVoice = Sv4rs.getSSLangVoice(lang);
    final currentSSRate = Sv4rs.getSSLangRate(lang);
    final currentSSPitch = Sv4rs.getssLangPitch(lang);

    // Call universal speak (uses regular voices)
    await universalSpeak(text, lang, tts);

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

  static Future<void> messageWindowSpeak (String text, String deafultLang, TTSInterface tts,) async {
   final segments = identifyLanguageSegments(text, deafultLang);
     resetHighlightStart();
     int cumulativeStart = 0;

     for (final segment in segments) {
      final lang = segment['lang']!;
      final segmentText = segment['text']!;

      setHighlightStart(cumulativeStart);

      final langName = getLangName(lang);
      final voiceID = Sv4rs.getLangVoice(langName);
      final rate = Sv4rs.getLangRate(langName);
      final pitch = Sv4rs.getLangPitch(langName);

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
      await tts.onDone.first;
      cumulativeStart += segmentText.length;
    }
  }
    resetHighlightStart();
    if (clearAfterSpeak == true && !wasPaused.value) {
    message.value = "";
  }

 } 

  static Future<void> mwSpeakWithSSRestore(String text, String lang, TTSInterface tts) async {
  // Save SS voice settings
  final currentSSVoice = Sv4rs.getSSLangVoice(lang);
  final currentSSRate = Sv4rs.getSSLangRate(lang);
  final currentSSPitch = Sv4rs.getssLangPitch(lang);

  // Call universal speak (uses regular voices)
  wasPaused.value = false;
  await messageWindowSpeak(text, lang, tts);

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
  static Future<void> speakOnSelect (String text, String deafultLang, TTSInterface tts) async {
   final segments = identifyLanguageSegments(text, deafultLang);
     for (final segment in segments) {
      final lang = segment['lang']!;
      String segmentText = segment['text']!;

      //pronounciation exception code start
      const Map<String, String> pronunciationExceptions = {
      "I": "eye",
       };

      if (pronunciationExceptions.containsKey(segmentText.trim())) {
        segmentText = pronunciationExceptions[segmentText.trim()]!;
      }
      //pronouncistaion exception code end 

      final langName = getLangName(lang);
      final voiceID = Sv4rs.useDifferentVoiceforSS ? Sv4rs.getSSLangVoice(langName) : Sv4rs.getLangVoice(langName);
      final rate = Sv4rs.useDifferentVoiceforSS ? Sv4rs.getSSLangRate(langName) : Sv4rs.getLangRate(langName);
      final pitch = Sv4rs.useDifferentVoiceforSS ? Sv4rs.getssLangPitch(langName) : Sv4rs.getLangPitch(langName);

      final allVoices = await tts.getVoices();

      final matchingVoice = allVoices.firstWhere(
        (v) => v['identifier'] == voiceID,
        orElse: () => <String, String>{},
      );

      final voiceName = matchingVoice['name'] ?? 'default';

    if (voiceName != null) {

     // await tts.setLanguage(lang);
      await tts.setVoice({
        'identifier': voiceID ?? 'default',
      });
      await tts.setRate(rate);
      await tts.setPitch(pitch);
      await tts.speak(segmentText);
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return tts.isSpeaking.value;
      });
       setHighlightStart(segmentText.length);
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
//button type map
//
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

    print(myBoardsets);
    print(currentFile);
    print(ExV4rs.fileToExport);
    print('currentFile != null');
    
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

    print(myBoardsets);
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

    print(myBoardsets);
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
    
    loadRootData();
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

  static Future<void> loadSavedValues() async {
    final prefs = await SharedPreferences.getInstance();
    // how to clear a value from shared prefs:  
    //await prefs.remove('myBoardsets');

    //reset Json on load
    //deleteLocalCopy(); 
    deleteLocalCopytemplates();

    Fv4rs.loadSavedFontValues(); 
    Cv4rs.loadSavedColorValues();
    Bv4rs.loadSavedBoardsetValues();
    ExV4rs.loadSavedExportValues();

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

    //all the other variables to load
    
    showScrollButtons = prefs.getBool(_showScrollButtons) ?? true;
    showLanguageSelectorSlider = prefs.getBool(_showLanguageSelectorSlider) ?? true;

    doOnboarding.value = prefs.getBool(_doOnboarding) ?? true; // Default to true if not set
    screenheight = prefs.getDouble(_screenheight) ?? 0.0;
    screenwidth = prefs.getDouble(_screenwidth) ?? 0.0;
    keyboardheight = prefs.getDouble(_keyboardheight) ?? 250.0;

    Sv4rs.useDifferentVoiceforSS = prefs.getBool(Sv4rs.useDifferentVoiceforSS_) ?? false;
    Sv4rs.speakInterfaceButtonsOnSelect = prefs.getBool(Sv4rs.speakInterfaceButtonsOnSelect_) ?? false;

    interfaceLanguage = prefs.getString(_interfaceLanguage) ?? 'English';
    selectedLanguage.value = prefs.getString(_selectedLanguage) ?? interfaceLanguage;

    interfaceFont = prefs.getString(_interfaceFont) ?? 'Default';
    interfaceFontSize = prefs.getDouble(_interfaceFontSize) ?? interfaceFontSize;
    interfaceFontWeight = prefs.getInt(_interfaceFontWeight) ?? interfaceFontWeight;
    interfaceFontItalics = prefs.getBool(_interfaceFontItalics) ?? interfaceFontItalics;
    interfaceFontColor = Color(prefs.getInt(_interfaceFontColor) ?? 0xFF000000);

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

    for (final lang in Sv4rs.myLanguages) {
      Sv4rs.languageRates[lang] = prefs.getDouble('tts_rate_$lang') ?? 0.5;
      Sv4rs.languagePitch[lang] = prefs.getDouble('tts_pitch_$lang') ?? 1.0;
      Sv4rs.languageVoice[lang] = prefs.getString('tts_voice_$lang') ?? 'default';
      
      Sv4rs.sslanguageRates[lang] = prefs.getDouble('tts_forSS_rate_$lang') ?? 0.5;
      Sv4rs.sslanguagePitch[lang] = prefs.getDouble('tts_forSS_pitch_$lang') ?? 1.0;
      Sv4rs.speakSelectLanguageVoice[lang] = prefs.getString('tts_forSS_voice_$lang') ?? 'default';
    }
  }

}