import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/fonts/font_variables.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/fonts/font_options.dart';
import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutterkeysaac/Variables/colors/color_pickers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;


class FontPicker1 extends StatefulWidget {
  final double size;
  final int weight;
  final bool italics; 
  final bool useUnderline;
  final bool underline;
  final String font;
  final String label;
  final Color color;
  final ValueChanged<double> onSizeChanged;
  final ValueChanged<int> onWeightChanged;
  final ValueChanged<bool> onItalicsChanged;
  final ValueChanged<String> onFontChanged;
  final ValueChanged<String> onColorChanged;
  final ValueChanged<bool> onUnderlineChanged;
  final TTSInterface tts;
  final int sizeMin;
  final int sizeMax;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

  const FontPicker1({
    super.key,
    required this.size,
    required this.weight,
    required this.italics,
    required this.font,
    required this.label,
    required this.color,
    required this.onSizeChanged,
    required this.onWeightChanged,
    required this.onItalicsChanged,
    required this.onFontChanged,
    required this.onColorChanged,
    required this.useUnderline,
    this.underline = false,
    required this.onUnderlineChanged,
    required this.tts,
    this.sizeMin = 5,
    this.sizeMax = 50,
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,
  });

  @override
  State<FontPicker1> createState() => _FontPickerState1();
}

class _FontPickerState1 extends State<FontPicker1> {
  late bool _useUnderline;
  late bool _underline;
  late double _size;
  late int _weight;
  late bool _italics;
  late String _font;
  late TTSInterface _tts;
  late Color _color;


  @override
  void initState() {
    super.initState();
    _size = widget.size;
    _weight = widget.weight;
    _italics = widget.italics;
    _font = widget.font;
    _tts = widget.tts;
    _color = widget.color;
    _useUnderline = widget.useUnderline;
    _underline = widget.underline;
  }

  TextStyle get labelStyle =>  
  TextStyle(
    color: _color, 
    fontSize: V4rs.fontValue(_size), 
    fontFamily: Fontsy.fontToFamily[_font] ?? _font, 
    fontWeight: FontWeight.values[((_weight ~/ 100) - 1 ).clamp(0, 8)],
    fontStyle: _italics ? FontStyle.italic : FontStyle.normal,
    decoration: (_underline) ? TextDecoration.underline : TextDecoration.none,
    );


  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.label,  style: Sv4rs.settingslabelStyle,),
      collapsedBackgroundColor: Cv4rs.themeColor4,
      backgroundColor: Cv4rs.themeColor4,
      childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(20)),
      onExpansionChanged: (bool expanded) {  
        if (Sv4rs.speakInterfaceButtonsOnSelect) {
            V4rs.speakOnSelect(
              widget.label, V4rs.selectedLanguage.value, 
              _tts,
              widget.speakSelectSherpaOnnxSynth,
              widget.initForSS,
              widget.playerForSS,
            );
          }},
      children: [
        // Sample text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded( child: Center( child: 
            Text(
              'Sample Text: Abcde',
              style: labelStyle,
            ),
            ),
            ),
          ],
        ),

        // Size slider
         Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(20)), child:
        Row(
          children: [
            Text('Size:', style: Sv4rs.settingslabelStyle,),
            Expanded(
              child: Slider(
                value: _size,
                min: widget.sizeMin.toDouble(),
                max: widget.sizeMax.toDouble(),
                divisions: 40,
                activeColor: Cv4rs.themeColor1,
                inactiveColor: Cv4rs.themeColor3,
                thumbColor: Cv4rs.themeColor1,
                onChanged: (val) {
                  setState(() => _size = val);
                  widget.onSizeChanged(val);
                },
              ),
            ),
          ],
        ),
        ),

        // Italics switch
        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(20)), child:
        Row(
          children: [
            Text('Italics:', style: Sv4rs.settingslabelStyle, ),
            Spacer(),
            Switch(
              value: _italics,
              onChanged: (val) {
                setState(() => _italics = val);
                widget.onItalicsChanged(val);
              },
            ),
          ],
        ),
         ),

        // Underline switch
        if (_useUnderline) 
        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(20)), child:
        Row(
          children: [
            Text('Underline:', style: Sv4rs.settingslabelStyle, ),
            Spacer(),
            Switch(
              value: _underline,
              onChanged: (val) {
                setState(() => _underline = val);
                widget.onUnderlineChanged(val);
              },
            ),
          ],
        ),
        ),

       
        // Weight slider
        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(20)), child:
        Row(
          children: [
            Text('Weight:', style: Sv4rs.settingslabelStyle,),
            Expanded(
              child: Slider(
                value: _weight.toDouble(),
                min: 100,
                max: 900,
                divisions: 8,
                activeColor: Cv4rs.themeColor1,
                inactiveColor: Cv4rs.themeColor3,
                thumbColor: Cv4rs.themeColor1,
                onChanged: (val) {
                  setState(() => _weight = val.toInt());
                  widget.onWeightChanged(val.toInt());
                },
              ),
            ),
          ],
        ),
        ),

        //font picker
        FontFamilyPicker(
          font: _font, onFontChanged: widget.onFontChanged, 
          tts: _tts, label: 'Font Family: ${Fontsy.familyToFont[_font]}',
          speakSelectSherpaOnnxSynth: widget.speakSelectSherpaOnnxSynth,
          initForSS: widget.initForSS,
          playerForSS: widget.playerForSS,
        ),

        //color font 
        ExpansionTile(
            title: Row(
              children: [
                Text('Font Color:', style: Sv4rs.settingslabelStyle,),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: Cv4rs.themeColor3,
                  radius: 20,
                  child: Icon(Icons.circle, color: _color, size: 40, shadows: [
                    Shadow(
                      color: Cv4rs.themeColor4,
                      blurRadius: 4,
                    ),
                  ],),
                ),
              ]
            ),
            children: [
              //hexcode input
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(40), vertical: V4rs.paddingValue(20)),
                child: HexCodeInput(
                  startValue: _color.toHexString(),
                  textStyle: Sv4rs.settingslabelStyle,
                  hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                  onColorChanged: (color) {
                    setState(() => _color = color);
                    widget.onColorChanged(color.toHexString());
              },
                ),
              ),
              //color picker
              Padding(
                padding: EdgeInsets.fromLTRB(
                  V4rs.paddingValue(40), 0, 
                  V4rs.paddingValue(10), V4rs.paddingValue(10)),
                child: ColorPicker(
                  pickerColor: _color, 
                  enableAlpha: true,
                  displayThumbColor: false,
                  labelTypes: ColorLabelType.values,
                  onColorChanged: (color) {
                    setState(() => _color = color);
                    widget.onColorChanged(color.toHexString());
              },
                ),
            ),
          ],
        ),
      ],
    );
  }
}

class FontPicker2 extends StatefulWidget {
  final bool specialLabel;
  final double size;
  final bool matchFontSet;
  final int weight;
  final bool italics; 
  final bool useUnderline;
  final bool underline;
  final String font;
  final String label;
  final Color color;
  final double height;
  final ValueChanged<double> onSizeChanged;
  final ValueChanged<int> onWeightChanged;
  final ValueChanged<bool> onMatchFont;
  final ValueChanged<bool> onItalicsChanged;
  final ValueChanged<String> onFontChanged;
  final ValueChanged<String> onColorChanged;
  final ValueChanged<bool> onUnderlineChanged;
  final int sizeMin;
  final int sizeMax;
  final Widget widgety;
  final int divisions;

  const FontPicker2({
    super.key,
    this.divisions = 40,
    required this.widgety,
    required this.matchFontSet,
    required this.size,
    required this.height,
    required this.weight,
    required this.italics,
    required this.font,
    required this.label,
    required this.color,
    required this.onSizeChanged,
    required this.onWeightChanged,
    required this.onItalicsChanged,
    required this.onFontChanged,
    required this.onColorChanged,
    required this.onMatchFont,
    required this.useUnderline,
    this.underline = false,
    required this.onUnderlineChanged,
    this.sizeMin = 5,
    this.sizeMax = 50,
    this.specialLabel = false,
  });

  @override
  State<FontPicker2> createState() => _FontPickerState2();
}

class _FontPickerState2 extends State<FontPicker2> {
  late bool _useUnderline;
  late bool _underline;
  late double _size;
  late int _weight;
  late bool _italics;
  late String _font;
  late Color _color;
  late double _height;
  late bool _matchFontSet;


  @override
  void initState() {
    super.initState();
    _size = widget.size;
    _weight = widget.weight;
    _italics = widget.italics;
    _font = widget.font;
    _color = widget.color;
    _useUnderline = widget.useUnderline;
    _underline = widget.underline;
    _height = widget.height;
    _matchFontSet = widget.matchFontSet;
  }

  TextStyle get labelStyle =>  
  TextStyle(
    color: _color, 
    fontSize: V4rs.fontValue(_size), 
    fontFamily: Fontsy.fontToFamily[_font] ?? _font, 
    fontWeight: FontWeight.values[((_weight ~/ 100) - 1 ).clamp(0, 8)],
    fontStyle: _italics ? FontStyle.italic : FontStyle.normal,
    decoration: (_underline) ? TextDecoration.underline : TextDecoration.none,
    );


  Widget dynamicTextAndWidget(List<Widget> Function() textAndWidget){
    if (!V4rs.smallEditorMode) {
      return Row(children: [
        Expanded(child: textAndWidget()[0]),
        textAndWidget()[1],
        ]
      ); 
    } else { 
      return Column(children: textAndWidget());
    }
  }

  List<Widget> textAndSwitch(String text, bool value, void Function(bool)? onChanged){
    return [
      Text(
        text, 
        style: Sv4rs.settingslabelStyle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      Switch(
        value: value,
        onChanged: onChanged
      ),
    ];
  }

  List<Widget> matchFontWidget(){
    return textAndSwitch(
      'Match Font:',
      _matchFontSet,
      (val) {
        setState(() => _matchFontSet = val);
        widget.onMatchFont(val);
      },
    );
  }

  List<Widget> italicsWidget(){
    return textAndSwitch(
      'Italics:',
      _italics,
      (val) {
        setState(() => _italics = val);
        widget.onItalicsChanged(val);
      },
    );
  }

  List<Widget> underlineWidget(){
    return textAndSwitch(
      'Underline:',
      _underline,
      (val) {
        setState(() => _underline = val);
        widget.onUnderlineChanged(val);
      },
    );
  }

  List <Widget> colorTitleWidget() {
    return [ 
      Text('Font Color:', style: Sv4rs.settingslabelStyle, textAlign: TextAlign.center),
      CircleAvatar(
        backgroundColor: Cv4rs.themeColor3,
        radius: 20,
        child: Icon(
          Icons.circle, color: _color, size: 40, 
          shadows: [
            Shadow(
              color: Cv4rs.themeColor4,
              blurRadius: 4,
            ),
          ],
        ),
      ),
    ];
  }
  


  @override
  Widget build(BuildContext context) {
    return Container(
       padding: EdgeInsets.all(V4rs.paddingValue(10)),
       decoration: BoxDecoration(
        color: Cv4rs.themeColor4,
        borderRadius: BorderRadius.circular(10)
        ),
      child: Column(children:[
        if (widget.specialLabel)
          Text('--Not All Match--', style: Sv4rs.settingslabelStyle),
        // Sample text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded( child: Center( child: 
            Padding(
              padding: EdgeInsetsGeometry.all(V4rs.paddingValue(V4rs.paddingValue(5))),
              child: 
            Text(
              'Sample Text: Abcde',
              style: labelStyle,
              textAlign: TextAlign.center,
            ),
            ),
            ),
            ),
          ],
        ),

        //match font
        dynamicTextAndWidget(matchFontWidget),
        

        // Size slider
        Padding(padding: EdgeInsetsGeometry.symmetric(vertical: V4rs.paddingValue(10)), child: 
        Column(
          children: [
            Text('Size: $_size', style: Sv4rs.settingslabelStyle,),
             Slider(
              padding: EdgeInsets.fromLTRB(
                V4rs.paddingValue(5), 
                V4rs.paddingValue(5), 
                V4rs.paddingValue(5), 
                V4rs.paddingValue(10),
              ),
              value: _size,
              min: widget.sizeMin.toDouble(),
              max: widget.sizeMax.toDouble(),
              divisions: widget.divisions,
              activeColor: Cv4rs.themeColor1,
              inactiveColor: Cv4rs.themeColor3,
              thumbColor: Cv4rs.themeColor1,
              onChanged: (val) {
                setState(() => _size = val);
                widget.onSizeChanged(val);
              },
              ),
          ],
        ),
        ),

        // Italics switch
        dynamicTextAndWidget(italicsWidget),
        

        // Underline switch
        if (_useUnderline) 
        dynamicTextAndWidget(underlineWidget),
        
        
        // Weight slider
        Padding(padding: EdgeInsetsGeometry.fromLTRB(0, V4rs.paddingValue(10), 0, 0), child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [ 
            Text(
              'Weight: $_weight', 
              textAlign: TextAlign.start,
              style: Sv4rs.settingslabelStyle,
            ),
            
            Slider(
              padding: EdgeInsets.fromLTRB(
                V4rs.paddingValue(5), 
                V4rs.paddingValue(5), 
                V4rs.paddingValue(5), 
                V4rs.paddingValue(10),
              ),
                value: _weight.toDouble(),
                min: 100,
                max: 900,
                divisions: 8,
                activeColor: Cv4rs.themeColor1,
                inactiveColor: Cv4rs.themeColor3,
                thumbColor: Cv4rs.themeColor1,
                onChanged: (val) {
                  setState(() => _weight = val.toInt());
                  widget.onWeightChanged(val.toInt());
                },
            ),
          ],
        
        ),
        ),
        //font picker
        FontFamilyPicker2(
          font: _font, 
          onFontChanged: widget.onFontChanged, 
          label: 'Font Family:'
        ),
        
        //color font 
        ExpansionTile(
          tilePadding: EdgeInsets.all(0),
          title: dynamicTextAndWidget(colorTitleWidget),          
          children: [
              Column(children:[
              //hexcode input
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: V4rs.paddingValue(10), vertical: V4rs.paddingValue(20)),
                child: HexCodeInput2(
                  startValue: _color.toHexString(),
                  textStyle: Sv4rs.settingslabelStyle,
                  hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                  onColorChanged: (color) {
                    setState(() => _color = color);
                    widget.onColorChanged(color.toHexString());
              },
                ),
              ),
              //color picker
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: 
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[ 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Text('Scroll horizontally here...', 
                      style: Sv4rs.settingsSecondaryLabelStyle,
                      ),
                  SizedBox(height: 30,),
                  ]),
                  GestureDetector(
                    onVerticalDragStart: (_) {},
                    onVerticalDragUpdate: (_) {},
                    onVerticalDragEnd: (_) {},
                    child:
                SizedBox(
                  height: _height,
                  child:  
                  ColorPicker(
                  pickerColor: _color, 
                  enableAlpha: true,
                  displayThumbColor: false,
                  labelTypes: ColorLabelType.values,
                  onColorChanged: (color) {
                    setState(() => _color = color);
                    widget.onColorChanged(color.toHexString());
              },
                ),
                ))]
              
            ),
              ),
          ]),
          ],
        ),

        widget.widgety,
      ]
     ),
    );
  }
}

class FontFamilyPicker extends StatefulWidget {
  final String font;
  final ValueChanged<String> onFontChanged;
  final TTSInterface? tts;
  final String label;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function()? initForSS;
  final AudioPlayer? playerForSS;

  const FontFamilyPicker({
    super.key,
    required this.font,
    required this.onFontChanged,
    required this.label,
    this.tts,
    this.speakSelectSherpaOnnxSynth,
    this.initForSS,
    this.playerForSS,
  });

  @override
  State<FontFamilyPicker> createState() => _FontFamilyPicker();
}

class _FontFamilyPicker extends State<FontFamilyPicker> {
  late String _font;


  @override
  void initState() {
    super.initState();
    _font = widget.font;
  }

  TextStyle get labelStyle =>  
  TextStyle(
    color: Fv4rs.interfaceFontColor, 
    fontSize: V4rs.fontValue(Fv4rs.interfaceFontSize), 
    fontFamily: Fontsy.fontToFamily[_font] ?? _font, 
    fontWeight: FontWeight.values[((Fv4rs.interfaceFontWeight ~/ 100) - 1 ).clamp(0, 8)],
    fontStyle: Fv4rs.interfaceFontItalics ? FontStyle.italic : FontStyle.normal,
    );


  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.label,  style: Sv4rs.settingslabelStyle,),
      collapsedBackgroundColor: Cv4rs.themeColor4,
      backgroundColor: Cv4rs.themeColor4,
      childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(20)),
      onExpansionChanged: (bool expanded) {  
        if (Sv4rs.speakInterfaceButtonsOnSelect 
          && widget.tts != null
          && widget.initForSS != null
          && widget.playerForSS != null
        ) {
            V4rs.speakOnSelect(
              widget.label, 
              V4rs.selectedLanguage.value, 
              widget.tts!,
              widget.speakSelectSherpaOnnxSynth,
              widget.initForSS!,
              widget.playerForSS!,
            );
          }},
      children: [
        // Sample text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded( child: Center( child: 
            Text(
              'Sample Text: ${Fontsy.getSampleForWritSystem(Fontsy.writingSystemNumber)}',
              style: labelStyle,
            ),
            ),
            ),
          ],
        ),
        
        //font picker
        ExpansionTile(
          title: Text('Font:', style: Sv4rs.settingslabelStyle,),
          collapsedBackgroundColor: Cv4rs.themeColor4,
          backgroundColor: Cv4rs.themeColor4,
          
          children: [
            ExpansionTile(
          title: Row (mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Text('Language Writing System: ${
              Fontsy.writingSystemNumber == 1 ? 'Arabic'
            : Fontsy.writingSystemNumber == 2 ? 'Cyrillic'
            : Fontsy.writingSystemNumber == 3 ? 'Devanagari' 
            : Fontsy.writingSystemNumber == 4 ? 'Greek'
            : Fontsy.writingSystemNumber == 5 ? 'Hanzi'
            : Fontsy.writingSystemNumber == 6 ? 'Hebrew'
            : Fontsy.writingSystemNumber == 7 ? 'Japanese'
            : Fontsy.writingSystemNumber == 8 ? 'Korean'
            : Fontsy.writingSystemNumber == 9 ? 'Latin'
            : 'Thai'
          }', style: Sv4rs.settingslabelStyle, textAlign: TextAlign.center,
          ), 
            ),
           ]),
          childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(40)), 
          children: [
            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(10)), child:
            Row(
              children: [
                Expanded(child: 
                  Text('Writing System:', style: Sv4rs.settingslabelStyle,),
                ),
                Expanded(
                  flex: 5,
                  child: Slider(
                    value: Fontsy.writingSystemNumber.toDouble(), 
                    min: 1.0,
                    max: 10.0,
                    divisions: 11,
                    activeColor: Cv4rs.themeColor1,
                    inactiveColor: Cv4rs.themeColor3,
                    thumbColor: Cv4rs.themeColor1,
                    onChanged: (value) async {
                        setState(() {
                          Fontsy.writingSystemNumber = value.round();
                        });
                      },
                    ),
                ),
                Expanded(child: Text(
                  Fontsy.writingSystemNumber == 1 ? 'Arabic' 
                  : Fontsy.writingSystemNumber == 2 ? 'Cyrillic' 
                  : Fontsy.writingSystemNumber == 3 ? 'Devanagari' 
                  : Fontsy.writingSystemNumber == 4 ? 'Greek'
                  : Fontsy.writingSystemNumber == 5 ? 'Hanzi' 
                  : Fontsy.writingSystemNumber == 6 ? 'Hebrew' 
                  : Fontsy.writingSystemNumber == 7 ? 'Japanese' 
                  : Fontsy.writingSystemNumber == 8 ? 'Korean' 
                  : Fontsy.writingSystemNumber == 9 ? 'Latin' 
                  : 'Thai', style: Sv4rs.settingslabelStyle,
                ),
              ),
          ],
        ),
            ),
            ],
            ),
        
            RadioGroup<String>(
              groupValue: _font,
              onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Text('Default', style: Sv4rs.settingslabelStyle,),
                    value: 'Default',
                  ),

              //
              //Cyrillic
              //

              if (Fontsy.writingSystemNumber == 2) ...[
              ...Fontsy.cyrillicFonts.map((font) {
              return RadioListTile<String>(
                title: Row(
                  children: [
                    Expanded(flex: 3, child: 
                      Text(font, style: Sv4rs.settingslabelStyle,),
                    ),
                    Spacer(flex: 1),
                    Expanded(flex: 2, child: 
                      Text('Абвг', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                    ),
                    Spacer(flex: 1),
                      Expanded(flex: 3, child: 
                    Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                    ),
                  ],
                ),
                value: font,
              );
            }
        ),
        ExpansionTile(
          title: Text('Rounded fonts:', style: Sv4rs.settingslabelStyle,),
          children: [
            ...Fontsy.cyrillicRoundedFonts.map((font) {
              return RadioListTile<String>(
                title: Row(
                  children: [
                    Expanded(flex: 3, child: 
                    Text(font, style: Sv4rs.settingslabelStyle,),
                    ),
                    Spacer(flex: 1),
                    Expanded(flex: 2, child: 
                      Text('Абвг', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                    ),
                    Spacer(flex: 1),
                    Expanded(flex: 3, child: 
                      Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                    ),
                  ],
                ),
                value: font,
              );
            }
        ),
          ],
        ),
          ] 
          
              //
              //Chinese
              //

              else if (Fontsy.writingSystemNumber == 5) ...[
                ExpansionTile(
                  title: Text('Simplified Hanzi', style: Sv4rs.settingslabelStyle,),
                  children: [
                    ...Fontsy.simplifiedHanFonts.map((font) {
                      return RadioListTile<String>(
                        title: Row(
                          children: [
                            Expanded(flex: 3, child: 
                            Text(font, style: Sv4rs.settingslabelStyle,),
                            ),
                            Spacer(flex: 1),
                            Expanded(flex: 2, child: 
                            Text('的一是学国', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                            ),
                            Spacer(flex: 1),
                            Expanded(flex: 3, child: 
                            Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                            ),
                          ],
                        ),
                        value: font,
                      );
                    }
                ),
                  ],
                ),
                ExpansionTile(
                  title: Text('Traditional Hanzi', style: Sv4rs.settingslabelStyle,),
                  children: [
                    ...Fontsy.traditionalHanFonts.map((font) {
                      return RadioListTile<String>(
                        title: Row(
                          children: [
                            Expanded(flex: 3, child: 
                            Text(font, style: Sv4rs.settingslabelStyle,),
                            ),
                            Spacer(flex: 1),
                            Expanded(flex: 2, child: 
                            Text('的一是學國', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                            ),
                            Spacer(flex: 1),
                            Expanded(flex: 3, child: 
                            Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                            ),
                          ],
                        ),
                        value: font,
                      );
                    }
                ),
                  ],
                ),
                ExpansionTile(
                  title: Text('Hong Kong Hanzi', style: Sv4rs.settingslabelStyle,),
                  children: [
                    ...Fontsy.hongKongHanziFonts.map((font) {
                      return RadioListTile<String>(
                        title: Row(
                          children: [
                            Expanded(flex: 3, child: 
                            Text(font, style: Sv4rs.settingslabelStyle,),
                            ),
                            Spacer(flex: 1),
                            Expanded(flex: 2, child: 
                            Text('的一是學國', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                            ),
                            Spacer(flex: 1),
                            Expanded(flex: 3, child: 
                            Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                            ),
                          ],
                        ),
                        value: font,
                      );
                    }
                ),
                  ],
                ),
                  
              ] 

              //
              //Latin
              //

              else if (Fontsy.writingSystemNumber == 9) ...[
            ExpansionTile(
              title: Text('OpenDyslexic', style: Sv4rs.settingslabelStyle,),
              children: [
                ...Fontsy.latinOpenDyslexicFonts.map((font) {
                  return RadioListTile<String>(
                    title: Row(
                      children: [
                        Expanded(flex: 3, child: 
                        Text(font, style: Sv4rs.settingslabelStyle,),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 2, child: 
                        Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 3, child: 
                        Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                        ),
                      ],
                    ),
                    value: font,
                  );
                }
            ),
              ],
            ),
            ExpansionTile(
              title: Text('Sans-Serif', style: Sv4rs.settingslabelStyle,),
              children: [
                ...Fontsy.latinSansSerifFonts.map((font) {
                  return RadioListTile<String>(
                    title: Row(
                      children: [
                        Expanded(flex: 3, child: 
                        Text(font, style: Sv4rs.settingslabelStyle,),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 2, child: 
                        Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 3, child: 
                        Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                        ),
                      ],
                    ),
                    value: font,
                  );
                }
            ),
              ],
            ),
            ExpansionTile(
              title: Text('Rounded', style: Sv4rs.settingslabelStyle,),
              children: [
                ...Fontsy.latinRoundedFonts.map((font) {
                  return RadioListTile<String>(
                    title: Row(
                      children: [
                        Expanded(flex: 3, child: 
                        Text(font, style: Sv4rs.settingslabelStyle,),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 2, child: 
                        Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 3, child: 
                        Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                        ),
                      ],
                    ),
                    value: font,
                  );
                }
            ),
              ],
            ),
              ExpansionTile(
              title: Text('Serif', style: Sv4rs.settingslabelStyle),
              children: [
                ...Fontsy.latinSerifFonts.map((font) {
                  return RadioListTile<String>(
                    title: Row(
                      children: [
                        Expanded(flex: 3, child: 
                        Text(font, style: Sv4rs.settingslabelStyle,),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 2, child: 
                        Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 3, child: 
                        Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                        ),
                      ],
                    ),
                    value: font,
                  );
                }
            ),
              ],
            ),
            ExpansionTile(
              title: Text('Monospaced', style: Sv4rs.settingslabelStyle),
              children: [
                ...Fontsy.latinMonoFonts.map((font) {
                  return RadioListTile<String>(
                    title: Row(
                      children: [
                        Expanded(flex: 3, child: 
                        Text(font, style: Sv4rs.settingslabelStyle,),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 2, child: 
                        Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 3, child: 
                        Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                        ),
                      ],
                    ),
                    value: font,
                  );
                }
            ),
              ],
            ),
            ExpansionTile(
              title: Text('Handwriting', style: Sv4rs.settingslabelStyle),
              children: [
                ...Fontsy.latinHandwritFonts.map((font) {
                  return RadioListTile<String>(
                    title: Row(
                      children: [
                        Expanded(flex: 3, child: 
                        Text(font, style: Sv4rs.settingslabelStyle,),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 2, child: 
                        Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 3, child: 
                        Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                        ),
                      ],
                    ),
                    value: font,
                  );
                }
            ),
              ],
            ),
                ExpansionTile(
              title: Text('Stylized', style: Sv4rs.settingslabelStyle),
              children: [
                ...Fontsy.latinStylizedFonts.map((font) {
                  return RadioListTile<String>(
                    title: Row(
                      children: [
                        Expanded(flex: 3, child: 
                        Text(font, style: Sv4rs.settingslabelStyle,),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 2, child: 
                        Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 3, child: 
                        Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                        ),
                      ],
                    ),
                    value: font,
                  );
                }
            ),
              ],
            ),
              
              ] else ...[
                ...Fontsy.getFontsForWritSystem(Fontsy.writingSystemNumber).map((font) {
                  return RadioListTile<String>(
                    title: Row(
                      children: [
                        Expanded(flex: 3, child: 
                        Text(font, style: Sv4rs.settingslabelStyle,),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 2, child: 
                        Text(
                          Fontsy.getSampleForWritSystem(Fontsy.writingSystemNumber), 
                          style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                        ),
                        Spacer(flex: 1),
                        Expanded(flex: 3, child: 
                        Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                        ),
                      ],
                    ),
                    value: font,
                  );
                }
              ),
              ]
                ]
              )
            ),
            
          ]
        ),
      
      ],
    );
  }
}

class FontFamilyPicker2 extends StatefulWidget {
  final String font;
  final ValueChanged<String> onFontChanged;
  final TTSInterface? tts;
  final String label;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function()? initForSS;
  final AudioPlayer? playerForSS;

  const FontFamilyPicker2({
    super.key,
    required this.font,
    required this.onFontChanged,
    required this.label,
    this.tts,
    this.speakSelectSherpaOnnxSynth,
    this.initForSS,
    this.playerForSS,
  });

  @override
  State<FontFamilyPicker2> createState() => _FontFamilyPicker2();
}

class _FontFamilyPicker2 extends State<FontFamilyPicker2> {
  late String _font;


  @override
  void initState() {
    super.initState();
    _font = widget.font;
  }

  TextStyle get labelStyle =>  
  TextStyle(
    color: Fv4rs.interfaceFontColor, 
    fontSize: V4rs.fontValue(Fv4rs.interfaceFontSize), 
    fontFamily: Fontsy.fontToFamily[_font] ?? _font, 
    fontWeight: FontWeight.values[((Fv4rs.interfaceFontWeight ~/ 100) - 1 ).clamp(0, 8)],
    fontStyle: Fv4rs.interfaceFontItalics ? FontStyle.italic : FontStyle.normal,
    );


  @override
  Widget build(BuildContext context) {
    return 
    Column(children: [
      Text(widget.label, style: Sv4rs.settingslabelStyle, textAlign: TextAlign.left,),
      ExpansionTile(
        title: SizedBox.shrink(),
        collapsedBackgroundColor: Cv4rs.themeColor4,
        backgroundColor: Cv4rs.themeColor4,
        childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(20)),
        onExpansionChanged: (bool expanded) {  
          if (Sv4rs.speakInterfaceButtonsOnSelect 
            && widget.tts != null
            && widget.initForSS != null
            && widget.playerForSS != null
          ) {
              V4rs.speakOnSelect(
                widget.label, 
                V4rs.selectedLanguage.value, 
                widget.tts!,
                widget.speakSelectSherpaOnnxSynth,
                widget.initForSS!,
                widget.playerForSS!,
              );
            }},
        children: [
          // Sample text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded( child: Center( child: 
              Text(
                'Sample Text: ${Fontsy.getSampleForWritSystem(Fontsy.writingSystemNumber)}',
                style: labelStyle,
                textAlign: TextAlign.center,
              ),
              ),
              ),
            ],
          ),

          Divider(),
          
          //font picker
          Text('Font:', style: Sv4rs.settingslabelStyle,),
          ExpansionTile(
            title: SizedBox.shrink(),
            collapsedBackgroundColor: Cv4rs.themeColor4,
            backgroundColor: Cv4rs.themeColor4,
            childrenPadding: EdgeInsets.all(0),
            children: [

            //writing system picker
            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(10)), child:
              Column(
                children: [
                  Text('Writing System:', style: Sv4rs.settingslabelStyle,),
                  DropdownButton<int>(
                    isExpanded: true,
                    value: Fontsy.writingSystemNumber,
                    onChanged: (value) {
                      if (value != null){
                        setState(() {
                          Fontsy.writingSystemNumber = value;
                        });
                      }
                    },
                    items: [
                      DropdownMenuItem<int>(
                        value: 1,
                        child:
                          Text('Arabic', style: Sv4rs.settingslabelStyle, maxLines: 3,),
                        
                      ),
                      DropdownMenuItem<int>(
                        value: 2,
                        child:
                          Text('Cyrillic', style: Sv4rs.settingslabelStyle, maxLines: 3,),
                        
                      ),
                      DropdownMenuItem<int>(
                        value: 3,
                        child:  
                          Text('Devanagari', style: Sv4rs.settingslabelStyle, maxLines: 3,),
                        
                      ),
                      DropdownMenuItem<int>(
                        value: 4,
                        child: 
                          Text('Greek', style: Sv4rs.settingslabelStyle, maxLines: 3,),
                        
                      ),
                      DropdownMenuItem<int>(
                        value: 5,
                        child:
                          Text('Hanzi', style: Sv4rs.settingslabelStyle, maxLines: 3,),
                        
                      ),
                      DropdownMenuItem<int>(
                        value: 6,
                        child:
                          Text('Hebrew', style: Sv4rs.settingslabelStyle, maxLines: 3,),
                        
                      ),
                      DropdownMenuItem<int>(
                        value: 7,
                        child: 
                          Text('Japanese', style: Sv4rs.settingslabelStyle, maxLines: 3,),
                        
                      ),
                      DropdownMenuItem<int>(
                        value: 8,
                        child: 
                          Text('Korean', style: Sv4rs.settingslabelStyle, maxLines: 3,),
                        
                      ),
                      DropdownMenuItem<int>(
                        value: 9,
                        child:   
                          Text('Latin', style: Sv4rs.settingslabelStyle, maxLines: 3,),
                        
                      ),
                      DropdownMenuItem<int>(
                        value: 10,
                        child:
                          Text('Thai', style: Sv4rs.settingslabelStyle, maxLines: 3,),
                        
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(),
        
            RadioGroup<String>(
              groupValue: _font,
              onChanged: (val) {
                if (val != null) {
                  setState(() => _font = val);
                  widget.onFontChanged(val);
                }
              },
              child: Column(
                children: [
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 5, 0, 0), child: 
                    Text('Default', style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),),
                  ),
                  RadioListTile<String>(
                    title: SizedBox.shrink(),
                    value: 'Default',
                  ),

                  Divider(),

                  //
                  //Cyrillic
                  //

                  if (Fontsy.writingSystemNumber == 2) ...[
                    ...Fontsy.cyrillicFonts.map((font) {
                      return Column(children: [
                        Text('Абвг', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                        Text(
                          font, 
                          style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${Fontsy.fontLanguages[font]}', 
                          style: Sv4rs.settingslabelStyle,
                          textAlign: TextAlign.center,
                        ),
                        RadioListTile<String>(
                          title: SizedBox.shrink(),
                          value: font,
                        ),
                        Divider(),
                      ]
                      );
                    }),
                    Text(
                      'Rounded fonts:', 
                      textAlign: TextAlign.start,
                      style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    ExpansionTile(
                      title: SizedBox.shrink(),
                      children: [
                        ...Fontsy.cyrillicRoundedFonts.map((font) {
                          return Column(children: [
                            Text('Абвг', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                            Text(
                              font, 
                              style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${Fontsy.fontLanguages[font]}', 
                              style: Sv4rs.settingslabelStyle,
                              textAlign: TextAlign.center,
                            ),
                            RadioListTile<String>(
                              title: SizedBox.shrink(),
                              value: font,
                            ),
                            Divider(),
                          ]);
                        }),
                      ],
                    ),
                  ] 
          
                  //
                  //Chinese
                  //

                  else if (Fontsy.writingSystemNumber == 5) ...[
                    Column(children: [
                      Text(
                        'Simplified Hanzi', 
                        textAlign: TextAlign.start,
                        style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w600),
                      ),
                      ExpansionTile(
                        title: SizedBox.shrink(),
                        children: [
                          ...Fontsy.simplifiedHanFonts.map((font) {
                            return Column(children: [
                              Text('的一是学国', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                              Text(
                                font, 
                                textAlign: TextAlign.center,
                                style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${Fontsy.fontLanguages[font]}',
                                textAlign: TextAlign.center, 
                                style: Sv4rs.settingslabelStyle,
                              ),
                              RadioListTile<String>(
                                title: SizedBox.shrink(),
                                value: font,
                              ),
                              Divider(),
                             ]);
                          }),
                        ],
                      ),
                    Text(
                      'Traditional Hanzi', 
                      textAlign: TextAlign.start,
                      style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    ExpansionTile(
                      title: SizedBox.shrink(),
                      children: [
                        ...Fontsy.traditionalHanFonts.map((font) {
                          return Column(children: [
                            Text('的一是學國', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                            Text(
                                font, 
                                textAlign: TextAlign.center,
                                style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${Fontsy.fontLanguages[font]}', 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle,
                            ),
                            RadioListTile<String>(
                            title: SizedBox.shrink(),
                            value: font,
                          ),
                          Divider(),
                          ]);
                        }
                      ),
                      ],
                    ),
                    Text(
                      'Hong Kong Hanzi', 
                      textAlign: TextAlign.start,
                      style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    ExpansionTile(
                      title: SizedBox.shrink(),
                      children: [
                        ...Fontsy.hongKongHanziFonts.map((font) {
                          return Column(children: [
                            Text('的一是學國', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                            Text(
                              font, 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${Fontsy.fontLanguages[font]}', 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle,
                            ),
                            RadioListTile<String>(
                              title: SizedBox.shrink(),
                              value: font,
                            ),
                            Divider(),
                          ]);
                        }
                    ),
                      ],
                    ),
                     ],
                    )
                  ] 

                  //
                  //Latin
                  //

                  else if (Fontsy.writingSystemNumber == 9) ...[
                    Text(
                      'OpenDyslexic', 
                      textAlign: TextAlign.start,
                      style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w600)
                    ),
                    ExpansionTile(
                      title: SizedBox.shrink(),
                      children: [
                        ...Fontsy.latinOpenDyslexicFonts.map((font) {
                          return Column(children: [
                            Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                            Text(
                              font, 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${Fontsy.fontLanguages[font]}', 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle,
                            ),
                            RadioListTile<String>(
                              title: SizedBox.shrink(),
                              value: font,
                            ),
                            Divider(),
                          ]);
                        }),
                      ],
                    ),
                    
                    Text(
                      'Sans-Serif', 
                      textAlign: TextAlign.start,
                      style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w600)
                    ),
                    ExpansionTile(
                      title: SizedBox.shrink(),
                      children: [
                        ...Fontsy.latinSansSerifFonts.map((font) {
                          return Column(children: [ 
                            Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                            Text(
                              font, 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${Fontsy.fontLanguages[font]}', 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle,
                            ),
                            RadioListTile<String>(
                              title: SizedBox.shrink(),
                              value: font,
                            ),
                            Divider(),
                      ]);
                      }
                    ),
                      ],
                    ),
                    
                    Text(
                      'Rounded', 
                      textAlign: TextAlign.start,
                      style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    ExpansionTile(
                      title: SizedBox.shrink(),
                      children: [
                        ...Fontsy.latinRoundedFonts.map((font) {
                          return Column(children: [ 
                            Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                            Text(
                              font, 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${Fontsy.fontLanguages[font]}', 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle,
                            ),
                            RadioListTile<String>(
                              title: SizedBox.shrink(),
                              value: font,
                            ),
                            Divider(),
                          ]);
                        }
                      ),
                      ],
                    ),
                    
                    Text(
                      'Serif', 
                      textAlign: TextAlign.start,
                      style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    ExpansionTile(
                      title: SizedBox.shrink(),
                      children: [
                        ...Fontsy.latinSerifFonts.map((font) {
                          return Column(children: [ 
                            Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                            Text(
                              font, 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${Fontsy.fontLanguages[font]}', 
                              style: Sv4rs.settingslabelStyle,
                              textAlign: TextAlign.center,
                            ),
                            RadioListTile<String>(
                              title: SizedBox.shrink(),
                              value: font,
                            ),
                            Divider(),
                           ]
                          );
                        }
                    ),
                      ],
                    ),
                    
                    Text(
                      'Monospaced', 
                      textAlign: TextAlign.start,
                      style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    ExpansionTile(
                      title: SizedBox.shrink(),
                      children: [
                        ...Fontsy.latinMonoFonts.map((font) {
                          return Column(children: [
                            Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                            Text(
                              font, 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${Fontsy.fontLanguages[font]}', 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle,
                            ),
                            RadioListTile<String>(
                              title: SizedBox.shrink(),
                              value: font,
                            ),
                            Divider(),
                           ]
                          );
                        }),
                      ],
                    ),
                    
                    Text(
                      'Handwriting', 
                      textAlign: TextAlign.start,
                      style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    ExpansionTile(
                      title: SizedBox.shrink(),
                      children: [
                        ...Fontsy.latinHandwritFonts.map((font) {
                          return Column(children: [ 
                            Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                            Text(
                              font, 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${Fontsy.fontLanguages[font]}',
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle,
                            ),
                            RadioListTile<String>(
                              title: SizedBox.shrink(),
                              value: font,
                            ),
                            Divider(),
                          ]);
                        }
                    ),
                      ],
                    ),
                    
                    Text(
                      'Stylized', 
                      textAlign: TextAlign.start,
                      style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    ExpansionTile(
                      title: SizedBox.shrink(),
                      children: [
                        ...Fontsy.latinStylizedFonts.map((font) {
                          return Column(children: [
                            Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                            Text(
                              font, 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${Fontsy.fontLanguages[font]}', 
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle,
                            ),
                            RadioListTile<String>(
                              title: SizedBox.shrink(),
                              value: font, 
                            ),
                            Divider(),
                            ],
                          );
                        }
                    ),
                      ],
                    ),
                      
                  ] 
                  else ...[
                    ...Fontsy.getFontsForWritSystem(Fontsy.writingSystemNumber).map((font) {
                      return Column(children: [
                        Text(
                          Fontsy.getSampleForWritSystem(Fontsy.writingSystemNumber), 
                          style: TextStyle(fontFamily: Fontsy.fontToFamily[font])
                        ),
                        Text(
                          font, 
                          textAlign: TextAlign.center,
                          style: Sv4rs.settingslabelStyle.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${Fontsy.fontLanguages[font]}', 
                          textAlign: TextAlign.center,
                          style: Sv4rs.settingslabelStyle,
                        ),
                        RadioListTile<String>(
                          title: SizedBox.shrink(),
                          value: font,
                        ),
                        Divider(),
                      ]);
                    }),
                  ]
                    ]
                  )
                ),
            ]
          ),
        
        ],
      )
     ]
    );
  }
}

