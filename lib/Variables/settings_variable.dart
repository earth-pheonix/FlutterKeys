import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/color_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/fonts.dart';


class Sv4rs {
 
//label style 
 static TextStyle get settingslabelStyle =>  
 TextStyle(
  color: V4rs.interfaceFontColor,
  fontSize: V4rs.interfaceFontSize, 
  fontFamily: Fontsy.fontToFamily[V4rs.interfaceFont], 
  fontWeight: FontWeight.values[((V4rs.interfaceFontWeight ~/ 100) - 1 ).clamp(0, 8)],
  fontStyle: V4rs.interfaceFontItalics ? FontStyle.italic : FontStyle.normal
  );

 static TextStyle get settingsSecondaryLabelStyle =>  
 TextStyle(
  color: Cv4rs.themeColor2, 
  fontSize: V4rs.interfaceFontSize, 
  fontFamily: Fontsy.fontToFamily[V4rs.interfaceFont], 
  fontWeight: FontWeight.w500,
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
  
      //voice
      static Map<String, String> speakSelectLanguageVoice = {};  
      static Future<void> setSSlanguageVoice(String sslangVoice, String voice) async {
        speakSelectLanguageVoice[sslangVoice] = voice;
      }
      static String? getSSLangVoice(String sslangVoice) {
        return speakSelectLanguageVoice[sslangVoice] ?? 'default';
      }
      //rate
      static Map<String, double> sslanguageRates = {};
      static Future<void> setSSlanguageRates(String sslangRate, double rate) async {
          sslanguageRates[sslangRate] = rate;
        } 
      static double getSSLangRate(String sslangRate) {
          return sslanguageRates[sslangRate] ?? 0.5;
        }

      //pitch 
      static Map<String, double> sslanguagePitch = {};
      static Future<void> setSSlanguagePitch(String sslangPitch, double pitch) async {
        sslanguagePitch[sslangPitch] = pitch;
      } 
      static double getssLangPitch(String sslangPitch) {
        return sslanguagePitch[sslangPitch] ?? 1.0;
      }

  //rate
  static Map<String, double> languageRates = {};
  static Future<void> setlanguageRates(String langRate, double rate) async {
      languageRates[langRate] = rate;
    } 
  static double getLangRate(String langRate) {
      return languageRates[langRate] ?? 0.5;
    }

  //pitch 
  static Map<String, double> languagePitch = {};
  static Future<void> setlanguagePitch(String langPitch, double pitch) async {
    languagePitch[langPitch] = pitch;
  } 
  static double getLangPitch(String langPitch) {
    return languagePitch[langPitch] ?? 1.0;
  }

  //voice
  static Map<String, String> languageVoice = {};  
  static Future<void> setlanguageVoice(String langVoice, String voice) async {
    languageVoice[langVoice] = voice;
  }
  static String? getLangVoice(String langVoice) {
    return languageVoice[langVoice] ?? 'default';
  }

  // Test phrases
  static const testPhrases = {
    'English': 'Hello, this is a test.',
    'Chinese': '你好，这是一个测试。',
    'Spanish': 'Hola, esto es una prueba.',
    'French': 'Bonjour, ceci est un test.',
    // add more here
  };


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