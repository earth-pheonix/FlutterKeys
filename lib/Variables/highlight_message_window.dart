import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterkeysaac/Variables/fonts/font_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:async';

class HV4rs {
   static bool highlightAsSpoken = !kIsWeb && Platform.isIOS;
  static final String _highlightAsSpoken = "highlightAsSpoken";

  static Future<void> saveHighlightAsSpoken (bool highlightAsSpoken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_highlightAsSpoken, highlightAsSpoken);
  } 

  static final highlightStart = ValueNotifier<int>(0);
  static ValueNotifier<int> highlightAdd = ValueNotifier<int>(0);
  static ValueNotifier<int?> highlightLength = ValueNotifier<int?>(null);
  static ValueNotifier<bool> enableHighlighting = ValueNotifier(true);

  static ValueNotifier<bool> useWPM = ValueNotifier(false);
  static double currentWPM = 150;
  static ValueNotifier<int> streamVersion = ValueNotifier(0);

  static final StreamController<Map<String, dynamic>> _wordController =
      StreamController<Map<String, dynamic>>.broadcast();

  static Stream<Map<String, dynamic>> get wordStream => 
      _wordController.stream;

  static StreamSubscription? _activeSubscription;


  static void resetHighlightStart() {
    highlightStart.value = 0;
  }

  static void setHighlightStart(int where){
    highlightStart.value += where;
  }

  static Stream<Map<String, int>?>? fakeWordStream(){
    final interval = Duration(milliseconds: (60000 / HV4rs.currentWPM).round());
    final words = V4rs.message.value.split(' ');
    int currentHighlightStart = 0;

    return Stream<Map<String, int>?>.periodic(interval, (i) {
      if (i >= words.length) return null;

      String word = words[i];
      int start = V4rs.message.value.indexOf(word, currentHighlightStart);
      currentHighlightStart = start + word.length; 

      return {
        'start': start, 
        'length': word.length
      };
    })
      .take(words.length)
      .where((e) => e != null)
      .asBroadcastStream();
  }

  static void subscribeWordStream(TTSInterface? synth) {

    _activeSubscription?.cancel();

    final Stream<Map<String, dynamic>?> source =
        useWPM.value 
        ? fakeWordStream()! 
        : synth!.wordStream;

      _activeSubscription = source.listen((event) {
        if (event != null) {
          _wordController.add(event);
        }
      });
  }

  //called in message window to display the highlight
  static Widget highlightedTextWidget( 
    BuildContext context, 
    TextEditingController controller,
    ScrollController scrollController,
  ) {
    //text and text styling
    final defaultStyle = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    final text = controller.text;

    //tells us where to keep in frame (scrolling to keep highlight visible)
    final highlightKey = GlobalKey();

    //keep track of highlight start, stream version, and the stream itself
    return ValueListenableBuilder<int>(
      valueListenable: HV4rs.highlightStart,
      builder: (context, notifierStart, _) {

    return ValueListenableBuilder<int>(
      valueListenable: HV4rs.streamVersion,
      builder: (context, _, _) {
    
    return StreamBuilder<Map<String, dynamic>?>(
      stream: wordStream, 
      builder: (context, highlightStream) {

      //saftey
      if (!enableHighlighting.value || !highlightStream.hasData) {
        return Text(
          controller.text,
          style: defaultStyle,
        );
      } 

      //highlight info
      final data = highlightStream.data!;
      final start = (data['start'] as int) + notifierStart;
      final length = (data['length'] as int);

      final safeStart = start.clamp(0, text.length);
      final safeEnd = (safeStart + length).clamp(0, text.length);

      //callback to keep highlight in frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (highlightKey.currentContext != null) {
          Scrollable.ensureVisible(
            highlightKey.currentContext!,
            duration: Duration.zero, 
            alignment: 0.5,         
          );
        }
      });

      //the display itself
      return SingleChildScrollView(
        controller: scrollController,
        child: RichText(
          textScaler: MediaQuery.of(context).textScaler,
          text: TextSpan(
            style: defaultStyle.merge(Fv4rs.mwLabelStyle),
            children: [
              //text before highlighted
              TextSpan(
                text: text.substring(0, safeStart),
                style: Fv4rs.mwLabelStyle,
              ),
              //highlighted
              TextSpan(
                text: text.substring(safeStart, safeEnd),
                style: Fv4rs.highlightTextStyle,
              ),
              // anchor for scrolling
              WidgetSpan(
                child: SizedBox(
                  key: highlightKey,
                  width: 0,
                  height: 0,
                ),
              ),
              //text after higghlighted segment
              TextSpan(
                text: text.substring(safeEnd),
                style: Fv4rs.mwLabelStyle,
              ),
             ],
          ),
        ),
      );
     },
    );
     }
    );
     }
    );
  }

static Widget highlightedSymbolTextWidget( 
    BuildContext context, 
    TextEditingController controller,
    ScrollController scrollController,
  ) {
    //text and text styling
    final defaultStyle = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    final text = controller.text;

    //tells us where to keep in frame (scrolling to keep highlight visible)
    final highlightKey = GlobalKey();

    //keep track of highlight start, stream version, and the stream itself
    return ValueListenableBuilder<int>(
      valueListenable: HV4rs.highlightStart,
      builder: (context, notifierStart, _) {

    return ValueListenableBuilder<int>(
      valueListenable: HV4rs.streamVersion,
      builder: (context, _, _) {
    
    return StreamBuilder<Map<String, dynamic>?>(
      stream: wordStream, 
      builder: (context, highlightStream) {

      //saftey
      if (!enableHighlighting.value || !highlightStream.hasData) {
        return Text(
          controller.text,
          style: defaultStyle,
        );
      } 

      //highlight info
      final data = highlightStream.data!;
      final start = (data['start'] as int) + notifierStart;
      final length = (data['length'] as int);

      final safeStart = start.clamp(0, text.length);
      final safeEnd = (safeStart + length).clamp(0, text.length);

      //callback to keep highlight in frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (highlightKey.currentContext != null) {
          Scrollable.ensureVisible(
            highlightKey.currentContext!,
            duration: Duration.zero, 
            alignment: 0.5,         
          );
        }
      });

      //the display itself
      return SingleChildScrollView(
        controller: scrollController,
        child: RichText(
          textScaler: MediaQuery.of(context).textScaler,
          text: TextSpan(
            style: defaultStyle.merge(Fv4rs.mwLabelStyle),
            children: [
              //text before highlighted
              TextSpan(
                text: text.substring(0, safeStart),
                style: Fv4rs.mwLabelStyle,
              ),
              //highlighted
              TextSpan(
                text: text.substring(safeStart, safeEnd),
                style: Fv4rs.highlightTextStyle,
              ),
              // anchor for scrolling
              WidgetSpan(
                child: SizedBox(
                  key: highlightKey,
                  width: 0,
                  height: 0,
                ),
              ),
              //text after higghlighted segment
              TextSpan(
                text: text.substring(safeEnd),
                style: Fv4rs.mwLabelStyle,
              ),
             ],
          ),
        ),
      );
     },
    );
     }
    );
     }
    );
  }


}