import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutterkeysaac/Models/json_model_grammer.dart';
import 'package:flutterkeysaac/Variables/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:flutterkeysaac/Variables/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Variables/Settings_variable.dart';
import 'package:flutterkeysaac/Variables/Grammer_variables.dart';
import 'package:flutterkeysaac/Variables/color_variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
  
  
  //===: grammer button editor
   class GrammerEditor extends StatefulWidget{
      final void Function(Root root, String objUUID, String field, dynamic value) saveField;
      final Root root;
      final GrammerObjects obj;
      const GrammerEditor({
        super.key,
        required this.saveField,
        required this.root,
        required this.obj,
      });

      @override
      State<GrammerEditor> createState() => _GrammerEditorState();
    }

    class _GrammerEditorState extends State<GrammerEditor>{
      final ImagePicker _picker = ImagePicker();
      var everyImage = <String>[];

      @override
      Widget build(BuildContext context) {
        Root root = widget.root;
        final screenSize = MediaQuery.of(context).size;
        final isLandscape = screenSize.width > screenSize.height;

        everyImage = Ev4rs.getAllImages(root);
          

            final obj_ = Ev4rs.findGrammerById(root.grammerRow, Ev4rs.grammerSelectedUUID);
            if (obj_ == null) {
              return const Center(child: Text("Object not found"));
            }

            Ev4rs.setGrammerPlacholderValues(obj_);
            
            var allBoards = Ev4rs.getBoards(root.boards);

            final mapOfBoards = {
              for (var board in allBoards) 
                if (board.title != null) 
                  board.title!: board.id,
            };

            Widget image = LoadImage.fromSymbol(obj_.symbol);


        return Stack( children: [
              
            
            Row( 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              //
              //back, in positioned is the tap expander
              //
              Padding(padding: EdgeInsetsGeometry.all(7),
              child: SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.065 : MediaQuery.of(context).size.height * 0.03 ,
                child: ButtonStyle1(
                  imagePath: 'assets/interface_icons/interface_icons/iBack.png', 
                  onPressed: () {
                  setState(() {
                    Ev4rs.closeEditorAction();
                  });
                  }
                ),
              ),
              ),

              //
              //Image, image padding, image overlay settings
              //
              ValueListenableBuilder(
                valueListenable: CombinedValueNotifier(
                    Ev4rs.padding, Ev4rs.overlay, Ev4rs.contrast, 
                    Ev4rs.invert, Ev4rs.saturation, Ev4rs.matchContrast, 
                    Ev4rs.matchInvert, Ev4rs.matchOverlay, Ev4rs.matchSaturation
                  ), 
                builder: (context, values, _) {
              return Expanded(flex: 8, child: 
                Column( children:[
                  //
                  //image
                  //
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                          Container(
                            width: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                              color: Cv4rs.themeColor4,
                              borderRadius: BorderRadius.circular(10)
                              ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(child: Padding(padding: EdgeInsetsGeometry.all(Ev4rs.padding.value), 
                                  child: ImageStyle1(
                                      image: image, 
                                      symbolSaturation: Ev4rs.saturation.value, 
                                      symbolContrast: Ev4rs.contrast.value, 
                                      invertSymbolColors: Ev4rs.invert.value, 
                                      overlayColor: Ev4rs.overlay.value, 
                                      matchOverlayColor: Ev4rs.matchOverlay.value, 
                                      matchSymbolContrast: Ev4rs.matchContrast.value, 
                                      matchSymbolInvert: Ev4rs.matchInvert.value, 
                                      matchSymbolSaturation: Ev4rs.matchSaturation.value,
                                      defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
                                      defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
                                      defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
                                      defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
                                      )
                                  ),
                                ),
                                Flexible(child: 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                        SizedBox( 
                                          width: MediaQuery.of(context).size.height * 0.08,
                                          child: ButtonStyle3(
                                            imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                            onPressed: () async {
                                              Ev4rs.grammerPickImage(widget.saveField, root, _picker);
                                              if (everyImage.isNotEmpty) {
                                             // await Ev4rs.cleanupUnusedImages(everyImage);
                                              } 
                                            }, 
                                            label: 'Photo Lib'
                                          ),
                                        ),
                                      ),
                                  Visibility(
                                    visible: false,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                    SizedBox( 
                                      width: MediaQuery.of(context).size.height * 0.07,
                                      child: ButtonStyle3(
                                      imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                      onPressed: () async {
                                        Ev4rs.grammerPickImage(widget.saveField, root, _picker);
                                          if (everyImage.isNotEmpty) {
                                          //  await Ev4rs.cleanupUnusedImages(everyImage);
                                          } 
                                      }, 
                                      label: 'App Lib'
                                      )
                                    ),
                                  ),
                                  ),
                              ]
                              )
                              ),
                            ]),
                          ),
                  ),

                  //
                  //padding
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox( 
                    width: MediaQuery.of(context).size.height * 0.25,
                    child: 
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(10), child: 
                        Column(children: [
                        Text('Image Padding: ${Ev4rs.padding.value}', style: Sv4rs.settingslabelStyle,),
                        Slider(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              value: Ev4rs.padding.value,
                              min: 0.0,
                              max: 10.0,
                              divisions: 11,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Image Padding: ${Ev4rs.padding.value}',
                              onChanged: (value) {
                                Ev4rs.padding.value = value.roundToDouble();
                              }
                          ),
                        ])
                        ),
                        ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'padding', Ev4rs.padding.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save Padding'
                          ),
                        ]),
                    ),
                  ),
                  ),

                  //
                  //symbolColors
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox(
                    child:
                  SymbolColorCustomizer2(
                    widgety: 
                    ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'matchOverlayColor', Ev4rs.matchOverlay.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'overlayColor', Ev4rs.overlay.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'matchSymbolSaturation', Ev4rs.matchSaturation.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'symbolSaturation', Ev4rs.saturation.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'matchSymbolContrast', Ev4rs.matchContrast.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'symbolContrast', Ev4rs.contrast.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'matchInvertSymbol', Ev4rs.matchInvert.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'invertSymbol', Ev4rs.invert.value);
                              
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save Adjustments'
                          ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    additionalHeight: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.height * 0.25,
                    invert: Ev4rs.invert.value, 
                    overlay: Ev4rs.overlay.value,
                    saturation: Ev4rs.saturation.value, 
                    contrast: Ev4rs.contrast.value, 
                    matchContrast: Ev4rs.matchContrast.value,
                    matchInvert: Ev4rs.matchInvert.value,
                    matchOverlay: Ev4rs.matchOverlay.value,
                    matchSaturation: Ev4rs.matchSaturation.value,
                    onContrastChanged: (value){
                      Ev4rs.contrast.value = value;
                    }, 
                    onInvertChanged: (value){
                      Ev4rs.invert.value = value;
                    },
                    onOverlayChanged: (value){
                      Ev4rs.overlay.value = value;
                    },
                    onSaturationChanged: (value){
                      Ev4rs.saturation.value = value;
                    },
                    onMatchContrastChanged: (value){
                      Ev4rs.matchContrast.value = value;
                    }, 
                    onMatchInvertChanged: (value){
                      Ev4rs.matchInvert.value = value;
                    },
                    onMatchOverlayChanged: (value){
                      Ev4rs.matchOverlay.value = value;
                    },
                    onMatchSaturationChanged: (value){
                      Ev4rs.matchSaturation.value = value;
                    },
                    )
                  )
                  ),
                  

                ]
                ),
              );
              }
            ),
              
              //
              //label, speak on select, font
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //label
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                              ValueListenableBuilder(valueListenable: Ev4rs.notes, builder: (context, value, _) {
                          final labelController = TextEditingController(text: value)
                          ..selection = TextSelection.collapsed(offset: value.length);

                          return 
                        TextField(
                          controller: labelController,
                                style: Ev4rs.labelStyle,
                                onChanged: (value){
                                  Ev4rs.label.value = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Ev4rs.hintLabelStyle,
                                hintText: '${obj_.label}',
                                ),
                              );
                              }),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'label', Ev4rs.label.value);
                              Ev4rs.saveJson(root);
                              });
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                    ]
                    ))),
                  //match speak on select, speak on select
                  Padding(padding: EdgeInsetsGeometry.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchSpeakOnSelect, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(child: 
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(10, 10, 10, 0), 
                                child: Text(
                                  'Match Speak on Select:', 
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchSpeakOnSelect.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchSpeakOnSelect.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.speakOnSelect, 
                          builder: (context, speakOnSelect, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.all(10), 
                              child: Column(children: [
                                Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 1.0,
                                  max: 3.0,
                                  divisions: 2,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 'Speak on Select: ${Ev4rs.speakOnSelect.value}',
                                  value: Ev4rs.speakOnSelect.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.speakOnSelect.value = value.toInt();
                                    }
                                  ),
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10), 
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                    Expanded(child: 
                                      Text(
                                        "Off", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Label", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Change", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ]
                                  ), 
                                ),
                                ButtonStyle2(
                                  imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                                  onPressed: (){setState(() {
                                      widget.saveField(root, Ev4rs.grammerSelectedUUID, 'matchSpeakOS', Ev4rs.matchSpeakOnSelect.value);
                                      widget.saveField(root, Ev4rs.grammerSelectedUUID, 'speakOS', Ev4rs.speakOnSelect.value);
                                      Ev4rs.saveJson(root);
                                      });
                                  }, 
                                  label: 'Save'
                                ),
                              ]
                            ),
                            );
                          }
                        ),
                        
                      ]
                    )
                    )
                  ),
                  //font, match font settings, font picker
                  Padding(
                      padding: EdgeInsetsGeometry.all(10), 
                      child: FontPicker2(
                        widgety:  ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){setState(() {
                                widget.saveField(root, Ev4rs.grammerSelectedUUID, 'matchFont', Ev4rs.matchFont.value);
                                widget.saveField(root, Ev4rs.grammerSelectedUUID, 'fontSize', Ev4rs.fontSize.value);
                                widget.saveField(root, Ev4rs.grammerSelectedUUID, 'fontItalics', Ev4rs.fontItalics.value);
                                widget.saveField(root, Ev4rs.grammerSelectedUUID, 'fontUnderline', Ev4rs.fontUnderline.value);
                                widget.saveField(root, Ev4rs.grammerSelectedUUID, 'fontWeight', Ev4rs.fontWeight.value);
                                widget.saveField(root, Ev4rs.grammerSelectedUUID, 'fontFamily', Ev4rs.fontFamily.value);
                                widget.saveField(root, Ev4rs.grammerSelectedUUID, 'fontColor', Ev4rs.fontColor.value);
                                Ev4rs.saveJson(root);
                                });
                            }, 
                            label: 'Save Button Font'
                            ),
                            matchFontSet: Ev4rs.matchFont.value,
                            height: MediaQuery.of(context).size.height * 0.3,
                            size: Ev4rs.fontSize.value, 
                            sizeMax: 25,
                            sizeMin: 5,
                            divisions: 20,
                            weight: (Ev4rs.fontWeight.value).toInt(), 
                            italics: Ev4rs.fontItalics.value, 
                            font: Ev4rs.fontFamily.value, 
                            label: 'Button Font:', 
                            color: Ev4rs.fontColor.value, 
                            underline: Ev4rs.fontUnderline.value,
                            onSizeChanged: (value) {
                              Ev4rs.fontSize.value = value;
                              }, 
                            onWeightChanged: (value) {
                              Ev4rs.fontWeight.value = value.toDouble();
                              },
                            onItalicsChanged: (value) {
                              Ev4rs.fontItalics.value = value;
                              },
                            onFontChanged: (value) {
                              Ev4rs.fontFamily.value = value;
                              },
                            onColorChanged: (value) {
                              Ev4rs.fontColor.value = value.toColor() ?? Cv4rs.themeColor1;
                              },
                            onMatchFont: (value) {
                              Ev4rs.matchFont.value = value;
                              },
                            useUnderline: true, 
                            onUnderlineChanged: (value) {
                              Ev4rs.fontUnderline.value = value;
                              }, 
                            )
                          ),
                ]
              ),
              ),
              
              //
              //, format, border
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  
                  //
                  //format
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container(
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchFormat, 
                          builder: (context, matchFormat, _) {
                            return Row(children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 0), 
                                    child: Text(
                                      'Match Format:', 
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchFormat.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchFormat.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.format, 
                          builder: (context, format, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(5, 15, 5, 10), 
                              child: Column(children: [
                                      Text(
                                        "Format: ${
                                          Ev4rs.format.value == 1 ? 
                                            'Text Right' 
                                          : Ev4rs.format.value == 2 ? 
                                            'Text Left' 
                                          : Ev4rs.format.value == 3 ? 
                                            'Image Only' 
                                          : Ev4rs.format.value == 4 ? 
                                            'Text Only' 
                                          : ''
                                          }", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                Slider(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  min: 1.0,
                                  max: 4.0,
                                  divisions: 3,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  value: Ev4rs.format.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.format.value = value.toInt();
                                    }
                                  ),
                                ]
                            ),
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'matchFormat', Ev4rs.matchFormat.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'format', Ev4rs.format.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  //background
                  
                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [

                        //match border 
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchBackground, 
                          builder: (context, matchBackground, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 10), 
                                    child: Text(
                                      'Match Color:', 
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchBackground.value,
                                  onChanged: (value) {
                                    Ev4rs.matchBackground.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),

                        //border color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.backgroundColor, 
                          builder: (context, backgroundColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                Text('Button Color:', style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.backgroundColor.value, size: 40, shadows: [
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
                                startValue: Ev4rs.backgroundColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.backgroundColor.value = color;
                                },
                              ),
                            ),
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
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.backgroundColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.backgroundColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'matchPOS', Ev4rs.matchBackground.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'backgroundColor', Ev4rs.backgroundColor.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                ]
                ),
              ),
              
              //
              // button type -> type, func, link, notes
              //
              Expanded(flex: 7, child: 
                Column( children:[
                 
                 //type 
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.grammerType, 
                          builder: (context, buttonType, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                'Type:', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                            DropdownButton<String>(
                              isExpanded: true,
                                hint: Text(
                                  'type', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.grammerType.value,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: 'button',
                                    child: Text(
                                      'button', 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'placeholder',
                                    child: Text(
                                      'placeholder', 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'folder',
                                    child: Text(
                                      'folder', 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  ),
                                  ],
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.grammerType.value = value;
                                  }
                                },
                              ),
                            ),
                  
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'type', Ev4rs.grammerType.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                  
                  ),
                  ),
                 
                 //function
                 if (Ev4rs.grammerType.value == 'button' || Ev4rs.grammerType.value == 'placeholder')
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.grammerFunction, 
                          builder: (context, grammerFunction, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                'Grammer Function:', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                            DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                  'grammer function', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.grammerFunction.value,
                                items: Gv4rs.grammerFunctionMap.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.grammerFunction.value = value;
                                  }
                                },
                              ),
                          ),
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'function', Ev4rs.grammerFunction.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                
                  ),
                  ),
                  

                 //link
                 if (Ev4rs.grammerType.value == 'folder')
                 Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.link, 
                          builder: (context, link, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                'Link To...', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                            DropdownButton<String>(
                              isExpanded: true,
                                hint: Text(
                                  'link to...', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.link.value,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: Text('none', style: Sv4rs.settingslabelStyle),
                                  ),
                                ...mapOfBoards.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                })
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.link.value = value;
                                  }
                                },
                              ),
                            ),
                            //save 
                            ButtonStyle2(
                              imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                              onPressed: (){setState(() {
                                  widget.saveField(root, Ev4rs.grammerSelectedUUID, 'openUUID', Ev4rs.link.value);
                                  Ev4rs.saveJson(root);
                                  });
                              }, 
                              label: 'Save'
                            ),
                          ]);
                        }),
                      ),
                    ),

                  //notes
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10), child: 
                              ValueListenableBuilder(valueListenable: Ev4rs.notes, builder: (context, value, _) {
                          final notesController = TextEditingController(text: value)
                          ..selection = TextSelection.collapsed(offset: value.length);

                          return 
                        TextField(
                          controller: notesController,
                                minLines: 1,
                                maxLines: 5,
                                style: Sv4rs.settingslabelStyle,
                                onChanged: (value){
                                  Ev4rs.notes.value = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Sv4rs.settingslabelStyle,
                                hintText: 'Notes... ${Ev4rs.notes.value}',
                                ),
                              );
                              }),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUID, 'note', Ev4rs.notes.value);
                                Ev4rs.saveJson(root);
                                });
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                    ]
                      
                    ))),

                ]
                ),
              ),
              
              //
              //undo + share
              //
              Expanded(flex: 2, child: 
                Column( children:[
                  //undo
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                child:ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.isUndoing, 
                    builder: (context, inverting, _) {
                return 
                  ButtonStyle1(
                    glow: (Ev4rs.isUndoing.value) ? true : false,
                    imagePath: 'assets/interface_icons/interface_icons/iUndo.png', 
                    onPressed: () { setState(() {
                      Ev4rs.undoAction(root);
                    });
                    }
                  );
                    }),
                  ),
                  ),

                  //share
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                child:
                
                  ButtonStyle1(
                    imagePath: 'assets/interface_icons/interface_icons/iExport.png', 
                    onPressed: () { setState(() {
                      Ev4rs.isExporting.value = !Ev4rs.isExporting.value;
                    });
                    }
                  ), 
                  ),
                  ),
                ]
                ),
              ),
              
              //
              //redo + print
              //
              Expanded(flex: 2, child: 
                Column( children:[
                  //redo
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04,
                child: ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.isRedoing, 
                    builder: (context, inverting, _) {
                return 
                  ButtonStyle1(
                    glow: (Ev4rs.isRedoing.value) ? true : false,
                    imagePath: 'assets/interface_icons/interface_icons/iRe-do.png', 
                    onPressed: () { setState(() {
                      Ev4rs.redoAction(root);
                    });
                    }
                  );
                    }),
                  ),
                  ),
                  //print
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04,
                child:
                  ButtonStyle1(
                    imagePath: 'assets/interface_icons/interface_icons/iPrint.png', 
                    onPressed: () { setState(() {
                      Ev4rs.isPrinting.value = !Ev4rs.isPrinting.value;
                    });
                    }
                  ),
                  ),
                  ),
                ]
                ),
              ),
              
              //
              //expand/collapse + board settings
              //
              Column( children:[
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(7, 7, 7, 0),
                  child: SizedBox( 
                    height: (isLandscape) ? MediaQuery.of(context).size.height * 0.07 : MediaQuery.of(context).size.height * 0.04,
                    child: (Ev4rs.isButtonExpanded.value) 
                    ? ButtonStyle1(
                        imagePath: 'assets/interface_icons/interface_icons/iCollapse.png', 
                        onPressed: () { 
                          setState(() {
                            Ev4rs.isButtonExpanded.value = false;
                          });
                        }
                      ) 
                    : ButtonStyle1(
                        imagePath: 'assets/interface_icons/interface_icons/iExpand.png', 
                        onPressed: () { 
                          setState(() {
                            Ev4rs.isButtonExpanded.value = true;
                          });
                        }
                      ) 
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(7, 0, 7, 7),
                  child: SizedBox( 
                    height: (isLandscape) ? MediaQuery.of(context).size.height * 0.08 : MediaQuery.of(context).size.height * 0.04 ,
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(10), child: 
                       ButtonStyle1(
                          glow: (Ev4rs.boardEditor.value) ? true : false,
                          imagePath: 'assets/interface_icons/interface_icons/iBoard.png', 
                          onPressed: () { setState(() {
                            Ev4rs.editBoardsAction(root);
                          });
                          }
                        ) 
                      ),
                    ),
                  ),
              ]
              )
            ]
            ),
              
        //here
        Positioned(
          top: (isLandscape) ? MediaQuery.of(context).size.height * 0.08 : MediaQuery.of(context).size.height * 0.04,
          child: ValueListenableBuilder<bool>(valueListenable: Ev4rs.showSelectionMenu, builder: (context, showSelectionMenu, _) {
          return SizedBox( 
            height: (isLandscape) ? MediaQuery.of(context).size.height * 0.09 : MediaQuery.of(context).size.height * 0.04,
            child:  Padding(padding: EdgeInsetsGeometry.all(7), child:
          Row(
            children: [
              //tap
            if (Ev4rs.isButtonExpanded.value == false)
                ButtonStyle1(
                imagePath: 'assets/interface_icons/interface_icons/iTap.png', 
                onPressed: () { setState(() {
                  Ev4rs.showSelectionMenu.value = !Ev4rs.showSelectionMenu.value;
                });
                }
              ),

            //tap and swap
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.tapAndSwap) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iTapAndSwap.png', 
                  onPressed: () { setState(() {
                    Ev4rs.tapAndSwapAction(root);
                  });
                  }
                ),

            //drag to select multiple
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.dragSelectMultiple.value) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iDragSelectMultiple.png', 
                  onPressed: () { setState(() {
                    Ev4rs.dragSelectMultipleAction(root);
                  });
                }
              ),

            //select multiple
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.selectMultiple.value) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iSelectMultiple.png', 
                  onPressed: () { setState(() {
                    Ev4rs.selectMultipleAction(root);
                  });
                }
              ),

            //invert selection
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
              ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.invertSelections, 
                    builder: (context, inverting, _) { 
                return ButtonStyle1(
                  glow: (Ev4rs.invertSelections.value) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iInvertSelection.png', 
                  onPressed: () { 
                    setState(() {
                      Ev4rs.invertSelectionAction(root);
                    });
                  }
                );
              }),

            //sort a-z
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
              ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.sortSelectAZ, 
                    builder: (context, inverting, _) {
                return ButtonStyle1(
                glow: (Ev4rs.sortSelectAZ.value) ? true : false,
                imagePath: 'assets/interface_icons/interface_icons/iSortAZ.png', 
                onPressed: () { setState(() {
                  Ev4rs.sortSelectedAzAction(root);
                });
                }
              );}),

          ]
          ),
            ),
          );
        }
        )
        )
        ]
        );
      }
    }

    class MultiGrammerEditor extends StatefulWidget{
          final GrammerObjects obj;
          final void Function(Root root, List<String> objUUID, String field, dynamic value) saveField;
          final Root root;
          const MultiGrammerEditor({
            super.key,
            required this.root,
            required this.saveField,
            required this.obj,
          });

          @override
          State<MultiGrammerEditor> createState() => _MultiGrammerEditor();
        }

    class _MultiGrammerEditor extends State<MultiGrammerEditor>{
      final ImagePicker _picker = ImagePicker();
      var everyImage = <String>[];

      @override
      Widget build(BuildContext context) {
        Root root = widget.root;
        final screenSize = MediaQuery.of(context).size;
        final isLandscape = screenSize.width > screenSize.height;

         
            everyImage = Ev4rs.getAllImages(root);
          

            final obj_ = Ev4rs.findGrammerById(root.grammerRow, Ev4rs.grammerSelectedUUID);
            if (obj_ == null) {
              return const Center(child: Text("Object not found"));
            }

            Ev4rs.setGrammerPlacholderValues(obj_);
            
            var allBoards = Ev4rs.getBoards(root.boards);

            final mapOfBoards = {
              for (var board in allBoards) 
                if (board.title != null) 
                  board.title!: board.id,
            };

            Widget image = LoadImage.fromSymbol('assets/interface_icons/interface_icons/iPlaceholder.png');
            Widget image2 = LoadImage.fromSymbol(obj_.symbol);


        return Stack( children: [
             
            Row( 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              //
              //back, in positioned is the tap expander
              //
              Padding(padding: EdgeInsetsGeometry.all(7),
              child: SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.065 : MediaQuery.of(context).size.height * 0.03 ,
                child: ButtonStyle1(
                  imagePath: 'assets/interface_icons/interface_icons/iBack.png', 
                  onPressed: () {
                  setState(() {
                    Ev4rs.closeEditorAction();
                  });
                  }
                ),
              ),
              ),

              //
              //Image, image padding, image overlay settings
              //
              ValueListenableBuilder(
                valueListenable: CombinedValueNotifier(
                    Ev4rs.padding, Ev4rs.overlay, Ev4rs.contrast, 
                    Ev4rs.invert, Ev4rs.saturation, Ev4rs.matchContrast, 
                    Ev4rs.matchInvert, Ev4rs.matchOverlay, Ev4rs.matchSaturation
                  ), 
                builder: (context, values, _) {
              return Expanded(flex: 8, child: 
                Column( children:[
                  //
                  //image
                  //
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                          Container(
                            width: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                              color: Cv4rs.themeColor4,
                              borderRadius: BorderRadius.circular(10)
                              ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(child: Padding(padding: EdgeInsetsGeometry.all(Ev4rs.padding.value), 
                                  child: (!Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.symbol)) ?
                                  Column(children: [
                                    Text('--Not All Match--', style: Sv4rs.settingslabelStyle),
                                    ImageStyle1(
                                        image: image, 
                                        symbolSaturation: Bv4rs.buttonSymbolSaturation, 
                                        symbolContrast: Bv4rs.buttonSymbolContrast, 
                                        invertSymbolColors: Bv4rs.buttonSymbolInvert, 
                                        overlayColor: Bv4rs.buttonSymbolColorOverlay, 
                                        matchOverlayColor: true, 
                                        matchSymbolContrast: true, 
                                        matchSymbolInvert: true, 
                                        matchSymbolSaturation: true,
                                        defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
                                        defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
                                        defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
                                        defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
                                      ) 
                                    ]
                                    )
                                  : ImageStyle1(
                                      image: image2, 
                                      symbolSaturation: obj_.symbolSaturation ?? 1.0, 
                                      symbolContrast: obj_.symbolContrast ?? 1.0, 
                                      invertSymbolColors: obj_.invertSymbol ?? false, 
                                      overlayColor: obj_.overlayColor ?? Colors.white,
                                      
                                      matchOverlayColor: 
                                        (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchOverlayColor) 
                                        && (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.overlayColor)))
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      matchSymbolContrast:
                                        (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchSymbolContrast)
                                        && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.symbolContrast)) 
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      matchSymbolInvert:  
                                        (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchInvertSymbol)
                                        && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.invertSymbol)) 
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      matchSymbolSaturation: 
                                        (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchSymbolSaturation)
                                        && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.symbolSaturation)) 
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      
                                      defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
                                      defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
                                      defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
                                      defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
                                      )
                                  ),
                                ),
                                Flexible(child: 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                        SizedBox( 
                                          width: MediaQuery.of(context).size.height * 0.08,
                                          child: ButtonStyle3(
                                            imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                            onPressed: () async {
                                              Ev4rs.multiPickImage(widget.saveField, root, _picker);
                                              if (everyImage.isNotEmpty) {
                                              //await Ev4rs.cleanupUnusedImages(everyImage);
                                              } 
                                            }, 
                                            label: 'Photo Lib'
                                          ),
                                        ),
                                      ),
                                  Visibility(
                                    visible: false,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                    SizedBox( 
                                      width: MediaQuery.of(context).size.height * 0.07,
                                      child: ButtonStyle3(
                                      imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                      onPressed: () async {
                                        Ev4rs.multiPickImage(widget.saveField, root, _picker);
                                          if (everyImage.isNotEmpty) {
                                            //await Ev4rs.cleanupUnusedImages(everyImage);
                                          } 
                                      }, 
                                      label: 'App Lib'
                                      )
                                    ),
                                  ),
                                  ),
                              ]
                              )
                              ),
                            ]),
                          ),
                  ),

                  //
                  //padding
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox( 
                    width: MediaQuery.of(context).size.height * 0.25,
                    child: 
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(10), child: 
                        Column(children: [
                          (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.padding)) 
                        ? Text('Image Padding: ${Ev4rs.padding.value}', style: Sv4rs.settingslabelStyle,)
                        : Text('Image Padding: --Not All Match--', style: Sv4rs.settingslabelStyle,),
                        Slider(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              value: Ev4rs.padding.value,
                              min: 0.0,
                              max: 10.0,
                              divisions: 11,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Image Padding: ${Ev4rs.padding.value}',
                              onChanged: (value) {
                                Ev4rs.padding.value = value.roundToDouble();
                              }
                          ),
                        ])
                        ),
                        ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'padding', Ev4rs.padding.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save Padding'
                          ),
                        ]),
                    ),
                  ),
                  ),

                  //
                  //symbolColors
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox(
                    child:
                  SymbolColorCustomizer2(
                    specialLabel: 
                      (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchSymbolContrast) 
                      && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.symbolContrast)
                      && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchInvertSymbol) 
                      && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.invertSymbol)
                      && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchSymbolSaturation) 
                      && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.symbolSaturation)
                      && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchOverlayColor) 
                      && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.overlayColor)
                      ) 
                      ? false 
                      : true,
                    widgety: 
                    ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'matchOverlayColor', Ev4rs.matchOverlay.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'overlayColor', Ev4rs.overlay.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'matchSymbolSaturation', Ev4rs.matchSaturation.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'symbolSaturation', Ev4rs.saturation.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'matchSymbolContrast', Ev4rs.matchContrast.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'symbolContrast', Ev4rs.contrast.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'matchInvertSymbol', Ev4rs.matchInvert.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'invertSymbol', Ev4rs.invert.value);
                              
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save Adjustments'
                          ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    additionalHeight: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.height * 0.25,
                    invert: Ev4rs.invert.value, 
                    overlay: Ev4rs.overlay.value,
                    saturation: Ev4rs.saturation.value, 
                    contrast: Ev4rs.contrast.value, 
                    
                    matchContrast: 
                    (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchSymbolContrast) 
                    && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.symbolContrast)) 
                    ? Ev4rs.matchContrast.value
                    : true,
                    matchInvert: 
                    (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchInvertSymbol) 
                    && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.invertSymbol)) 
                    ? Ev4rs.matchInvert.value
                    : true,
                    matchOverlay: 
                    (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchOverlayColor) 
                    && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.overlayColor)) 
                    ? Ev4rs.matchOverlay.value
                    : true,
                    matchSaturation: 
                    (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchSymbolSaturation) 
                    && Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.symbolSaturation)) 
                    ? Ev4rs.matchSaturation.value
                    : true,
                    
                    onContrastChanged: (value){
                      Ev4rs.contrast.value = value;
                    }, 
                    onInvertChanged: (value){
                      Ev4rs.invert.value = value;
                    },
                    onOverlayChanged: (value){
                      Ev4rs.overlay.value = value;
                    },
                    onSaturationChanged: (value){
                      Ev4rs.saturation.value = value;
                    },
                    onMatchContrastChanged: (value){
                      Ev4rs.matchContrast.value = value;
                    }, 
                    onMatchInvertChanged: (value){
                      Ev4rs.matchInvert.value = value;
                    },
                    onMatchOverlayChanged: (value){
                      Ev4rs.matchOverlay.value = value;
                    },
                    onMatchSaturationChanged: (value){
                      Ev4rs.matchSaturation.value = value;
                    },
                    )
                  )
                  ),
                
                ]
                ),
              );
              }
            ),
              
              //
              //label, speak on select, font
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //label
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                              ValueListenableBuilder(valueListenable: Ev4rs.notes, builder: (context, value, _) {
                          final labelController = TextEditingController(text: value)
                          ..selection = TextSelection.collapsed(offset: value.length);

                          return 
                        TextField(
                          controller: labelController,
                                style: Ev4rs.labelStyle,
                                onChanged: (value){
                                  Ev4rs.label.value = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Ev4rs.hintLabelStyle,
                                hintText: (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => (b).label)) ? '${obj_.label}' : '--Not All Match--',
                                ),
                              );
                              }),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'label', Ev4rs.label.value);
                                
                                Ev4rs.saveJson(root);
                                });
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                       
                    ]
                      
                    ))),
                  //match speak on select, speak on select
                  Padding(padding: EdgeInsetsGeometry.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchSpeakOnSelect, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(child: 
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(10, 10, 10, 0), 
                                child: Text( (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchSpeakOS)) ?
                                  'Match Speak on Select:' : 'Match Speak on Select: --Not All Match--', 
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchSpeakOnSelect.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchSpeakOnSelect.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.speakOnSelect, 
                          builder: (context, speakOnSelect, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.all(10), 
                              child: Column(children: [
                                if (!Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchSpeakOS)) 
                                  Text('Speak on Select: --Not All Match--', style: Sv4rs.settingslabelStyle),
                                Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 1.0,
                                  max: 3.0,
                                  divisions: 2,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 
                                    (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchSpeakOS)) 
                                    ? 'Speak on Select: ${Ev4rs.speakOnSelect.value}'
                                    : 'Speak on Select: --Not All Match--',
                                  value: Ev4rs.speakOnSelect.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.speakOnSelect.value = value.toInt();
                                    }
                                  ),
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10), 
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                    Expanded(child: 
                                      Text(
                                        "Off", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Label", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Change", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ]
                                  ), 
                                ),
                                ButtonStyle2(
                                  imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                                  onPressed: (){setState(() {
                                      widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'matchSpeakOS', Ev4rs.matchSpeakOnSelect.value);
                                      widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'speakOS', Ev4rs.speakOnSelect.value);
                                      Ev4rs.saveJson(root);
                                      });
                                  }, 
                                  label: 'Save'
                                ),
                              ]
                            ),
                            );
                          }
                        ),
                        
                      ]
                    )
                    )
                  ),
                  //font, match font settings, font picker
                  Padding(
                      padding: EdgeInsetsGeometry.all(10), 
                      child: FontPicker2(
                        widgety:  ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){setState(() {
                                widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'matchFont', Ev4rs.matchFont.value);
                                widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'fontSize', Ev4rs.fontSize.value);
                                widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'fontItalics', Ev4rs.fontItalics.value);
                                widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'fontUnderline', Ev4rs.fontUnderline.value);
                                widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'fontWeight', Ev4rs.fontWeight.value);
                                widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'fontFamily', Ev4rs.fontFamily.value);
                                widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'fontColor', Ev4rs.fontColor.value);
                                Ev4rs.saveJson(root);
                                });
                            }, 
                            label: 'Save Button Font'
                            ),
                            specialLabel: 
                              (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchFont) 
                              || Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.fontSize)
                              || Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.fontItalics)
                              || Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.fontUnderline)
                              || Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.fontWeight)
                              || Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.fontFamily)
                              || Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.fontColor)) 
                              ? false 
                              : true,
                            matchFontSet: Ev4rs.matchFont.value,
                            height: MediaQuery.of(context).size.height * 0.3,
                            size: Ev4rs.fontSize.value, 
                            sizeMax: 25,
                            sizeMin: 5,
                            divisions: 20,
                            weight: (Ev4rs.fontWeight.value).toInt(), 
                            italics: Ev4rs.fontItalics.value, 
                            font: Ev4rs.fontFamily.value, 
                            label: 'Button Font:', 
                            color: Ev4rs.fontColor.value, 
                            underline: Ev4rs.fontUnderline.value,
                            onSizeChanged: (value) {
                              Ev4rs.fontSize.value = value;
                              }, 
                            onWeightChanged: (value) {
                              Ev4rs.fontWeight.value = value.toDouble();
                              },
                            onItalicsChanged: (value) {
                              Ev4rs.fontItalics.value = value;
                              },
                            onFontChanged: (value) {
                              Ev4rs.fontFamily.value = value;
                              },
                            onColorChanged: (value) {
                              Ev4rs.fontColor.value = value.toColor() ?? Cv4rs.themeColor1;
                              },
                            onMatchFont: (value) {
                              Ev4rs.matchFont.value = value;
                              },
                            useUnderline: true, 
                            onUnderlineChanged: (value) {
                              Ev4rs.fontUnderline.value = value;
                              }, 
                            )
                          ),
                ]
              ),
              ),
              
              //
              // format, border, background
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  
                  //
                  //format
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container(
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchFormat, 
                          builder: (context, matchFormat, _) {
                            return Row(children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0), 
                                    child: Text(
                                      (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.matchFormat)) 
                                        ? 'Match Format:'
                                        : 'Match Format: --Not All Match--',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchFormat.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchFormat.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.format, 
                          builder: (context, format, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(5, 15, 5, 10), 
                              child: Column(children: [
                                      Text(
                                        "Format: ${ Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.format) 
                                          ? (Ev4rs.format.value == 1 ? 
                                              'Text Right' 
                                            : Ev4rs.format.value == 2 ? 
                                              'Text Left' 
                                            : Ev4rs.format.value == 3 ? 
                                              'Image Only' 
                                            : Ev4rs.format.value == 4 ? 
                                              'Text Only' 
                                            : '') 
                                          : '--Not All Match--'
                                          }", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                Slider(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  min: 1.0,
                                  max: 4.0,
                                  divisions: 3,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  value: Ev4rs.format.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.format.value = value.toInt();
                                    }
                                  ),
                                ]
                            ),
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'matchFormat', Ev4rs.matchFormat.value);
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'format', Ev4rs.format.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  

                  //
                  //background
                  //
                  
                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [

                        
                        //Background color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.backgroundColor, 
                          builder: (context, backgroundColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                Text((Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.backgroundColor)) 
                                  ? 'Background Color: '
                                  : 'Background Color: --Not All Match--', 
                                  style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.backgroundColor.value, size: 40, shadows: [
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
                                startValue: Ev4rs.backgroundColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.backgroundColor.value = color;
                                },
                              ),
                            ),
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
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.backgroundColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.backgroundColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'backgroundColor', Ev4rs.backgroundColor.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                ]
                ),
              ),
              
              //
              //button type -> link, return after select
              //
              Expanded(flex: 7, child: 
                Column( children:[

                  //type 
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.buttonType, 
                          builder: (context, buttonType, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text((Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.type)) 
                                  ? 'Type: '
                                  : 'Type: --Not All Match--', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                            DropdownButton<String>(
                              isExpanded: true,
                                hint: Text((Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.type)) 
                                  ? 'Type: '
                                  : 'Type: --Not All Match--', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.grammerType.value,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: 'button',
                                    child: Text(
                                      'button', 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'placeholder',
                                    child: Text(
                                      'placeholder', 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'folder',
                                    child: Text(
                                      'folder', 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  ),
                                  ],
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.grammerType.value = value;
                                  }
                                },
                              ),
                            ),
                  
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'type', Ev4rs.grammerType.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                  
                  ),
                  ),

                  //function
                  if (Ev4rs.grammerType.value == 'button' || Ev4rs.grammerType.value == 'placeholder')
                   Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.grammerFunction, 
                          builder: (context, grammerFunction, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.function)) 
                                  ? 'Grammer Function:'
                                  : 'Grammer Function: --Not All Match--',
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                            DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                  'grammer function', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.grammerFunction.value,
                                items: Gv4rs.grammerFunctionMap.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.grammerFunction.value = value;
                                  }
                                },
                              ),
                          ),
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'function', Ev4rs.grammerFunction.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                
                  ),
                  ),
                  


                  if (Ev4rs.grammerType.value == 'folder')
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.link, 
                          builder: (context, link, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child:  Text(
                                (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.openUUID)) 
                                  ? 'Link To...'
                                  : 'Link To... --Not All Match--', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            DropdownButton<String>(
                              isExpanded: true,
                                hint:  Text(
                                (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.openUUID)) 
                                  ? 'Link To...'
                                  : 'Link To... --Not All Match--', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.link.value,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: Text('none', style: Sv4rs.settingslabelStyle),
                                  ),
                                ...mapOfBoards.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                })
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.link.value = value;
                                  }
                                },
                              ),
                            //save 
                            ButtonStyle2(
                              imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                              onPressed: (){setState(() {
                                 widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'type', Ev4rs.grammerType.value);
                                 Ev4rs.saveJson(root);
                                 });
                                
                              }, 
                              label: 'Save'
                            ),
                          ]);
                        }),
                      ),
                    ),

                  //notes
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10), child: 
                              ValueListenableBuilder(valueListenable: Ev4rs.notes, builder: (context, value, _) {
                          final notesController = TextEditingController(text: value)
                          ..selection = TextSelection.collapsed(offset: value.length);

                          return 
                        TextField(
                          controller: notesController,
                                minLines: 1,
                                maxLines: 5,
                                style: Sv4rs.settingslabelStyle,
                                onChanged: (value){
                                  Ev4rs.notes.value = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Sv4rs.settingslabelStyle,
                                hintText: (Ev4rs.compareGrammerObjFields(root.grammerRow, (b) => b.note)) 
                                  ? 'Notes... ${Ev4rs.notes.value}'
                                  : 'Notes... --Not All Match--',
                                ),
                              );
                              }),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.grammerSelectedUUIDs.value, 'note', Ev4rs.notes.value);
                                Ev4rs.saveJson(root);
                                });
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                    ]
                      
                    ))),

                ]
                ),
              ),
              
              //
              //undo + share
              //
              Expanded(flex: 2, child: 
                Column( children:[
                  //undo
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                child: ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.isUndoing, 
                    builder: (context, inverting, _) {
                return 
                  ButtonStyle1(
                    glow: (Ev4rs.isUndoing.value) ? true : false,
                    imagePath: 'assets/interface_icons/interface_icons/iUndo.png', 
                    onPressed: () { setState(() {
                      Ev4rs.undoAction(root);
                    });
                    }
                  );
                  }),
                  ),
                  ),

                  //share
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                child:
                  ButtonStyle1(
                    imagePath: 'assets/interface_icons/interface_icons/iExport.png', 
                    onPressed: () { setState(() {
                      Ev4rs.isExporting.value = !Ev4rs.isExporting.value;
                    });
                    }
                  ), 
                  ),
                  ),
                ]
                ),
              ),
              
              //
              //redo + print
              //
              Expanded(flex: 2, child: 
                Column( children:[
                  //redo
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                child: ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.isRedoing, 
                    builder: (context, inverting, _) {
                return 
                  ButtonStyle1(
                    glow: (Ev4rs.isRedoing.value) ? true : false,
                    imagePath: 'assets/interface_icons/interface_icons/iRe-do.png', 
                    onPressed: () { setState(() {
                      Ev4rs.redoAction(root);
                    });
                    }
                );
                    }),
                  ),
                  ),
                  //print
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                child:
                  ButtonStyle1(
                    imagePath: 'assets/interface_icons/interface_icons/iPrint.png', 
                    onPressed: () { setState(() {
                      Ev4rs.isPrinting.value = !Ev4rs.isPrinting.value;
                    });
                    }
                  ),
                  ),
                  ),
                ]
                ),
              ),
              
              //
              //expand/collapse + board settings
              //
              Column( children:[
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(7, 7, 7, 0),
                  child: SizedBox( 
                    height: (isLandscape) ? MediaQuery.of(context).size.height * 0.07 : MediaQuery.of(context).size.height * 0.04,
                    child: (Ev4rs.isButtonExpanded.value) 
                    ? ButtonStyle1(
                        imagePath: 'assets/interface_icons/interface_icons/iCollapse.png', 
                        onPressed: () { 
                          setState(() {
                            Ev4rs.isButtonExpanded.value = false;
                          });
                        }
                      ) 
                    : ButtonStyle1(
                        imagePath: 'assets/interface_icons/interface_icons/iExpand.png', 
                        onPressed: () { 
                          setState(() {
                            Ev4rs.isButtonExpanded.value = true;
                          });
                        }
                      ) 
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(7, 0, 7, 7),
                  child: SizedBox( 
                    height: (isLandscape) ? MediaQuery.of(context).size.height * 0.08 : MediaQuery.of(context).size.height * 0.04 ,
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(10), child: 
                       ButtonStyle1(
                          glow: (Ev4rs.boardEditor.value) ? true : false,
                          imagePath: 'assets/interface_icons/interface_icons/iBoard.png', 
                          onPressed: () { setState(() {
                            Ev4rs.editBoardsAction(root);
                          });
                          }
                        ) 
                      ),
                    ),
                  ),
              ]
              )
            ]
            ),
        //here
        Positioned(
          top: (isLandscape) ? MediaQuery.of(context).size.height * 0.08 : MediaQuery.of(context).size.height * 0.04,
          child: ValueListenableBuilder<bool>(valueListenable: Ev4rs.showSelectionMenu, builder: (context, showSelectionMenu, _) {
          return SizedBox( 
            height: (isLandscape) ? MediaQuery.of(context).size.height * 0.09 : MediaQuery.of(context).size.height * 0.04,
            child:  Padding(padding: EdgeInsetsGeometry.all(7), child:
          Row(
            children: [
              //tap
            if (Ev4rs.isButtonExpanded.value == false)
                ButtonStyle1(
                imagePath: 'assets/interface_icons/interface_icons/iTap.png', 
                onPressed: () { setState(() {
                  Ev4rs.showSelectionMenu.value = !Ev4rs.showSelectionMenu.value;
                });
                }
              ),

            //tap and swap
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.tapAndSwap) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iTapAndSwap.png', 
                  onPressed: ()  {
                    setState(() {
                      Ev4rs.tapAndSwapAction(root);
                    });
                  }
                ),

            //drag to select multiple
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.dragSelectMultiple.value) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iDragSelectMultiple.png', 
                  onPressed: () { 
                    setState(() {
                      Ev4rs.dragSelectMultipleAction(root);
                    });
                  }
                ),

            //select multiple
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.selectMultiple.value) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iSelectMultiple.png', 
                  onPressed: () { 
                    setState(() {
                      Ev4rs.selectMultipleAction(root);
                    });
                  }
                ),

            //invert selection

            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.invertSelections, 
                    builder: (context, inverting, _) {
              return ButtonStyle1(
                glow: (Ev4rs.invertSelections.value) ? true : false,
                imagePath: 'assets/interface_icons/interface_icons/iInvertSelection.png', 
                onPressed: () { setState(() {
                  Ev4rs.invertSelectionAction(root);
                });
                }
              );
                    }
                    ),

            //sort a-z
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
              ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.sortSelectAZ, 
                    builder: (context, sorting, _) {
              return ButtonStyle1(
                imagePath: 'assets/interface_icons/interface_icons/iSortAZ.png', 
                onPressed: () { setState(() {
                  Ev4rs.sortSelectedAzAction(root);
                });
                }
              );
                    })

          ]
          ),
            ),
          );
        }
        )
        )
        ]
        );
      }
    }


  //===: nav button editor 
    class NavButtonEditor extends StatefulWidget{
      final void Function(Root root, String objUUID, String field, dynamic value) saveField;
      final Root root;
      final NavObjects obj;
      const NavButtonEditor({
        super.key,
        required this.saveField,
        required this.root,
        required this.obj,
      });

      @override
      State<NavButtonEditor> createState() => _NavButtonEditorState();
    }

    class _NavButtonEditorState extends State<NavButtonEditor>{
      final ImagePicker _picker = ImagePicker();
      var everyImage = <String>[];


      @override
      Widget build(BuildContext context) {
        Root root = widget.root;
        final screenSize = MediaQuery.of(context).size;
        final isLandscape = screenSize.width > screenSize.height;


            everyImage = Ev4rs.getAllImages(root);
          

            final obj_ = Ev4rs.findNavById(root.navRow, Ev4rs.navSelectedUUID);
            if (obj_ == null) {
              return const Center(child: Text("Object not found"));
            }

            Ev4rs.setNavPlacholderValues(obj_);
            
            var allBoards = Ev4rs.getBoards(root.boards);

            final mapOfBoards = {
              for (var board in allBoards) 
                if (board.title != null) 
                  board.title!: board.id,
            };

            Widget image = LoadImage.fromSymbol(obj_.symbol);


        return Stack( children: [
              
            Row( 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              //
              //back, in positioned is the tap expander
              //
              Padding(padding: EdgeInsetsGeometry.all(7),
              child: SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.065 : MediaQuery.of(context).size.height * 0.03 ,
                child: ButtonStyle1(
                  imagePath: 'assets/interface_icons/interface_icons/iBack.png', 
                  onPressed: () {
                  setState(() {
                    Ev4rs.closeEditorAction();
                  });
                  }
                ),
              ),
              ),

              //
              //Image, image padding, image overlay settings
              //
              ValueListenableBuilder(
                valueListenable: CombinedValueNotifier(
                    Ev4rs.padding, Ev4rs.overlay, Ev4rs.contrast, 
                    Ev4rs.invert, Ev4rs.saturation, Ev4rs.matchContrast, 
                    Ev4rs.matchInvert, Ev4rs.matchOverlay, Ev4rs.matchSaturation
                  ), 
                builder: (context, values, _) {
              return Expanded(flex: 8, child: 
                Column( children:[
                  //
                  //image
                  //
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                          Container(
                            width: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                              color: Cv4rs.themeColor4,
                              borderRadius: BorderRadius.circular(10)
                              ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(child: Padding(padding: EdgeInsetsGeometry.all(Ev4rs.padding.value), 
                                  child: ImageStyle1(
                                      image: image, 
                                      symbolSaturation: Ev4rs.saturation.value, 
                                      symbolContrast: Ev4rs.contrast.value, 
                                      invertSymbolColors: Ev4rs.invert.value, 
                                      overlayColor: Ev4rs.overlay.value, 
                                      matchOverlayColor: Ev4rs.matchOverlay.value, 
                                      matchSymbolContrast: Ev4rs.matchContrast.value, 
                                      matchSymbolInvert: Ev4rs.matchInvert.value, 
                                      matchSymbolSaturation: Ev4rs.matchSaturation.value,
                                      defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
                                      defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
                                      defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
                                      defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
                                      )
                                  ),
                                ),
                                Flexible(child: 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                        SizedBox( 
                                          width: MediaQuery.of(context).size.height * 0.08,
                                          child: ButtonStyle3(
                                            imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                            onPressed: () async {
                                              Ev4rs.navPickImage(widget.saveField, root, _picker);
                                              if (everyImage.isNotEmpty) {
                                              //await Ev4rs.cleanupUnusedImages(everyImage);
                                              } 
                                            }, 
                                            label: 'Photo Lib'
                                          ),
                                        ),
                                      ),
                                  Visibility(
                                    visible: false,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                    SizedBox( 
                                      width: MediaQuery.of(context).size.height * 0.07,
                                      child: ButtonStyle3(
                                      imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                      onPressed: () async {
                                        Ev4rs.navPickImage(widget.saveField, root, _picker);
                                        if (everyImage.isNotEmpty) {
                                         // await Ev4rs.cleanupUnusedImages(everyImage);
                                        } 
                                      }, 
                                      label: 'App Lib'
                                      )
                                    ),
                                  ),
                                  ),
                              ]
                              )
                              ),
                            ]),
                          ),
                  ),

                  //
                  //padding
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox( 
                    width: MediaQuery.of(context).size.height * 0.25,
                    child: 
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(10), child: 
                        Column(children: [
                        Text('Image Padding: ${Ev4rs.padding.value}', style: Sv4rs.settingslabelStyle,),
                        Slider(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              value: Ev4rs.padding.value,
                              min: 0.0,
                              max: 10.0,
                              divisions: 11,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Image Padding: ${Ev4rs.padding.value}',
                              onChanged: (value) {
                                Ev4rs.padding.value = value.roundToDouble();
                              }
                          ),
                        ])
                        ),
                        ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'padding', Ev4rs.padding.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save Padding'
                          ),
                        ]),
                    ),
                  ),
                  ),

                  //
                  //symbolColors
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox(
                    child:
                  SymbolColorCustomizer2(
                    widgety: 
                    ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'matchOverlayColor', Ev4rs.matchOverlay.value);
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'overlayColor', Ev4rs.overlay.value);
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'matchSymbolSaturation', Ev4rs.matchSaturation.value);
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'symbolSaturation', Ev4rs.saturation.value);
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'matchSymbolContrast', Ev4rs.matchContrast.value);
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'symbolContrast', Ev4rs.contrast.value);
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'matchInvertSymbol', Ev4rs.matchInvert.value);
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'invertSymbol', Ev4rs.invert.value);
                              
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save Adjustments'
                          ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    additionalHeight: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.height * 0.25,
                    invert: Ev4rs.invert.value, 
                    overlay: Ev4rs.overlay.value,
                    saturation: Ev4rs.saturation.value, 
                    contrast: Ev4rs.contrast.value, 
                    matchContrast: Ev4rs.matchContrast.value,
                    matchInvert: Ev4rs.matchInvert.value,
                    matchOverlay: Ev4rs.matchOverlay.value,
                    matchSaturation: Ev4rs.matchSaturation.value,
                    onContrastChanged: (value){
                      Ev4rs.contrast.value = value;
                    }, 
                    onInvertChanged: (value){
                      Ev4rs.invert.value = value;
                    },
                    onOverlayChanged: (value){
                      Ev4rs.overlay.value = value;
                    },
                    onSaturationChanged: (value){
                      Ev4rs.saturation.value = value;
                    },
                    onMatchContrastChanged: (value){
                      Ev4rs.matchContrast.value = value;
                    }, 
                    onMatchInvertChanged: (value){
                      Ev4rs.matchInvert.value = value;
                    },
                    onMatchOverlayChanged: (value){
                      Ev4rs.matchOverlay.value = value;
                    },
                    onMatchSaturationChanged: (value){
                      Ev4rs.matchSaturation.value = value;
                    },
                    )
                  )
                  ),
                  

                ]
                ),
              );
              }
            ),
              
              //
              //label, alternate label, speak on select, font
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //label and message
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        //label
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                                 ValueListenableBuilder(valueListenable: Ev4rs.notes, builder: (context, value, _) {
                          final labelController = TextEditingController(text: value)
                          ..selection = TextSelection.collapsed(offset: value.length);

                          return 
                        TextField(
                          controller: labelController,
                                style: Ev4rs.labelStyle,
                                onChanged: (value){
                                  Ev4rs.label.value = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Ev4rs.hintLabelStyle,
                                hintText: '${obj_.label}',
                                ),
                              );
                                 }),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'label', Ev4rs.label.value);
                              Ev4rs.saveJson(root);
                              });
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                        ],
                      ),
                        //alternate label
                        Row(children: [ 
                          Expanded(
                            flex: 5,
                            child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                              ValueListenableBuilder(valueListenable: Ev4rs.notes, builder: (context, value, _) {
                          final alternateController = TextEditingController(text: value)
                          ..selection = TextSelection.collapsed(offset: value.length);

                          return 
                        TextField(
                          controller: alternateController,
                                style: Ev4rs.labelStyle,
                                onChanged: (value){
                                  Ev4rs.alternateLabel.value = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Ev4rs.hintLabelStyle,
                                hintText: '${obj_.alternateLabel}',
                                ),
                              );
                              }),
                            ),
                          ),
                        Flexible(
                          flex: 2,
                          child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                        ButtonStyle4(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'alternateLabel', Ev4rs.alternateLabel.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                          ),
                          ),
                        ),
                      ]
                      ),
                    ]
                    )
                    )
                    ),
                  
                  //match speak on select, speak on select
                  Padding(padding: EdgeInsetsGeometry.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchSpeakOnSelect, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(child: 
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(10, 10, 10, 0), 
                                child: Text(
                                  'Match Speak on Select:', 
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchSpeakOnSelect.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchSpeakOnSelect.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.speakOnSelect, 
                          builder: (context, speakOnSelect, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.all(10), 
                              child: Column(children: [
                                Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 1.0,
                                  max: 3.0,
                                  divisions: 2,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 'Speak on Select: ${Ev4rs.speakOnSelect.value}',
                                  value: Ev4rs.speakOnSelect.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.speakOnSelect.value = value.toInt();
                                    }
                                  ),
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10), 
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                    Expanded(child: 
                                      Text(
                                        "Off", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Label", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Alt. Label", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ]
                                  ), 
                                ),
                                ButtonStyle2(
                                  imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                                  onPressed: (){setState(() {
                                      widget.saveField(root, Ev4rs.navSelectedUUID, 'matchSpeakOS', Ev4rs.matchSpeakOnSelect.value);
                                      widget.saveField(root, Ev4rs.navSelectedUUID, 'speakOS', Ev4rs.speakOnSelect.value);
                                      Ev4rs.saveJson(root);
                                      });
                                  }, 
                                  label: 'Save'
                                ),
                              ]
                            ),
                            );
                          }
                        ),
                        
                      ]
                    )
                    )
                  ),
                  //font, match font settings, font picker
                  Padding(
                      padding: EdgeInsetsGeometry.all(10), 
                      child: FontPicker2(
                        widgety:  ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){setState(() {
                                widget.saveField(root, Ev4rs.navSelectedUUID, 'matchFont', Ev4rs.matchFont.value);
                                widget.saveField(root, Ev4rs.navSelectedUUID, 'fontSize', Ev4rs.fontSize.value);
                                widget.saveField(root, Ev4rs.navSelectedUUID, 'fontItalics', Ev4rs.fontItalics.value);
                                widget.saveField(root, Ev4rs.navSelectedUUID, 'fontUnderline', Ev4rs.fontUnderline.value);
                                widget.saveField(root, Ev4rs.navSelectedUUID, 'fontWeight', Ev4rs.fontWeight.value.toInt(),);
                                widget.saveField(root, Ev4rs.navSelectedUUID, 'fontFamily', Ev4rs.fontFamily.value);
                                widget.saveField(root, Ev4rs.navSelectedUUID, 'fontColor', Ev4rs.fontColor.value);
                                Ev4rs.saveJson(root);
                                });
                            }, 
                            label: 'Save Button Font'
                            ),
                            matchFontSet: Ev4rs.matchFont.value,
                            height: MediaQuery.of(context).size.height * 0.3,
                            size: Ev4rs.fontSize.value, 
                            sizeMax: 25,
                            sizeMin: 5,
                            divisions: 20,
                            weight: (Ev4rs.fontWeight.value).toInt(), 
                            italics: Ev4rs.fontItalics.value, 
                            font: Ev4rs.fontFamily.value, 
                            label: 'Button Font:', 
                            color: Ev4rs.fontColor.value, 
                            underline: Ev4rs.fontUnderline.value,
                            onSizeChanged: (value) {
                              Ev4rs.fontSize.value = value;
                              }, 
                            onWeightChanged: (value) {
                              Ev4rs.fontWeight.value = value.toDouble();
                              },
                            onItalicsChanged: (value) {
                              Ev4rs.fontItalics.value = value;
                              },
                            onFontChanged: (value) {
                              Ev4rs.fontFamily.value = value;
                              },
                            onColorChanged: (value) {
                              Ev4rs.fontColor.value = value.toColor() ?? Cv4rs.themeColor1;
                              },
                            onMatchFont: (value) {
                              Ev4rs.matchFont.value = value;
                              },
                            useUnderline: true, 
                            onUnderlineChanged: (value) {
                              Ev4rs.fontUnderline.value = value;
                              }, 
                            )
                          ),
                ]
              ),
              ),
              
              //
              //show, format, border, background
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  
                  //
                  //show button
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container( 
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.show, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(
                                child: Text(
                                  'Show Button:', 
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.show.value, 
                                  onChanged: (value) {
                                    Ev4rs.show.value = value;
                                  }
                                ),
                              ),
                              ]
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'show', Ev4rs.show.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                  
                  //
                  //format
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container(
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchFormat, 
                          builder: (context, matchFormat, _) {
                            return Row(children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 0), 
                                    child: Text(
                                      'Match Format:', 
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchFormat.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchFormat.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.format, 
                          builder: (context, format, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(5, 15, 5, 10), 
                              child: Column(children: [
                                      Text(
                                        "Format: ${
                                          Ev4rs.format.value == 1 ? 
                                            'Text Below' 
                                          : Ev4rs.format.value == 2 ? 
                                            'Text Above' 
                                          : Ev4rs.format.value == 3 ? 
                                            'Image Only' 
                                          : Ev4rs.format.value == 4 ? 
                                            'Text Only' 
                                          : ''
                                          }", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                Slider(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  min: 1.0,
                                  max: 4.0,
                                  divisions: 3,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  value: Ev4rs.format.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.format.value = value.toInt();
                                    }
                                  ),
                                ]
                            ),
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'matchFormat', Ev4rs.matchFormat.value);
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'format', Ev4rs.format.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  //
                  //border
                  //

                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [

                        //match border 
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchBorder, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 20), 
                                    child: Text(
                                      'Match Border:', 
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchBorder.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchBorder.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),

                        //border weight 
                        ValueListenableBuilder<double>(
                          valueListenable: Ev4rs.borderWeight, 
                          builder: (context, borderWeight, _) {
                            return Column (children: [
                            Text('Border Weight: ${Ev4rs.borderWeight.value}', style: Sv4rs.settingslabelStyle),
                            Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 0.0,
                                  max: 10.0,
                                  divisions: 20,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 'Border Weight: ${Ev4rs.borderWeight.value}',
                                  value: Ev4rs.borderWeight.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.borderWeight.value = value;
                                    }
                            )
                            ]
                                  );
                          }
                        ),

                        //border color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.borderColor, 
                          builder: (context, borderColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                Text('Border Color:', style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.borderColor.value, size: 40, shadows: [
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
                                startValue: Ev4rs.borderColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.borderColor.value = color;
                                },
                              ),
                            ),
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
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.borderColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.borderColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'borderWeight', Ev4rs.borderWeight.value);
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'matchBorder', Ev4rs.matchBorder.value);
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'borderColor', Ev4rs.borderColor.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  //background
                  
                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [

                        //match border 
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchBackground, 
                          builder: (context, matchBackground, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 10), 
                                    child: Text(
                                      'Match Color:', 
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchBackground.value,
                                  onChanged: (value) {
                                    Ev4rs.matchBackground.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),

                        //border color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.backgroundColor, 
                          builder: (context, backgroundColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                Text('Button Color:', style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.backgroundColor.value, size: 40, shadows: [
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
                                startValue: Ev4rs.backgroundColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.backgroundColor.value = color;
                                },
                              ),
                            ),
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
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.backgroundColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.backgroundColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'matchPOS', Ev4rs.matchBackground.value);
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'backgroundColor', Ev4rs.backgroundColor.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                ]
                ),
              ),
              
              //
              //pos, button type -> link, return after select, grammer func, mp3
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //part of speech
                  
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: SizedBox( child:
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.pos, 
                          builder: (context, pos, _) {
                            return 
                          Column(children: [
                            SizedBox(child:
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                'Part of Speech:', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10), child:
                            DropdownButton<String>(
                              isExpanded: true,
                              hint: SizedBox(child: Text(
                                'Part of Speech:', 
                                style: Sv4rs.settingslabelStyle,
                                ),),
                              value: Ev4rs.pos.value.toLowerCase(),
                              items: Gv4rs.partOfSpeechList.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: SizedBox(child: Text(
                                    item,
                                    style: Sv4rs.settingslabelStyle,
                                    overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                  Ev4rs.pos.value = value;
                                }
                                }
                            ),
                            ),
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'pos', Ev4rs.pos.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                
                  ),
                    ),
                  ),
                  
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.link, 
                          builder: (context, link, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                'Link To...', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                            DropdownButton<String>(
                              isExpanded: true,
                                hint: Text(
                                  'link to...', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.link.value,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: 
                                    Text('none', style: Sv4rs.settingslabelStyle),
                                  ),
                                ...mapOfBoards.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                })
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.link.value = value;
                                    Ev4rs.linkLabel.value = mapOfBoards.entries.firstWhere((element) => element.value == value).key;
                                  }
                                },
                              ),
                            ),
                            //save 
                            ButtonStyle2(
                              imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                              onPressed: (){setState(() {
                                  widget.saveField(root, Ev4rs.navSelectedUUID, 'linkToUUID', Ev4rs.link.value);
                                  widget.saveField(root, Ev4rs.navSelectedUUID, 'linkToLabel', Ev4rs.linkLabel.value);
                                  Ev4rs.saveJson(root);
                                  });
                              }, 
                              label: 'Save'
                            ),
                          ]);
                        }),
                      ),
                    ),

                  //notes
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10), child: 
                              ValueListenableBuilder(valueListenable: Ev4rs.notes, builder: (context, value, _) {
                          final notesController = TextEditingController(text: value)
                          ..selection = TextSelection.collapsed(offset: value.length);

                          return 
                        TextField(
                          controller: notesController,
                                minLines: 1,
                                maxLines: 5,
                                style: Sv4rs.settingslabelStyle,
                                onChanged: (value){
                                  Ev4rs.notes.value = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Sv4rs.settingslabelStyle,
                                hintText: 'Notes... ${Ev4rs.notes.value}',
                                ),
                              );
                              }),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUID, 'note', Ev4rs.notes.value);
                                Ev4rs.saveJson(root);
                                });
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                    ]
                      
                    ))),

                ]
                ),
              ),
              
              //
              //undo + share
              //
              Expanded(flex: 2, child: 
                Column( children:[
                  //undo
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                child:ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.isUndoing, 
                    builder: (context, inverting, _) {
                return 
                  ButtonStyle1(
                    glow: (Ev4rs.isUndoing.value) ? true : false,
                    imagePath: 'assets/interface_icons/interface_icons/iUndo.png', 
                    onPressed: () { setState(() {
                      Ev4rs.undoAction(root);
                    });
                    }
                  );
                    }),
                  ),
                  ),

                  //share
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                child:
                
                  ButtonStyle1(
                    imagePath: 'assets/interface_icons/interface_icons/iExport.png', 
                    onPressed: () { setState(() {
                      Ev4rs.isExporting.value = !Ev4rs.isExporting.value;
                    });
                    }
                  ), 
                  ),
                  ),
                ]
                ),
              ),
              
              //
              //redo + print
              //
              Expanded(flex: 2, child: 
                Column( children:[
                  //redo
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04,
                child: ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.isRedoing, 
                    builder: (context, inverting, _) {
                return 
                  ButtonStyle1(
                    glow: (Ev4rs.isRedoing.value) ? true : false,
                    imagePath: 'assets/interface_icons/interface_icons/iRe-do.png', 
                    onPressed: () { setState(() {
                      Ev4rs.redoAction(root);
                    });
                    }
                  );
                    }),
                  ),
                  ),
                  //print
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04,
                child:
                  ButtonStyle1(
                    imagePath: 'assets/interface_icons/interface_icons/iPrint.png', 
                    onPressed: () { setState(() {
                      Ev4rs.isPrinting.value = !Ev4rs.isPrinting.value;
                    });
                    }
                  ),
                  ),
                  ),
                ]
                ),
              ),
              
              //
              //expand/collapse + board settings
              //
              Column( children:[
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(7, 7, 7, 0),
                  child: SizedBox( 
                    height: (isLandscape) ? MediaQuery.of(context).size.height * 0.07 : MediaQuery.of(context).size.height * 0.04,
                    child: (Ev4rs.isButtonExpanded.value) 
                    ? ButtonStyle1(
                        imagePath: 'assets/interface_icons/interface_icons/iCollapse.png', 
                        onPressed: () { 
                          setState(() {
                            Ev4rs.isButtonExpanded.value = false;
                          });
                        }
                      ) 
                    : ButtonStyle1(
                        imagePath: 'assets/interface_icons/interface_icons/iExpand.png', 
                        onPressed: () { 
                          setState(() {
                            Ev4rs.isButtonExpanded.value = true;
                          });
                        }
                      ) 
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(7, 0, 7, 7),
                  child: SizedBox( 
                    height: (isLandscape) ? MediaQuery.of(context).size.height * 0.08 : MediaQuery.of(context).size.height * 0.04 ,
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(10), child: 
                       ButtonStyle1(
                          glow: (Ev4rs.boardEditor.value) ? true : false,
                          imagePath: 'assets/interface_icons/interface_icons/iBoard.png', 
                          onPressed: () { setState(() {
                            Ev4rs.editBoardsAction(root);
                          });
                          }
                        ) 
                      ),
                    ),
                  ),
              ]
              )
            ]
            ),
        //here
        Positioned(
          top: (isLandscape) ? MediaQuery.of(context).size.height * 0.08 : MediaQuery.of(context).size.height * 0.04,
          child: ValueListenableBuilder<bool>(valueListenable: Ev4rs.showSelectionMenu, builder: (context, showSelectionMenu, _) {
          return SizedBox( 
            height: (isLandscape) ? MediaQuery.of(context).size.height * 0.09 : MediaQuery.of(context).size.height * 0.04,
            child:  Padding(padding: EdgeInsetsGeometry.all(7), child:
          Row(
            children: [
              //tap
            if (Ev4rs.isButtonExpanded.value == false)
                ButtonStyle1(
                imagePath: 'assets/interface_icons/interface_icons/iTap.png', 
                onPressed: () { setState(() {
                  Ev4rs.showSelectionMenu.value = !Ev4rs.showSelectionMenu.value;
                });
                }
              ),

            //tap and swap
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.tapAndSwap) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iTapAndSwap.png', 
                  onPressed: () { setState(() {
                    Ev4rs.tapAndSwapAction(root);
                  });
                  }
                ),

            //drag to select multiple
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.dragSelectMultiple.value) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iDragSelectMultiple.png', 
                  onPressed: () { setState(() {
                    Ev4rs.dragSelectMultipleAction(root);
                  });
                }
              ),

            //select multiple
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.selectMultiple.value) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iSelectMultiple.png', 
                  onPressed: () { setState(() {
                    Ev4rs.selectMultipleAction(root);
                  });
                }
              ),

            //invert selection
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
              ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.invertSelections, 
                    builder: (context, inverting, _) { 
                return ButtonStyle1(
                  glow: (Ev4rs.invertSelections.value) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iInvertSelection.png', 
                  onPressed: () { 
                    setState(() {
                      Ev4rs.invertSelectionAction(root);
                    });
                  }
                );
              }),

            //sort a-z
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
              ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.sortSelectAZ, 
                    builder: (context, inverting, _) {
                return ButtonStyle1(
                glow: (Ev4rs.sortSelectAZ.value) ? true : false,
                imagePath: 'assets/interface_icons/interface_icons/iSortAZ.png', 
                onPressed: () { setState(() {
                  Ev4rs.sortSelectedAzAction(root);
                });
                }
              );}),

          ]
          ),
            ),
          );
        }
        )
        )
        ]
        );
      }
    }

    class MultiNavButtonEditor extends StatefulWidget{
      final void Function(Root root, List<String> objUUID, String field, dynamic value) saveField;
      final NavObjects obj;
      final Root root;
      const MultiNavButtonEditor({
        super.key,
        required this.root,
        required this.saveField,
        required this.obj,
      });

      @override
      State<MultiNavButtonEditor> createState() => _MultiNavButtonEditor();
    }

    class _MultiNavButtonEditor extends State<MultiNavButtonEditor>{
      final ImagePicker _picker = ImagePicker();
      var everyImage = <String>[];

      @override
      Widget build(BuildContext context) {
        Root root = widget.root;
        final screenSize = MediaQuery.of(context).size;
        final isLandscape = screenSize.width > screenSize.height;


            everyImage = Ev4rs.getAllImages(root);
          

            final obj_ = Ev4rs.findNavById(root.navRow, Ev4rs.navSelectedUUID);
            if (obj_ == null) {
              return const Center(child: Text("Object not found"));
            }

            Ev4rs.setNavPlacholderValues(obj_);
            
            var allBoards = Ev4rs.getBoards(root.boards);

            final mapOfBoards = {
              for (var board in allBoards) 
                if (board.title != null) 
                  board.title!: board.id,
            };

            Widget image = LoadImage.fromSymbol('assets/interface_icons/interface_icons/iPlaceholder.png');
            Widget image2 = LoadImage.fromSymbol(obj_.symbol);

        return Stack( children: [
              

            Row( 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              //
              //back, in positioned is the tap expander
              //
              Padding(padding: EdgeInsetsGeometry.all(7),
              child: SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.065 : MediaQuery.of(context).size.height * 0.03 ,
                child: ButtonStyle1(
                  imagePath: 'assets/interface_icons/interface_icons/iBack.png', 
                  onPressed: () {
                  setState(() {
                    Ev4rs.closeEditorAction();
                  });
                  }
                ),
              ),
              ),

              //
              //Image, image padding, image overlay settings
              //
              ValueListenableBuilder(
                valueListenable: CombinedValueNotifier(
                    Ev4rs.padding, Ev4rs.overlay, Ev4rs.contrast, 
                    Ev4rs.invert, Ev4rs.saturation, Ev4rs.matchContrast, 
                    Ev4rs.matchInvert, Ev4rs.matchOverlay, Ev4rs.matchSaturation
                  ), 
                builder: (context, values, _) {
              return Expanded(flex: 8, child: 
                Column( children:[
                  //
                  //image
                  //
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                          Container(
                            width: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                              color: Cv4rs.themeColor4,
                              borderRadius: BorderRadius.circular(10)
                              ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(child: Padding(padding: EdgeInsetsGeometry.all(Ev4rs.padding.value), 
                                  child: (!Ev4rs.compareNavObjFields(root.navRow, (b) => b.symbol)) ?
                                  Column(children: [
                                    Text('--Not All Match--', style: Sv4rs.settingslabelStyle),
                                    ImageStyle1(
                                        image: image, 
                                        symbolSaturation: Bv4rs.buttonSymbolSaturation, 
                                        symbolContrast: Bv4rs.buttonSymbolContrast, 
                                        invertSymbolColors: Bv4rs.buttonSymbolInvert, 
                                        overlayColor: Bv4rs.buttonSymbolColorOverlay, 
                                        matchOverlayColor: true, 
                                        matchSymbolContrast: true, 
                                        matchSymbolInvert: true, 
                                        matchSymbolSaturation: true,
                                        defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
                                        defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
                                        defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
                                        defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
                                      ) 
                                    ]
                                    )
                                  : ImageStyle1(
                                      image: image2, 
                                      symbolSaturation: obj_.symbolSaturation ?? 1.0, 
                                      symbolContrast: obj_.symbolContrast ?? 1.0, 
                                      invertSymbolColors: obj_.invertSymbol ?? false, 
                                      overlayColor: obj_.overlayColor ?? Colors.white,
                                      
                                      matchOverlayColor: 
                                        (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchOverlayColor) 
                                        && (Ev4rs.compareNavObjFields(root.navRow, (b) => b.overlayColor)))
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      matchSymbolContrast:
                                        (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchSymbolContrast)
                                        && Ev4rs.compareNavObjFields(root.navRow, (b) => b.symbolContrast)) 
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      matchSymbolInvert:  
                                        (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchInvertSymbol)
                                        && Ev4rs.compareNavObjFields(root.navRow, (b) => b.invertSymbol)) 
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      matchSymbolSaturation: 
                                        (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchSymbolSaturation)
                                        && Ev4rs.compareNavObjFields(root.navRow, (b) => b.symbolSaturation)) 
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      
                                      defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
                                      defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
                                      defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
                                      defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
                                      )
                                  ),
                                ),
                                Flexible(child: 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                        SizedBox( 
                                          width: MediaQuery.of(context).size.height * 0.08,
                                          child: ButtonStyle3(
                                            imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                            onPressed: () async {
                                              Ev4rs.multiNavPickImage(widget.saveField, root, _picker);
                                              if (everyImage.isNotEmpty) {
                                             // await Ev4rs.cleanupUnusedImages(everyImage);
                                              } 
                                            }, 
                                            label: 'Photo Lib'
                                          ),
                                        ),
                                      ),
                                  Visibility(
                                    visible: false,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                    SizedBox( 
                                      width: MediaQuery.of(context).size.height * 0.07,
                                      child: ButtonStyle3(
                                      imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                      onPressed: () async {
                                        Ev4rs.multiNavPickImage(widget.saveField, root, _picker);
                                          if (everyImage.isNotEmpty) {
                                           // await Ev4rs.cleanupUnusedImages(everyImage);
                                          } 
                                      }, 
                                      label: 'App Lib'
                                      )
                                    ),
                                  ),
                                  ),
                              ]
                              )
                              ),
                            ]),
                          ),
                  ),

                  //
                  //padding
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox( 
                    width: MediaQuery.of(context).size.height * 0.25,
                    child: 
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(10), child: 
                        Column(children: [
                          (Ev4rs.compareNavObjFields(root.navRow, (b) => b.padding)) 
                        ? Text('Image Padding: ${Ev4rs.padding.value}', style: Sv4rs.settingslabelStyle,)
                        : Text('Image Padding: --Not All Match--', style: Sv4rs.settingslabelStyle,),
                        Slider(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              value: Ev4rs.padding.value,
                              min: 0.0,
                              max: 10.0,
                              divisions: 11,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Image Padding: ${Ev4rs.padding.value}',
                              onChanged: (value) {
                                Ev4rs.padding.value = value.roundToDouble();
                              }
                          ),
                        ])
                        ),
                        ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'padding', Ev4rs.padding.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save Padding'
                          ),
                        ]),
                    ),
                  ),
                  ),

                  //
                  //symbolColors
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox(
                    child:
                  SymbolColorCustomizer2(
                    specialLabel: 
                      (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchSymbolContrast) 
                      && Ev4rs.compareNavObjFields(root.navRow, (b) => b.symbolContrast)
                      && Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchInvertSymbol) 
                      && Ev4rs.compareNavObjFields(root.navRow, (b) => b.invertSymbol)
                      && Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchSymbolSaturation) 
                      && Ev4rs.compareNavObjFields(root.navRow, (b) => b.symbolSaturation)
                      && Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchOverlayColor) 
                      && Ev4rs.compareNavObjFields(root.navRow, (b) => b.overlayColor)
                      ) 
                      ? false 
                      : true,
                    widgety: 
                    ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'matchOverlayColor', Ev4rs.matchOverlay.value);
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'overlayColor', Ev4rs.overlay.value);
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'matchSymbolSaturation', Ev4rs.matchSaturation.value);
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'symbolSaturation', Ev4rs.saturation.value);
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'matchSymbolContrast', Ev4rs.matchContrast.value);
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'symbolContrast', Ev4rs.contrast.value);
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'matchInvertSymbol', Ev4rs.matchInvert.value);
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'invertSymbol', Ev4rs.invert.value);
                              
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save Adjustments'
                          ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    additionalHeight: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.height * 0.25,
                    invert: Ev4rs.invert.value, 
                    overlay: Ev4rs.overlay.value,
                    saturation: Ev4rs.saturation.value, 
                    contrast: Ev4rs.contrast.value, 
                    
                    matchContrast: 
                    (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchSymbolContrast) 
                    && Ev4rs.compareNavObjFields(root.navRow, (b) => b.symbolContrast)) 
                    ? Ev4rs.matchContrast.value
                    : true,
                    matchInvert: 
                    (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchInvertSymbol) 
                    && Ev4rs.compareNavObjFields(root.navRow, (b) => b.invertSymbol)) 
                    ? Ev4rs.matchInvert.value
                    : true,
                    matchOverlay: 
                    (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchOverlayColor) 
                    && Ev4rs.compareNavObjFields(root.navRow, (b) => b.overlayColor)) 
                    ? Ev4rs.matchOverlay.value
                    : true,
                    matchSaturation: 
                    (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchSymbolSaturation) 
                    && Ev4rs.compareNavObjFields(root.navRow, (b) => b.symbolSaturation)) 
                    ? Ev4rs.matchSaturation.value
                    : true,
                    
                    onContrastChanged: (value){
                      Ev4rs.contrast.value = value;
                    }, 
                    onInvertChanged: (value){
                      Ev4rs.invert.value = value;
                    },
                    onOverlayChanged: (value){
                      Ev4rs.overlay.value = value;
                    },
                    onSaturationChanged: (value){
                      Ev4rs.saturation.value = value;
                    },
                    onMatchContrastChanged: (value){
                      Ev4rs.matchContrast.value = value;
                    }, 
                    onMatchInvertChanged: (value){
                      Ev4rs.matchInvert.value = value;
                    },
                    onMatchOverlayChanged: (value){
                      Ev4rs.matchOverlay.value = value;
                    },
                    onMatchSaturationChanged: (value){
                      Ev4rs.matchSaturation.value = value;
                    },
                    )
                  )
                  ),
                
                ]
                ),
              );
              }
            ),
              
              //
              //label, message, speak on select, font
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //label and message
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                                 ValueListenableBuilder(valueListenable: Ev4rs.notes, builder: (context, value, _) {
                          final labelController = TextEditingController(text: value)
                          ..selection = TextSelection.collapsed(offset: value.length);

                          return 
                        TextField(
                          controller: labelController,
                                style: Ev4rs.labelStyle,
                                onChanged: (value){
                                  Ev4rs.label.value = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Ev4rs.hintLabelStyle,
                                hintText: (Ev4rs.compareNavObjFields(root.navRow, (b) => (b).label)) ? '${obj_.label}' : '--Not All Match--',
                                ),
                              );
                                 }),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'label', Ev4rs.label.value);
                              Ev4rs.saveJson(root);
                              });
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                        Row(children: [ 
                        Expanded(
                          flex: 5,
                          child: 
                        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                             ValueListenableBuilder(valueListenable: Ev4rs.notes, builder: (context, value, _) {
                          final alternateController = TextEditingController(text: value)
                          ..selection = TextSelection.collapsed(offset: value.length);

                          return 
                        TextField(
                          controller: alternateController,
                            style: Ev4rs.labelStyle,
                            onChanged: (value){
                              Ev4rs.alternateLabel.value = value;
                            },
                            decoration: InputDecoration(
                            hintStyle: Ev4rs.hintLabelStyle,
                            hintText: (Ev4rs.compareNavObjFields(root.navRow, (b) => (b).alternateLabel)) ? '${obj_.alternateLabel}' : '--Not All Match--',
                            ),
                          );
                             }),
                        ),
                        ),
                        Flexible(
                          flex: 2,
                          child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                        ButtonStyle4(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              Ev4rs.message.value = '${Ev4rs.message.value.trim()} ';
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'alternateLabel', Ev4rs.alternateLabel.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                          ),
                          ),
                        ),
                      ]
                      ),
                    ]
                    )
                    )
                    ),
                  //match speak on select, speak on select
                  Padding(padding: EdgeInsetsGeometry.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchSpeakOnSelect, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(child: 
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(10, 10, 10, 0), 
                                child: Text( (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchSpeakOS)) ?
                                  'Match Speak on Select:' : 'Match Speak on Select: --Not All Match--', 
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchSpeakOnSelect.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchSpeakOnSelect.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.speakOnSelect, 
                          builder: (context, speakOnSelect, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.all(10), 
                              child: Column(children: [
                                if (!Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchSpeakOS)) 
                                  Text('Speak on Select: --Not All Match--', style: Sv4rs.settingslabelStyle),
                                Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 1.0,
                                  max: 3.0,
                                  divisions: 2,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 
                                    (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchSpeakOS)) 
                                    ? 'Speak on Select: ${Ev4rs.speakOnSelect.value}'
                                    : 'Speak on Select: --Not All Match--',
                                  value: Ev4rs.speakOnSelect.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.speakOnSelect.value = value.toInt();
                                    }
                                  ),
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10), 
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                    Expanded(child: 
                                      Text(
                                        "Off", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Label", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Alt. Label", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ]
                                  ), 
                                ),
                                ButtonStyle2(
                                  imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                                  onPressed: (){setState(() {
                                      widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'matchSpeakOS', Ev4rs.matchSpeakOnSelect.value);
                                      widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'speakOS', Ev4rs.speakOnSelect.value);
                                      Ev4rs.saveJson(root);
                                      });
                                  }, 
                                  label: 'Save'
                                ),
                              ]
                            ),
                            );
                          }
                        ),
                        
                      ]
                    )
                    )
                  ),
                  //font, match font settings, font picker
                  Padding(
                      padding: EdgeInsetsGeometry.all(10), 
                      child: FontPicker2(
                        widgety:  ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){setState(() {
                                widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'matchFont', Ev4rs.matchFont.value);
                                widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'fontSize', Ev4rs.fontSize.value);
                                widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'fontItalics', Ev4rs.fontItalics.value);
                                widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'fontUnderline', Ev4rs.fontUnderline.value);
                                widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'fontWeight', Ev4rs.fontWeight.value.toInt(),);
                                widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'fontFamily', Ev4rs.fontFamily.value);
                                widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'fontColor', Ev4rs.fontColor.value);
                                Ev4rs.saveJson(root);
                                });
                            }, 
                            label: 'Save Button Font'
                            ),
                            specialLabel: 
                              (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchFont) 
                              || Ev4rs.compareNavObjFields(root.navRow, (b) => b.fontSize)
                              || Ev4rs.compareNavObjFields(root.navRow, (b) => b.fontItalics)
                              || Ev4rs.compareNavObjFields(root.navRow, (b) => b.fontUnderline)
                              || Ev4rs.compareNavObjFields(root.navRow, (b) => b.fontWeight)
                              || Ev4rs.compareNavObjFields(root.navRow, (b) => b.fontFamily)
                              || Ev4rs.compareNavObjFields(root.navRow, (b) => b.fontColor)) 
                              ? false 
                              : true,
                            matchFontSet: Ev4rs.matchFont.value,
                            height: MediaQuery.of(context).size.height * 0.3,
                            size: Ev4rs.fontSize.value, 
                            sizeMax: 25,
                            sizeMin: 5,
                            divisions: 20,
                            weight: (Ev4rs.fontWeight.value).toInt(), 
                            italics: Ev4rs.fontItalics.value, 
                            font: Ev4rs.fontFamily.value, 
                            label: 'Button Font:', 
                            color: Ev4rs.fontColor.value, 
                            underline: Ev4rs.fontUnderline.value,
                            onSizeChanged: (value) {
                              Ev4rs.fontSize.value = value;
                              }, 
                            onWeightChanged: (value) {
                              Ev4rs.fontWeight.value = value.toDouble();
                              },
                            onItalicsChanged: (value) {
                              Ev4rs.fontItalics.value = value;
                              },
                            onFontChanged: (value) {
                              Ev4rs.fontFamily.value = value;
                              },
                            onColorChanged: (value) {
                              Ev4rs.fontColor.value = value.toColor() ?? Cv4rs.themeColor1;
                              },
                            onMatchFont: (value) {
                              Ev4rs.matchFont.value = value;
                              },
                            useUnderline: true, 
                            onUnderlineChanged: (value) {
                              Ev4rs.fontUnderline.value = value;
                              }, 
                            )
                          ),
                ]
              ),
              ),
              
              //
              //show, format, border, background
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  
                  //
                  //show button
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container( 
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.show, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(
                                child: Text(
                                  (Ev4rs.compareNavObjFields(root.navRow, (b) => b.show)) 
                                    ? 'Show Button:'
                                    : 'Show Button: --Not All Match--', 
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.show.value, 
                                  onChanged: (value) {
                                    Ev4rs.show.value = value;
                                  }
                                ),
                              ),
                              ]
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'show', Ev4rs.show.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                  
                  //
                  //format
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container(
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchFormat, 
                          builder: (context, matchFormat, _) {
                            return Row(children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0), 
                                    child: Text(
                                      (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchFormat)) 
                                        ? 'Match Format:'
                                        : 'Match Format: --Not All Match--',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchFormat.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchFormat.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.format, 
                          builder: (context, format, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(5, 15, 5, 10), 
                              child: Column(children: [
                                      Text(
                                        "Format: ${ Ev4rs.compareNavObjFields(root.navRow, (b) => b.format) 
                                          ? (Ev4rs.format.value == 1 ? 
                                              'Text Below' 
                                            : Ev4rs.format.value == 2 ? 
                                              'Text Above' 
                                            : Ev4rs.format.value == 3 ? 
                                              'Image Only' 
                                            : Ev4rs.format.value == 4 ? 
                                              'Text Only' 
                                            : '') 
                                          : '--Not All Match--'
                                          }", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                Slider(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  min: 1.0,
                                  max: 4.0,
                                  divisions: 3,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  value: Ev4rs.format.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.format.value = value.toInt();
                                    }
                                  ),
                                ]
                            ),
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'matchFormat', Ev4rs.matchFormat.value);
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'format', Ev4rs.format.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  //
                  //border
                  //

                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        //match border 
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchBorder, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 10, 3, 20), 
                                    child: Text(
                                      (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchBorder)) 
                                        ? 'Match Border: '
                                        : 'Match Border: --Not All Match--', 
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchBorder.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchBorder.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),

                        //border weight 
                        ValueListenableBuilder<double>(
                          valueListenable: Ev4rs.borderWeight, 
                          builder: (context, borderWeight, _) {
                            return Column(children: [
                            Text(
                              (Ev4rs.compareNavObjFields(root.navRow, (b) => b.borderWeight)) 
                              ? 'Border Weight: ${Ev4rs.borderWeight.value}'
                              : 'Border Weight: --Not All Match--',
                              style: Sv4rs.settingslabelStyle),
                            Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 0.0,
                                  max: 10.0,
                                  divisions: 20,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 
                                    (Ev4rs.compareNavObjFields(root.navRow, (b) => b.borderWeight)) 
                                      ? 'Border Weight: ${Ev4rs.borderWeight}'
                                      : 'Border Weight: --Not All Match--',
                                  value: Ev4rs.borderWeight.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.borderWeight.value = value;
                                    }
                            )
                            ]
                                  );
                          }
                        ),

                        //border color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.borderColor, 
                          builder: (context, borderColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                  Text(
                                    (Ev4rs.compareNavObjFields(root.navRow, (b) => b.borderColor)) 
                                      ? 'Border Color: '
                                      : 'Border Weight: --Not All Match--', 
                                    style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.borderColor.value, size: 40, shadows: [
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
                                startValue: Ev4rs.borderColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.borderColor.value = color;
                                },
                              ),
                            ),
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
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.borderColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.borderColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'borderWeight', Ev4rs.borderWeight.value);
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'matchBorder', Ev4rs.matchBorder.value);
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'borderColor', Ev4rs.borderColor.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  //background
                  
                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [

                        //match border 
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchBackground, 
                          builder: (context, matchBackground, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 10), 
                                    child: Text(
                                      (Ev4rs.compareNavObjFields(root.navRow, (b) => b.matchPOS)) 
                                        ? 'Background Color:'
                                        : 'Background Color: --Not All Match--',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchBackground.value,
                                  onChanged: (value) {
                                    Ev4rs.matchBackground.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),

                        //border color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.backgroundColor, 
                          builder: (context, backgroundColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                Text((Ev4rs.compareNavObjFields(root.navRow, (b) => b.backgroundColor)) 
                                  ? 'Background Color: '
                                  : 'Background Color: --Not All Match--', 
                                  style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.backgroundColor.value, size: 40, shadows: [
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
                                startValue: Ev4rs.backgroundColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.backgroundColor.value = color;
                                },
                              ),
                            ),
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
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.backgroundColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.backgroundColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'matchPOS', Ev4rs.matchBackground.value);
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'backgroundColor', Ev4rs.backgroundColor.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                ]
                ),
              ),
              
              //
              //pos, button type -> link, return after select, grammer func, mp3
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //part of speech
                  
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: SizedBox( child:
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.pos, 
                          builder: (context, pos, _) {
                            return 
                          Column(children: [
                            SizedBox(child:
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text((Ev4rs.compareNavObjFields(root.navRow, (b) => b.pos)) 
                                  ? 'Part of Speech:'
                                  : 'Part of Speech: --Not All Match--', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10), child:
                            DropdownButton<String>(
                              isExpanded: true,
                              hint: SizedBox(child: Text(
                                'Part of Speech:', 
                                style: Sv4rs.settingslabelStyle,
                                ),),
                              value: Ev4rs.pos.value.toLowerCase(),
                              items: Gv4rs.partOfSpeechList.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: SizedBox(child: Text(
                                    item,
                                    style: Sv4rs.settingslabelStyle,
                                    overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                  Ev4rs.pos.value = value;
                                }
                                }
                            ),
                            ),
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'pos', Ev4rs.pos.value);
                              Ev4rs.saveJson(root);
                              });
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                
                  ),
                    ),
                  ),
                 
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.link, 
                          builder: (context, link, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                (Ev4rs.compareNavObjFields(root.navRow, (b) => b.linkToUUID)) 
                                  ? 'Link To...'
                                  : 'Link To... --Not All Match--', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                            DropdownButton<String>(
                              isExpanded: true,
                                hint: Text(
                                  'link to...', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.link.value,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: Text('none', style: Sv4rs.settingslabelStyle),
                                  ),
                                ...mapOfBoards.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                })
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.link.value = value;
                                    Ev4rs.linkLabel.value = mapOfBoards.entries.firstWhere((element) => element.value == value).key;
                                  }
                                },
                              ),
                          ),
                            //save 
                            ButtonStyle2(
                              imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                              onPressed: (){ setState(() {
                                  widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'linkToUUID', Ev4rs.link.value);
                                  widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'linkToLabel', Ev4rs.linkLabel.value);
                                  Ev4rs.saveJson(root);
                                  });
                              }, 
                              label: 'Save'
                            ),
                          ]);
                        }),
                      ),
                    ),

                  //notes
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10), child: 
                              ValueListenableBuilder(valueListenable: Ev4rs.notes, builder: (context, value, _) {
                          final notesController = TextEditingController(text: value)
                          ..selection = TextSelection.collapsed(offset: value.length);

                          return 
                        TextField(
                          controller: notesController,
                                minLines: 1,
                                maxLines: 5,
                                style: Sv4rs.settingslabelStyle,
                                onChanged: (value){
                                  Ev4rs.notes.value = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Sv4rs.settingslabelStyle,
                                hintText: (Ev4rs.compareNavObjFields(root.navRow, (b) => b.note)) 
                                  ? 'Notes... ${Ev4rs.notes.value}'
                                  : 'Notes... --Not All Match--',
                                ),
                              );
                              }),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){setState(() {
                              widget.saveField(root, Ev4rs.navSelectedUUIDs.value, 'note', Ev4rs.notes.value);
                                Ev4rs.saveJson(root);
                                });
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                    ]
                      
                    )
                    )
                    ),

                ]
                ),
              ),
              
              //
              //undo + share
              //
              Expanded(flex: 2, child: 
                Column( children:[
                  //undo
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                child: ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.isUndoing, 
                    builder: (context, inverting, _) {
                return 
                  ButtonStyle1(
                    glow: (Ev4rs.isUndoing.value) ? true : false,
                    imagePath: 'assets/interface_icons/interface_icons/iUndo.png', 
                    onPressed: () { setState(() {
                      Ev4rs.undoAction(root);
                    });
                    }
                  );
                  }),
                  ),
                  ),

                  //share
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04,
                child:
                  ButtonStyle1(
                    imagePath: 'assets/interface_icons/interface_icons/iExport.png', 
                    onPressed: () { setState(() {
                      Ev4rs.isExporting.value = !Ev4rs.isExporting.value;
                    });
                    }
                  ), 
                  ),
                  ),
                ]
                ),
              ),
              
              //
              //redo + print
              //
              Expanded(flex: 2, child: 
                Column( children:[
                  //redo
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04,
                child: ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.isRedoing, 
                    builder: (context, inverting, _) {
                return 
                  ButtonStyle1(
                    glow: (Ev4rs.isRedoing.value) ? true : false,
                    imagePath: 'assets/interface_icons/interface_icons/iRe-do.png', 
                    onPressed: () { setState(() {
                      Ev4rs.redoAction(root);
                    });
                    }
                );
                    }),
                  ),
                  ),
                  //print
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                child:
                  ButtonStyle1(
                    imagePath: 'assets/interface_icons/interface_icons/iPrint.png', 
                    onPressed: () { setState(() {
                      Ev4rs.isPrinting.value = !Ev4rs.isPrinting.value;
                    });
                    }
                  ),
                  ),
                  ),
                ]
                ),
              ),
              
              //
              //expand/collapse + board settings
              //
              Column( children:[
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(7, 7, 7, 0),
                  child: SizedBox( 
                    height: (isLandscape) ? MediaQuery.of(context).size.height * 0.07 : MediaQuery.of(context).size.height * 0.04,
                    child: (Ev4rs.isButtonExpanded.value) 
                    ? ButtonStyle1(
                        imagePath: 'assets/interface_icons/interface_icons/iCollapse.png', 
                        onPressed: () { 
                          setState(() {
                            Ev4rs.isButtonExpanded.value = false;
                          });
                        }
                      ) 
                    : ButtonStyle1(
                        imagePath: 'assets/interface_icons/interface_icons/iExpand.png', 
                        onPressed: () { 
                          setState(() {
                            Ev4rs.isButtonExpanded.value = true;
                          });
                        }
                      ) 
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(7, 0, 7, 7),
                  child: SizedBox( 
                    height: (isLandscape) ? MediaQuery.of(context).size.height * 0.08 : MediaQuery.of(context).size.height * 0.04 ,
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(10), child: 
                       ButtonStyle1(
                          glow: (Ev4rs.boardEditor.value) ? true : false,
                          imagePath: 'assets/interface_icons/interface_icons/iBoard.png', 
                          onPressed: () { setState(() {
                            Ev4rs.editBoardsAction(root);
                          });
                          }
                        ) 
                      ),
                    ),
                  ),
              ]
              )
            ]
            ),
        //here
        Positioned(
          top: (isLandscape) ? MediaQuery.of(context).size.height * 0.08 : MediaQuery.of(context).size.height * 0.04,
          child: ValueListenableBuilder<bool>(valueListenable: Ev4rs.showSelectionMenu, builder: (context, showSelectionMenu, _) {
          return SizedBox( 
            height: (isLandscape) ? MediaQuery.of(context).size.height * 0.09 : MediaQuery.of(context).size.height * 0.04,
            child:  Padding(padding: EdgeInsetsGeometry.all(7), child:
          Row(
            children: [
              //tap
            if (Ev4rs.isButtonExpanded.value == false)
                ButtonStyle1(
                imagePath: 'assets/interface_icons/interface_icons/iTap.png', 
                onPressed: () { setState(() {
                  Ev4rs.showSelectionMenu.value = !Ev4rs.showSelectionMenu.value;
                });
                }
              ),

            //tap and swap
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.tapAndSwap) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iTapAndSwap.png', 
                  onPressed: ()  {
                    setState(() {
                      Ev4rs.tapAndSwapAction(root);
                    });
                  }
                ),

            //drag to select multiple
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.dragSelectMultiple.value) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iDragSelectMultiple.png', 
                  onPressed: () { 
                    setState(() {
                      Ev4rs.dragSelectMultipleAction(root);
                    });
                  }
                ),

            //select multiple
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.selectMultiple.value) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iSelectMultiple.png', 
                  onPressed: () { 
                    setState(() {
                      Ev4rs.selectMultipleAction(root);
                    });
                  }
                ),

            //invert selection

            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.invertSelections, 
                    builder: (context, inverting, _) {
              return ButtonStyle1(
                glow: (Ev4rs.invertSelections.value) ? true : false,
                imagePath: 'assets/interface_icons/interface_icons/iInvertSelection.png', 
                onPressed: () { setState(() {
                  Ev4rs.invertSelectionAction(root);
                });
                }
              );
                    }
                    ),

            //sort a-z
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
              ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.sortSelectAZ, 
                    builder: (context, sorting, _) {
              return ButtonStyle1(
                imagePath: 'assets/interface_icons/interface_icons/iSortAZ.png', 
                onPressed: () { setState(() {
                  Ev4rs.sortSelectedAzAction(root);
                });
                }
              );
                    })

          ]
          ),
            ),
          );
        }
        )
        )
        ]
        );
      }
    }