import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


class Bv4rs {

  //
  //NAV ROW
  //

  //show 
  //1 = true, 2 = hide in place, 3 = hide 
  static int showNavRow = 1;
  static final String _showNavRow = 'showNavRow';

  static Future<void> saveShowNavRow(int showNavRow) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_showNavRow, showNavRow);
  }

  //nav button format 
  static int navButtonFormat = 1;
  static final String _navButtonFormat = 'navButtonFormat';
  static Future<void> saveNavButtonFormat(int navButtonFormat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_navButtonFormat, navButtonFormat);
  }
  //center show buttons
  static int showCenterButtons = 1;
  static final String _showCenterButtons = 'showCenterButtons';
  static Future<void> saveShowCenterButtons(int showCenterButtons) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_showCenterButtons, showCenterButtons);
  }

  //center button format
  static int centerButtonFormat = 3;
  static final String _centerButtonFormat = 'centerButtonFormat';
  static Future<void> saveCenterButtonFormat(int centerButtonFormat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_centerButtonFormat, centerButtonFormat);
  }

  //speak on selecct
  //1 = false, 2 = label, 3 = alternate label
  static int navRowSpeakOnSelect = 1;
  static final String _navRowSpeakOnSelect = 'navRowSpeakOnSelect'; 

  static Future<void> saveNavRowSpeakOnSelect(int navRowSpeakOnSelect) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_navRowSpeakOnSelect, navRowSpeakOnSelect);
  }

  //border weight

  static double navRowBorderWeight = 3.5;
  static final String _navRowBorderWeight = 'navRowBorderWeight';

  static Future<void> saveNavRowBorderWeight(double navRowBorderWeight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_navRowBorderWeight, navRowBorderWeight);
  }

  //
  //=- symbol colors -====-
  //

  //invert
  static bool navRowSymbolInvert = false;
  static final String _navRowSymbolInvert = 'navRowSymbolInvert';

  static Future<void> saveNavRowSymbolInvert(bool navRowSymbolInvert) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_navRowSymbolInvert, navRowSymbolInvert);
  }

  //overlay 
  static Color navRowSymbolColorOverlay = Color(0x00000000);
  static final String _navRowSymbolColorOverlay = 'navRowSymbolColorOverlay';

  static Future<void> saveNavRowSymbolColorOverlay(Color navRowSymbolColorOverlay) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_navRowSymbolColorOverlay, navRowSymbolColorOverlay.toARGB32());
  }

  //saturation
  static double navRowSymbolSaturation = 1.0;
  static final String _navRowSymbolSaturation = 'navRowSymbolSaturation';

  static Future<void> saveNavRowSymbolSaturation(double? navRowSymbolSaturation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_navRowSymbolSaturation, navRowSymbolSaturation ?? 0.0);
  }

  //contrast
  static double navRowSymbolContrast = 1.0;
  static final String _navRowSymbolContrast = 'navRowSymbolContrast';

  static Future<void> saveNavRowSymbolContrast(double? navRowSymbolContrast) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_navRowSymbolContrast, navRowSymbolContrast ?? 0.0);
  }

  //
  //BOARDS
  //

  //format
  static int buttonFormat = 1; //1= text below, 2 = text above, 3 = image only, 4 = text only 
  static final String _buttonFormat = 'buttonFormat';
  static Future<void> saveButtonFormat(int buttonFormat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_buttonFormat, buttonFormat);
  }

  static int subFolderFormat = 1; //1= text right, 2 = text left, 3 = image only, 4 = text only 
  static final String _subFolderFormat = 'subFolderFormat';
  static Future<void> saveSubFolderFormat(int subFolderFormat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_subFolderFormat, subFolderFormat);
  }

  //speak on selecct
  static int buttonSpeakOnSelect = 1; //1 = false, 2 = label, 3 = message
  static final String _buttonSpeakOnSelect = 'buttonSpeakOnSelect'; 

  static Future<void> saveButtonSpeakOnSelect(int buttonSpeakOnSelect) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_buttonSpeakOnSelect, buttonSpeakOnSelect);
  }

  static int folderSpeakOnSelect = 1; //1 = false, 2 = label, 3 = message
  static final String _folderSpeakOnSelect = 'folderSpeakOnSelect'; 

  static Future<void> savefolderSpeakOnSelect(int folderSpeakOnSelect) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_folderSpeakOnSelect, folderSpeakOnSelect);
  }

  static int audioTileSpeakOnSelect = 1; //1 = false, 2 = label, 3 = message
  static final String _audioTileSpeakOnSelect = 'audioTileSpeakOnSelect'; 

  static Future<void> saveaudioTileSpeakOnSelect(int audioTileSpeakOnSelect) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_audioTileSpeakOnSelect, audioTileSpeakOnSelect);
  }

  static int pocketFolderSpeakOnSelect = 1; //1 = false, 2 = label, 3 = message
  static final String _pocketFolderSpeakOnSelect = 'pocketFolderSpeakOnSelect'; 

  static Future<void> savepocketFolderSpeakOnSelect(int pocketFolderSpeakOnSelect) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pocketFolderSpeakOnSelect, pocketFolderSpeakOnSelect);
  }

  static int typingKeySpeakOnSelect = 1; //1 = false, 2 = label, 3 = message
  static final String _typingKeySpeakOnSelect = 'typingKeySpeakOnSelect'; 

  static Future<void> savetypingKeySpeakOnSelect(int typingKeySpeakOnSelect) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_typingKeySpeakOnSelect, typingKeySpeakOnSelect);
  }


  static int subFolderSpeakOnSelect = 1; //1 = false, 2 = label, 3 = alternate label
  static final String _subFolderSpeakOnSelect = 'subFolderSpeakOnSelect'; 

  static Future<void> saveSubFolderSpeakOnSelect(int subFolderSpeakOnSelect) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_subFolderSpeakOnSelect, subFolderSpeakOnSelect);
  }

  //border weight
  static double subFolderBorderWeight = 3.5;
  static final String _subFolderBorderWeight = 'subFolderBorderWeight';

  static Future<void> saveSubFolderBorderWeight(double subFolderBorderWeight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_subFolderBorderWeight, subFolderBorderWeight);
  }

  static double buttonBorderWeight = 2.5;
  static final String _buttonBorderWeight = 'buttonBorderWeight';

  static Future<void> saveButtonBorderWeight(double boardsButtonWeight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_buttonBorderWeight, buttonBorderWeight);
  }

  //
  //=- symbol colors -====-
  //

  //buttons

  //invert
  static bool buttonSymbolInvert = false;
  static final String _buttonSymbolInvert = 'buttonSymbolInvert';

  static Future<void> savebuttonSymbolInvert(bool buttonSymbolInvert) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_buttonSymbolInvert, buttonSymbolInvert);
  }

  //overlay 
  static Color buttonSymbolColorOverlay = Color(0x00000000);
  static final String _buttonSymbolColorOverlay = 'buttonSymbolColorOverlay';

  static Future<void> savebuttonSymbolColorOverlay(Color buttonSymbolColorOverlay) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_buttonSymbolColorOverlay, buttonSymbolColorOverlay.toARGB32());
  }

  //saturation
  static double buttonSymbolSaturation = 1.0;
  static final String _buttonSymbolSaturation = 'buttonSymbolSaturation';

  static Future<void> savebuttonSymbolSaturation(double? buttonSymbolSaturation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_buttonSymbolSaturation, buttonSymbolSaturation ?? 0.0);
  }

  //contrast
  static double buttonSymbolContrast = 1.0;
  static final String _buttonSymbolContrast = 'buttonSymbolContrast';

  static Future<void> savebuttonSymbolContrast(double? buttonSymbolContrast) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_buttonSymbolContrast, buttonSymbolContrast ?? 0.0);
  }

  //sub folder

  //invert
  static bool subFolderSymbolInvert = false;
  static final String _subFolderSymbolInvert = 'subFolderSymbolInvert';

  static Future<void> savesubFolderSymbolInvert(bool subFolderSymbolInvert) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_subFolderSymbolInvert, subFolderSymbolInvert);
  }

  //overlay 
  static Color subFolderSymbolColorOverlay = Color(0x00000000);
  static final String _subFolderSymbolColorOverlay = 'subFolderSymbolColorOverlay';

  static Future<void> savesubFolderSymbolColorOverlay(Color subFolderSymbolColorOverlay) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_subFolderSymbolColorOverlay, subFolderSymbolColorOverlay.toARGB32());
  }

  //saturation
  static double subFolderSymbolSaturation = 1.0;
  static final String _subFolderSymbolSaturation = 'subFolderSymbolSaturation';

  static Future<void> savesubFolderSymbolSaturation(double? subFolderSymbolSaturation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_subFolderSymbolSaturation, subFolderSymbolSaturation ?? 0.0);
  }

  //contrast
  static double subFolderSymbolContrast = 1.0;
  static final String _subFolderSymbolContrast = 'subFolderSymbolContrast';

  static Future<void> savesubFolderSymbolContrast(double? subFolderSymbolContrast) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_subFolderSymbolContrast, subFolderSymbolContrast ?? 0.0);
  }

  //
  //GRAMMER ROW
  //
  static int grammerRowSpeakOnSelect = 1; //1 = false, 2 = label, 3 = alternate label
  static final String _grammerRowSpeakOnSelect = 'grammerRowSpeakOnSelect'; 

  static Future<void> savegrammerRowSpeakOnSelect(int grammerRowSpeakOnSelect) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_grammerRowSpeakOnSelect, grammerRowSpeakOnSelect);
  }
  //show 
  //1 = true, 2 = hide in place, 3 = hide 
  static int showGrammerRow = 1;
  static final String _showGrammerRow = 'showGrammerRow';

  static Future<void> saveShowGrammerRow(int showGrammerRow) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_showGrammerRow, showGrammerRow);
  }
  //format
  static int grammerRowFormat = 1; //1= text right, 2 = text left, 3 = image only, 4 = text only 
  static final String _grammerRowFormat = 'grammerRowFormat';
  static Future<void> savegrammerRowFormat(int grammerRowFormat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_grammerRowFormat, grammerRowFormat);
  }
  //===: symbol color stuff
  //invert
  static bool grammerRowSymbolInvert = false;
  static final String _grammerRowSymbolInvert = 'grammerRowSymbolInvert';

  static Future<void> savegrammerRowSymbolInvert(bool grammerRowSymbolInvert) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_grammerRowSymbolInvert, grammerRowSymbolInvert);
  }

  //overlay 
  static Color grammerRowSymbolColorOverlay = Color(0x00000000);
  static final String _grammerRowSymbolColorOverlay = 'grammerRowSymbolColorOverlay';

  static Future<void> savegrammerRowSymbolColorOverlay(Color grammerRowSymbolColorOverlay) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_grammerRowSymbolColorOverlay, grammerRowSymbolColorOverlay.toARGB32());
  }

  //saturation
  static double grammerRowSymbolSaturation = 1.0;
  static final String _grammerRowSymbolSaturation = 'grammerRowSymbolSaturation';

  static Future<void> savegrammerRowSymbolSaturation(double? grammerRowSymbolSaturation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_grammerRowSymbolSaturation, grammerRowSymbolSaturation ?? 0.0);
  }

  //contrast
  static double grammerRowSymbolContrast = 1.0;
  static final String _grammerRowSymbolContrast = 'grammerRowSymbolContrast';

  static Future<void> savegrammerRowSymbolContrast(double? grammerRowSymbolContrast) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_grammerRowSymbolContrast, grammerRowSymbolContrast ?? 0.0);
  }

  //
  //LOAD FROM PREFS
  //

  static Future<void> loadSavedBoardsetValues() async {
    final prefs = await SharedPreferences.getInstance();

    navRowSpeakOnSelect = prefs.getInt(_navRowSpeakOnSelect) ?? 1;
    navRowBorderWeight = prefs.getDouble(_navRowBorderWeight) ?? 3.5;
    showNavRow = prefs.getInt(_showNavRow) ?? 1;

    navRowSymbolInvert = prefs.getBool(_navRowSymbolInvert) ?? false;
    navRowSymbolColorOverlay = Color(prefs.getInt(_navRowSymbolColorOverlay) ?? 0x00000000);
    navRowSymbolSaturation = prefs.getDouble(_navRowSymbolSaturation) ?? 0.5;
    navRowSymbolContrast = prefs.getDouble(_navRowSymbolContrast) ?? 0.5;

    navButtonFormat = prefs.getInt(_navButtonFormat) ?? 1;
    showCenterButtons = prefs.getInt(_showCenterButtons) ?? 1;
    centerButtonFormat = prefs.getInt(_centerButtonFormat) ?? 1;

    buttonFormat = prefs.getInt(_buttonFormat) ?? 1;
    subFolderFormat = prefs.getInt(_subFolderFormat) ?? 1;
    buttonSpeakOnSelect = prefs.getInt(_buttonSpeakOnSelect) ?? 1;
    subFolderSpeakOnSelect = prefs.getInt(_subFolderSpeakOnSelect) ?? 1;
    buttonBorderWeight = prefs.getDouble(_buttonBorderWeight) ?? 2.5;
    subFolderBorderWeight = prefs.getDouble(_subFolderBorderWeight) ?? 2.5;

    subFolderSymbolInvert = prefs.getBool(_subFolderSymbolInvert) ?? false;
    subFolderSymbolColorOverlay = Color(prefs.getInt(_subFolderSymbolColorOverlay) ?? 0x00000000);
    subFolderSymbolSaturation = prefs.getDouble(_subFolderSymbolSaturation) ?? 0.5;
    subFolderSymbolContrast = prefs.getDouble(_subFolderSymbolContrast) ?? 0.5;
    buttonSymbolInvert = prefs.getBool(_buttonSymbolInvert) ?? false;
    buttonSymbolColorOverlay = Color(prefs.getInt(_buttonSymbolColorOverlay) ?? 0x00000000);
    buttonSymbolSaturation = prefs.getDouble(_buttonSymbolSaturation) ?? 0.5;
    buttonSymbolContrast = prefs.getDouble(_buttonSymbolContrast) ?? 0.5;

    grammerRowSymbolInvert = prefs.getBool(_grammerRowSymbolInvert) ?? false;
    grammerRowSymbolColorOverlay = Color(prefs.getInt(_grammerRowSymbolColorOverlay) ?? 0x00000000);
    grammerRowSymbolSaturation = prefs.getDouble(_grammerRowSymbolSaturation) ?? 0.5;
    grammerRowSymbolContrast = prefs.getDouble(_grammerRowSymbolContrast) ?? 0.5;

    grammerRowFormat = prefs.getInt(_grammerRowFormat) ?? 1;
    grammerRowSpeakOnSelect = prefs.getInt(_grammerRowSpeakOnSelect) ?? 1;
    showGrammerRow = prefs.getInt(_showGrammerRow) ?? 1;
    
  }

}