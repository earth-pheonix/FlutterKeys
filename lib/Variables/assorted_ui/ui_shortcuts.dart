import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/fonts/font_variables.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;


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
    required this.imagePath, //when i call this buttton I will tell it the image path to use 
    required this.onPressed, //I will also tell it what to do when pressed
  });

  //defines the button 
  @override
  Widget build(BuildContext context) {
    
    //the image that will be on the button
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
        child: ColorFiltered( //the image on the button, I have it wraped in a color filter, thats optional
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