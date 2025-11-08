import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/editing/editable_buttons.dart';
import 'package:flutterkeysaac/Variables/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Variables/color_variables.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';

class GrammerObjects {
  final String id;
  String? type;
  String? title;
  final List<GrammerObjects> content;


  String? language;
  String? label;
  String? openUUID;
  String? function;

  bool? matchFormat;
  int? format;
  Color? backgroundColor;

  bool? matchFont;
  String? fontFamily;
  double? fontSize;
  double? fontWeight;
  bool? fontItalics;
  bool? fontUnderline;
  Color? fontColor;

  String? symbol;
  double? padding;
  bool? matchOverlayColor;
  Color? overlayColor;
  bool? matchSymbolSaturation;
  double? symbolSaturation;
  bool? matchSymbolContrast;
  double? symbolContrast;
  bool? matchInvertSymbol;
  bool? invertSymbol;

  bool? matchSpeakOS;
  int? speakOS;

  String? note;

  GrammerObjects({ 
    required this.content,
    required this.id,
    this.type,
    this.title,
    this.language,
    this.label,
    this.openUUID,
    this.function,
    this.matchFormat,
    this.format,
    this.backgroundColor,
    this.matchFont,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.fontItalics,
    this.fontUnderline,
    this.fontColor,
    this.symbol,
    this.padding,
    this.matchOverlayColor,
    this.overlayColor,
    this.matchSymbolSaturation,
    this.symbolSaturation,
    this.matchSymbolContrast,
    this.symbolContrast,
    this.matchInvertSymbol,
    this.invertSymbol,
    this.matchSpeakOS,
    this.speakOS,
    this.note
  });

  factory GrammerObjects.fromJson(Map<String, dynamic> json) {
    try {
    return GrammerObjects (
      id: json['id'] as String,
      type: json['type'] as String?,
      title: json['title'] as String?,
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => GrammerObjects.fromJson(e))
              .toList() ??
          [],
      language: json['language'] as String?,
      label: json['label'] as String?,
      openUUID: json['openUUID'] as String?,
      function: json['function'] as String?,
      matchFormat: json['matchFormat'] as bool?,
      format: (json['format'] as num?)?.toInt(),
      backgroundColor: json['backgroundColor'] != null
          ? Color(json['backgroundColor'] as int)
          : null,
      matchFont: json['matchFont'] as bool?,
      fontFamily: json['fontFamily'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontWeight: (json['fontWeight'] as num?)?.toDouble(),
      fontItalics: json['fontItalics'] as bool?,
      fontUnderline: json['fontUnderline'] as bool?,
      fontColor: json['fontColor'] != null
          ? Color(json['fontColor'] as int)
          : null,
      symbol: json['symbol'] as String?,
      padding: (json['padding'] as num?)?.toDouble(),
      matchOverlayColor: json['matchOverlayColor'] as bool?,
      overlayColor: json['overlayColor'] != null
          ? Color(json['overlayColor'] as int)
          : null,
      matchSymbolSaturation: json['matchSymbolSaturation'] as bool?,
      symbolSaturation: (json['symbolSaturation'] as num?)?.toDouble(),
      matchSymbolContrast: json['matchSymbolContrast'] as bool?,
      symbolContrast: (json['symbolContrast'] as num?)?.toDouble(),
      matchInvertSymbol: json['matchInvertSymbol'] as bool?,
      invertSymbol: json['invertSymbol'] as bool?,
      matchSpeakOS: json['matchSpeakOS'] as bool?,
      speakOS: (json['speakOS'] as num?)?.toInt(),
      note: json['note'] as String?
    );
  }  catch (e) {
    print('error in Grammer: $e');
    rethrow;
  }
  }

    Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'type': type,
      'title': title,
      'content': content.map((e) => e.toJson()).toList(),

      'language': language,
      'label': label,
      'openUUID': openUUID,
      'function': function,
      'matchFormat': matchFormat,
      'format': format,
      'backgroundColor': backgroundColor?.toARGB32(),
      
      'matchFont': matchFont,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'fontWeight': fontWeight,
      'fontItalics': fontItalics,
      'fontUnderline': fontUnderline,
      'fontColor': fontColor?.toARGB32(),
      
      'symbol': symbol,
      'padding': padding,
      'matchOverlayColor': matchOverlayColor,
      'overlayColor': overlayColor?.toARGB32(),
      'matchSymbolSaturation': matchSymbolSaturation,
      'symbolSaturation': symbolSaturation,
      'matchSymbolContrast': matchSymbolContrast,
      'symbolContrast': symbolContrast,
      'matchInvertSymbol': matchInvertSymbol,
      'invertSymbol': invertSymbol,
      
      'matchSpeakOS': matchSpeakOS,
      'speakOS': speakOS,

      'note': note,
      };
    }
}


extension BoardsDisplay on GrammerObjects {

  Widget buildWidget(
    TTSInterface synth, 
    void Function(BoardObjects) openBoard, 
    List<BoardObjects> boards, 
    BoardObjects? Function(String uuid, List<BoardObjects> boards) 
    findBoardById) {

       int index = 0;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < content.length; i++) ...[
            (content[i].type == 'folder') 
            ? Expanded(
              child: 
             BuildGrammerFolder(
              obj: content[index++],
              synth: synth, 
              openBoard: openBoard, 
              boards: boards, 
              findBoardById: findBoardById)
            )
            : (content[i].type == 'placeholder') 
              ? Expanded(child: 
              BuildGrammerPlacholder(
                obj: content[index++], 
                synth: synth)
              )
              : Expanded(child: 
              BuildGrammerButton(
                obj: content[index++], 
                synth: synth)
              ),
             
          if (i < 10) Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 6), child:
          FractionallySizedBox(heightFactor: 0.5, child:
          VerticalDivider(
            width: 3,
            thickness: 2,
            color: Cv4rs.themeColor1,
          )
          )
          )
          ]
        ],
      );
    }
  
  Widget buildEditableWidget(
    TTSInterface synth, 
    Root root,
    void Function(BoardObjects) openBoard, 
    List<BoardObjects> boards, 
    BoardObjects? Function(String uuid, List<BoardObjects> boards) 
    findBoardById) {

       int index = 0;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < content.length; i++) ...[
            (content[i].type == 'folder') 
            ? Expanded(
              child: 
             BuildEditableGrammerFolder(
              obj: content[index++],
              synth: synth, 
              openBoard: openBoard, 
              boards: boards, 
              findBoardById: findBoardById,
              root: root)
            )
            : (content[i].type == 'placeholder') 
              ? Expanded(child: 
              BuildEditableGrammerPlacholder(
                obj: content[index++], 
                synth: synth,
                root: root)
              )
              : Expanded(child: 
               BuildEditableGrammerButton(
                obj: content[index++], 
                synth: synth,
                root: root)
              ),
             
          if (i < 10) Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 6), child:
          FractionallySizedBox(heightFactor: 0.5, child:
          VerticalDivider(
            width: 3,
            thickness: 2,
            color: Cv4rs.themeColor1,
          )
          )
          )
          ]
        ],
      );
    }

}




