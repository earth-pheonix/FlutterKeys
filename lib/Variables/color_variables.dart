import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cv4rs {
  
  //corner tab color  
  static Color cornerTabColor = Color(0xba8b8b8b);
  static final String cornerTabColor_ = "cornerTabColor";

  static Future<void> saveCornerTabColor(Color cornerTabColor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(cornerTabColor_, cornerTabColor.toARGB32());
  }

  //
  //INTERFACE COLORS
  //

    //ui icon color
    static Color uiIconColor = Color(0xFFFFFFFF);
    static final String uiIconsColor_ = "UIIconColor";

    static Future<void> saveUIIconColor(Color uiIconColor) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(uiIconsColor_, uiIconColor.toARGB32());
    }

    //themecolor 1
    static Color themeColor1 = Color(0xFF000000);
      static final String themeColor1_ = 'themeColor1';

    static ValueNotifier<Color> notifierthemeColor1 = ValueNotifier<Color>(themeColor1);

    static Future<void> savethemecolorone(Color themeColor1) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(themeColor1_, themeColor1.toARGB32());
    } 

    //themecolor 2
    static Color themeColor2 = Color(0xFF666564);
    static final String themeColor2_ = 'themeColor2';

    static Future<void> savethemecolortwo(Color themeColor2) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(themeColor2_, themeColor2.toARGB32());
    } 
    
    //themecolor 3
    static Color themeColor3 = Color(0xFFCCCAC8);
    static final String themeColor3_ = 'themeColor3';

    static Future<void> savethemecolorthree(Color themeColor3) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(themeColor3_, themeColor3.toARGB32());
    } 

    //theme color 4
    static Color themeColor4 = Color(0xFFFFFFFF);
    static final String themeColor4_ = 'themeColor4';

    static Future<void> savethemecolorfour(Color themeColor4) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(themeColor4_, themeColor4.toARGB32());
    } 

  //
  //EXPAND PAGE COLORS
  //

    //expand icon color
    static Color expandIconColor = Color(0xFFFFFFFF);
    static final String expandIconColor_ = "expandIconColor";

    static Future<void> saveexpandiconcolor(Color expandIconColor) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(expandIconColor_, expandIconColor.toARGB32());
    } 

    //expand color 1
    static Color expandColor1 = Color(0xFF000000);
    static final String expandColor1_ = 'expandColor1';

    static Future<void> saveexpandcolorone(Color expandColor4) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(expandColor1_, expandColor1.toARGB32());
    } 

    //expand color 2
    static Color expandColor2 = Color(0xFF666564);
    static final String expandColor2_ = 'expandColor2';

    static Future<void> saveexpandcolortwo(Color expandColor2) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(expandColor2_, expandColor2.toARGB32());
    } 
    
    //expand color 3
    static Color expandColor3 = Color(0xFFCCCAC8);
    static final String expandColor3_ = 'expandColor3';

    static Future<void> saveexpandcolorthree(Color expandColor3) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(expandColor3_, expandColor3.toARGB32());
    } 

    //expand color 4
    static Color expandColor4 = Color(0xFFFFFFFF);
    static final String expandColor4_ = 'expandColor4';

    static Future<void> saveexpandcolorfour(Color expandColor4) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(expandColor4_, expandColor4.toARGB32());
    } 
    

  //
  //PART OF SPEECH (POS) COLORS
  //

  //background colors

  static Color determiner = Color(0xFFe4e4e4);
  static final String determiner_ = 'determiner';
  static Future<void> saveDeterminerColor(Color determiner) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(determiner_, determiner.toARGB32());
  }
  static Color social = Color(0xFFf3d6e9);
  static final String social_ = 'social';
  static Future<void> saveSocialColor(Color social) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(social_, social.toARGB32());
  }
  static Color pronoun = Color(0xFFf2edd2);
  static final String pronoun_ = 'pronoun';
  static Future<void> savePronounColor(Color pronoun) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(pronoun_, pronoun.toARGB32());
  }
  static Color noun = Color(0xFFf2ddcd);
  static final String noun_ = 'noun';
  static Future<void> saveNounColor(Color noun) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(noun_, noun.toARGB32());
  }
  static Color verb = Color(0xFFd8ecd8);
  static final String verb_ = 'verb';
  static Future<void> saveVerbColor(Color verb) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(verb_, verb.toARGB32());
  }
  static Color adjective = Color(0xFFd0e6f3);
  static final String adjective_ = 'adjective';
  static Future<void> saveAdjectiveColor(Color adjective) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(adjective_, adjective.toARGB32());
  }
  static Color adverb = Color(0xFFf4dede);
  static final String adverb_ = 'adverb';
  static Future<void> saveAdverbColor(Color adverb) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(adverb_, adverb.toARGB32());
  }
  static Color question = Color(0xFFf0dff1);
  static final String question_ = 'question';
  static Future<void> saveQuestionColor(Color question) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(question_, question.toARGB32());
  }
  static Color conjunction = Color(0xFFD5EDE1);
  static final String conjunction_ = 'conjunction';
  static Future<void> saveConjunctionColor(Color conjunction) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(conjunction_, conjunction.toARGB32());
  }
  static Color preposition = Color(0xFFe5e2ea);
  static final String preposition_ = 'preposition';
  static Future<void> savePrepositionColor(Color preposition) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(preposition_, preposition.toARGB32());
  }
  static Color negation = Color(0xFFefa1a1);
  static final String negation_ = 'negation';
  static Future<void> saveNegationColor(Color negation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(negation_, negation.toARGB32());
  }
  static Color interjection = Color(0xFFffcbea);
  static final String interjection_ = 'interjection';
  static Future<void> saveInterjectionColor(Color interjection) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(interjection_, interjection.toARGB32());
  }
  static Color folder = Color(0xFFffffff);
  static final String folder_ = 'folder';
  static Future<void> saveFolderColor(Color folder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(folder_, folder.toARGB32());
  }
  static Color extra1 = Color(0xFFe5e1f7);
  static final String extra1_ = 'extra1';
  static Future<void> saveExtra1Color(Color extra1) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(extra1_, extra1.toARGB32());
  }
  static Color extra2 = Color(0xFFd8edea);
  static final String extra2_ = 'extra2';
  static Future<void> saveExtra2Color(Color extra2) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(extra2_, extra2.toARGB32());
  }

    static Color posToColor(String pos) {
      switch (pos.toLowerCase()) {
        case 'determiner':
          return determiner;
        case 'social':
          return social;
        case 'pronoun':
          return pronoun;
        case 'noun':
          return noun;
        case 'verb':
          return verb;
        case 'adjective':
          return adjective;
        case 'adverb':
          return adverb;
        case 'question':
          return question;
        case 'conjunction':
          return conjunction;
        case 'preposition':
          return preposition;
        case 'negation&':
          return negation;
        case 'interjection':
          return interjection;
        case 'extra 1':
          return extra1;
        case 'extra 2':
          return extra2;
        case 'folder':
          return folder;
        default:
          return extra1;
      }
    }

  //border colors
  static Color determinerBorder = Color(0xFFb8b3b3);
  static final String determinerBorder_ = 'determinerBorder';
  static Future<void> saveDeterminerBorderColor(Color determinerBorder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(determinerBorder_, determinerBorder.toARGB32());
  }
  static Color socialBorder = Color(0xFFe6a4c0);
  static final String socialBorder_ = 'socialBorder';
  static Future<void> saveSocialBorderColor(Color socialBorder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(socialBorder_, socialBorder.toARGB32());
  }
  static Color pronounBorder = Color(0xFFddcaa6);
  static final String pronounBorder_ = 'pronounBorder';
  static Future<void> savePronounBorderColor(Color pronounBorder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(pronounBorder_, pronounBorder.toARGB32());
  }
  static Color nounBorder = Color(0xFFe1c0a6);
  static final String nounBorder_ = 'nounBorder';
  static Future<void> saveNounBorderColor(Color nounBorder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(nounBorder_, nounBorder.toARGB32());
  }
  static Color verbBorder = Color(0xFF9dd4b1);
  static final String verbBorder_ = 'verbBorder';
  static Future<void> saveVerbBorderColor(Color verbBorder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(verbBorder_, verbBorder.toARGB32());
  }
  static Color adjectiveBorder = Color(0xFFaed0e4);
  static final String adjectiveBorder_ = 'adjectiveBorder';
  static Future<void> saveAdjectiveBorderColor(Color adjectiveBorder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(adjectiveBorder_, adjectiveBorder.toARGB32());
  }
  static Color adverbBorder = Color(0xFFe1afaf);
  static final String adverbBorder_ = 'adverbBorder';
  static Future<void> saveAdverbBorderColor(Color adverbBorder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(adverbBorder_, adverbBorder.toARGB32());
  }
  static Color questionBorder = Color(0xFFcfadd1);
  static final String questionBorder_ = 'questionBorder';
  static Future<void> saveQuestionBorderColor(Color questionBorder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(questionBorder_, questionBorder.toARGB32());
  }
  static Color conjunctionBorder = Color(0xFFc3c995);
  static final String conjunctionBorder_ = 'conjunctionBorder';
  static Future<void> saveConjunctionBorderColor(Color conjunctionBorder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(conjunctionBorder_, conjunctionBorder.toARGB32());
  }
  static Color prepositionBorder = Color(0xFFd1add6);
  static final String prepositionBorder_ = 'prepositionBorder';
  static Future<void> savePrepositionBorderColor(Color prepositionBorder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(prepositionBorder_, prepositionBorder.toARGB32());
  }
  static Color negationBorder = Color(0xFFd47575);
  static final String negationBorder_ = 'negationBorder';
  static Future<void> saveNegationBorderColor(Color negationBorder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(negationBorder_, negationBorder.toARGB32());
  }
  static Color interjectionBorder = Color(0xFF6cdd71);
  static final String interjectionBorder_ = 'interjectionBorder';
  static Future<void> saveInterjectionBorderColor(Color interjectionBorder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(interjectionBorder_, interjectionBorder.toARGB32());
  }
  static Color folderBorder = Color(0xFFb4b4b4);
  static final String folderBorder_ = 'folderBorder';
  static Future<void> saveFolderBorderColor(Color folderBorder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(folderBorder_, folderBorder.toARGB32());
  }
  static Color extra1Border = Color(0xFFc1bae1);
  static final String extra1Border_ = 'extra1Border';
  static Future<void> saveExtra1BorderColor(Color extra1Border) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(extra1Border_, extra1Border.toARGB32());
  }
  static Color extra2Border = Color(0xFF97d4c4);
  static final String extra2Border_ = 'extra2Border';
  static Future<void> saveExtra2BorderColor(Color extra2Border) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(extra2Border_, extra2Border.toARGB32());
  }

   static Color posToBorderColor(String pos) {
      switch (pos.toLowerCase()) {
        case 'determiner':
          return determinerBorder;
        case 'social':
          return socialBorder;
        case 'pronoun':
          return pronounBorder;
        case 'noun':
          return nounBorder;
        case 'verb':
          return verbBorder;
        case 'adjective':
          return adjectiveBorder;
        case 'adverb':
          return adverbBorder;
        case 'question':
          return questionBorder;
        case 'conjunction':
          return conjunctionBorder;
        case 'preposition':
          return prepositionBorder;
        case 'negation&':
          return negationBorder;
        case 'interjection':
          return interjectionBorder;
        case 'extra 1':
          return extra1Border;
        case 'extra 2':
          return extra2Border;
        case 'folder':
          return folderBorder;
        default:
          return extra1Border;
      }
    }

//
// COLOR FILTERS 
//
  static List<double> identityMatrix() => [
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0,
  ];

  static List<double> saturationMatrix(double saturation) {
    // saturation = 1.0 is normal, 0.0 is grayscale
    final invSat = 1 - saturation;
    final r = 0.2126 * invSat;
    final g = 0.7152 * invSat;
    final b = 0.0722 * invSat;

    return [
      r + saturation, g, b, 0, 0,
      r, g + saturation, b, 0, 0,
      r, g, b + saturation, 0, 0,
      0, 0, 0, 1, 0,
    ];
  }

  static List<double> contrastMatrix(double contrast) {
    // contrast = 1.0 is normal, <1 darkens, >1 brightens
    final t = (1.0 - contrast) * 128.0;
    return [
      contrast, 0, 0, 0, t,
      0, contrast, 0, 0, t,
      0, 0, contrast, 0, t,
      0, 0, 0, 1, 0,
    ];
  }

  static List<double> invertMatrix() {
    return [
      -1, 0, 0, 0, 255,
      0, -1, 0, 0, 255,
      0, 0, -1, 0, 255,
      0, 0, 0, 1, 0,
    ];
  }

  static List<double> applyAThenBColorMatrices(List<double> a, List<double> b) {
    final out = List<double>.filled(20, 0.0);
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 5; col++) {
        out[row * 5 + col] =
            a[row * 5 + 0] * b[0 * 5 + col] +
            a[row * 5 + 1] * b[1 * 5 + col] +
            a[row * 5 + 2] * b[2 * 5 + col] +
            a[row * 5 + 3] * b[3 * 5 + col] +
            (col == 4 ? a[row * 5 + 4] : 0);
      }
    }
    return out;
  }

  static List<double> combineMatrices(List<List<double>> matrices) {
    if (matrices.isEmpty) return identityMatrix();
    var result = matrices.first;
    for (var i = 1; i < matrices.length; i++) {
      result = applyAThenBColorMatrices(result, matrices[i]);
    }
    return result;
  }

  //
  //LOAD THESE VALUES
  //

    static Future<void> loadSavedColorValues() async {
      final prefs = await SharedPreferences.getInstance();

      themeColor1 = Color(prefs.getInt(themeColor1_) ?? 0xFF000000);
      themeColor2 = Color(prefs.getInt(themeColor2_) ?? 0xFF666564);
      themeColor3 = Color(prefs.getInt(themeColor3_) ?? 0xFFCCCAC8);
      themeColor4 = Color(prefs.getInt(themeColor4_) ?? 0xFFFFFFFF);
      uiIconColor = Color(prefs.getInt(uiIconsColor_) ?? 0xFFFFFFFF);

      expandColor1 = Color(prefs.getInt(expandColor1_) ?? 0xFF000000);
      expandColor2 = Color(prefs.getInt(expandColor2_) ?? 0xFF666564);
      expandColor3 = Color(prefs.getInt(expandColor3_) ?? 0xFFCCCAC8);
      expandColor4 = Color(prefs.getInt(expandColor4_) ?? 0xFFFFFFFF);
      expandIconColor = Color(prefs.getInt(expandIconColor_) ?? 0xFFFFFFFF);

      determiner = Color(prefs.getInt(determiner_) ?? 0xFFe4e4e4);
      social = Color(prefs.getInt(social_) ?? 0xFFf3d6e9);
      pronoun = Color(prefs.getInt(pronoun_) ?? 0xFFf2edd2);
      noun = Color(prefs.getInt(noun_) ?? 0xFFf2ddcd);
      verb = Color(prefs.getInt(verb_) ?? 0xFFd8ecd8);
      adjective = Color(prefs.getInt(adjective_) ?? 0xFFd0e6f3);
      adverb = Color(prefs.getInt(adverb_) ?? 0xFFf4dede);
      question = Color(prefs.getInt(question_) ?? 0xFFe5e1f7);
      conjunction = Color(prefs.getInt(conjunction_) ?? 0xFFe1e6ba);
      preposition = Color(prefs.getInt(preposition_) ?? 0xFFe4d5e6);
      negation = Color(prefs.getInt(negation_) ?? 0xFFefa1a1);
      interjection = Color(prefs.getInt(interjection_) ?? 0xFFffcbea);
      folder = Color(prefs.getInt(folder_) ?? 0xFFFFFFFF);
      extra1 = Color(prefs.getInt(extra1_) ?? 0xFFd8efe8);
      extra2 = Color(prefs.getInt(extra2_) ?? 0xFFf0dff1);

      determinerBorder = Color(prefs.getInt(determinerBorder_) ?? 0xFFb8b3b3);
      socialBorder = Color(prefs.getInt(socialBorder_) ?? 0xFFe6a4c0);
      pronounBorder = Color(prefs.getInt(pronounBorder_) ?? 0xFFddcaa6);
      nounBorder = Color(prefs.getInt(nounBorder_) ?? 0xFFe1c0a6);
      verbBorder = Color(prefs.getInt(verbBorder_) ?? 0xFF9dd4b1);
      adjectiveBorder = Color(prefs.getInt(adjectiveBorder_) ?? 0xFFaed0e4);
      adverbBorder = Color(prefs.getInt(adverbBorder_) ?? 0xFFe1afaf);
      questionBorder = Color(prefs.getInt(questionBorder_) ?? 0xFFc1bae1);
      conjunctionBorder = Color(prefs.getInt(conjunctionBorder_) ?? 0xFFc3c995);
      prepositionBorder = Color(prefs.getInt(prepositionBorder_) ?? 0xFFd1add6);
      negationBorder = Color(prefs.getInt(negationBorder_) ?? 0xFFd47575);
      interjectionBorder = Color(prefs.getInt(interjectionBorder_) ?? 0xFF6cdd71);
      folderBorder = Color(prefs.getInt(folderBorder_) ?? 0xFFb4b4b4);
      extra1Border = Color(prefs.getInt(extra1Border_) ?? 0xFF97d4c1);
      extra2Border = Color(prefs.getInt(extra2Border_) ?? 0xFFcfadd1);

      cornerTabColor = Color(prefs.getInt(cornerTabColor_) ?? cornerTabColor.toARGB32());
    
    }
}