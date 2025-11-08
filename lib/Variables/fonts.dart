
import 'package:flutterkeysaac/Variables/variables.dart';

class Fontsy {

    static var fonts = getFontsForWritSystem(writingSystemNumber);
    static var includeCurrentFont = !fonts.contains(V4rs.interfaceFont) && V4rs.interfaceFont != 'Default';

    static int writingSystemNumber = languageToWritSysNumber(V4rs.interfaceLanguage);

    static int languageToWritSysNumber(String language) {
    // AR = 1, CY = 2, DE = 3, GR = 4, HA = 5, HE = 6, JA = 7, KO = 8, LA = 9, TH = 10
      switch (language.toLowerCase()) {
        case 'english':
          return 9;
        case 'española':
          return 9;
        case 'français':
          return 9;
        case '中文':
          return 5;
        default:
          return 9;
      }
    }
  
  static List<String> getFontsForWritSystem(int systemNumber) {
    switch (systemNumber) {
      case 1: return arabicFonts;
      case 2: return [...cyrillicFonts, ...cyrillicRoundedFonts];
      case 3: return devanagariFonts;
      case 4: return greekFonts;
      case 5: return []; // hanzi placeholder
      case 6: return hebrewFonts;
      case 7: return japaneseFonts;
      case 8: return koreanFonts;
      case 9: return []; // latin placeholder
      default: return thaiFonts;
    }
  }
  //Font information
    static List <String> supportedWritSys = [
      'Arabic', 
      'Cyrillic', 
      'Devanagari', 
      'Greek', 
      'Hanzi', 
      'Hebrew', 
      'Japanese', 
      'Korean', 
      'Latin', 
      'Thai'
    ];

    //Arabic
    static List <String> arabicFonts = [
    'Noto Sans (for Arabic)',
    'Noto Kufi (for Arabic)',
    'Noto Naskh (for Arabic)',
    ];

    //Cyrillic
    static List <String> cyrillicFonts = [
    'Noto Sans (for Latin, Greek, and Cyrillic)',
    'Noto Serif (for Latin, Greek, and Cyrillic)',
    'Noto Sans Mono',
    ];

    static List <String> cyrillicRoundedFonts = [
    'M PLUS Rounded 1c',
    'Shantell Sans',
    'Comic Relief',
    ];

    //Devanagari
    static List <String> devanagariFonts= [
    'Noto Sans (for Devanagari)',
    'Noto Serif (for Devanagari)',
    ];

    //Greek
    static List <String> greekFonts = [
    'Noto Sans (for Latin, Greek, and Cyrillic)',
    'M PLUS Rounded 1c',
    'Comic Relief',
    'Noto Serif (for Latin, Greek, and Cyrillic)',
    'Noto Sans Mono',
    ];

    //Hanzi
    static List <String> simplifiedHanFonts= [
    'Noto Sans (for Simplified Hanzi)',
    'Noto Serif (for Simplified Hanzi)',
    'ZCOOL XiaoWei',
    'Ma Shan Zheng',
    ];

    static List <String> traditionalHanFonts= [
    'Noto Sans (for Traditional Hanzi)',
    'M PLUS Rounded 1c',
    'Noto Serif (for Traditional Hanzi)',
    ];

    static List <String> hongKongHanziFonts= [
    'Noto Sans (for Hong Kong)',
    'Noto Serif (for Hong Kong)',
    ];

    //hebrew
    static List <String> hebrewFonts = [
    'Noto Sans (for Hebrew)',
    'M PLUS Rounded 1c',
    'Noto Serif (for Hebrew)',
    ];

    //japanese
    static List <String> japaneseFonts= [
    'Noto Sans (for Japanese)',
    'M PLUS Rounded 1c',
    'Noto Serif (for Japanese)',
    ];

    //korean
    static List <String> koreanFonts= [
    'Noto Sans (for Korean)',
    'Noto Serif (for Korean)',
    ];

    //thai
    static List <String> thaiFonts= [
    'Noto Sans (for Thai)',
    'Noto Sans Thai Looped',
    'Itim',
    'Noto Serif (for Thai)',
    ];

    //latin 
    static List <String> latinOpenDyslexicFonts= [
    'Open Dyslexic',
    'Open Dyslexic Alta',
    'Open Dyslexic Mono',
    ];

    static List <String> latinSansSerifFonts = [
    'Noto Sans (for Latin, Greek, and Cyrillic)',
    'Lexend',
    'Atkinson Hyperlegible',
    'Telex',
    ];

    static List <String> latinRoundedFonts = [
    'M PLUS Rounded 1c',
    'Shantell Sans',
    'Comic Relief',
    'Gamja Flower',
    'Itim',
    ];

    static List <String> latinSerifFonts = [
    'Noto Serif (for Latin, Greek, and Cyrillic)',
    'Arvo',
    ];

    static List <String> latinMonoFonts = [
    'Noto Sans Mono',
    'Atkinson Hyperlegible Mono',
    'Courier Prime',
    ];

    static List <String> latinHandwritFonts = [
    'Ma Shan Zheng',
    ];

    static List <String> latinStylizedFonts = [
    'ZCOOL XiaoWei',
    'Manufacturing Consent',
    'Metal Mania',
    'Rye',
    ];

    //get supported writing systems 
    static Map<String, String> fontLanguages = {
      'Open Dyslexic' : 'LA',
      'Open Dyslexic Alta' : 'LA',
      'Open Dyslexic Mono' : 'LA',
      'Noto Sans (for Latin, Greek, and Cyrillic)' : 'CY, GR, LA',
      'Noto Serif (for Latin, Greek, and Cyrillic)' : 'CY, GR, LA',
      'Lexend' : 'LA',
      'Atkinson Hyperlegible' : 'LA',
      'M PLUS Rounded 1c' : 'CY, GR, HA, HE, JA, LA',
      'Shantell Sans' : 'CY, LA',
      'Comic Relief' : 'CY, GR, LA',
      'Itim' : 'LA, TH',
      'Arvo' : 'LA',
      'Noto Sans Mono' : 'CY, GR, LA',
      'Atkinson Hyperlegible Mono' : 'LA',
      'Courier Prime' : 'LA',
      'Ma Shan Zheng' : 'HA, LA',
      'ZCOOL XiaoWei' : 'HA, LA',
      'Manufacturing Consent' : 'LA',
      'Metal Mania' : 'LA',
      'Rye' : 'LA',
      'Noto Sans Thai Looped' : 'TH',
      'Noto Sans (for Arabic)' : 'AR',
      'Noto Kufi (for Arabic)' : 'AR',
      'Noto Naskh (for Arabic)' : 'AR',
      'Noto Sans (for Hebrew)' : 'HE',
      'Noto Serif (for Hebrew)' : 'HE',
      'Noto Sans (for Devanagari)' : 'DE',
      'Noto Serif (for Devanagari)' : 'DE',
      'Noto Sans (for Japanese)' : 'JA',
      'Noto Serif (for Japanese)' : 'JA',
      'Noto Sans (for Korean)' : 'KO',
      'Noto Serif (for Korean)' : 'KO',
      'Noto Sans (for Hong Kong)' : 'HA',
      'Noto Serif (for Hong Kong)' : 'HA',
      'Noto Sans (for Simplified Hanzi)' : 'HA',
      'Noto Serif (for Traditional Hanzi)' : 'HA',
      'Noto Sans (for Traditional Hanzi)' : 'HA',
      'Noto Serif (for Simplified Hanzi)' : 'HA',
      'Gamja Flower' : 'KO, LA',
      'Noto Sans (for Thai)' : 'TH',
      'Noto Serif (for Thai)' : 'TH',
      'Telex' : 'LA',
    };

    //convert from display name to pubspec yaml name
    static Map<String, String> fontToFamily = {
      'Open Dyslexic' : 'openDyslexic',
      'Open Dyslexic Alta' : 'openDyslexicAlta',
      'Open Dyslexic Mono' : 'openDyslexicMono',
      'Noto Sans (for Latin, Greek, and Cyrillic)' : 'notoSansLCG',
      'Noto Serif (for Latin, Greek, and Cyrillic)' : 'notoSerifLCG',
      'Lexend' : 'lexend',
      'Atkinson Hyperlegible' : 'atkinsonHyperlegible',
      'M PLUS Rounded 1c' : 'mPLUSRounded1c',
      'Shantell Sans' : 'shantellSans',
      'Comic Relief' : 'comicRelief',
      'Itim' : 'itim',
      'Arvo' : 'arvo',
      'Noto Sans Mono' : 'notoSansMono',
      'Atkinson Hyperlegible Mono' : 'atkinsonHyperlegibleMono',
      'Courier Prime' : 'courierPrime',
      'Ma Shan Zheng' : 'maShanZheng',
      'ZCOOL XiaoWei' : 'zCOOLXiaoWei',
      'Manufacturing Consent' : 'manufacturingConsent',
      'Metal Mania' : 'metalMania',
      'Rye' : 'rye',
      'Noto Sans Thai Looped' : 'notoSansThaiLooped',
      'Noto Sans (for Arabic)' : 'notoSansArabic',
      'Noto Kufi (for Arabic)' : 'notoKufiArabic',
      'Noto Naskh (for Arabic)' : 'notoNaskhArabic',
      'Noto Sans (for Hebrew)' : 'notoSansHebrew',
      'Noto Serif (for Hebrew)' : 'notoSerifHebrew',
      'Noto Sans (for Devanagari)' : 'notoSansDevanagari',
      'Noto Serif (for Devangari)' : 'notoSerifDevanagari',
      'Noto Sans (for Japanese)' : 'notoSansJP',
      'Noto Serif (for Japanese)' : 'notoSerifJapanese',
      'Noto Sans (for Korean)' : 'notoSansKorean',
      'Noto Serif (for Korean)' : 'notoSerifKorean',
      'Noto Sans (for Hong Kong)' : 'notoSansHK',
      'Noto Serif (for Hong Kong)' : 'notoSerifHK',
      'Noto Sans (for Simplified Hanzi)' : 'notoSansSimplified',
      'Noto Serif (for Traditional Hanzi)' : 'notoSerifTraditional',
      'Noto Sans (for Traditional Hanzi)' : 'notoSansTraditional',
      'Noto Serif (for Simplified Hanzi)' : 'notoSerifSimplified',
      'Gamja Flower' : 'gamjaFlower',
      'Telex' : 'telex',
    };

}