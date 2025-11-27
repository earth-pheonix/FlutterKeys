import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/color_variables.dart';
import 'package:flutterkeysaac/Variables/editing/save_indicator.dart';
import 'package:flutterkeysaac/Variables/settings_variable.dart';
import 'package:flutterkeysaac/Variables/grammer_variables.dart';
import 'package:flutterkeysaac/Variables/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/fonts.dart';
import 'package:flutterkeysaac/Variables/more_font_variables.dart';
import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Models/json_model_grammer.dart';
import 'package:flutterkeysaac/Variables/export_variables.dart';
import 'package:printing/printing.dart';

import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:typed_data';


class LoadImage {
  // Cache resolved file paths so no flash
  static final Map<String, String> _resolvedCache = {};

  static Widget fromSymbol(
    String? symbol, {
    BoxFit fit = BoxFit.contain,
    String placeholderAsset = 'assets/interface_icons/interface_icons/iPlaceholder.png',
  }) {
    final path = symbol ?? placeholderAsset;

    if (path.startsWith('/')) {
      // Absolute file path
      return _buildCachedFileImage(File(path), fit, placeholderAsset);
    } else if (path.startsWith('my_images/')) {
      // Relative file path inside app docs
      if (_resolvedCache.containsKey(path)) {
        // Already resolved once → use cached full path
        return _buildCachedFileImage(File(_resolvedCache[path]!), fit, placeholderAsset);
      }

      return FutureBuilder<String?>(
        future: _resolveRelative(path),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
            _resolvedCache[path] = snapshot.data!; // cache it
            return _buildCachedFileImage(File(snapshot.data!), fit, placeholderAsset);
          }
          // While waiting, don’t flash → just hold placeholder
          return Image.asset(placeholderAsset, fit: fit);
        },
      );
    } else {
      // Asset image
      return Image.asset(path, fit: fit);
    }
  }

  static Widget _buildCachedFileImage(File file, BoxFit fit, String placeholderAsset) {
    if (!file.existsSync()) {
      return Image.asset(placeholderAsset, fit: fit);
    }

    final provider = FileImage(file);
    return Builder(
      builder: (context) {
        precacheImage(provider, context); // pre-decode into cache
        return Image(image: provider, fit: fit, gaplessPlayback: true);
      },
    );
  }

  static Future<String?> _resolveRelative(String relPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final fullPath = p.join(dir.path, relPath);
    final file = File(fullPath);
    return await file.exists() ? fullPath : null;
  }
}

class LoadAudio {
  static final AudioPlayer _player = AudioPlayer();
  static Future<void> fromAudio(
    String? audio, {
    String fallbackAsset = 'sounds/twoNoteChime_byEqylizer.mp3',
  }) async {
    final path = audio ?? fallbackAsset;

    if (path.startsWith('/')) {
      // Absolute file path
      await _player.play(DeviceFileSource(path));
    } else if (path.startsWith('my_sounds/')) {
      // Relative file path -> resolve full path
      final fullPath = await _resolveRelative(path);
      await _player.play(DeviceFileSource(fullPath));
    } else {
      // Asset
      await _player.play(AssetSource(path));
    }
  }

  /// Resolve a relative `my_sounds/...` path to full absolute path
  static Future<String> _resolveRelative(String relPath) async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, relPath);
  }

  /// Optionally stop/pause/resume
  static Future<void> stop() async => _player.stop();
  static Future<void> pause() async => _player.pause();
  static Future<void> resume() async => _player.resume();
}


class ButtonStyle1 extends StatelessWidget {
  //these are the values that we will define when using the button
  final String imagePath;
  final VoidCallback onPressed;
  final bool glow;
  final bool specialImageColor;
  final int turn;

  //constructs the button 
  const ButtonStyle1 ({
    super.key,
    required this.imagePath,
    required this.onPressed,
    this.specialImageColor = false,
    this.glow = false,
    this.turn = 0,
  });

  //defines the button 
  @override
  Widget build(BuildContext context) {
    
    Widget image = Image.asset(
      imagePath,
      fit: BoxFit.contain,
    );

    return Material( 
              color: Colors.transparent,
              child:

    ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: glow ? Cv4rs.themeColor2 : Cv4rs.themeColor1, //button color
          elevation: 2, //shadow
          shape: RoundedRectangleBorder( //makes it a rounded rectangle
            borderRadius: BorderRadius.circular(10), // number is corner roundness
          ),
          shadowColor: Cv4rs.themeColor4,  //shadow color
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Padding around pictures 
          overlayColor: Cv4rs.themeColor4,
        ),
        onPressed: onPressed,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(specialImageColor ? Cv4rs.themeColor1 : Cv4rs.uiIconColor, BlendMode.srcIn
          ),
          child: (turn > 0) 
          ? Transform.rotate(
            angle: turn * math.pi / 180,
            child: image
          )
          : image,
        ),
      ),
    );
  }

}

class ButtonStyle2 extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final String label;
  final double padding;

  const ButtonStyle2 ({
    super.key,
    required this.imagePath,
    required this.onPressed,
    required this.label,
    this.padding = 10,
  });

  @override
  Widget build(BuildContext context) {
    
    Widget image = Image.asset(
      imagePath,
      fit: BoxFit.contain,
    );

    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Cv4rs.themeColor4, //button color
          elevation: 3, //shadow
          shape: RoundedRectangleBorder( //makes it a rounded rectangle
            borderRadius: BorderRadius.circular(10), // number is corner roundness
          ),
          shadowColor: Cv4rs.themeColor1,  //shadow color
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Padding around pictures 
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          Expanded(
            flex: 1,
            child:
            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: padding), child: 
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn
          ),
          child: image,
        ),
            ),
          ),
        
        Expanded(
          flex: 2,
          child: 
        Text(label, 
        style: Sv4rs.settingslabelStyle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        ),
        ),
        ]),
      );
  }

}

class ButtonStyle3 extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final String label;
  final bool use;

  const ButtonStyle3 ({
    super.key,
    required this.imagePath,
    required this.onPressed,
    required this.label,
    this.use = false,
  });

  @override
  Widget build(BuildContext context) {
    
    //Widget image = Image.asset(
    //  imagePath,
    //  fit: BoxFit.contain,
    //);

    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Cv4rs.themeColor4, //button color
          elevation: 2, //shadow
          shape: RoundedRectangleBorder( //makes it a rounded rectangle
            borderRadius: BorderRadius.circular(10), // number is corner roundness
          ),
          shadowColor: Cv4rs.themeColor1,  //shadow color
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Padding around pictures 
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
       // ColorFiltered(
       //   colorFilter: ColorFilter.mode(Cv4rs.uiIconColor, BlendMode.srcIn
       //   ),
       //   child: image,
       // ),
          
        Text(label, 
        style: Sv4rs.settingslabelStyle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        ),
        ]),
      );
  }

}

class ButtonStyle4 extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final String label;
  final bool use;

  const ButtonStyle4 ({
    super.key,
    required this.imagePath,
    required this.onPressed,
    required this.label,
    this.use = false,
  });

  @override
  Widget build(BuildContext context) {
    
    Widget image = Image.asset(
      imagePath,
      fit: BoxFit.contain,
    );

    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Cv4rs.themeColor4, //button color
          elevation: 2, //shadow
          shape: RoundedRectangleBorder( //makes it a rounded rectangle
            borderRadius: BorderRadius.circular(10), // number is corner roundness
          ),
          shadowColor: Cv4rs.themeColor1,  //shadow color
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Padding around pictures 
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn
          ),
          child: image,
        ),
          
        if (!use) Text(label, 
        style: Sv4rs.settingslabelStyle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        ),
        ]),
      );
  }

}

class ExpandButtonStyle extends StatelessWidget {
  //these are the values that we will define when using the button
  final String imagePath;
  final VoidCallback onPressed;

  //constructs the button 
  const ExpandButtonStyle ({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  //defines the button 
  @override
  Widget build(BuildContext context) {
    
    Widget image = Image.asset(
      imagePath,
      fit: BoxFit.contain,
    );

    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Cv4rs.expandColor1, //button color
          elevation: 2, //shadow
          shape: RoundedRectangleBorder( //makes it a rounded rectangle
            borderRadius: BorderRadius.circular(10), // number is corner roundness
          ),
          shadowColor: Cv4rs.themeColor4,  //shadow color
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Padding around pictures 
        ),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Cv4rs.expandIconColor, BlendMode.srcIn
          ),
          child: image,
        ),
      );
  }

}

class AlertStyle extends StatelessWidget {
  //these are the values that we will define when using the button
  final String imagePath;
  final VoidCallback onPressed;
  final bool invertColors;

  //constructs the button 
  const AlertStyle ({
    super.key,
    required this.imagePath,
    required this.onPressed,
    this.invertColors = false,
  });

  //defines the button 
  @override
  Widget build(BuildContext context) {
    
    Widget image = Image.asset(
      imagePath,
      fit: BoxFit.contain,
    );

    if (invertColors) {
      image = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          -1, 0, 0, 0, 255, // Red
          0, -1, 0, 0, 255, // Green
          0, 0, -1, 0, 255, // Blue
          0, 0, 0, 1, 0     // Alpha
        ]),
        child: image,
      );
    }

    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Cv4rs.themeColor3, //button color
          elevation: 2, //shadow
          shape: RoundedRectangleBorder( //makes it a rounded rectangle
            borderRadius: BorderRadius.circular(0), // number is corner roundness
          ),
          shadowColor: Cv4rs.themeColor4,  //shadow color
          padding: EdgeInsets.all(5), // Padding around pictures 
        ),
        child: image,
      );
  }

}

class MessageWindowTextField extends StatefulWidget {
  final TextEditingController controller;
  final ScrollController scrollController;
  

  const MessageWindowTextField({super.key, required this.controller, required this.scrollController});

  @override
  State<MessageWindowTextField> createState() => _MessageWindowTextFieldState();
}
  
class _MessageWindowTextFieldState extends State<MessageWindowTextField> {
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) { 
    return SizedBox.shrink(
    child: SingleChildScrollView(
      controller: widget.scrollController,
      child: Column(children: [
      TextField(
        controller: widget.controller,
        minLines: 3,
        maxLines: null,
        textAlign: TextAlign.left,
        style: Fv4rs.mwLabelStyle,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: Fv4rs.hintMWLabelStyle,
          hintText: 'Message Window...',
        ),
    ),
    Text('', style: Fv4rs.mwLabelStyle,)
      ]
      )
    ),
    
    );
      }
    );
  }
}

class HexCodeInput extends StatefulWidget {
  final String startValue; 
  final TextStyle textStyle;
  final TextStyle hintTextStyle;
  final Function(Color color)? onColorChanged; 

  const HexCodeInput({
    super.key,
    this.startValue = '#FFFFFF',
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.hintTextStyle = const TextStyle(color: Colors.blueGrey, fontSize: 16),
    this.onColorChanged,
  });

  @override
  State<HexCodeInput> createState() => _HexCodeInputState();
}

class _HexCodeInputState extends State<HexCodeInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _updateColor(_controller.text);
  }

  void _updateColor(String hex) {
    try {
      Color color = _hexToColor(hex);

      if (widget.onColorChanged != null) {
        widget.onColorChanged!(color);
      }
    } catch (_) {
      //color is invalid
    }
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Row (
      children: [
        Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Text('Input hex code:', style: widget.textStyle,),
        ),
        Expanded(child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: '#${widget.startValue.substring(2)}',
            hintStyle: widget.hintTextStyle
          ),
          onChanged: _updateColor,
        ))
      ],
    );
  }
}

class HexCodeInput2 extends StatefulWidget {
  final String startValue; 
  final TextStyle textStyle;
  final TextStyle hintTextStyle;
  final Function(Color color)? onColorChanged; 

  const HexCodeInput2({
    super.key,
    this.startValue = '#FFFFFF',
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.hintTextStyle = const TextStyle(color: Colors.blueGrey, fontSize: 16),
    this.onColorChanged,
  });

  @override
  State<HexCodeInput2> createState() => _HexCodeInput2State();
}

class _HexCodeInput2State extends State<HexCodeInput2> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _updateColor(_controller.text);
  }

  void _updateColor(String hex) {
    try {
      Color color = _hexToColor(hex);

      if (widget.onColorChanged != null) {
        widget.onColorChanged!(color);
      }
    } catch (_) {
      //color is invalid
    }
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Column (
      children: [
        Padding(
          padding: EdgeInsetsGeometry.fromLTRB(10, 10, 10, 0),
          child: Text('Input hex code:', style: widget.textStyle,),
        ),
        TextField(
          textAlign: TextAlign.center,
          controller: _controller,
          decoration: InputDecoration(
            hintText: '#${widget.startValue.substring(2)}',
            hintStyle: widget.hintTextStyle
          ),
          onChanged: _updateColor,
        )
      ],
    );
  }
}


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
    fontSize: _size, 
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
      childrenPadding: EdgeInsets.symmetric(horizontal: 20),
      onExpansionChanged: (bool expanded) {  
        if (Sv4rs.speakInterfaceButtonsOnSelect) {
            V4rs.speakOnSelect(widget.label, V4rs.selectedLanguage.value, _tts);
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
         Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 20), child:
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
        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 20), child:
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
        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 20), child:
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
        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 20), child:
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
        ExpansionTile(
          title: Text('Font:', style: Sv4rs.settingslabelStyle,),
          collapsedBackgroundColor: Cv4rs.themeColor4,
          backgroundColor: Cv4rs.themeColor4,
          
          children: [
            ExpansionTile(
          title: Row ( children: [
            Spacer(),
            Text('Language Writing System: ${
              Fontsy.writingSystemNumber == 1 ? 'Arabic'
            : Fontsy.writingSystemNumber == 2 ? 'Cyrillic'
            : Fontsy.writingSystemNumber == 3 ? 'Devanagari' 
            : Fontsy.writingSystemNumber == 4 ? 'Greek'
            : Fontsy.writingSystemNumber == 5 ? 'Hanzi'
            : Fontsy.writingSystemNumber == 6 ? 'Hebrew'
            : Fontsy.writingSystemNumber == 7 ? 'Japanese'
            : Fontsy.writingSystemNumber == 8 ? 'Korean'
            : Fontsy.writingSystemNumber == 9 ? 'Latin'
            : Text('Thai')
          }', style: Sv4rs.settingslabelStyle,
          ), 
          Spacer(), ]),
          childrenPadding: EdgeInsets.symmetric(horizontal: 40), 
          children: [
            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 60), child:
            Row(
              children: [
            Text('Writing System:', style: Sv4rs.settingslabelStyle,),
            Expanded(
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
            Fontsy.writingSystemNumber == 1 ? Text('Arabic', style: Sv4rs.settingslabelStyle,) 
            : Fontsy.writingSystemNumber == 2 ? Text('Cyrillic', style: Sv4rs.settingslabelStyle,) 
            : Fontsy.writingSystemNumber == 3 ? Text('Devanagari', style: Sv4rs.settingslabelStyle,) 
            : Fontsy.writingSystemNumber == 4 ? Text('Greek', style: Sv4rs.settingslabelStyle,)
            : Fontsy.writingSystemNumber == 5 ? Text('Hanzi', style: Sv4rs.settingslabelStyle,) 
            : Fontsy.writingSystemNumber == 6 ? Text('Hebrew', style: Sv4rs.settingslabelStyle,) 
            : Fontsy.writingSystemNumber == 7 ? Text('Japanese', style: Sv4rs.settingslabelStyle,) 
            : Fontsy.writingSystemNumber == 8 ? Text('Korean', style: Sv4rs.settingslabelStyle,) 
            : Fontsy.writingSystemNumber == 9 ? Text('Latin', style: Sv4rs.settingslabelStyle,) 
            : Text('Thai', style: Sv4rs.settingslabelStyle,),
          ],
        ),
            ),
            ],
            ),
        
            RadioListTile<String>(
              title: Text('Default', style: Sv4rs.settingslabelStyle,),
              value: 'Default',
              groupValue: _font,
              onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
            ),
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
                    Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                    ),
                    Spacer(flex: 1),
                    Expanded(flex: 3, child: 
                    Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                    ),
                  ],
                ),
                value: font,
                groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
                    Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                    ),
                    Spacer(flex: 1),
                    Expanded(flex: 3, child: 
                    Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                    ),
                  ],
                ),
                value: font,
                groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
                },
              );
            }
        ),
          ],
        ),
          ] else if (Fontsy.writingSystemNumber == 5) ...[
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
                    Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                    ),
                    Spacer(flex: 1),
                    Expanded(flex: 3, child: 
                    Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                    ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
                    Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                    ),
                    Spacer(flex: 1),
                    Expanded(flex: 3, child: 
                    Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                    ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
                    Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                    ),
                    Spacer(flex: 1),
                    Expanded(flex: 3, child: 
                    Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                    ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
              );
            }
        ),
          ],
        ),
          
          ] else if (Fontsy.writingSystemNumber == 9) ...[
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
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
                },
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
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
                    Text('Abcde', style: TextStyle(fontFamily: Fontsy.fontToFamily[font])),
                    ),
                    Spacer(flex: 1),
                    Expanded(flex: 3, child: 
                    Text('${Fontsy.fontLanguages[font]}', style: Sv4rs.settingslabelStyle,),
                    ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
              );
            }
          ),
          ]
          ]
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
                padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
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
                padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
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
    fontSize: _size, 
    fontFamily: Fontsy.fontToFamily[_font] ?? _font, 
    fontWeight: FontWeight.values[((_weight ~/ 100) - 1 ).clamp(0, 8)],
    fontStyle: _italics ? FontStyle.italic : FontStyle.normal,
    decoration: (_underline) ? TextDecoration.underline : TextDecoration.none,
    );


  @override
  Widget build(BuildContext context) {
    return Container(
       padding: EdgeInsets.all(10),
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
              padding: EdgeInsetsGeometry.all(5),
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
          Row(
            children: [
              Expanded( child: 
              Text('Match Font:', style: Sv4rs.settingslabelStyle, ),
              ),
              Spacer(),
              Switch(
                value: _matchFontSet,
                onChanged: (val) {
                  setState(() => _matchFontSet = val);
                  widget.onMatchFont(val);
                },
              ),
            ],
          ),
        

        // Size slider
        Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 10), child: 
        Column(
          children: [
            Text('Size: $_size', style: Sv4rs.settingslabelStyle,),
             Slider(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 10,),
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
        Row(
          children: [
            Expanded( child: 
            Text('Italics:', style: Sv4rs.settingslabelStyle, ),
            ),
            Switch(
              value: _italics,
              onChanged: (val) {
                setState(() => _italics = val);
                widget.onItalicsChanged(val);
              },
            ),
          ],
        ),
        

        // Underline switch
        if (_useUnderline) 
        Row(
          children: [
            Expanded( child: 
            Text('Underline:', style: Sv4rs.settingslabelStyle, ),
            ),
            Switch(
              value: _underline,
              onChanged: (val) {
                setState(() => _underline = val);
                widget.onUnderlineChanged(val);
              },
            ),
          ],
        ),
        
        
        // Weight slider
        Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0), child: 
        Column(
          children: [ 
            Text('Weight: $_weight', style: Sv4rs.settingslabelStyle,),
            
            Slider(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 10,),
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
        ExpansionTile(
          tilePadding: EdgeInsets.all(0),
          title: Text('Font:', style: Sv4rs.settingslabelStyle,),
          collapsedBackgroundColor: Cv4rs.themeColor4,
          backgroundColor: Cv4rs.themeColor4,
          children: [
            ExpansionTile(
              tilePadding: EdgeInsets.all(0),
              title: Row ( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: 
                    Text('Writing System: ${
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
                   }', style: Sv4rs.settingslabelStyle,
                  ), 
                 ),
                ]
              ),
              children: [
                Column(
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0), child:
                    Text('Writing System:', style: Sv4rs.settingslabelStyle,),
                    ),
                Slider(
                    value: Fontsy.writingSystemNumber.toDouble(), 
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
              ],
            ),
            
            ],
            ),
        
            RadioListTile<String>(
              contentPadding: EdgeInsets.all(0),
              title: Column(
                  children: [
                    Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily["Default"]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                    Text(
                      'Default', 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                      ),
                  ],
                ),
              value: 'Default',
              groupValue: _font,
              onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
            ),
            if (Fontsy.writingSystemNumber == 2) ...[
              ...Fontsy.cyrillicFonts.map((font) {
              return RadioListTile<String>(
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  children: [
                    Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily[font]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                    Text(
                      font, 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                      ),
                  ],
                ),
                value: font,
                groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
              );
            }
        ),
        ExpansionTile(
          title: Text('Rounded fonts:', style: Sv4rs.settingslabelStyle,),
          children: [
            ...Fontsy.cyrillicRoundedFonts.map((font) {
              return RadioListTile<String>(
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  children: [
                    Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily[font]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                    Text(
                      font, 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                      ),
                  ],
                ),
                value: font,
                groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
                },
              );
            }
        ),
          ],
        ),
          ] else if (Fontsy.writingSystemNumber == 5) ...[
        ExpansionTile(
          title: Text('Simplified Hanzi', style: Sv4rs.settingslabelStyle,),
          children: [
            ...Fontsy.simplifiedHanFonts.map((font) {
              return RadioListTile<String>(
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  children: [
                    Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily[font]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                    Text(
                      font, 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                      ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
                contentPadding: EdgeInsets.all(0),
                title:Column(
                  children: [
                    Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily[font]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                    Text(
                      font, 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                      ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  children: [
                    Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily[font]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                    Text(
                      font, 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                      ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
              );
            }
        ),
          ],
        ),
          
          ] else if (Fontsy.writingSystemNumber == 9) ...[
        ExpansionTile(
          title: Text('OpenDyslexic', style: Sv4rs.settingslabelStyle,),
          children: [
            ...Fontsy.latinOpenDyslexicFonts.map((font) {
              return RadioListTile<String>(
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  children: [
                    Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily[font]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                   Text(
                      font, 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                      ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  children: [
                    Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily[font]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                    Text(
                      font, 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                      ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  children: [
                   Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily[font]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                    Text(
                      font, 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                      ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
                },
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
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  children: [
                    Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily[font]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                    Text(
                      font, 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                      ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  children: [
                    Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily[font]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                    Text(
                      font, 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                      ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
              );
            }
        ),
          ],
        ),
        ExpansionTile(
          title: Text('Handwrit', style: Sv4rs.settingslabelStyle),
          children: [
            ...Fontsy.latinHandwritFonts.map((font) {
              return RadioListTile<String>(
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  children: [
                    Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily[font]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                    Text(
                      font, 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                      ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
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
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  children: [
                    Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily[font]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                    Text(
                      font, 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                      ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
              );
            }
        ),
          ],
        ),
          
          ] else ...[
            ...Fontsy.getFontsForWritSystem(Fontsy.writingSystemNumber).map((font) {
              return RadioListTile<String>(
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  children: [
                    Text(
                      'Abcde', 
                      style: TextStyle(fontFamily: Fontsy.fontToFamily[font]),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                    Text(
                      font, 
                      style: Sv4rs.settingslabelStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                value: font,
               groupValue: _font,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _font = val);
                    widget.onFontChanged(val);
                  }
              },
              );
            }
          ),
          ]
          ]
        ),
      
        //color font 
        ExpansionTile(
          tilePadding: EdgeInsets.all(0),
          title: Row(
              children: [
                Expanded(child: 
                Text('Font Color:', style: Sv4rs.settingslabelStyle,),
                ),
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
              Column(children:[
              //hexcode input
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 20),
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


class SymbolColorCustomizer extends StatefulWidget {
  final bool invert;
  final Color overlay;
  final double saturation; 
  final double contrast;
  final ValueChanged<bool> onInvertChanged;
  final ValueChanged<Color> onOverlayChanged;
  final ValueChanged<double> onSaturationChanged;
  final ValueChanged<double> onContrastChanged;
  final TTSInterface tts;

  const SymbolColorCustomizer({
    super.key,
    required this.invert,
    required this.overlay,
    required this.saturation,
    required this.contrast,
    required this.onContrastChanged,
    required this.onInvertChanged,
    required this.onOverlayChanged,
    required this.onSaturationChanged,
    required this.tts,
  });

  @override
  State<SymbolColorCustomizer> createState() => _SymbolColorCustomizer();
}

class _SymbolColorCustomizer extends State<SymbolColorCustomizer> {
  late bool _invert;
  late Color _overlay;
  late double _saturation; 
  late double _contrast;

  late ValueChanged<bool> _onInvertChanged;
  late ValueChanged<Color> _onOverlayChanged;
  late ValueChanged<double> _onSaturationChanged;
  late ValueChanged<double> _onContrastChanged;
  late TTSInterface _tts;

  Widget image = Image.asset(
         'assets/interface_icons/interface_icons/iSymbol_sample.png',
          fit: BoxFit.fitWidth,
        );

  @override
  void initState() {
    super.initState();
    _invert = widget.invert;
    _overlay = widget.overlay;
    _saturation = widget.saturation;
    _contrast = widget.contrast;
    _onInvertChanged = widget.onInvertChanged;
    _onOverlayChanged = widget.onOverlayChanged; 
    _onSaturationChanged = widget.onSaturationChanged;
    _onContrastChanged = widget.onContrastChanged;
    _tts = widget.tts;
  }


  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(children: [
        Flexible(flex: 20, child: 
        Row(children: [
        Text('Symbol Colors:',  style: Sv4rs.settingslabelStyle,), 
        Spacer(),
        ]
        )
        ),
        Flexible(flex: 1, child:
        ImageStyle1(
                image: image,
                defaultSymbolColorOverlay: _overlay,
                defaultSymbolContrast: _contrast,
                defaultSymbolInvert: _invert,
                defaultSymbolSaturation: _saturation,
                overlayColor: _overlay,
                symbolContrast: _contrast,
                symbolSaturation: _saturation,
                invertSymbolColors: _invert,
                matchOverlayColor: true,
                matchSymbolContrast: true,
                matchSymbolInvert: true,
                matchSymbolSaturation: true,
            ),
        )
        ]),
      collapsedBackgroundColor: Cv4rs.themeColor4,
      backgroundColor: Cv4rs.themeColor4,
      childrenPadding: EdgeInsets.symmetric(horizontal: 20),
      onExpansionChanged: (bool expanded) {  
        if (Sv4rs.speakInterfaceButtonsOnSelect) {
            V4rs.speakOnSelect('symbol colors', V4rs.selectedLanguage.value, _tts);
          }},
      children: [

        // invert
        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 20), child:
        Row(
          children: [
            Text(
              'Invert Colors:', style: Sv4rs.settingslabelStyle,),

           
            Switch(
              value: _invert,
              onChanged: (val) {
                setState(() => _invert = val);
                _onInvertChanged(val);
              },
            ),
          ],
        ),
        ),

        // Symbol Saturation
         Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 20), child:
        Row(
          children: [
            Text('Symbol Saturation:  $_saturation', style: Sv4rs.settingslabelStyle,),
            Expanded(
              child: Slider(
                value: _saturation,
                min: 0.0,
                max: 2.0,
                divisions: 20,
                activeColor: Cv4rs.themeColor1,
                inactiveColor: Cv4rs.themeColor3,
                thumbColor: Cv4rs.themeColor1,
                onChanged: (val) {
                  setState(() => _saturation= val);
                  _onSaturationChanged(val);
                },
              ),
            ),
          ],
        ),
        ),

        //symbol contrast
        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 20), child:
        Row(
          children: [
            Text('Symbol Contrast:  $_contrast', style: Sv4rs.settingslabelStyle,),
            Expanded(
              child: Slider(
                value: _contrast,
                min: 0.0,
                max: 2.0,
                divisions: 20,
                activeColor: Cv4rs.themeColor1,
                inactiveColor: Cv4rs.themeColor3,
                thumbColor: Cv4rs.themeColor1,
                onChanged: (val) {
                  setState(() => _contrast= val);
                  _onContrastChanged(val);
                },
              ),
            ),
          ],
        ),
        ),
        //overlay
         ExpansionTile(
            title: Row(
              children: [
                Text('Color Overlay:', style: Sv4rs.settingslabelStyle,),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: Cv4rs.themeColor3,
                  radius: 20,
                  child: Icon(Icons.circle, color: _overlay, size: 40, shadows: [
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
                padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
                child: HexCodeInput(
                  startValue: _overlay.toHexString(),
                  textStyle: Sv4rs.settingslabelStyle,
                  hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                  onColorChanged:  (color) { setState(() {
                    _overlay = color;
                    _onOverlayChanged(color);
                   });
                   }
                ),
              ),
              //color picker
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
                child: ColorPicker(
                  pickerColor: _overlay, 
                  enableAlpha: true,
                  displayThumbColor: false,
                  labelTypes: ColorLabelType.values,
                  onColorChanged: (color) { setState(() {
                    _overlay = color;
                    _onOverlayChanged(color);
                   });
                   }
                ),
            ),
            ],
          ),
      ],
    );
  }
}

class SymbolColorCustomizer2 extends StatefulWidget {
  final bool specialLabel;
  final double width;
  final double height;
  final double additionalHeight;
  final Widget widgety;
  final bool invert;
  final Color overlay;
  final double saturation; 
  final double contrast;

  final bool matchInvert;
  final bool matchOverlay;
  final bool matchSaturation;
  final bool matchContrast;

  final ValueChanged<bool> onInvertChanged;
  final ValueChanged<Color> onOverlayChanged;
  final ValueChanged<double> onSaturationChanged;
  final ValueChanged<double> onContrastChanged;

  final ValueChanged<bool> onMatchInvertChanged;
  final ValueChanged<bool> onMatchOverlayChanged;
  final ValueChanged<bool> onMatchSaturationChanged;
  final ValueChanged<bool> onMatchContrastChanged;

  const SymbolColorCustomizer2({
    super.key,
    required this.height,
    required this.additionalHeight,
    required this.widgety,
    required this.width,
    required this.invert,
    required this.overlay,
    required this.saturation,
    required this.contrast,
    required this.matchInvert,
    required this.matchOverlay,
    required this.matchSaturation,
    required this.matchContrast,
    required this.onContrastChanged,
    required this.onInvertChanged,
    required this.onOverlayChanged,
    required this.onSaturationChanged,
    required this.onMatchContrastChanged,
    required this.onMatchInvertChanged,
    required this.onMatchOverlayChanged,
    required this.onMatchSaturationChanged,
    this.specialLabel = false,
  });

  @override
  State<SymbolColorCustomizer2> createState() => _SymbolColorCustomizer2();
}

class _SymbolColorCustomizer2 extends State<SymbolColorCustomizer2> {
  late double _width;
  late double _height;
  late Widget _widgety;
  late bool _invert;
  late Color _overlay;
  late double _saturation; 
  late double _contrast;

  late bool _matchInvert;
  late bool _matchOverlay;
  late bool _matchSaturation;
  late bool _matchContrast;

  late ValueChanged<bool> _onInvertChanged;
  late ValueChanged<Color> _onOverlayChanged;
  late ValueChanged<double> _onSaturationChanged;
  late ValueChanged<double> _onContrastChanged;

  late ValueChanged<bool> _onMatchInvertChanged;
  late ValueChanged<bool> _onMatchOverlayChanged;
  late ValueChanged<bool> _onMatchSaturationChanged;
  late ValueChanged<bool> _onMatchContrastChanged;

  Widget image = Image.asset(
         'assets/interface_icons/interface_icons/iSymbol_sample.png',
          fit: BoxFit.fitWidth,
        );

  @override
  void initState() {
    super.initState();
    _width = widget.width;
    _height = widget.height;
    _widgety = widget.widgety;

    _invert = widget.invert;
    _overlay = widget.overlay;
    _saturation = widget.saturation;
    _contrast = widget.contrast;
    
    _matchOverlay = widget.matchOverlay;
    _matchInvert = widget.matchInvert;
    _matchSaturation = widget.matchSaturation;
    _matchContrast = widget.matchContrast;

    _onInvertChanged = widget.onInvertChanged;
    _onOverlayChanged = widget.onOverlayChanged; 
    _onSaturationChanged = widget.onSaturationChanged;
    _onContrastChanged = widget.onContrastChanged;

    _onMatchInvertChanged = widget.onMatchInvertChanged;
    _onMatchOverlayChanged = widget.onMatchOverlayChanged; 
    _onMatchSaturationChanged = widget.onMatchSaturationChanged;
    _onMatchContrastChanged = widget.onMatchContrastChanged;
  }


  @override
  Widget build(BuildContext context) {
    return 
          Container(
            width: _width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Cv4rs.themeColor4,
              borderRadius: BorderRadius.circular(10)
              ),
            child: Column(children: [ 

        if (widget.specialLabel) 
          Text("--Not all match--", style: Sv4rs.settingslabelStyle),

        // invert
        Row(
          children: [
            Expanded(child: 
            Text(
              'Match Invert:', 
              style: Sv4rs.settingslabelStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            ),
            Switch(
              value: _matchInvert,
              onChanged: (val) {
                setState(() => _matchInvert = val);
                _onMatchInvertChanged(val);
              },
            ),
          ],
        ),
        
       
        Row(
          children: [
            Expanded(child: 
            Text(
              'Invert Colors:', 
              style: Sv4rs.settingslabelStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              ),
            ),
            Switch(
              value: _invert,
              onChanged: (val) {
                setState(() => _invert = val);
                _onInvertChanged(val);
              },
            ),
          ],
        ),
        

        // Symbol Saturation
      
        Row(
          children: [
            Expanded(child:
            Text(
              'Match Saturation:',
              style: Sv4rs.settingslabelStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              ),
            ),
            Switch(
              value: _matchSaturation,
              onChanged: (val) {
                setState(() => _matchSaturation = val);
                _onMatchSaturationChanged(val);
              },
            ),
          ],
        ),
        
        
        Column(
          children: [
            Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0), child:
            Text('Symbol Saturation:  $_saturation', 
            style: Sv4rs.settingslabelStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
              ),
            ),
              Slider(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
                value: _saturation,
                min: 0.0,
                max: 2.0,
                divisions: 20,
                activeColor: Cv4rs.themeColor1,
                inactiveColor: Cv4rs.themeColor3,
                thumbColor: Cv4rs.themeColor1,
                onChanged: (val) {
                  setState(() => _saturation= val);
                  _onSaturationChanged(val);
                },
              ),
          ],
        ),
        

        //symbol contrast
       
        Row(
          children: [
            Expanded(child: 
            Text(
              'Match Contrast:', 
              style: Sv4rs.settingslabelStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              ),
            ),
            Switch(
              value: _matchContrast,
              onChanged: (val) {
                setState(() => _matchContrast = val);
                _onMatchContrastChanged(val);
              },
            ),
          ],
        ),
        
       
        Column(
          children: [
            Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0), child:
            Text('Symbol Contrast:  $_contrast', 
              style: Sv4rs.settingslabelStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              ),
              ),
              Slider(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
                value: _contrast,
                min: 0.0,
                max: 2.0,
                divisions: 20,
                activeColor: Cv4rs.themeColor1,
                inactiveColor: Cv4rs.themeColor3,
                thumbColor: Cv4rs.themeColor1,
                onChanged: (val) {
                  setState(() => _contrast= val);
                  _onContrastChanged(val);
                },
              
            ),
          ],
        ),
        
        //overlay
      
        Row(
          children: [
            Expanded(child:
            Text(
              'Match Overlay Color:', 
              style: Sv4rs.settingslabelStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              ),
              ),
            Switch(
              value: _matchOverlay,
              onChanged: (val) {
                setState(() => _matchOverlay = val);
                _onMatchOverlayChanged(val);
              },
            ),
          ],
        ),
        
         ExpansionTile(
          tilePadding: EdgeInsets.all(2),
          title: Row(
              children: [
                Expanded(child:
                Text('Overlay Color:', 
                  style: Sv4rs.settingslabelStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Cv4rs.themeColor3,
                  radius: 20,
                  child: Icon(Icons.circle, color: _overlay, size: 40, shadows: [
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
              Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10), child: 
               HexCodeInput2(
                  startValue: _overlay.toHexString(),
                  textStyle: Sv4rs.settingslabelStyle,
                  hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                  onColorChanged:  (color) { setState(() {
                    _overlay = color;
                    _onOverlayChanged(color);
                   });
                   }
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
                  pickerColor: _overlay, 
                  enableAlpha: true,
                  displayThumbColor: false,
                  labelTypes: ColorLabelType.values,
                  onColorChanged: (color) { setState(() {
                    _overlay = color;
                    _onOverlayChanged(color);
                   });
                }
               ),
                  ),
                  ),
                ]),
                
              ),
            ],
          ),
      _widgety,
      ],
                        ),
    );
  }
}


class ColorPickerWithHex extends StatefulWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerWithHex({
    super.key,
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  @override
  State<ColorPickerWithHex> createState() => _ColorPickerWithHex();
}

class _ColorPickerWithHex extends State<ColorPickerWithHex> {
  late String _label;
  late Color _color;
  late ValueChanged<Color> _onColorChanged;

  @override
  void initState() {
    super.initState();
    _color = widget.color;
    _label = widget.label;
    _onColorChanged = widget.onColorChanged;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Text(_label, style: Sv4rs.settingslabelStyle,),
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
      collapsedBackgroundColor: Cv4rs.themeColor4,
      backgroundColor: Cv4rs.themeColor4,
      childrenPadding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
          child: HexCodeInput(
            startValue: _color.toHexString(),
            textStyle: Sv4rs.settingslabelStyle,
            hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
            onColorChanged: (color) {
              setState(() {
                _color = color;
                _onColorChanged(color);
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
          child: ColorPicker(
            pickerColor: _color,
            enableAlpha: true,
            displayThumbColor: false,
            labelTypes: ColorLabelType.values,
            onColorChanged: (color) {
              setState(() {
                _color = color;
                widget.onColorChanged(color);
              });
            },
          ),
        ),
      ],
    );
  }
}

class ImageStyle1 extends StatelessWidget {
  final Widget image;
  final double symbolSaturation;
  final double symbolContrast;
  final bool invertSymbolColors;
  final bool matchOverlayColor;
  final bool matchSymbolContrast;
  final bool matchSymbolSaturation;
  final bool matchSymbolInvert;
  final Color overlayColor;
  final double defaultSymbolContrast;
  final double defaultSymbolSaturation;
  final bool defaultSymbolInvert;
  final Color defaultSymbolColorOverlay;

  const ImageStyle1({
    super.key,
    required this.image,
    required this.symbolSaturation,
    required this.symbolContrast,
    required this.invertSymbolColors,
    required this.matchOverlayColor,
    required this.overlayColor,
    required this.defaultSymbolColorOverlay,
    required this.matchSymbolContrast,
    required this.matchSymbolInvert,
    required this.matchSymbolSaturation,
    required this.defaultSymbolInvert,
    required this.defaultSymbolContrast,
    required this.defaultSymbolSaturation,
  });

  @override
  Widget build(BuildContext context) {
    
    // pick overlay color depending on state
    final Color finalOverlay = matchOverlayColor
        ? defaultSymbolColorOverlay
        : overlayColor;

    final double finalContrast = matchSymbolContrast
        ? defaultSymbolContrast
        : symbolContrast;
    
    final double finalSaturation = matchSymbolSaturation
        ? defaultSymbolSaturation
        : symbolSaturation;

    final bool finalInvert = matchSymbolInvert
        ? defaultSymbolInvert
        : invertSymbolColors;

    return Stack(
      children: [
        // Base image, handles image when other is transparent
        ColorFiltered(
          colorFilter: ColorFilter.matrix(
            Cv4rs.combineMatrices([
              Cv4rs.saturationMatrix(finalSaturation),
              Cv4rs.contrastMatrix(finalContrast),
              finalInvert
                  ? Cv4rs.invertMatrix()
                  : Cv4rs.identityMatrix(),
            ]),
          ),
          child: image,
        ),

        // Overlay 
        ColorFiltered(
            colorFilter: ColorFilter.mode(
              finalOverlay, 
              BlendMode.srcIn, 
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.matrix(
                Cv4rs.combineMatrices([
                  Cv4rs.saturationMatrix(finalSaturation),
                  Cv4rs.contrastMatrix(finalContrast),
                  finalInvert
                      ? Cv4rs.invertMatrix()
                      : Cv4rs.identityMatrix(),
                ]),
              ),
              child: image,
            ),
          )
          
        
      ],
    );
  }
}

// buttons

class BuildPocketFolder extends StatefulWidget{

    final BoardObjects obj;
    final TTSInterface synth;
    final void Function(BoardObjects board) openBoard;
    final void Function(BoardObjects board) openBoardWithReturn;
    final List<BoardObjects> boards;
    final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;

    const BuildPocketFolder({
      super.key, 
      required this.obj, 
      required this.synth,
      required this.openBoard, 
      required this.openBoardWithReturn, 
      required this.boards,
      required this.findBoardById
      });
    
    @override
    State<BuildPocketFolder> createState() => _BuildPocketFolderState();
}

class _BuildPocketFolderState extends State<BuildPocketFolder> {
    final Stopwatch _stopwatch = Stopwatch();
    DateTime? _lastTapTime;
    final Duration _doubleTapMaxDelay = Duration(milliseconds: (V4rs.doubleTapClickSpeed));
    Timer? _singleTapTimer;

    @override
    Widget build(BuildContext context) {

    final bool altAccessActive = MediaQuery.of(context).accessibleNavigation;
    
    final obj = widget.obj;
    final findBoardById = widget.findBoardById;
    final boards = widget.boards;
    final openBoard = widget.openBoard;
    final openBoardWithReturn = widget.openBoardWithReturn;
    final synth = widget.synth;
    String linkTo = obj.linkToUUID ?? '';

    //font settings
    TextStyle uniqueStyle =  
    TextStyle(
      color: obj.fontColor ?? Colors.black,
      fontSize: obj.fontSize ?? 16,
      fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
      fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
      decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
    );

    TextStyle matchStyle =  
    TextStyle(
      color: Fv4rs.buttonFontColor,
      fontSize: Fv4rs.buttonFontSize,
      fontFamily: Fontsy.fontToFamily[Fv4rs.buttonFont], 
      fontWeight: FontWeight.values[((Fv4rs.buttonFontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: Fv4rs.buttonFontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: Fv4rs.buttonFontUnderline ? TextDecoration.underline : TextDecoration.none,
    );

    //label
      Text theLabel = 
      Text(obj.label ?? "", 
        style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        );
      Text theLabel2 = 
      Text(obj.label ?? "", 
        style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        );
  
    //image
      Widget image = LoadImage.fromSymbol(obj.symbol);
      

    //symbol
      Widget theSymbol = 
        ImageStyle1(
          image: image, 
          symbolSaturation: obj.symbolSaturation ?? 1.0, 
          symbolContrast: obj.symbolContrast ?? 1.0, 
          invertSymbolColors: obj.invertSymbol ?? false, 
          matchOverlayColor: obj.matchOverlayColor ?? true, 
          overlayColor: obj.overlayColor ?? Colors.white,
          defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
          matchSymbolContrast: obj.matchSymbolContrast ?? true, 
          matchSymbolInvert: obj.matchInvertSymbol ?? true, 
          matchSymbolSaturation: obj.matchSymbolSaturation ?? true, 
          defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
          defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
          defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
        );

        //tap action
          Future<void> doTapAction(
            BoardObjects obj,
            TTSInterface synth,
            ) async {
              setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.pocketFolderSpeakOnSelect : obj.speakOS) {
            case 1:
              V4rs.changedMWfromButton = true;
              V4rs.message.value = V4rs.message.value + (obj.message ?? '');
              V4rs.changedMWfromButton = false;
              break;
            case 2:
              V4rs.changedMWfromButton = true;
              V4rs.message.value = V4rs.message.value + (obj.message ?? '');
              await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
              V4rs.changedMWfromButton = false;
              break;
            case 3:
              V4rs.changedMWfromButton = true;
              V4rs.message.value = V4rs.message.value + (obj.message ?? '');
              await V4rs.speakOnSelect(obj.message ?? '', V4rs.selectedLanguage.value, synth);
              V4rs.changedMWfromButton = false;
              break;
            }
          }     

          Future<void> doSecondaryTap(
            BoardObjects obj,
            TTSInterface synth,
            ) async {
              setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.pocketFolderSpeakOnSelect : obj.speakOS) {
            case 1:
              final board = findBoardById(linkTo, boards);
                if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
                }
              break;
            case 2:
              final board = findBoardById(linkTo, boards);
                if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
                }
              await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
              break;
            case 3:
              final board = findBoardById(linkTo, boards);
                if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
                }
              await V4rs.speakOnSelect(obj.message ?? '', V4rs.selectedLanguage.value, synth);
              break;
            }
          }
      //
      //button
      //
      return LayoutBuilder(builder: (context, constraints) {
      double side = constraints.maxHeight * 0.2;
      double top = constraints.maxWidth * 0.15;

      return Stack(children: [ 
      Positioned.fill(child: 
      Visibility(
        visible: (obj.show ?? true), 
        maintainSize: true, 
        maintainAnimation: true,
        maintainState: true, child:
       Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _stopwatch..reset()..start(),
        onPointerUp: (_) async {
          _stopwatch.stop();
          final now = DateTime.now();
        
        //===: USE LONG TAP :===///
         if (!V4rs.useLongTapOr) {
           if (_stopwatch.elapsedMilliseconds < V4rs.longTapDuration) {
            await doTapAction(obj, synth);
            return;
           } else {
            await doSecondaryTap(obj, synth);
            return;
          }

         //===: USE DOUBLE TAP  :===///
         } else {
          if (_lastTapTime != null &&
              now.difference(_lastTapTime!) <= _doubleTapMaxDelay) {
            _singleTapTimer?.cancel();
            await doSecondaryTap(obj, synth);
            _lastTapTime = null;
            return;
          }
          _lastTapTime = now;
          _singleTapTimer?.cancel();
          _singleTapTimer = Timer(_doubleTapMaxDelay, () async {
            await doTapAction(obj, synth);
            _lastTapTime = null;
          });

          return;

         }
      },
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        elevation: 2,
        backgroundColor: (V4rs.isSearchPath(V4rs.searchPathUUIDS.value, obj))
          ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
          : (obj.matchPOS ?? true) 
            ? Cv4rs.posToColor(obj.pos ?? 'Extra 2')
            : obj.backgroundColor ?? Colors.blueGrey,
        shadowColor: Cv4rs.themeColor4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: (obj.matchBorder ?? true)
                ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
                : obj.borderColor ?? Colors.white,
            width: (obj.matchBorder ?? true)
                ? Bv4rs.buttonBorderWeight
                : obj.borderWeight ?? 2.5,
          ),
        ),
      ),
      onPressed: () async {
        if (altAccessActive) {
          await doTapAction(obj, synth);
        }
      }, 
      child: () {
        switch ((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
          case 1:
            return Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      obj.padding ?? 2.0,
                      (obj.padding ?? 2.0) + 2.0,
                      obj.padding ?? 2.0,
                      obj.padding ?? 2.0,
                    ),
                    child: theSymbol,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: theLabel,
                ),
              ]),
            ]);
          case 2:
            return Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: theLabel,
                ), 
                Flexible(child: 
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    obj.padding ?? 2.0,
                    obj.padding ?? 2.0,
                    obj.padding ?? 2.0,
                    (obj.padding ?? 2.0) + 2.0,
                  ),
                  child: theSymbol,
                ),
                ),
              ]),
            ]);
          case 3:
            return Stack(children: [
              Padding(
                padding: EdgeInsets.all(obj.padding ?? 2.0),
                child: theSymbol,
              ),
            ]);
          case 4:
            return Stack(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: theLabel2,
              ),
            ]);
          default:
            return SizedBox.shrink();
            }
          }(),
          ),
        )),
        ),


        //
        //CORNER TAB 
        //
        Positioned(
              top: 2,
              right: 3,
              child: SizedBox(width: top, height: side,
                child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),),
                onPressed: () async { if (altAccessActive) {
                  await doSecondaryTap(obj, synth);
                } else { 
                  //pretend you hit the button
                  await doTapAction(obj, synth);
                }
                },
                child: Visibility(
                visible: (obj.show ?? true), 
                maintainSize: true, 
                maintainAnimation: true,
                maintainState: true,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Cv4rs.cornerTabColor, BlendMode.srcIn
                    ), child:
                   Image.asset('assets/interface_icons/interface_icons/iCornerTabPocketFolder.png'),
                  )
                )
                )
              ),
        )
        ]); 
      });
    }
  }

class BuildTypingKey extends StatefulWidget{

    final BoardObjects obj;
    final TTSInterface synth;

    const BuildTypingKey({
      super.key, 
      required this.obj, 
      required this.synth,
      });
    
    @override
    State<BuildTypingKey> createState() => _BuildTypingKeyState();
}

class _BuildTypingKeyState extends State<BuildTypingKey> {
    final Stopwatch _stopwatch = Stopwatch();
    DateTime? _lastTapTime;
    final Duration _doubleTapMaxDelay = Duration(milliseconds: (V4rs.doubleTapClickSpeed));
    Timer? _singleTapTimer;

    @override
    Widget build(BuildContext context) {

    final bool altAccessActive = MediaQuery.of(context).accessibleNavigation;
    
    final obj = widget.obj;
    final synth = widget.synth;

    //font settings
    TextStyle uniqueStyle =  
    TextStyle(
      color: obj.fontColor ?? Colors.black,
      fontSize: obj.fontSize ?? 16,
      fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
      fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
      decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
    );

    TextStyle matchStyle =  
    TextStyle(
      color: Fv4rs.buttonFontColor,
      fontSize: Fv4rs.buttonFontSize,
      fontFamily: Fontsy.fontToFamily[Fv4rs.buttonFont], 
      fontWeight: FontWeight.values[((Fv4rs.buttonFontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: Fv4rs.buttonFontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: Fv4rs.buttonFontUnderline ? TextDecoration.underline : TextDecoration.none,
    );

    //label
      Text theLabel = 
      Text(obj.label ?? "", 
        style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        );
      Text theLabel2 = 
      Text(obj.label ?? "", 
        style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        );
  
    //image
      Widget image = LoadImage.fromSymbol(obj.symbol);

    //symbol
      Widget theSymbol = 
        ImageStyle1(
          image: image, 
          symbolSaturation: obj.symbolSaturation ?? 1.0, 
          symbolContrast: obj.symbolContrast ?? 1.0, 
          invertSymbolColors: obj.invertSymbol ?? false, 
          matchOverlayColor: obj.matchOverlayColor ?? true, 
          overlayColor: obj.overlayColor ?? Colors.white,
          defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
          matchSymbolContrast: obj.matchSymbolContrast ?? true, 
          matchSymbolInvert: obj.matchInvertSymbol ?? true, 
          matchSymbolSaturation: obj.matchSymbolSaturation ?? true, 
          defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
          defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
          defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
        );

        //tap action
          Future<void> doTapAction(
            BoardObjects obj,
            TTSInterface synth,
            ) async {
              setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.typingKeySpeakOnSelect : obj.speakOS) {
                  case 1:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value.trim() + (obj.message ?? '');
                    V4rs.changedMWfromButton = false;
                    break;
                  case 2:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value.trim() + (obj.message ?? '');
                    await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                    V4rs.changedMWfromButton = false;
                    break;
                  case 3:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value.trim() + (obj.message ?? '');
                    await V4rs.speakOnSelect(obj.message ?? '', V4rs.selectedLanguage.value, synth);
                    V4rs.changedMWfromButton = false;
                    break;
                  }
                }     

          Future<void> doSecondaryTap(
            BoardObjects obj,
            TTSInterface synth,
            ) async {
              setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.typingKeySpeakOnSelect : obj.speakOS) {
                  case 1:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                    V4rs.changedMWfromButton = false;
                    break;
                  case 2:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                    await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                    V4rs.changedMWfromButton = false;
                    break;
                  case 3:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                    await V4rs.speakOnSelect(obj.message ?? '', V4rs.selectedLanguage.value, synth);
                    V4rs.changedMWfromButton = false;
                    break;
                  }
                }

      
      //
      //button
      //
      return LayoutBuilder(builder: (context, constraints) {
      double side = constraints.maxHeight * 0.2;
      double top = constraints.maxWidth * 0.2;

      return Stack(children: [ 
      Positioned.fill(child: 
      Visibility(
        visible: (obj.show ?? true), 
        maintainSize: true, 
        maintainAnimation: true,
        maintainState: true, 
        child:
       Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _stopwatch..reset()..start(),
        onPointerUp: (_) async {
          _stopwatch.stop();

          final now = DateTime.now();

            //===: USE LONG TAP :===///
            if (!V4rs.useLongTapOr) {
              if (_stopwatch.elapsedMilliseconds < V4rs.longTapDuration) {
                await doTapAction(obj, synth);
                return;
              } else {
                await doSecondaryTap(obj, synth);
                return;
              }

            //===: USE DOUBLE TAP  :===///
          } else {
            if (_lastTapTime != null &&
                now.difference(_lastTapTime!) <= _doubleTapMaxDelay) {
              _singleTapTimer?.cancel();
              await doSecondaryTap(obj, synth);
              _lastTapTime = null;
              return;
            }
            _lastTapTime = now;
            _singleTapTimer?.cancel();
            _singleTapTimer = Timer(_doubleTapMaxDelay, () async {
              await doTapAction(obj, synth);
              _lastTapTime = null;
            });

              return;
          }
      },
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        elevation: 2,
        backgroundColor: (V4rs.isSearchPath(V4rs.searchPathUUIDS.value, obj))
          ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
          : (obj.matchPOS ?? true)
            ? Cv4rs.posToColor(obj.pos ?? 'Extra 2')
            : obj.backgroundColor ?? Colors.blueGrey,
        shadowColor: Cv4rs.themeColor4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: (obj.matchBorder ?? true)
                ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
                : obj.borderColor ?? Colors.white,
            width: (obj.matchBorder ?? true)
                ? Bv4rs.buttonBorderWeight
                : obj.borderWeight ?? 2.5,
          ),
        ),
      ),
      onPressed: () async {
        if (altAccessActive) {
          await doTapAction(obj, synth);
        }
      },
      child: () {
        switch ((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
          case 1:
            //text below
            return Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      obj.padding ?? 2.0,
                      (obj.padding ?? 2.0) + 2.0,
                      obj.padding ?? 2.0,
                      obj.padding ?? 2.0,
                    ),
                    child: theSymbol,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: theLabel,
                ),
              ]),
            ]);

          //text above 
          case 2:
            return Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: theLabel,
                ), 
                Flexible(child: 
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    obj.padding ?? 2.0,
                    obj.padding ?? 2.0,
                    obj.padding ?? 2.0,
                    (obj.padding ?? 2.0) + 2.0,
                  ),
                  child: theSymbol,
                ),
                ),
              ]),
            ]);
          
          //symbol only 
          case 3:
            return Stack(children: [
              Padding(
                padding: EdgeInsets.all(obj.padding ?? 2.0),
                child: theSymbol,
              ),
            ]);

          //label only
          case 4:
            return Stack(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: theLabel2,
              ),
            ]);
          
          //fallback
          default:
            return SizedBox.shrink();
            }
          }(),
          ),
        )),
        ),
        //
        //CORNER TAB 
        //
        Positioned(
              top: 0,
              right: 5,
              child: SizedBox(width: top, height: side,
                child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),),
                onPressed: () async { if (altAccessActive) {
                  doSecondaryTap(obj, synth);
                } else { 
                  //pretend you hit the button
                  doTapAction(obj, synth);
                }
                },
                child: Visibility(
                visible: (obj.show ?? true), 
                maintainSize: true, 
                maintainAnimation: true,
                maintainState: true, 
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Cv4rs.cornerTabColor, BlendMode.srcIn
                    ), child:
                     Image.asset('assets/interface_icons/interface_icons/iCornerTabTypingKey.png'),
                )
                )
                )
              ),
        )
        ]); 
      });
    }
  }

class BuildAudioTile extends StatefulWidget{

    final BoardObjects obj;
    final TTSInterface synth;

    const BuildAudioTile({
      super.key, 
      required this.obj, 
      required this.synth,
      });
    
    @override
    State<BuildAudioTile> createState() => _BuildAudioTileState();
}

class _BuildAudioTileState extends State<BuildAudioTile> {
    late AudioPlayer _player;
    final Stopwatch _stopwatch = Stopwatch();
    DateTime? _lastTapTime;
    final Duration _doubleTapMaxDelay = Duration(milliseconds: (V4rs.doubleTapClickSpeed));
    Timer? _singleTapTimer;

    @override
    void initState() {
      super.initState();
      _player = AudioPlayer();
    }

    @override
    void dispose() {
      _player.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {

    final bool altAccessActive = MediaQuery.of(context).accessibleNavigation;
    
    final obj = widget.obj;
    final synth = widget.synth;

    //font settings
    TextStyle uniqueStyle =  
    TextStyle(
      color: obj.fontColor ?? Colors.black,
      fontSize: obj.fontSize ?? 16,
      fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
      fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
      decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
    );

    TextStyle matchStyle =  
    TextStyle(
      color: Fv4rs.buttonFontColor,
      fontSize: Fv4rs.buttonFontSize,
      fontFamily: Fontsy.fontToFamily[Fv4rs.buttonFont], 
      fontWeight: FontWeight.values[((Fv4rs.buttonFontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: Fv4rs.buttonFontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: Fv4rs.buttonFontUnderline ? TextDecoration.underline : TextDecoration.none,
    );

    //label
      Text theLabel = 
      Text(obj.label ?? "", 
        style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        );
      Text theLabel2 = 
      Text(obj.label ?? "", 
        style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        );
  
    //image
      Widget image = LoadImage.fromSymbol(obj.symbol);

    //symbol
      Widget theSymbol = 
        ImageStyle1(
          image: image, 
          symbolSaturation: obj.symbolSaturation ?? 1.0, 
          symbolContrast: obj.symbolContrast ?? 1.0, 
          invertSymbolColors: obj.invertSymbol ?? false, 
          matchOverlayColor: obj.matchOverlayColor ?? true, 
          overlayColor: obj.overlayColor ?? Colors.white,
          defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
          matchSymbolContrast: obj.matchSymbolContrast ?? true, 
          matchSymbolInvert: obj.matchInvertSymbol ?? true, 
          matchSymbolSaturation: obj.matchSymbolSaturation ?? true, 
          defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
          defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
          defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
        );

        //tap action
          Future<void> doTapAction(
            BoardObjects obj,
            TTSInterface synth,
            ) async {
              setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.typingKeySpeakOnSelect : obj.speakOS) {
                  case 1:
                    await LoadAudio.fromAudio(obj.audioClip);
                    break;
                  case 2:
                    await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                    await LoadAudio.fromAudio(obj.audioClip);
                    break;
                  case 3:
                    await V4rs.speakOnSelect(obj.message ?? '', V4rs.selectedLanguage.value, synth);
                    await LoadAudio.fromAudio(obj.audioClip);
                    break;
                  }
                }     

          Future<void> doSecondaryTap(
            BoardObjects obj,
            TTSInterface synth,
            ) async {
              setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.typingKeySpeakOnSelect : obj.speakOS) {
                  case 1:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                    V4rs.changedMWfromButton = false;
                    break;
                  case 2:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                    await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                    V4rs.changedMWfromButton = false;
                    break;
                  case 3:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                    await V4rs.speakOnSelect(obj.message ?? '', V4rs.selectedLanguage.value, synth);
                    V4rs.changedMWfromButton = false;
                    break;
                  }
                }

      
      //
      //button
      //
      return LayoutBuilder(builder: (context, constraints) {
      double side = constraints.maxHeight * 0.3;
      double top = constraints.maxWidth * 0.2;

      return Stack(children: [ 
      Positioned.fill(child: 
      Visibility(
        visible: (obj.show ?? true), 
        maintainSize: true, 
        maintainAnimation: true,
        maintainState: true, 
        child:
       Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _stopwatch..reset()..start(),
        onPointerUp: (_) async {
          _stopwatch.stop();

          final now = DateTime.now();

            //===: USE LONG TAP :===///
            if (!V4rs.useLongTapOr) {
              if (_stopwatch.elapsedMilliseconds < V4rs.longTapDuration) {
                await doTapAction(obj, synth);
                return;
              } else {
                await doSecondaryTap(obj, synth);
                return;
              }

            //===: USE DOUBLE TAP  :===///
          } else {
            if (_lastTapTime != null &&
                now.difference(_lastTapTime!) <= _doubleTapMaxDelay) {
              _singleTapTimer?.cancel();
              await doSecondaryTap(obj, synth);
              _lastTapTime = null;
              return;
            }
            _lastTapTime = now;
            _singleTapTimer?.cancel();
            _singleTapTimer = Timer(_doubleTapMaxDelay, () async {
              await doTapAction(obj, synth);
              _lastTapTime = null;
            });

              return;
          }
      },
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        elevation: 2,
        backgroundColor: (V4rs.isSearchPath(V4rs.searchPathUUIDS.value, obj))
          ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
          : (obj.matchPOS ?? true)
            ? Cv4rs.posToColor(obj.pos ?? 'Extra 2')
            : obj.backgroundColor ?? Colors.blueGrey,
        shadowColor: Cv4rs.themeColor4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: (obj.matchBorder ?? true)
                ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
                : obj.borderColor ?? Colors.white,
            width: (obj.matchBorder ?? true)
                ? Bv4rs.buttonBorderWeight
                : obj.borderWeight ?? 2.5,
          ),
        ),
      ),
      onPressed: () async {
        if (altAccessActive) {
          await doTapAction(obj, synth);
        }
      },
      child: () {
        switch ((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
          case 1:
            //text below
            return Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      obj.padding ?? 2.0,
                      (obj.padding ?? 2.0) + 2.0,
                      obj.padding ?? 2.0,
                      obj.padding ?? 2.0,
                    ),
                    child: theSymbol,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: theLabel,
                ),
              ]),
            ]);

          //text above 
          case 2:
            return Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: theLabel,
                ), 
                Flexible(child: 
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    obj.padding ?? 2.0,
                    obj.padding ?? 2.0,
                    obj.padding ?? 2.0,
                    (obj.padding ?? 2.0) + 2.0,
                  ),
                  child: theSymbol,
                ),
                ),
              ]),
            ]);
          
          //symbol only 
          case 3:
            return Stack(children: [
              Padding(
                padding: EdgeInsets.all(obj.padding ?? 2.0),
                child: theSymbol,
              ),
            ]);

          //label only
          case 4:
            return Stack(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: theLabel2,
              ),
            ]);
          
          //fallback
          default:
            return SizedBox.shrink();
            }
          }(),
          ),
        )),
        ),
        //
        //CORNER TAB 
        //
        Positioned(
              top: 3,
              right: 5,
              child: SizedBox(width: top, height: side,
                child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),),
                onPressed: () async { if (altAccessActive) {
                  doSecondaryTap(obj, synth);
                } else { 
                  //pretend you hit the button
                  doTapAction(obj, synth);
                }
                },
                child: Visibility(
                visible: (obj.show ?? true), 
                maintainSize: true, 
                maintainAnimation: true,
                maintainState: true, 
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Cv4rs.cornerTabColor, BlendMode.srcIn
                    ), child:
                     Image.asset('assets/interface_icons/interface_icons/iCornerTabAudioTile.png'),
                )
                )
                )
              ),
        )
        ]); 
      });
    }
  }

class BuildButtonGrammer extends StatelessWidget{

    final BoardObjects obj;
    final TTSInterface synth;

    const BuildButtonGrammer({super.key, required this.obj, required this.synth});

     @override
    Widget build(BuildContext context) {

    //font settings
        TextStyle uniqueStyle =  
        TextStyle(
          color: obj.fontColor ?? Colors.black,
          fontSize: obj.fontSize ?? 16,
          fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
          fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
          decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
        );

        TextStyle matchStyle =  
        TextStyle(
          color: Fv4rs.buttonFontColor,
          fontSize: Fv4rs.buttonFontSize,
          fontFamily: Fontsy.fontToFamily[Fv4rs.buttonFont], 
          fontWeight: FontWeight.values[((Fv4rs.buttonFontWeight ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: Fv4rs.buttonFontItalics ? FontStyle.italic : FontStyle.normal,
          decoration: Fv4rs.buttonFontUnderline ? TextDecoration.underline : TextDecoration.none,
        );

      //label
        Text theLabel = 
        Text(obj.label ?? "", 
          style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          );
        Text theLabel2 = 
        Text(obj.label ?? "", 
          style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          );
      
      //image
        Widget image = LoadImage.fromSymbol(obj.symbol);

      //symbol
        Widget theSymbol = 
          ImageStyle1(
            image: image, 
            symbolSaturation: obj.symbolSaturation ?? 1.0, 
            symbolContrast: obj.symbolContrast ?? 1.0, 
            invertSymbolColors: obj.invertSymbol ?? false, 
            matchOverlayColor: obj.matchOverlayColor ?? true, 
            overlayColor: obj.overlayColor ?? Colors.white,
            defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
            matchSymbolContrast: obj.matchSymbolContrast ?? true, 
            matchSymbolInvert: obj.matchInvertSymbol ?? true, 
            matchSymbolSaturation: obj.matchSymbolSaturation ?? true, 
            defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
            defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
            defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
            );
             return LayoutBuilder(builder: (context, constraints) {
      double side = constraints.maxHeight * 0.2;
      double top = constraints.maxWidth * 0.2;

      //
      //button
      //
      return 
      
      Stack(children: [ 
      Positioned.fill(child: 
       Visibility(
        visible: (obj.show ?? true), 
        maintainSize: true, 
        maintainAnimation: true,
        maintainState: true, child:
        ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            elevation: 2,
            backgroundColor: (V4rs.isSearchPath(V4rs.searchPathUUIDS.value, obj))
              ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
              : (obj.matchPOS ?? true) 
                ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                : obj.backgroundColor ?? Colors.blueGrey,
            shadowColor: Cv4rs.themeColor4, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: (obj.matchBorder ?? true) 
                  ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                  : obj.borderColor ?? Colors.white,
                width: (obj.matchBorder ?? true) 
                  ? Bv4rs.buttonBorderWeight
                  : obj.borderWeight ?? 2.5
              )
            ),
          ),
        onPressed: () async {
          switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
          case 1:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            V4rs.changedMWfromButton = false;
            V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
            break;
          case 2:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
            V4rs.changedMWfromButton = false;
            V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
            break;
          case 3:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            await V4rs.speakOnSelect(Gv4rs.lastWord, V4rs.selectedLanguage.value, synth);
            V4rs.changedMWfromButton = false;
            V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
            break;
          }
        },
        child: () {
          switch((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
            case 1: 
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Flexible(child: 
                Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0), 
                child:
                theSymbol,
                ),
                ),
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                theLabel,
                ),
              ],
            );
            case 2: 
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                theLabel,
                ),
                Flexible(child: 
                Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0), 
                child:
                  theSymbol,
                ),
                ),
            ],
            );
            case 3: 
              return Padding(
                padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                theSymbol,
              );
            case 4:
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
              theLabel2);
          }
        } (),
        )
      
      )
      
    ),

     //
        //CORNER TAB 
        //
        Positioned(
              top: 5,
              right: 0,
              child: SizedBox(width: top, height: side,
                child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),),
                onPressed: () async { 
                   switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
                      case 1:
                        V4rs.changedMWfromButton = true;
                        Gv4rs.grammerFunctions(obj.function ?? '');
                        V4rs.changedMWfromButton = false;
                        break;
                      case 2:
                        V4rs.changedMWfromButton = true;
                        Gv4rs.grammerFunctions(obj.function ?? '');
                        await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                        V4rs.changedMWfromButton = false;
                        break;
                      case 3:
                        V4rs.changedMWfromButton = true;
                        Gv4rs.grammerFunctions(obj.function ?? '');
                        await V4rs.speakOnSelect(Gv4rs.lastWord, V4rs.selectedLanguage.value, synth);
                        V4rs.changedMWfromButton = false;
                        break;
                      }
                },
                child: Visibility(
                visible: (obj.show ?? true), 
                maintainSize: true, 
                maintainAnimation: true,
                maintainState: true,
                  child: Transform.rotate(angle: 190, child:
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(Cv4rs.cornerTabColor, BlendMode.srcIn
                    ), child:
                   Image.asset('assets/interface_icons/interface_icons/iCornerTabTypingKey.png'),
                  )
                  )
                )
                )
              ),
        )
        
    ]
    );
    });
    }
  }

class PreveiwButton extends StatelessWidget{
  
  final BoardObjects obj;

  const PreveiwButton({super.key, required this.obj});

    @override
    Widget build(BuildContext context) {

    //font settings
        TextStyle uniqueStyle =  
        TextStyle(
          color: obj.fontColor ?? Colors.black,
          fontSize: obj.fontSize ?? 16,
          fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
          fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
          decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
        );

        TextStyle matchStyle =  
        TextStyle(
          color: Fv4rs.buttonFontColor,
          fontSize: Fv4rs.buttonFontSize,
          fontFamily: Fontsy.fontToFamily[Fv4rs.buttonFont], 
          fontWeight: FontWeight.values[((Fv4rs.buttonFontWeight ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: Fv4rs.buttonFontItalics ? FontStyle.italic : FontStyle.normal,
          decoration: Fv4rs.buttonFontUnderline ? TextDecoration.underline : TextDecoration.none,
        );

      //label
        Text theLabel = 
        Text(obj.label ?? "", 
          style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          );
        Text theLabel2 = 
        Text(obj.label ?? "", 
          style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          );
      
      //image
        Widget image = LoadImage.fromSymbol(obj.symbol);

      //symbol
        Widget theSymbol = 
          ImageStyle1(
            image: image, 
            symbolSaturation: obj.symbolSaturation ?? 1.0, 
            symbolContrast: obj.symbolContrast ?? 1.0, 
            invertSymbolColors: obj.invertSymbol ?? false, 
            matchOverlayColor: obj.matchOverlayColor ?? true, 
            overlayColor: obj.overlayColor ?? Colors.white,
            defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
            matchSymbolContrast: obj.matchSymbolContrast ?? true, 
            matchSymbolInvert: obj.matchInvertSymbol ?? true, 
            matchSymbolSaturation: obj.matchSymbolSaturation ?? true, 
            defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
            defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
            defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
            );
      //
      //button
      //
      return Opacity(
        opacity: (obj.show ?? true) ? 1.0 : 0.5, 
        child: Container(
          decoration: BoxDecoration(
            color: (obj.matchPOS ?? true) 
                ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                : obj.backgroundColor ?? Colors.blueGrey,
            border: Border.all(
              color: (obj.matchBorder ?? true) 
                ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                : obj.borderColor ?? Colors.white,
              width: (obj.matchBorder ?? true) 
                ? Bv4rs.buttonBorderWeight
                : obj.borderWeight ?? 2.5
            ),
            borderRadius: BorderRadius.circular(10),
            ),
            child: () {
          switch((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
            case 1: 
              return Row(children: [
                Flexible(
                  flex: 2,
                  child: 
                Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0), 
                child:
                theSymbol,
                ),
                ),
                Flexible(
                  flex: 5, 
                  child:
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                theLabel,
                ),
                ),
              ],
            );
            case 2: 
              return Row(children: [
                Flexible( flex: 5, child:
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                theLabel,
                ),
                ),
                Flexible(
                  flex: 2,
                  child: 
                Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0), 
                child:
                  theSymbol,
                ),
                ),
            ],
            );
            case 3: 
              return Padding(
                padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                theSymbol,
              );
            case 4:
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
              theLabel2);
          }
        } (),
          ),

      );
    }
}

class BuildFolder extends StatefulWidget{

    final BoardObjects obj;
    final TTSInterface synth;
    final void Function(BoardObjects board) openBoard;
    final void Function(BoardObjects board) openBoardWithReturn;
    final List<BoardObjects> boards;
    final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;

    const BuildFolder({
      super.key, 
      required this.obj, 
      required this.synth,
      required this.openBoard, 
      required this.openBoardWithReturn, 
      required this.boards,
      required this.findBoardById
      });
    
    @override
    State<BuildFolder> createState() => _BuildFolderState();
}

class _BuildFolderState extends State<BuildFolder> {
    final Stopwatch _stopwatch = Stopwatch();
    DateTime? _lastTapTime;
    final Duration _doubleTapMaxDelay = Duration(milliseconds: (V4rs.doubleTapClickSpeed));
    Timer? _singleTapTimer;

    @override
    Widget build(BuildContext context) {

    final bool altAccessActive = MediaQuery.of(context).accessibleNavigation;
    
    final obj = widget.obj;
    final findBoardById = widget.findBoardById;
    final boards = widget.boards;
    final openBoard = widget.openBoard;
    final openBoardWithReturn = widget.openBoardWithReturn;
    final synth = widget.synth;
    String linkTo = obj.linkToUUID ?? '';

    //font settings
    TextStyle uniqueStyle =  
    TextStyle(
      color: obj.fontColor ?? Colors.black,
      fontSize: obj.fontSize ?? 16,
      fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
      fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
      decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
    );

    TextStyle matchStyle =  
    TextStyle(
      color: Fv4rs.buttonFontColor,
      fontSize: Fv4rs.buttonFontSize,
      fontFamily: Fontsy.fontToFamily[Fv4rs.buttonFont], 
      fontWeight: FontWeight.values[((Fv4rs.buttonFontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: Fv4rs.buttonFontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: Fv4rs.buttonFontUnderline ? TextDecoration.underline : TextDecoration.none,
    );

    //label
      Text theLabel = 
      Text(obj.label ?? "", 
        style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        );
      Text theLabel2 = 
      Text(obj.label ?? "", 
        style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        );
  
    //image
      Widget image = LoadImage.fromSymbol(obj.symbol);

    //symbol
      Widget theSymbol = 
        ImageStyle1(
          image: image, 
          symbolSaturation: obj.symbolSaturation ?? 1.0, 
          symbolContrast: obj.symbolContrast ?? 1.0, 
          invertSymbolColors: obj.invertSymbol ?? false, 
          matchOverlayColor: obj.matchOverlayColor ?? true, 
          overlayColor: obj.overlayColor ?? Colors.white,
          defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
          matchSymbolContrast: obj.matchSymbolContrast ?? true, 
          matchSymbolInvert: obj.matchInvertSymbol ?? true, 
          matchSymbolSaturation: obj.matchSymbolSaturation ?? true, 
          defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
          defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
          defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
        );
      
      //tap action
          Future<void> doTapAction(
            BoardObjects obj,
            TTSInterface synth,
            ) async { 
              setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
              switch ((obj.matchSpeakOS ?? true) ? Bv4rs.folderSpeakOnSelect : obj.speakOS) {
              case 1:
                final board = findBoardById(linkTo, boards);
                 if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
                }
                break;
              case 2:
                final board = findBoardById(linkTo, boards);
                 if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
                }
                await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                break;
              case 3:
                final board = findBoardById(linkTo, boards);
                  if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
                }
                await V4rs.speakOnSelect(obj.message ?? '', V4rs.selectedLanguage.value, synth);
                break;
              }
            }
          Future<void> doSecondaryTap(
            BoardObjects obj,
            TTSInterface synth,
            ) async {
             setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
              switch ((obj.matchSpeakOS ?? true) ? Bv4rs.folderSpeakOnSelect : obj.speakOS) {
              case 1:
                V4rs.changedMWfromButton = true;
                V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                V4rs.changedMWfromButton = false;
                break;
              case 2:
                V4rs.changedMWfromButton = true;
                V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                V4rs.changedMWfromButton = false;
                break;
              case 3:
                V4rs.changedMWfromButton = true;
                V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                await V4rs.speakOnSelect(obj.message ?? '', V4rs.selectedLanguage.value, synth);
                V4rs.changedMWfromButton = false;
                break;
              }
            }
      
      //
      //button
      //
      return LayoutBuilder(builder: (context, constraints) {
      double side = constraints.maxHeight * 0.3;
      double top = constraints.maxWidth * 0.25;

      return Stack(children: [ 
      Positioned.fill(child: 
      Visibility(
        visible: (obj.show ?? true), 
        maintainSize: true, 
        maintainAnimation: true,
        maintainState: true, child:
       Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _stopwatch..reset()..start(),
        onPointerUp: (_) async {
          _stopwatch.stop();
          final now = DateTime.now();


            //===: USE LONG TAP :===///
            if (!V4rs.useLongTapOr) {
              if (_stopwatch.elapsedMilliseconds < V4rs.longTapDuration) {
                await doTapAction(obj, synth);
                return;
              } else {
                await doSecondaryTap(obj, synth);
                return;
              }

            //===: USE DOUBLE TAP  :===///
          } else {
              if (_lastTapTime != null &&
                  now.difference(_lastTapTime!) <= _doubleTapMaxDelay) {
                _singleTapTimer?.cancel();
                await doSecondaryTap(obj, synth);
                _lastTapTime = null;
                return;
              }
              _lastTapTime = now;
              _singleTapTimer?.cancel();
              _singleTapTimer = Timer(_doubleTapMaxDelay, () async {
                await doTapAction(obj, synth);
                _lastTapTime = null;
              });

              return;
        }
      },
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        elevation: 2,
        backgroundColor: (V4rs.isSearchPath(V4rs.searchPathUUIDS.value, obj))
          ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
          : (obj.matchPOS ?? true)
            ? Cv4rs.posToColor(obj.pos ?? 'Extra 2')
            : obj.backgroundColor ?? Colors.blueGrey,
        shadowColor: Cv4rs.themeColor4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: (obj.matchBorder ?? true)
                ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
                : obj.borderColor ?? Colors.white,
            width: (obj.matchBorder ?? true)
                ? Bv4rs.buttonBorderWeight
                : obj.borderWeight ?? 2.5,
          ),
        ),
      ),
      onPressed: () async {
        if (altAccessActive) {
          await doTapAction(obj, synth);
          }
        }, 
      child: () {
        switch ((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
          case 1:
            //text below
            return Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      obj.padding ?? 2.0,
                      (obj.padding ?? 2.0) + 2.0,
                      obj.padding ?? 2.0,
                      obj.padding ?? 2.0,
                    ),
                    child: theSymbol,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: theLabel,
                ),
              ]),
            ]);

          //text above
          case 2:
            return Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: theLabel,
                ), 
                Flexible(child: 
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    obj.padding ?? 2.0,
                    obj.padding ?? 2.0,
                    obj.padding ?? 2.0,
                    (obj.padding ?? 2.0) + 2.0,
                  ),
                  child: theSymbol,
                ),
                ),
              ]),
            ]);

          //image only
          case 3:
            return Stack(children: [
              Padding(
                padding: EdgeInsets.all(obj.padding ?? 2.0),
                child: theSymbol,
              ),
            ]);

          //label only  
          case 4:
            return Stack(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: theLabel2,
              ),
            ]);

          //fallback 
          default:
            return SizedBox.shrink();
        }
      }(),
      ),
    )),
        ),
        //
        //CORNER TAB 
        //
        Positioned(
              top: 0,
              right: 0,
              child: SizedBox(width: top, height: side,
                child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),),
                onPressed: () async { if (altAccessActive) {
                  await doSecondaryTap(obj, synth);
                } else { 
                  //pretend you hit the button
                  await doTapAction(obj, synth);
                }
                },
                child:  Visibility(
                visible: (obj.show ?? true), 
                maintainSize: true, 
                maintainAnimation: true,
                maintainState: true, 
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Cv4rs.cornerTabColor, BlendMode.srcIn
                    ), child:
                   Image.asset('assets/interface_icons/interface_icons/iCornerTabFolder.png'),
                  )
                )
                )
              ),
        )
        ]); 
      });
    }
  }

class BuildButton extends StatelessWidget{

    final BoardObjects obj;
    final TTSInterface synth;

    const BuildButton({super.key, required this.obj, required this.synth});

     @override
    Widget build(BuildContext context) {

    //font settings
        TextStyle uniqueStyle =  
        TextStyle(
          color: obj.fontColor ?? Colors.black,
          fontSize: obj.fontSize ?? 16,
          fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
          fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
          decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
        );

        TextStyle matchStyle =  
        TextStyle(
          color: Fv4rs.buttonFontColor,
          fontSize: Fv4rs.buttonFontSize,
          fontFamily: Fontsy.fontToFamily[Fv4rs.buttonFont], 
          fontWeight: FontWeight.values[((Fv4rs.buttonFontWeight ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: Fv4rs.buttonFontItalics ? FontStyle.italic : FontStyle.normal,
          decoration: Fv4rs.buttonFontUnderline ? TextDecoration.underline : TextDecoration.none,
        );

      //label
        Text theLabel = 
        Text(obj.label ?? "", 
          style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          );
        Text theLabel2 = 
        Text(obj.label ?? "", 
          style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          );
      
      //image
        Widget image = LoadImage.fromSymbol(obj.symbol);

      //symbol
        Widget theSymbol = 
          ImageStyle1(
            image: image, 
            symbolSaturation: obj.symbolSaturation ?? 1.0, 
            symbolContrast: obj.symbolContrast ?? 1.0, 
            invertSymbolColors: obj.invertSymbol ?? false, 
            matchOverlayColor: obj.matchOverlayColor ?? true, 
            overlayColor: obj.overlayColor ?? Colors.white,
            defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
            matchSymbolContrast: obj.matchSymbolContrast ?? true, 
            matchSymbolInvert: obj.matchInvertSymbol ?? true, 
            matchSymbolSaturation: obj.matchSymbolSaturation ?? true, 
            defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
            defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
            defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
            );
      //
      //button
      //
      return Visibility(
        visible: (obj.show ?? true), 
        maintainSize: true, 
        maintainAnimation: true,
        maintainState: true,
        child: ValueListenableBuilder(valueListenable: V4rs.searchPathUUIDS, builder: (context, search, _) {
        return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            elevation: 2,
            backgroundColor: (V4rs.isSearchPath(V4rs.searchPathUUIDS.value, obj))
              ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
              : (obj.matchPOS ?? true) 
                ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                : obj.backgroundColor ?? Cv4rs.themeColor2,
            shadowColor: Cv4rs.themeColor4, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: (obj.matchBorder ?? true) 
                  ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                  : obj.borderColor ?? Colors.white,
                width: (obj.matchBorder ?? true) 
                  ? Bv4rs.buttonBorderWeight
                  : obj.borderWeight ?? 2.5
              )
            ),
          ),
        onPressed: () async {
          switch ((obj.matchSpeakOS ?? true) ? Bv4rs.buttonSpeakOnSelect : obj.speakOS) {
          case 1:
            V4rs.changedMWfromButton = true;
            V4rs.message.value = V4rs.message.value + (obj.message ?? '');
            V4rs.changedMWfromButton = false;
            V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
            break;
          case 2:
            V4rs.changedMWfromButton = true;
            V4rs.message.value = V4rs.message.value + (obj.message ?? '');
            await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
            V4rs.changedMWfromButton = false;
            V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
            break;
          case 3:
            V4rs.changedMWfromButton = true;
            V4rs.message.value = V4rs.message.value + (obj.message ?? '');
            await V4rs.speakOnSelect(obj.message ?? '', V4rs.selectedLanguage.value, synth);
            V4rs.changedMWfromButton = false;
            V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
            break;
          }
        },
        child: () {
          switch((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
            case 1: 
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Flexible(child: 
                Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0), 
                child:
                theSymbol,
                ),
                ),
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                theLabel,
                ),
              ],
            );
            case 2: 
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                theLabel,
                ),
                Flexible(child: 
                Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0), 
                child:
                  theSymbol,
                ),
                ),
            ],
            );
            case 3: 
              return Padding(
                padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                theSymbol,
              );
            case 4:
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
              theLabel2);
          }
        } (),
        );
        }
        )
      );
    }
  }

class BuildSubFolder extends StatelessWidget {

    final BoardObjects obj;
    final TTSInterface synth;

    final void Function() goBack;
    final void Function(BoardObjects board) openBoard;
    final void Function(BoardObjects board) openBoardWithReturn;
    final List<BoardObjects> boards;
    final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;

    const BuildSubFolder({
      super.key, 
      required this.obj, 
      required this.synth, 
      required this.goBack, 
      required this.openBoard, 
      required this.openBoardWithReturn, 
      required this.boards,
      required this.findBoardById
      });

    @override
  Widget build(BuildContext context) {

      //font settings
        TextStyle uniqueStyle =  
        TextStyle(
          color: obj.fontColor ?? Colors.black,
          fontSize: obj.fontSize ?? 16,
          fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
          fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
          decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
        );

        TextStyle matchStyle =  
        TextStyle(
          color: Fv4rs.subFolderFontColor,
          fontSize: Fv4rs.subFolderFontSize,
          fontFamily: Fontsy.fontToFamily[Fv4rs.subFolderFont], 
          fontWeight: FontWeight.values[((Fv4rs.subFolderFontWeight ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: Fv4rs.subFolderFontItalics ? FontStyle.italic : FontStyle.normal,
          decoration: Fv4rs.subFolderFontUnderline ? TextDecoration.underline : TextDecoration.none,
        );

      //label
        Text theLabel = 
        Text(obj.label ?? "", 
          style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle, 
          maxLines: 3,
          overflow: TextOverflow.ellipsis
        );
      
      //image
        Widget image = LoadImage.fromSymbol(obj.symbol);

      //symbol
        Widget theSymbol = 
          ImageStyle1(
            image: image, 
            symbolSaturation: obj.symbolSaturation ?? 1.0, 
            symbolContrast: obj.symbolContrast ?? 1.0, 
            invertSymbolColors: obj.invertSymbol ?? false, 
            matchOverlayColor: obj.matchOverlayColor ?? true, 
            overlayColor: obj.overlayColor ?? Colors.white,
            defaultSymbolColorOverlay: Bv4rs.subFolderSymbolColorOverlay, 
            matchSymbolContrast: obj.matchSymbolContrast ?? true, 
            matchSymbolInvert: obj.matchInvertSymbol ?? true, 
            matchSymbolSaturation: obj.matchSymbolSaturation ?? true, 
            defaultSymbolInvert: Bv4rs.subFolderSymbolInvert, 
            defaultSymbolContrast: Bv4rs.subFolderSymbolContrast, 
            defaultSymbolSaturation: Bv4rs.subFolderSymbolSaturation
            );

      //navigation  
       String linkTo = obj.linkToUUID ?? '';

      //
      //back button
      //
      if (obj.type1 == 'backButton'){
        return Visibility(
        visible: (obj.show ?? true), 
        maintainSize: true, 
        maintainAnimation: true,
        maintainState: true, 
        child:
        ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            elevation: 2,
            backgroundColor: (V4rs.isSearchPath(V4rs.searchPathUUIDS.value, obj))
              ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
              : (obj.matchPOS ?? true) 
                ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                : obj.backgroundColor ?? Cv4rs.themeColor2,
            shadowColor: Cv4rs.themeColor4, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: (obj.matchBorder ?? true) 
                  ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                  : obj.borderColor ?? Colors.white,
                width: (obj.matchBorder ?? true) 
                  ? Bv4rs.subFolderBorderWeight
                  : obj.borderWeight ?? 2.5
              )
            ),
          ),
        onPressed: () async {
          switch ((obj.matchSpeakOS ?? true) ? Bv4rs.subFolderSpeakOnSelect : obj.speakOS) {
          case 1:
            goBack();
            break;
          case 2:
            goBack();
            await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
            break;
          case 3:
            goBack();
            await V4rs.speakOnSelect(obj.alternateLabel ?? '', V4rs.selectedLanguage.value, synth);
            break;
          }
        },
        child: () {
          switch((obj.matchFormat ?? true) ? Bv4rs.subFolderFormat : obj.format) {
            case 1: 
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Padding(padding: EdgeInsets.all(obj.padding ?? 5.0), child:
                theSymbol,
                ),
                Flexible(child: 
                Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5.0), child:
                theLabel,
                ),
                ),
              ],
            );
            case 2: 
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: 
                  Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5.0), child:
                theLabel,
                  ),
                  ),
                Padding(padding: EdgeInsets.all(obj.padding ?? 5.0), child:
                  theSymbol,
                ),
            ],
            );
            case 3: 
              return Padding(
                padding: EdgeInsets.all(obj.padding ?? 5.0), child:
                theSymbol,
              );
            case 4:
              return Column(children: [
              Flexible(child: 
              Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5.0), child:
              theLabel,
              )
              )
              ]
              );
          }
        } (),
        )
      );
      } 

      //
      //sub folders + more
      //
      return Visibility(
        visible: (obj.show ?? true), 
        maintainSize: true, 
        maintainAnimation: true,
        maintainState: true, child:
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            elevation: 2,
            backgroundColor: (V4rs.isSearchPath(V4rs.searchPathUUIDS.value, obj))
              ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
              : (obj.matchPOS ?? true) 
                  ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                  : obj.backgroundColor ?? Colors.blueGrey,
            shadowColor: Cv4rs.themeColor4, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: (obj.matchBorder ?? true) 
                  ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                  : obj.borderColor ?? Colors.white,
                width: (obj.matchBorder ?? true) 
                  ? Bv4rs.subFolderBorderWeight
                  : obj.borderWeight ?? 2.5
              )
            ),
          ),
          onPressed: () async {
          switch ((obj.matchSpeakOS ?? true) ? Bv4rs.subFolderSpeakOnSelect : obj.speakOS) {
            case 1:
              final board = findBoardById(linkTo, boards);
               if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
              }
              V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              break;
            case 2:
              final board = findBoardById(linkTo, boards);
               if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
              }

              await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
              V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              break;
            case 3:
              final board = findBoardById(linkTo, boards);
               if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
              }
              await V4rs.speakOnSelect(obj.alternateLabel ?? '', V4rs.selectedLanguage.value, synth);
              V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              break;
            }},
          child: () {
          switch((obj.matchFormat ?? true) ? Bv4rs.subFolderFormat : obj.format) {
            case 1: 
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Padding(padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                theSymbol,
                ),
                Flexible(child: 
                Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5.0), child:
              theLabel
              ),
                ),
              ],
            );
            case 2: 
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: 
                Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5.0), child:
              theLabel
              ),
                  ),
                Padding(padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                  theSymbol,
                ),
            ],
            );
            case 3: 
              return Padding(
                padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                theSymbol,
              );
            case 4:
              return Column( 
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Flexible(child: 
              Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5.0), child:
              theLabel
              )
                ),
              ]);
          }
        } (),
      ),
    );
    }
}

//nav row buttons 
class NavButtonStyle extends StatelessWidget {
  final NavObjects? me;
  final String label;
  final String symbol;
  final TTSInterface tts;
  final void Function(BoardObjects board) openBoard;
  final List<BoardObjects> boards;
  final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;

  final String linkToLabel;
  final String linkToUUID;

  final bool show;
  final bool matchFormat;
  final int format;

  final String pos;
  final bool matchPOS;
  final Color backgroundColor;

  final bool matchBorder;
  final double borderWeight;
  final Color borderColor;

  final bool matchFont;
  final String fontFamily;
  final double fontSize;
  final int fontWeight;
  final bool fontItalics;
  final bool fontUnderline;
  final Color fontColor;

  final double padding;
  final bool matchOverlayColor;
  final Color overlayColor;
  final double symbolSaturation;
  final double symbolContrast;
  final bool invertSymbolColors;
  final bool matchSymbolContrast;
  final bool matchSymbolInvert;
  final bool matchSymbolSaturation;

  final bool matchSpeakOS;
  final int speakOS;
  final String alternateLabel;

  final String note;

  TextStyle get labelStyle =>  
    TextStyle(
      color: fontColor,
      fontSize: fontSize,
      fontFamily: Fontsy.fontToFamily[fontFamily], 
      fontWeight: FontWeight.values[((fontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: fontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: fontUnderline ? TextDecoration.underline : TextDecoration.none,
    );

  //constructs the button 
  const NavButtonStyle ({
    super.key,
    this.symbol = 'assets/interface_icons/interface_icons/iPlaceholder.png',
    required this.tts,
    required this.openBoard,
    required this.boards,
    required this.findBoardById,
    required this.me,
    this.label = '',
    this.linkToLabel = '',
    this.linkToUUID = '',
    this.show = true,
    this.matchFormat = true,
    this.format = 1,
    this.pos = 'Extra 1',
    this.matchPOS = true,
    this.backgroundColor = Colors.white,
    this.matchBorder = true,
    this.borderWeight = 0,
    this.borderColor = Colors.black,
    this.matchFont = true,
    this.fontFamily = 'Default',
    this.fontSize = 16,
    this.fontWeight = 400,
    this.fontItalics = false,
    this.fontUnderline = false,
    this.fontColor = Colors.black,
    this.padding = 5,
    this.matchOverlayColor = true,
    this.overlayColor = Colors.red,
    this.symbolSaturation = 1.0,
    this.symbolContrast = 1.0,
    this.invertSymbolColors = false,
    this.matchSpeakOS = true,
    this.speakOS = 1,
    this.alternateLabel = '',
    this.note = '',
    this.matchSymbolContrast = true,
    this.matchSymbolSaturation = true,
    this.matchSymbolInvert = true,
  });




  //defines the button 
  @override
  Widget build(BuildContext context) {
    
    //image
     Widget image = LoadImage.fromSymbol(symbol);

    return Visibility (
      visible: (Bv4rs.showNavRow == 2) ? false : show,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: ValueListenableBuilder(valueListenable: V4rs.searchPathUUIDS, builder: (context, search, _) {
      
   return ElevatedButton(
        onPressed: () {
        switch (matchSpeakOS ? Bv4rs.navRowSpeakOnSelect : speakOS) {
          case 1:
              if (me != null){
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, me!.linkToUUID ?? '');
              }
              final board = findBoardById(linkToUUID, boards);
              if (board != null) {
                openBoard(board);
                FocusScope.of(context).unfocus();
              }
              
            break;
          case 2:
              if (me != null){
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, me!.linkToUUID ?? '');
              }
            final board = findBoardById(linkToUUID, boards);
              if (board != null) {
                openBoard(board);
                FocusScope.of(context).unfocus();
              }
            V4rs.speakOnSelect(label, V4rs.selectedLanguage.value, tts);
            break;
          case 3:
            if (me != null){
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, me!.linkToUUID ?? '');
              }

            final board = findBoardById(linkToUUID, boards);
              if (board != null) {
                openBoard(board);
                FocusScope.of(context).unfocus();
              }
            V4rs.speakOnSelect(alternateLabel, V4rs.selectedLanguage.value, tts);
            break;
          }},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          backgroundColor: (V4rs.isSearchPathNav(V4rs.searchPathUUIDS.value, me)) 
          ? Cv4rs.posToBorderColor(pos)
          : matchPOS
            ? Cv4rs.posToColor(pos) 
            : backgroundColor, 
          elevation: 2,
          shadowColor: Cv4rs.themeColor4, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: matchBorder ? Cv4rs.posToBorderColor(pos) : borderColor, 
              width: matchBorder ? Bv4rs.navRowBorderWeight : borderWeight,
              ), 
          ),
        ),
        child: () {
        switch (matchFormat ? Bv4rs.navButtonFormat : format){
          
          //
          //text below
          //

          case 1: 
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //image
                Expanded( child:
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                ),
                ),

                //label
                Text(
                  label, 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle, 
                  textAlign: TextAlign.center, 
                ),
              ]
            );

          //
          //text above
          //

          case 2: 
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //label 
                Text(
                  label, 
                  maxLines: 1,  
                  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle, 
                  overflow: TextOverflow.ellipsis, 
                  textAlign: TextAlign.center, 
                ),

                //image
                Expanded( child:
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: ImageStyle1(
                     image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                ),
                 ),
              ]
            );
          
          //
          //image only
          //

          case 3:
            return SizedBox.expand(
              child: Center( child:
            Padding(
                  padding: EdgeInsets.all(padding),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
            )
              )
                );
         
          //
          //text only
          //
          
          case 4:
            return SizedBox.expand(child: Center( child:
            Text(
                  label, maxLines: 3,  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle, textAlign: TextAlign.center,   overflow: TextOverflow.ellipsis, 
            ),
            ),
            );
          
          //
          //oops
          //

          default:
            return Text(
                  'error (1366572)', style: Sv4rs.settingslabelStyle, 
                );
        } 
  } (),
    ); 
  })
  );
      
  }
}

class StorageButtonStyle extends StatelessWidget {
  final VoidCallback onPressed; 
  final String label;
  final String symbol;
  final TTSInterface tts;

  final String linkToLabel;
  final String linkToUUID;

  final int showOr;
  final bool matchFormat;
  final int format;

  final String pos;
  final bool matchPOS;
  final Color backgroundColor;

  final bool matchBorder;
  final double borderWeight;
  final Color borderColor;

  final bool matchFont;
  final String fontFamily;
  final double fontSize;
  final int fontWeight;
  final bool fontItalics;
  final bool fontUnderline;
  final Color fontColor;

  final double padding;
  final bool matchOverlayColor;
  final Color overlayColor;
  final double symbolSaturation;
  final double symbolContrast;
  final bool invertSymbolColors;
  final bool matchSymbolContrast;
  final bool matchSymbolInvert;
  final bool matchSymbolSaturation;

  final bool matchSpeakOS;
  final int speakOS;
  final String alternateLabel;

  final String note;

  TextStyle get labelStyle =>  
    TextStyle(
      color: fontColor,
      fontSize: fontSize,
      fontFamily: Fontsy.fontToFamily[fontFamily], 
      fontWeight: FontWeight.values[((fontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: fontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: fontUnderline ? TextDecoration.underline : TextDecoration.none,
    );

  const StorageButtonStyle ({
    super.key,
    required this.onPressed,
    this.symbol = 'assets/interface_icons/interface_icons/iPlaceholder.png',
    required this.tts,
    this.label = '',
    this.linkToLabel = '',
    this.linkToUUID = '',
    this.showOr = 1,
    this.matchFormat = true,
    this.format = 1,
    this.pos = 'Extra 1',
    this.matchPOS = true,
    this.backgroundColor = Colors.white,
    this.matchBorder = true,
    this.borderWeight = 0,
    this.borderColor = Colors.black,
    this.matchFont = true,
    this.fontFamily = 'Default',
    this.fontSize = 16,
    this.fontWeight = 400,
    this.fontItalics = false,
    this.fontUnderline = false,
    this.fontColor = Colors.black,
    this.padding = 5,
    this.matchOverlayColor = true,
    this.overlayColor = Colors.red,
    this.symbolSaturation = 1.0,
    this.symbolContrast = 1.0,
    this.invertSymbolColors = false,
    this.matchSpeakOS = true,
    this.speakOS = 1,
    this.alternateLabel = '',
    this.note = '',
    this.matchSymbolContrast = true,
    this.matchSymbolSaturation = true,
    this.matchSymbolInvert = true,
  });

  @override
  Widget build(BuildContext context) {
    
    Widget image = ((symbol).startsWith('/')) ? 
        Image.file(
          File(symbol),
        )
       : Image.asset(
          symbol,
          fit: BoxFit.contain,
        );

    return Visibility (
      visible: V4rs.showOrAsBool(showOr),
      maintainAnimation: true,
      maintainSize: true,
      maintainState: true,
      child:
    ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          backgroundColor: matchPOS ? Cv4rs.posToColor(pos) : backgroundColor, 
          elevation: 2,
          shadowColor: Cv4rs.themeColor4, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: matchBorder ? Cv4rs.posToBorderColor(pos) : borderColor, 
              width: matchBorder ? Bv4rs.navRowBorderWeight : borderWeight,
              ), 
          ),
        ),
        child: () {
        switch (matchFormat ? Bv4rs.centerButtonFormat: format){
          
          //
          //text below
          //

          case 1: 
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //image
                Expanded( child:
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                ),
                ),

                //label
                Text(
                  label, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, 
                  textAlign: TextAlign.center, 
                  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle, 
                ),
              ]
            );

          //
          //text above
          //

          case 2: 
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //label 
                Text(
                  label, maxLines: 1,  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle,  textAlign: TextAlign.center,   overflow: TextOverflow.ellipsis, 
                ),

                //image
                Expanded( child:
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: 
                  ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                 ),
                ),
              ]
            );
          
          //
          //image only
          //

          case 3:
            return Padding(
                  padding: EdgeInsets.all(padding),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                );
         
          //
          //text only
          //
          
          case 4:
            return Text(
                  label, maxLines: 3, style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle,  textAlign: TextAlign.center,   overflow: TextOverflow.ellipsis, 
                );
          
          //
          //oops
          //

          default:
            return Text(
                  'error (1366572)', style: Sv4rs.settingslabelStyle, 
                );
        } 
  } (),
    ),  
      );
  }
}

class SpecialNavButtonStyle extends StatelessWidget {
  final VoidCallback onPressed; 
  final String label;
  final String symbol;
  final TTSInterface tts;

  final String linkToLabel;
  final String linkToUUID;

  final int showOr;
  final bool matchFormat;
  final int format;

  final String pos;
  final bool matchPOS;
  final Color backgroundColor;

  final bool matchBorder;
  final double borderWeight;
  final Color borderColor;

  final bool matchFont;
  final String fontFamily;
  final double fontSize;
  final int fontWeight;
  final bool fontItalics;
  final bool fontUnderline;
  final Color fontColor;

  final double padding;
  final bool matchOverlayColor;
  final Color overlayColor;
  final double symbolSaturation;
  final double symbolContrast;
  final bool invertSymbolColors;
  final bool matchSymbolContrast;
  final bool matchSymbolInvert;
  final bool matchSymbolSaturation;

  final bool matchSpeakOS;
  final int speakOS;
  final String alternateLabel;

  final String note;
  final NavObjects? me;

  TextStyle get labelStyle =>  
    TextStyle(
      color: fontColor,
      fontSize: fontSize,
      fontFamily: Fontsy.fontToFamily[fontFamily], 
      fontWeight: FontWeight.values[((fontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: fontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: fontUnderline ? TextDecoration.underline : TextDecoration.none,
    );

  const SpecialNavButtonStyle ({
    super.key,
    required this.onPressed,
    this.symbol = 'assets/interface_icons/interface_icons/iPlaceholder.png',
    required this.tts,
    required this.me,
    this.label = '',
    this.linkToLabel = '',
    this.linkToUUID = '',
    this.showOr = 1,
    this.matchFormat = true,
    this.format = 1,
    this.pos = 'Extra 1',
    this.matchPOS = true,
    this.backgroundColor = Colors.white,
    this.matchBorder = true,
    this.borderWeight = 0.0,
    this.borderColor = Colors.black,
    this.matchFont = true,
    this.fontFamily = 'Default',
    this.fontSize = 16,
    this.fontWeight = 400,
    this.fontItalics = false,
    this.fontUnderline = false,
    this.fontColor = Colors.black,
    this.padding = 5,
    this.matchOverlayColor = true,
    this.overlayColor = Colors.red,
    this.symbolSaturation = 1.0,
    this.symbolContrast = 1.0,
    this.invertSymbolColors = false,
    this.matchSpeakOS = true,
    this.speakOS = 1,
    this.alternateLabel = '',
    this.note = '',
    this.matchSymbolContrast = true,
    this.matchSymbolSaturation = true,
    this.matchSymbolInvert = true,
  });

  @override
  Widget build(BuildContext context) {
    
    Widget image = ((symbol).startsWith('/')) ? 
        Image.file(
          File(symbol),
        )
       : Image.asset(
          symbol,
          fit: BoxFit.contain,
        );

    return Visibility (
      visible: (Bv4rs.showNavRow == 2) ? false : V4rs.showOrAsBool(showOr),
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child:
    ElevatedButton(
        onPressed:  () {
        switch (matchSpeakOS ? Bv4rs.navRowSpeakOnSelect : speakOS) {
          case 1:
            //add navigation link to
            FocusScope.of(context).unfocus();
            if (me != null){
              V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, me!.linkToUUID ?? '');
            }
            break;
          case 2:
            //add navigation link to
            FocusScope.of(context).unfocus();
            if (me != null){
              V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, me!.linkToUUID ?? '');
            }
            V4rs.speakOnSelect(label, V4rs.selectedLanguage.value, tts);
            break;
          case 3:
            //add navigation link to
            FocusScope.of(context).unfocus();
            if (me != null){
              V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, me!.linkToUUID ?? '');
            }
            V4rs.speakOnSelect(alternateLabel, V4rs.selectedLanguage.value, tts);
            break;
          }},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          backgroundColor: (V4rs.isSearchPathNav(V4rs.searchPathUUIDS.value, me)) 
            ? Cv4rs.posToBorderColor(pos)
            : matchPOS 
              ? Cv4rs.posToColor(pos) 
              : backgroundColor, 
          elevation: 2,
          shadowColor: Cv4rs.themeColor4, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: matchBorder ? Cv4rs.posToBorderColor(pos) : borderColor, 
              width: matchBorder ? Bv4rs.navRowBorderWeight : borderWeight,
              ), 
          ),
        ),
        child: () {
        switch (matchFormat ? Bv4rs.centerButtonFormat : format){
          
          //
          //text below
          //

          case 1: 
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //image
                Expanded(child: 
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                  ),
                ),

                //label
                Text(
                  label, maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle,  textAlign: TextAlign.center, 
                ),
              ]
            );

          //
          //text above
          //

          case 2: 
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //label 
                Text(
                  label, maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle, textAlign: TextAlign.center, 
                ),

                //image
                Expanded( child:
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                ),
                ),
              ]
            );
          
          //
          //image only
          //

          case 3:
            return Padding(
                  padding: EdgeInsets.all(padding),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                );
         
          //
          //text only
          //
          
          case 4:
            return Text(
                  label, maxLines: 3, style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle,  
                  textAlign: TextAlign.center, 
                  overflow: TextOverflow.ellipsis, 
                );
          
          //
          //oops
          //

          default:
            return Text(
                  'error (1366572)', style: Sv4rs.settingslabelStyle, 
                );
        } 
  } (),
    ),  
      );
  }
}



//gramer row buttons

class BuildGrammerButton extends StatelessWidget{

    final GrammerObjects obj;
    final TTSInterface synth;

    const BuildGrammerButton({super.key, required this.obj, required this.synth});

     @override
    Widget build(BuildContext context) {

    //font settings
        TextStyle uniqueStyle =  
        TextStyle(
          color: obj.fontColor ?? Colors.black,
          fontSize: obj.fontSize ?? 16,
          fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
          fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
          decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
        );

        TextStyle matchStyle =  
        TextStyle(
          color: Fv4rs.grammerFontColor,
          fontSize: Fv4rs.grammerFontSize,
          fontFamily: Fontsy.fontToFamily[Fv4rs.grammerFont], 
          fontWeight: FontWeight.values[((Fv4rs.grammerFontWeight ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: Fv4rs.grammerFontItalics ? FontStyle.italic : FontStyle.normal,
          decoration: Fv4rs.grammerFontUnderline ? TextDecoration.underline : TextDecoration.none,
        );

      //label
        Widget theLabel = 
        Text(obj.label ?? "", 
          textAlign: TextAlign.center,
          style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          );
        Text theLabel2 = 
        Text(obj.label ?? "", 
          textAlign: TextAlign.center,
          style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          );
      
      //image
        Widget image = LoadImage.fromSymbol(obj.symbol);

      //symbol
        Widget theSymbol = 
          ImageStyle1(
            image: image, 
            symbolSaturation: obj.symbolSaturation ?? 1.0, 
            symbolContrast: obj.symbolContrast ?? 1.0, 
            invertSymbolColors: obj.invertSymbol ?? false, 
            matchOverlayColor: obj.matchOverlayColor ?? true, 
            overlayColor: obj.overlayColor ?? Colors.white,
            defaultSymbolColorOverlay: Bv4rs.grammerRowSymbolColorOverlay, 
            matchSymbolContrast: obj.matchSymbolContrast ?? true, 
            matchSymbolInvert: obj.matchInvertSymbol ?? true, 
            matchSymbolSaturation: obj.matchSymbolSaturation ?? true, 
            defaultSymbolInvert: Bv4rs.grammerRowSymbolInvert, 
            defaultSymbolContrast: Bv4rs.grammerRowSymbolContrast, 
            defaultSymbolSaturation: Bv4rs.grammerRowSymbolSaturation
            );
      //
      //button
      //
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            elevation: 0,
            backgroundColor: obj.backgroundColor ?? Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, 
            )
          ),
        onPressed: () async {
          switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
          case 1:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            V4rs.changedMWfromButton = false;
            break;
          case 2:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
            V4rs.changedMWfromButton = false;
            break;
          case 3:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            await V4rs.speakOnSelect(Gv4rs.lastWord, V4rs.selectedLanguage.value, synth);
            V4rs.changedMWfromButton = false;
            break;
          }
        },
        child: () {
          switch((obj.matchFormat ?? true) ? Bv4rs.grammerRowFormat : obj.format) {
            case 1: 
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                (obj.symbol != null) ?
                Flexible(flex: 4, child: 
                Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0), 
                child:
                theSymbol,
                ),
                ) : SizedBox.shrink(),
                Expanded(flex: 7,
                  child: 
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                theLabel,
                ),
                ),
              ],
            );
            case 2: 
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Expanded(flex: 7, child: 
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                theLabel,
                ),
                ),
                (obj.symbol != null) ?
                Flexible(flex: 4, child: 
                Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0), 
                child:
                  theSymbol,
                ),
                ) : SizedBox.shrink(),
            ],
            );
            case 3: 
              return (obj.symbol != null) ? Padding(
                padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                theSymbol,
              ) : SizedBox.shrink();
            case 4:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Expanded(child: 
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
              theLabel2
              )
                )
              ]
              );
          }
        } (),
        );
    }
  }

class BuildGrammerFolder extends StatelessWidget{

    final GrammerObjects obj;
    final TTSInterface synth;

    final void Function(BoardObjects board) openBoard;
    final List<BoardObjects> boards;
    final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;

    const BuildGrammerFolder({
      super.key, 
      required this.obj, 
      required this.synth,
      required this.openBoard, 
      required this.boards,
      required this.findBoardById
    });

     @override
    Widget build(BuildContext context) {

    //font settings
        TextStyle uniqueStyle =  
        TextStyle(
          color: obj.fontColor ?? Colors.black,
          fontSize: obj.fontSize ?? 16,
          fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
          fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
          decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
        );

        TextStyle matchStyle =  
        TextStyle(
          color: Fv4rs.grammerFontColor,
          fontSize: Fv4rs.grammerFontSize,
          fontFamily: Fontsy.fontToFamily[Fv4rs.grammerFont], 
          fontWeight: FontWeight.values[((Fv4rs.grammerFontWeight ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: Fv4rs.grammerFontItalics ? FontStyle.italic : FontStyle.normal,
          decoration: Fv4rs.grammerFontUnderline ? TextDecoration.underline : TextDecoration.none,
        );

      //label
        Text theLabel = 
        Text(obj.label ?? "", 
          style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          );
        Text theLabel2 = 
        Text(obj.label ?? "", 
          style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          );
      
      //image
        Widget image = LoadImage.fromSymbol(obj.symbol);

      //symbol
        Widget theSymbol = 
          ImageStyle1(
            image: image, 
            symbolSaturation: obj.symbolSaturation ?? 1.0, 
            symbolContrast: obj.symbolContrast ?? 1.0, 
            invertSymbolColors: obj.invertSymbol ?? false, 
            matchOverlayColor: obj.matchOverlayColor ?? true, 
            overlayColor: obj.overlayColor ?? Colors.white,
            defaultSymbolColorOverlay: Bv4rs.grammerRowSymbolColorOverlay, 
            matchSymbolContrast: obj.matchSymbolContrast ?? true, 
            matchSymbolInvert: obj.matchInvertSymbol ?? true, 
            matchSymbolSaturation: obj.matchSymbolSaturation ?? true, 
            defaultSymbolInvert: Bv4rs.grammerRowSymbolInvert, 
            defaultSymbolContrast: Bv4rs.grammerRowSymbolContrast, 
            defaultSymbolSaturation: Bv4rs.grammerRowSymbolSaturation
            );
      //
      //button
      //
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            elevation: 0,
            backgroundColor: obj.backgroundColor ?? Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, 
            )
          ),
        onPressed: () async {
          switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
          case 1:
             final board = findBoardById((obj.openUUID ?? ''), boards);
              if (board != null) {
                openBoard(board);
              }
            break;
          case 2:
             final board = findBoardById(obj.openUUID ?? '', boards);
              if (board != null) {
                openBoard(board);
              }
            await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
            break;
          case 3:
             final board = findBoardById(obj.openUUID ?? '', boards);
              if (board != null) {
                openBoard(board);
              }
            if (Bv4rs.folderSpeakOnSelect != 1) {
            await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
            }
            break;
          }
        },
        child: () {
          switch((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
            case 1: 
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                (obj.symbol != null) ?
                Flexible(flex: 4, child: 
                Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0), 
                child:
                theSymbol,
                ),
                ) : SizedBox.shrink(),
                Expanded(flex: 7, child: 
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                theLabel,
                ),
                ),
              ],
            );
            case 2: 
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Expanded(flex: 7, child: 
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                theLabel,
                ),),
                (obj.symbol != null) ?
                Flexible(flex: 4, child: 
                Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0), 
                child:
                  theSymbol,
                ),
                ) : SizedBox.shrink(),
            ],
            );
            case 3: 
              return (obj.symbol != null) ? Padding(
                padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                theSymbol,
              ) : SizedBox.shrink();
            case 4:
              return Column( children: [
                Expanded(child: 
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0), child:
              theLabel2
              )
                )
              ]
              );
          }
        } (),
        );
    }
  }

class BuildGrammerPlacholder extends StatelessWidget{

    final GrammerObjects obj;
    final TTSInterface synth;

    const BuildGrammerPlacholder({super.key, required this.obj, required this.synth});

    @override
    Widget build(BuildContext context) {

      //
      //button
      //
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            elevation: 0,
            backgroundColor: obj.backgroundColor ?? Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, 
            )
          ),
        onPressed: () async {
          switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
          case 1:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            V4rs.changedMWfromButton = false;
            break;
          case 2:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
            V4rs.changedMWfromButton = false;
            break;
          case 3:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            await V4rs.speakOnSelect(Gv4rs.lastWord, V4rs.selectedLanguage.value, synth);
            V4rs.changedMWfromButton = false;
            break;
          }
        },
        child: () {
          return Row(children: [
            Spacer(),
          ]
          );
          
           } (),
        );
    }
  }

//speak on select shortcut 
Future<void> showOptionsPopupForSpeakOnSelect(BuildContext context, {
  required List<String> optionLabels,
  required List<bool> optionValues,
  required void Function(List<bool> updatedValues) onDone,
}) async {
  // Local mutable copy so the checkboxes can toggle
  List<bool> tempValues = List.from(optionValues);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true, // expands if need
    backgroundColor: Cv4rs.themeColor4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Speak on Select Options",
                  style: Sv4rs.settingslabelStyle,
                ),
                const SizedBox(height: 12),

                // Checkbox list
                ...List.generate(optionLabels.length, (i) {
                  return CheckboxListTile(
                    title: Text(optionLabels[i], style: Sv4rs.settingslabelStyle,),
                    value: tempValues[i],
                    onChanged: (val) {
                      setState(() {
                        tempValues[i] = val ?? false;
                      });
                    },
                  );
                }),

                const SizedBox(height: 16),

                // Done button
                Row(children: [
                Expanded(child: 
                ElevatedButton(
                   style: ElevatedButton.styleFrom(
                      backgroundColor: Cv4rs.themeColor3,
                      elevation: 2, 
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(10), 
                      ),
                      shadowColor: Cv4rs.themeColor4,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), 
                    ),
                  onPressed: () {
                    Navigator.pop(context);
                    onDone(tempValues); 
                  },
                  child: Text("Done", style: Sv4rs.settingslabelStyle,),
                ),
                ),
                ]),
              ],
            ),
          );
        },
      );
    },
  );
}

//print pop up
Future<void> showPrintPop(
  BuildContext context,
  Future<List<Uint8List?>> Function() captureAllForPrint,
) async { 
  await showDialog(
  context: context,
  builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SimpleDialog(
    title: Text("Print Options"),
    children: [
      Row(
        children: [
          Text('Include Message Row:'),
          Spacer(),
          DropdownButton<int>(
            value: ExV4rs.includeMessageRow,
            items: [
              DropdownMenuItem(value: 1, child: Text("Message Row")),
              DropdownMenuItem(value: 2, child: Text("Spacer")),
              DropdownMenuItem(value: 3, child: Text("None")),
            ],
            onChanged: (value) {
              setState(() {
                if (value!= null){
                  ExV4rs.includeMessageRow = value;
                }
              });
            },
          ),
        ]
      ),
      Row(
        children: [
          Text('Include Navigation Row:'),
          Spacer(),
          DropdownButton<int>(
            value: ExV4rs.includeNavRow,
            items: [
              DropdownMenuItem(value: 1, child: Text("Navigation Row")),
              DropdownMenuItem(value: 2, child: Text("Spacer")),
              DropdownMenuItem(value: 3, child: Text("None")),
            ],
            onChanged: (value) {
              setState(() {
                if (value!= null){
                  ExV4rs.includeNavRow = value;
                }
              });
            },
          ),
        ]
      ),
      Row(
        children: [
          Text('Include Grammar Row:'),
          Spacer(),
          DropdownButton<int>(
            value: ExV4rs.includeGrammerRow,
            items: [
              DropdownMenuItem(value: 1, child: Text("Grammar Row")),
              DropdownMenuItem(value: 2, child: Text("Spacer")),
              DropdownMenuItem(value: 3, child: Text("None")),
            ],
            onChanged: (value) {
              setState(() {
                if (value!= null){
                  ExV4rs.includeGrammerRow = value;
                }
              });
            },
          ),
        ]
      ),
      Row(
        children: [
          Text('Include Indicator Row:'),
          Spacer(),
          Switch(
            value: ExV4rs.includeIndicatorRow, 
            onChanged: (value) {
              setState(() {
                ExV4rs.includeIndicatorRow = value;
              });
            }
          ),
        ]
      ),
      if (ExV4rs.includeIndicatorRow)
       Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
        child: Row(
          children: [
            Text('1st Indicator Message:'),
            Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 20, 0), 
              child: TextField(
                onChanged: (value) {
                  ExV4rs.indicator1 = value;
                  ExV4rs.saveIndicator1(value);
                },
                decoration: InputDecoration(
                  hintText: ExV4rs.indicator1,
                ),
              ),
            ),
            ),
          ],
        ),
      ),
      if (ExV4rs.includeIndicatorRow)
      Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
        child: Row(
          children: [
            Text('2nd Indicator Message:'),
            Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 20, 0), 
              child: TextField(
                onChanged: (value) {
                  ExV4rs.indicator2 = value;
                  ExV4rs.saveIndicator2(value);
                },
                decoration: InputDecoration(
                  hintText: ExV4rs.indicator2,
                ),
              ),
            ),
            ),
          ],
        ),
      ),
      if (ExV4rs.includeIndicatorRow)
      Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
        child: Row(
          children: [
            Text('3rd Indicator Message:'),
            Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 20, 0), 
              child: TextField(
                onChanged: (value) {
                  ExV4rs.indicator3 = value;
                  ExV4rs.saveIndicator3(value);
                },
                decoration: InputDecoration(
                  hintText: ExV4rs.indicator3,
                ),
              ),
              ),
            ),
          ],
        ),
      ),
      // Done button
      Row(children: [
      Expanded(child: 
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Cv4rs.themeColor3,
            elevation: 2, 
            shape: RoundedRectangleBorder( 
              borderRadius: BorderRadius.circular(10), 
            ),
            shadowColor: Cv4rs.themeColor4,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), 
          ),
        onPressed: () async { if (ExV4rs.loadingPrint.value){} else {
            final pages =
                await captureAllForPrint();

            if (pages.isEmpty) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to generate print image")),
              );
              return;
            }

            // Show print dialog
            await Printing.layoutPdf(
              onLayout: (PdfPageFormat format) async {
                final doc = pw.Document();

                for (final pageBytes in pages){
                  if (pageBytes != null) {
                final image = pw.MemoryImage(pageBytes);

                doc.addPage(
                  pw.Page(
                    pageFormat: format,
                    build: (pw.Context ctx) {
                      return pw.Center(
                        child: pw.FittedBox(
                          fit: pw.BoxFit.contain,
                          child: pw.Image(image),
                        ),
                      );
                    },
                  ),
                );
                }
                }
                return doc.save();
              },
            );
            if (!context.mounted) return;
            Navigator.of(context).pop();
          }
          },
        child: Row(children: [
          Text("Done", style: Sv4rs.settingslabelStyle,),
          LoadingIndicator(notifier: ExV4rs.loadingPrint),
        ]),
      ),
      ),
      ]),
    ],
  );
        });}
);
}


class CombinedValueNotifier<A, B, C, D, E, F, G, H, I> extends ValueNotifier<(A, B, C, D, E, F, G, H?, I?)> {
  CombinedValueNotifier(ValueNotifier<A> a, ValueNotifier<B> b, ValueNotifier<C> c, ValueNotifier<D> d, 
    ValueNotifier<E> e, ValueNotifier<F> f, ValueNotifier<G> g, ValueNotifier<H>? h, ValueNotifier<I>? i,)
      : super((a.value, b.value, c.value, d.value, e.value, f.value, g.value, h?.value, i?.value)) {
    a.addListener(() => value = (a.value, b.value, c.value, d.value, e.value, f.value, g.value, h?.value, i?.value));
    b.addListener(() => value = (a.value, b.value, c.value, d.value, e.value, f.value, g.value, h?.value, i?.value));
    c.addListener(() => value = (a.value, b.value, c.value, d.value, e.value, f.value, g.value, h?.value, i?.value));
    d.addListener(() => value = (a.value, b.value, c.value, d.value, e.value, f.value, g.value, h?.value, i?.value));
    e.addListener(() => value = (a.value, b.value, c.value, d.value, e.value, f.value, g.value, h?.value, i?.value));
    f.addListener(() => value = (a.value, b.value, c.value, d.value, e.value, f.value, g.value, h?.value, i?.value));
    g.addListener(() => value = (a.value, b.value, c.value, d.value, e.value, f.value, g.value, h?.value, i?.value));
    if (h != null){
    h.addListener(() => value = (a.value, b.value, c.value, d.value, e.value, f.value, g.value, h.value, i?.value));
    }
    if (i != null){
    i.addListener(() => value = (a.value, b.value, c.value, d.value, e.value, f.value, g.value, h?.value, i.value));
    }
  }
}

class MiniCombinedValueNotifier<E, F, G, H, I> extends ValueNotifier<(E, F, G?, H?, I?)> {
  MiniCombinedValueNotifier(ValueNotifier<E> e, ValueNotifier<F> f, ValueNotifier<G>? g, ValueNotifier<H>? h, ValueNotifier<I>? i,)
      : super((e.value, f.value, g?.value, h?.value, i?.value)) {
    e.addListener(() => value = (e.value, f.value, g?.value, h?.value, i?.value));
    f.addListener(() => value = (e.value, f.value, g?.value, h?.value, i?.value));
    if (g != null){
    g.addListener(() => value = (e.value, f.value, g.value, h?.value, i?.value));
    }
    if (h != null){
    h.addListener(() => value = (e.value, f.value, g?.value, h.value, i?.value));
    }
    if (i != null){
    i.addListener(() => value = (e.value, f.value, g?.value, h?.value, i.value));
    }
  }
}



//bottom of file