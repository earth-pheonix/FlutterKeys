import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';

class Vv4rs{

  static List<Map<String, dynamic>> systemVoices = [];

  static List<Map<String, dynamic>> uniqueSystemVoices = [];

  //function to load system voices
  static Future<void> loadVoices(TTSInterface tts) async {
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
    
    Vv4rs.systemVoices = allVoices;
  }

  static String cleanVoiceLabel(Map voice) {
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
        uniqueSystemVoices = filteredVoices.where((voice) {
          final key = '${voice['name']}|${voice['language']}';
          if (seenVoices.contains(key)) {
            return false; // Skip duplicates
          } else {
            seenVoices.add(key);
            return true; // Keep unique voices
          }
        }).toList();

        //find the current voice
        final currentValue = Sv4rs.getLangVoice(language);

        //set the voices
        final validVoiceValues = [
          'default',
          ...uniqueSystemVoices.map((voice) => voice['identifier']!)
        ];

        dropdownValue = (validVoiceValues.contains(currentValue) && (currentValue != null)) 
          ? currentValue 
          : 'default';
  }

}