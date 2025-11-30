import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/fonts/font_options.dart';
import 'package:flutter/material.dart';


class Fv4rs {

//
//Fallback Fonts
//

  static String fallbackFont1 = 'Default';
  static final String _fallbackFont1 = "fallbackFont1";

   static Future<void> savefallbackFont1 (String fallbackFont1) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fallbackFont1, fallbackFont1);
  } 

  static String fallbackFont2 = 'Default';
  static final String _fallbackFont2 = "fallbackFont2";

   static Future<void> savefallbackFont2 (String fallbackFont2) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fallbackFont2, fallbackFont2);
  } 

//
//interface font settings 
//
  static TextStyle get interfacelabelStyle =>  
    TextStyle(
      color: interfaceFontColor, 
      fontSize: 16, 
      fontFamily: interfaceFont,
      fontFamilyFallback: [fallbackFont1, fallbackFont2]);

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
 //EXPAND PAGE FONT SETTINGS
 //

    //expand page font style 
    static TextStyle get expandedLabelStyle =>  
    TextStyle(
      color: expandedFontColor,
      fontSize: expandedFontSize,
      fontFamily: Fontsy.fontToFamily[expandedFont], 
      fontWeight: FontWeight.values[((expandedFontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: expandedFontItalics ? FontStyle.italic : FontStyle.normal,
      fontFamilyFallback: [fallbackFont1, fallbackFont2]
    );

    //font family
    static String expandedFont = 'Default';
    static final String _expandedFont = "expandedFont";

    static Future<void> saveExpandedFont (String expandedFont) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_expandedFont, expandedFont);
    } 

    //size
    static double expandedFontSize = 30;
    static final String _expandedFontSize = "expandedFontSize";

    static Future<void> saveExpandedFontSize (double expandedFontSize) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_expandedFontSize, expandedFontSize);
    } 
    //weight
    static int expandedFontWeight = 400;
    static final String _expandedFontWeight = "expandedFontweight";

    static Future<void> saveExpandedFontWeight (int expandedFontWeight) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_expandedFontWeight, expandedFontWeight);
    } 

    //italic
    static bool expandedFontItalics = false;
    static final String _expandedFontItalics = "expandedFontItalics";

    static Future<void> saveExpandedFontItalics (bool expandedFontItalics) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_expandedFontItalics, expandedFontItalics);
    } 

    //color
    static Color expandedFontColor = Cv4rs.themeColor1;
    static final String _expandedFontColor = "expandedFontColor";

    static Future<void> saveExpandedFontColor (Color expandedFontColor) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_expandedFontColor, expandedFontColor.toARGB32());
    } 
  
  //
  //MESSAGE WINDOW FONT SETTINGS
  //

    //font style 
    static TextStyle get mwLabelStyle =>  
    TextStyle(
      color: mwFontColor,
      fontSize: mwFontSize,
      fontFamily: Fontsy.fontToFamily[mwFont], 
      fontWeight: FontWeight.values[((mwFontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: mwFontItalics ? FontStyle.italic : FontStyle.normal,
      height: 1.5,
      fontFamilyFallback: [fallbackFont1, fallbackFont2]
    );

     //hint text style 
    static TextStyle get hintMWLabelStyle =>  
    TextStyle(
      color: Cv4rs.themeColor3,
      fontSize: mwFontSize,
      fontFamily: Fontsy.fontToFamily[mwFont], 
      fontWeight: FontWeight.values[((mwFontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: mwFontItalics ? FontStyle.italic : FontStyle.normal,
      height: 1.5,
      fontFamilyFallback: [fallbackFont1, fallbackFont2]
    );

    //font family
    static String mwFont = 'Default';
    static final String _mwFont = "mwFont";

    static Future<void> savemwFont (String mwFont) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_mwFont, mwFont);
    } 

    //size
    static double mwFontSize = 16;
    static final String _mwFontSize = "mwFontSize";

    static Future<void> savemwFontSize (double mwFontSize) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_mwFontSize, mwFontSize);
    } 
    //weight
    static int mwFontWeight = 400;
    static final String _mwFontWeight = "mwFontweight";

    static Future<void> savemwFontWeight (int mwFontWeight) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_mwFontWeight, mwFontWeight);
    } 

    //italic
    static bool mwFontItalics = false;
    static final String _mwFontItalics = "mwFontItalics";

    static Future<void> savemwFontItalics (bool mwFontItalics) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_mwFontItalics, mwFontItalics);
    } 

    //color
    static Color mwFontColor = Cv4rs.themeColor1;
    static final String _mwFontColor = "mwFontColor";

    static Future<void> savemwFontColor (Color mwFontColor) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_mwFontColor, mwFontColor.toARGB32());
    } 
    
  //
  //HIGHLIGHT FONT SETTINGS
  //

   static TextStyle get highlightTextStyle =>
    mwLabelStyle.copyWith(
      backgroundColor: uniquehighlightFontBColor ? highlightBackgroundFontColor : null,
      color: uniquehighlightFontColor ? highlightFontColor : mwFontColor,
      decoration: highlightFontUnderline ? TextDecoration.underline : TextDecoration.none,
      fontWeight: uniquehighlightFontWeight
          ? FontWeight.values[((highlightFontWeight ~/ 100) - 1).clamp(0, 8)]
          : mwLabelStyle.fontWeight,
      fontStyle: uniquehighlightFontItalics
          ? (highlightFontItalics ? FontStyle.italic : FontStyle.normal)
          : mwLabelStyle.fontStyle,
      fontFamilyFallback: [fallbackFont1, fallbackFont2]
    );
    //weight
    static bool uniquehighlightFontWeight = false;
    static final String _uniquehighlightFontWeight = "uniquehighlightFontweight";

    static Future<void> saveuniquehighlightFontWeight (bool uniquehighlightFontWeight) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_uniquehighlightFontWeight, uniquehighlightFontWeight);
    } 

    static int highlightFontWeight = 400;
    static final String _highlightFontWeight = "highlightFontweight";

    static Future<void> savehighlightFontWeight (int highlightFontWeight) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_highlightFontWeight, highlightFontWeight);
    } 

    //italic
    static bool uniquehighlightFontItalics = false;
    static final String _uniquehighlightFontItalic = "uniquehighlightFontItalics";

    static Future<void> saveuniquehighlightFontItalics (bool uniquehighlightFontItalics) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_uniquehighlightFontItalic, uniquehighlightFontItalics);
    } 

    static bool highlightFontItalics = false;
    static final String _highlightFontItalics = "highlightFontItalics";

    static Future<void> savehighlightFontItalics (bool highlightFontItalics) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_highlightFontItalics, highlightFontItalics);
    } 

    //color
    static bool uniquehighlightFontColor = false;
    static final String _uniquehighlightFontColor = "uniquehighlightFontColor";

    static Future<void> saveuniquehighlightFontColor (bool uniquehighlightFontItalics) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_uniquehighlightFontColor, uniquehighlightFontColor);
    } 

    static Color highlightFontColor = Cv4rs.themeColor1;
    static final String _highlightFontColor = "highlightFontColor";

    static Future<void> savehighlightFontColor (Color highlightFontColor) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_highlightFontColor, highlightFontColor.toARGB32());
    } 

    //background color
    static bool uniquehighlightFontBColor = false;
    static final String _uniquehighlightFontBColor = "uniquehighlightFontBColor";

    static Future<void> saveuniquehighlightFontBColor (bool uniquehighlightFontBColor) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_uniquehighlightFontBColor, uniquehighlightFontBColor);
    } 

    static Color highlightBackgroundFontColor = Cv4rs.themeColor3;
    static final String _highlightBackgroundFontColor = "highlightBackgroundFontColor";

    static Future<void> savehighlightBackgroundFontColor (Color highlightBackgroundFontColor) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_highlightBackgroundFontColor, highlightBackgroundFontColor.toARGB32());
    } 

    //underline

    static bool highlightFontUnderline = false;
    static final String _highlightFontUnderline = "highlightFontUnderline";

    static Future<void> savehighlightFontUnderline (bool highlightFontUnderline) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_highlightFontUnderline, highlightFontUnderline);
    } 

    //
    //NAV ROW FONT
    //

    //font style 
    static TextStyle get navRowLabelStyle =>  
    TextStyle(
      color: navRowFontColor,
      fontSize: navRowFontSize,
      fontFamily: Fontsy.fontToFamily[navRowFont], 
      fontWeight: FontWeight.values[((navRowFontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: navRowFontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: navRowFontUnderline ? TextDecoration.underline : TextDecoration.none,
      fontFamilyFallback: [fallbackFont1, fallbackFont2],
    );

    //font family
    static String navRowFont = 'Default';
    static final String _navRowFont = "navRowFont";

    static Future<void> savenavRowFont (String navRowFont) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_navRowFont, navRowFont);
    } 

    //size
    static double navRowFontSize = 14;
    static final String _navRowFontSize = "navRowFontSize";

    static Future<void> savenavRowFontSize (double navRowFontSize) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_navRowFontSize, navRowFontSize);
    } 
    //weight
    static int navRowFontWeight = 400;
    static final String _navRowFontWeight = "navRowFontweight";

    static Future<void> savenavRowFontWeight (int navRowFontWeight) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_navRowFontWeight, navRowFontWeight);
    } 

    //italic
    static bool navRowFontItalics = false;
    static final String _navRowFontItalics = "navRowFontItalics";

    static Future<void> savenavRowFontItalics (bool navRowFontItalics) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_navRowFontItalics, navRowFontItalics);
    } 

    //underline
    static bool navRowFontUnderline = false;
    static final String _navRowFontUnderline = "navRowFontUnderline";
    static Future<void> savenavRowFontUnderline (bool navRowFontUnderline) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_navRowFontUnderline, navRowFontUnderline);
    }

    //color
    static Color navRowFontColor = Cv4rs.themeColor1;
    static final String _navRowFontColor = "navRowFontColor";

    static Future<void> savenavRowFontColor (Color navRowFontColor) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_navRowFontColor, navRowFontColor.toARGB32());
    } 

  
    //
    //SUB FOLDERS
    //

    //font style 
    static TextStyle get subFolderLabelStyle =>  
    TextStyle(
      color: subFolderFontColor,
      fontSize: subFolderFontSize,
      fontFamily: Fontsy.fontToFamily[subFolderFont], 
      fontWeight: FontWeight.values[((subFolderFontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: subFolderFontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: subFolderFontUnderline ? TextDecoration.underline : TextDecoration.none,
      fontFamilyFallback: [fallbackFont1, fallbackFont2],
    );

    //font family
    static String subFolderFont = 'Default';
    static final String _subFolderFont = "subFolderFont";

    static Future<void> savesubFolderFont (String subFolderFont) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_subFolderFont, subFolderFont);
    } 

    //size
    static double subFolderFontSize = 14;
    static final String _subFolderFontSize = "subFolderFontSize";

    static Future<void> savesubFolderFontSize (double subFolderFontSize) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_subFolderFontSize, subFolderFontSize);
    } 
    //weight
    static int subFolderFontWeight = 400;
    static final String _subFolderFontWeight = "subFolderFontweight";

    static Future<void> savesubFolderFontWeight (int subFolderFontWeight) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_subFolderFontWeight, subFolderFontWeight);
    } 

    //italic
    static bool subFolderFontItalics = false;
    static final String _subFolderFontItalics = "subFolderFontItalics";

    static Future<void> savesubFolderFontItalics (bool subFolderFontItalics) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_subFolderFontItalics, subFolderFontItalics);
    } 

    //underline
    static bool subFolderFontUnderline = false;
    static final String _subFolderFontUnderline = "subFolderFontUnderline";
    static Future<void> savesubFolderFontUnderline (bool subFolderFontUnderline) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_subFolderFontUnderline, subFolderFontUnderline);
    }

    //color
    static Color subFolderFontColor = Cv4rs.themeColor1;
    static final String _subFolderFontColor = "subFolderFontColor";

    static Future<void> savesubFolderFontColor (Color subFolderFontColor) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_subFolderFontColor, subFolderFontColor.toARGB32());
    } 

  
    //
    //BUTTONS
    //

    //font style 
    static TextStyle get buttonLabelStyle =>  
    TextStyle(
      color: buttonFontColor,
      fontSize: buttonFontSize,
      fontFamily: Fontsy.fontToFamily[buttonFont], 
      fontWeight: FontWeight.values[((buttonFontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: buttonFontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: buttonFontUnderline ? TextDecoration.underline : TextDecoration.none,
      fontFamilyFallback: [fallbackFont1, fallbackFont2],
    );

    //font family
    static String buttonFont = 'Default';
    static final String _buttonFont = "buttonFont";

    static Future<void> savebuttonFont (String buttonFont) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_buttonFont, buttonFont);
    } 

    //size
    static double buttonFontSize = 14;
    static final String _buttonFontSize = "buttonFontSize";

    static Future<void> savebuttonFontSize (double buttonFontSize) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_buttonFontSize, buttonFontSize);
    } 
    //weight
    static int buttonFontWeight = 400;
    static final String _buttonFontWeight = "buttonFontweight";

    static Future<void> savebuttonFontWeight (int buttonFontWeight) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_buttonFontWeight, buttonFontWeight);
    } 

    //italic
    static bool buttonFontItalics = false;
    static final String _buttonFontItalics = "mwFontItalics";

    static Future<void> savebuttonFontItalics (bool buttonFontItalics) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_buttonFontItalics, buttonFontItalics);
    } 

    //underline
    static bool buttonFontUnderline = false;
    static final String _buttonFontUnderline = "buttonFontUnderline";
    static Future<void> savebuttonFontUnderline (bool buttonFontUnderline) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_buttonFontUnderline, buttonFontUnderline);
    }

    //color
    static Color buttonFontColor = Cv4rs.themeColor1;
    static final String _buttonFontColor = "buttonFontColor";

    static Future<void> savebuttonFontColor (Color buttonFontColor) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_buttonFontColor, buttonFontColor.toARGB32());
    } 

    //
    //GRAMMER ROW
    //

    //font style 
    static TextStyle get grammerLabelStyle =>  
    TextStyle(
      color: grammerFontColor,
      fontSize: grammerFontSize,
      fontFamily: Fontsy.fontToFamily[grammerFont], 
      fontWeight: FontWeight.values[((grammerFontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: grammerFontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: grammerFontUnderline ? TextDecoration.underline : TextDecoration.none,
      fontFamilyFallback: [fallbackFont1, fallbackFont2]
    );

    //font family
    static String grammerFont = 'Default';
    static final String _grammerFont = "grammerFont";

    static Future<void> savegrammerFont (String grammerFont) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_grammerFont, grammerFont);
    } 

    //size
    static double grammerFontSize = 14;
    static final String _grammerFontSize = "grammerFontSize";

    static Future<void> savegrammerFontSize (double grammerFontSize) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_grammerFontSize, grammerFontSize);
    } 
    //weight
    static int grammerFontWeight = 400;
    static final String _grammerFontWeight = "grammerFontweight";

    static Future<void> savegrammerFontWeight (int grammerFontWeight) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_grammerFontWeight, grammerFontWeight);
    } 

    //italic
    static bool grammerFontItalics = false;
    static final String _grammerFontItalics = "grammerFontItalics";

    static Future<void> savegrammerFontItalics (bool grammerFontItalics) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_grammerFontItalics, grammerFontItalics);
    } 

    //underline
    static bool grammerFontUnderline = false;
    static final String _grammerFontUnderline = "grammerFontUnderline";
    static Future<void> savegrammerFontUnderline (bool grammerFontUnderline) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_grammerFontUnderline, grammerFontUnderline);
    }

    //color
    static Color grammerFontColor = Cv4rs.themeColor1;
    static final String _grammerFontColor = "grammerFontColor";

    static Future<void> savegrammerFontColor (Color grammerFontColor) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_grammerFontColor, grammerFontColor.toARGB32());
    } 


  //load values from shared prefs
  static Future<void> loadSavedFontValues() async {
    final prefs = await SharedPreferences.getInstance();

    interfaceFont = prefs.getString(_interfaceFont) ?? 'Default';
    fallbackFont1 = prefs.getString(_fallbackFont1) ?? 'Default';
    fallbackFont2 = prefs.getString(_fallbackFont2) ?? 'Default';

    interfaceFontSize = prefs.getDouble(_interfaceFontSize) ?? interfaceFontSize;
    interfaceFontWeight = prefs.getInt(_interfaceFontWeight) ?? interfaceFontWeight;
    interfaceFontItalics = prefs.getBool(_interfaceFontItalics) ?? interfaceFontItalics;
    interfaceFontColor = Color(prefs.getInt(_interfaceFontColor) ?? 0xFF000000);

    expandedFont = prefs.getString(_expandedFont) ?? 'Default';
    expandedFontSize = prefs.getDouble(_expandedFontSize) ?? expandedFontSize;
    expandedFontWeight = prefs.getInt(_expandedFontWeight) ?? expandedFontWeight;
    expandedFontItalics = prefs.getBool(_expandedFontItalics) ?? expandedFontItalics;
    expandedFontColor = Color(prefs.getInt(_expandedFontColor) ?? 0xFF000000);

    mwFont = prefs.getString(_mwFont) ?? 'Default';
    mwFontSize = prefs.getDouble(_mwFontSize) ?? mwFontSize;
    mwFontWeight = prefs.getInt(_mwFontWeight) ?? mwFontWeight;
    mwFontItalics = prefs.getBool(_mwFontItalics) ?? mwFontItalics;
    mwFontColor = Color(prefs.getInt(_mwFontColor) ?? 0xFF000000);

    uniquehighlightFontBColor = prefs.getBool(_uniquehighlightFontBColor) ?? uniquehighlightFontBColor;
    uniquehighlightFontColor = prefs.getBool(_uniquehighlightFontColor) ?? uniquehighlightFontColor;
    uniquehighlightFontItalics = prefs.getBool(_uniquehighlightFontItalic) ?? uniquehighlightFontItalics;
    uniquehighlightFontWeight = prefs.getBool(_uniquehighlightFontWeight) ?? uniquehighlightFontWeight;

    highlightBackgroundFontColor = Color(prefs.getInt(_highlightBackgroundFontColor) ?? 0xFFCCCAC8);
    highlightFontColor = Color(prefs.getInt(_highlightFontColor) ?? 0xFF000000);
    highlightFontWeight = prefs.getInt(_highlightFontWeight) ?? highlightFontWeight;
    highlightFontItalics = prefs.getBool(_highlightFontItalics) ?? highlightFontItalics;
    highlightFontUnderline = prefs.getBool(_highlightFontUnderline) ?? highlightFontUnderline;

    navRowFont = prefs.getString(_navRowFont) ?? 'Default';
    navRowFontSize = prefs.getDouble(_navRowFontSize) ?? navRowFontSize;
    navRowFontWeight = prefs.getInt(_navRowFontWeight) ?? navRowFontWeight;
    navRowFontItalics = prefs.getBool(_navRowFontItalics) ?? navRowFontItalics;
    navRowFontColor = Color(prefs.getInt(_navRowFontColor) ?? 0xFF000000);

    buttonFont = prefs.getString(_buttonFont) ?? 'Default';
    buttonFontSize = prefs.getDouble(_buttonFontSize) ?? buttonFontSize;
    buttonFontWeight = prefs.getInt(_buttonFontWeight) ?? buttonFontWeight;
    buttonFontItalics = prefs.getBool(_buttonFontItalics) ?? buttonFontItalics;
    buttonFontColor = Color(prefs.getInt(_buttonFontColor) ?? 0xFF000000);

    subFolderFont = prefs.getString(_subFolderFont) ?? 'Default';
    subFolderFontSize = prefs.getDouble(_subFolderFontSize) ?? subFolderFontSize;
    subFolderFontWeight = prefs.getInt(_subFolderFontWeight) ?? subFolderFontWeight;
    subFolderFontItalics = prefs.getBool(_subFolderFontItalics) ?? subFolderFontItalics;
    subFolderFontColor = Color(prefs.getInt(_subFolderFontColor) ?? 0xFF000000);

    grammerFont = prefs.getString(_grammerFont) ?? 'Default';
    grammerFontSize = prefs.getDouble(_grammerFontSize) ?? grammerFontSize;
    grammerFontWeight = prefs.getInt(_grammerFontWeight) ?? grammerFontWeight;
    grammerFontItalics = prefs.getBool(_grammerFontItalics) ?? grammerFontItalics;
    grammerFontColor = Color(prefs.getInt(_grammerFontColor) ?? 0xFF000000);
  }

}