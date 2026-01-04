
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/fonts/font_options.dart';
import 'package:flutterkeysaac/Variables/fonts/font_variables.dart';


class Sv4rs {
 
//label style 
 static TextStyle get settingslabelStyle =>  
 TextStyle(
  color: Fv4rs.interfaceFontColor,
  fontSize: V4rs.fontValue(Fv4rs.interfaceFontSize), 
  fontFamily: Fontsy.fontToFamily[Fv4rs.interfaceFont], 
  fontWeight: FontWeight.values[((Fv4rs.interfaceFontWeight ~/ 100) - 1 ).clamp(0, 8)],
  fontStyle: Fv4rs.interfaceFontItalics ? FontStyle.italic : FontStyle.normal,
  fontFamilyFallback: [Fv4rs.fallbackFont1, Fv4rs.fallbackFont2]
  );

 static TextStyle get settingsSecondaryLabelStyle =>  
 TextStyle(
  color: Cv4rs.themeColor2, 
  fontSize: V4rs.fontValue(Fv4rs.interfaceFontSize), 
  fontFamily: Fontsy.fontToFamily[Fv4rs.interfaceFont], 
  fontWeight: FontWeight.w500,
  fontFamilyFallback: [Fv4rs.fallbackFont1, Fv4rs.fallbackFont2]
  );


// Language settings
  static List <String> allLanguages = ['English', '中文', 'Española', 'Français'];
  static Set <String> myLanguages = {V4rs.interfaceLanguage};
  
  static Future<void> setMyLanguages(Set<String> languages) async {
    myLanguages = languages;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('my_languages', languages.toList());
  }
  static Set<String> getMyLanguages() {
    return myLanguages;
  }

  static bool useLanguageOverlays = true;
  static final String useLanguageOverlays_ = 'useLanguageOverlays';
  static Future<void> saveUseLanguageOverlays(bool useLanguageOverlays) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(useLanguageOverlays_, useLanguageOverlays);
  }



//voice settings

  //pick from engine
  static String pickFromEngine = "sherpa-onnx";
  static final String pickFromEngine_ = 'pickFromEngine';
  static Future<void> savePickFromEngine(String pickFromEngine) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(pickFromEngine_, pickFromEngine);
  }

  //speak on select 
  static bool useDifferentVoiceforSS = false;
  static final String useDifferentVoiceforSS_ = 'useDifferentVoiceforSS';
  static Future<void> saveUseDiffVoiceSS(bool useDifferentVoiceforSS) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(useDifferentVoiceforSS_, useDifferentVoiceforSS);
  }
  //speak interface buttons on select 
  static bool speakInterfaceButtonsOnSelect = false;
  static final String speakInterfaceButtonsOnSelect_ = 'speakInterfaceButtonsOnSelect';
  static Future<void> saveSpeakInterfaceButtonsOnSelect(bool speakInterfaceButtonsOnSelect) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(speakInterfaceButtonsOnSelect_, speakInterfaceButtonsOnSelect);
  }

//alert settings 
  static int alertCount = 3;
  static final String alertCount_ = "alertCount";  

  static Future<void> saveAlertCount(int alertCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(alertCount_, alertCount);
  } 

  static String firstAlert = '.en. I have something to say .en.';
  static final String firstAlert_ = 'firstAlert';
  static Future<void> saveFirstAlert(String alert) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(firstAlert_, alert);
  }

  static String secondAlert = '.en. one second .en.';
  static final String secondAlert_ = 'secondAlert';
  static Future<void> saveSecondAlert(String alert) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(secondAlert_, alert);
  }

  static String thirdAlert = '.en. I made a mistake .en.';
  static final String thirdAlert_ = 'thirdAlert';
  static Future<void> saveThirdAlert(String alert) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(thirdAlert_, alert);
  }

//color settings 
  
}
