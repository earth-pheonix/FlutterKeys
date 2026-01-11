import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/settings/boardset_settings_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;

class BSSv4rs{
  static List<SpeakSelectBookmark> bookmarkedSS = [];
  static ValueNotifier<int> bookmarkedSSCount = ValueNotifier(0);

  static Future<void> savebookmarkedSSCount (int bookmarkedCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("bookmarkedSSCount", bookmarkedCount);
  } 
  
  static Future<void> savebookmarkedSS (List<SpeakSelectBookmark> bookmarkList) async {
    final prefs = await SharedPreferences.getInstance();

    int index = 0;
    for (final bookmark in bookmarkList){
      await prefs.setBool("bookmarkedSS-$index-interface", bookmark.interface);
      await prefs.setInt("bookmarkedSS-$index-nav", bookmark.nav);
      await prefs.setInt("bookmarkedSS-$index-grammer", bookmark.grammer);
      await prefs.setInt("bookmarkedSS-$index-subFolder", bookmark.subFolder);
      await prefs.setInt("bookmarkedSS-$index-button", bookmark.button);
      await prefs.setInt("bookmarkedSS-$index-typingKey", bookmark.typingKey);
      await prefs.setInt("bookmarkedSS-$index-folder", bookmark.folder);
      await prefs.setInt("bookmarkedSS-$index-audioTile", bookmark.audioTile);
      await prefs.setInt("bookmarkedSS-$index-pocketFolder", bookmark.pocketFolder);

      index++;
    }
  } 

  static void setBoomarkSS(){
    bookmarkedSS.add(
      SpeakSelectBookmark(
        interface: Sv4rs.speakInterfaceButtonsOnSelect, 
        nav: Bv4rs.navRowSpeakOnSelect, 
        grammer: Bv4rs.grammerRowSpeakOnSelect, 
        subFolder: Bv4rs.subFolderSpeakOnSelect, 
        button: Bv4rs.buttonSpeakOnSelect, 
        typingKey: Bv4rs.typingKeySpeakOnSelect, 
        pocketFolder: Bv4rs.pocketFolderSpeakOnSelect, 
        folder: Bv4rs.folderSpeakOnSelect, 
        audioTile: Bv4rs.audioTileSpeakOnSelect
      )
    );
    savebookmarkedSS(bookmarkedSS);
    bookmarkedSSCount.value = bookmarkedSS.length;
    savebookmarkedSSCount(bookmarkedSSCount.value);
  }

//delete
  static Future<void> deleteBookmarkedSS(int delete) async {
    bookmarkedSS.removeAt(delete);

    await clearBookmarkedSSPrefs();
    await savebookmarkedSS(bookmarkedSS);

    bookmarkedSSCount.value = bookmarkedSS.length;
    await savebookmarkedSSCount(bookmarkedSSCount.value);
  }

  static Future<void> clearBookmarkedSSPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final count = prefs.getInt('bookmarkedSSCount') ?? 0;

    for (int i = 0; i < count; i++) {
      await prefs.remove('bookmarkedSS-$i-interface');
      await prefs.remove('bookmarkedSS-$i-nav');
      await prefs.remove('bookmarkedSS-$i-grammer');
      await prefs.remove('bookmarkedSS-$i-subFolder');
      await prefs.remove('bookmarkedSS-$i-button');
      await prefs.remove('bookmarkedSS-$i-typingKey');
      await prefs.remove('bookmarkedSS-$i-pocketFolder');
      await prefs.remove('bookmarkedSS-$i-folder');
      await prefs.remove('bookmarkedSS-$i-audioTile');
    }
  }


//load
  static Future<void> loadSavedBookmarkedSSValues() async {
    final prefs = await SharedPreferences.getInstance();
    //clearBookmarkedSSPrefs();
    //await prefs.remove('bookmarkedSSCount');

    bookmarkedSSCount.value = prefs.getInt('bookmarkedSSCount') ?? 0;
    
    for (int i=0; i<(bookmarkedSSCount.value); i ++){
      bookmarkedSS.add(
        SpeakSelectBookmark(
          interface: prefs.getBool('bookmarkedSS-$i-interface') ?? false, 
          nav: prefs.getInt("bookmarkedSS-$i-nav") ?? 1, 
          grammer: prefs.getInt("bookmarkedSS-$i-grammer") ?? 1, 
          subFolder: prefs.getInt("bookmarkedSS-$i-subFolder") ?? 1, 
          button: prefs.getInt("bookmarkedSS-$i-button") ?? 1, 
          typingKey: prefs.getInt("bookmarkedSS-$i-typingKey") ?? 1, 
          pocketFolder: prefs.getInt("bookmarkedSS-$i-pocketFolder") ?? 1, 
          folder: prefs.getInt("bookmarkedSS-$i-folder") ?? 1, 
          audioTile: prefs.getInt("bookmarkedSS-$i-audioTile") ?? 1
        )
      );
    }
  }
}

class SpeakSelectBookmark{
  bool interface;
  int nav;
  int grammer;
  int subFolder;
  int button;
  int typingKey;
  int pocketFolder;
  int folder;
  int audioTile;

  SpeakSelectBookmark({
    required this.interface,
    required this.nav,
    required this.grammer,
    required this.subFolder,
    required this.button,
    required this.typingKey,
    required this.pocketFolder,
    required this.folder,
    required this.audioTile,
  });
}

class UiSpeakOnSelect extends StatefulWidget {
  final TTSInterface synth;
  final double totalWidth;
  
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

  const UiSpeakOnSelect({
    super.key, 
    required this.synth,
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,
    required this.totalWidth,
    });

  @override
  State<UiSpeakOnSelect> createState() => _UiSpeakOnSelect();
  
}

class _UiSpeakOnSelect extends State<UiSpeakOnSelect> with WidgetsBindingObserver {
  int deleteValue = 0;

  @override
  void initState() {
    super.initState();
  }


  Widget bookmarkButton() {
    return Padding(
        padding: EdgeInsetsGeometry.all(V4rs.paddingValue(5)), 
        child: ButtonStyle1(
          glow: true,
          padding: !V4rs.xSmallMode ? 5 : 15,
          imagePath: 'assets/interface_icons/interface_icons/iBookmark.png', 
          onPressed: (){
           BSSv4rs.setBoomarkSS();
          }
        ), 
    );
  }

  Widget deleteButton() {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Cv4rs.themeColor3,
      ),
      child: (BSSv4rs.bookmarkedSSCount.value >= 0)
        ? Row(
        children: [ 
            Padding(
              padding: EdgeInsetsGeometry.all(V4rs.paddingValue(10)), 
              child:Column(
              children: [
                SizedBox(width: !V4rs.xSmallMode? 90 : 60, child: 
                Text('Delete:', style: Sv4rs.settingslabelStyle),
                ),
                SizedBox(width: !V4rs.xSmallMode ? 90 : 60, child: 
                DropdownButton<int>(
                  hint: Text('###', style: Sv4rs.settingslabelStyle),
                  value: deleteValue,
                  isExpanded: true,
                  items: List.generate(
                    BSSv4rs.bookmarkedSSCount.value,
                    (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text('$index', style: Sv4rs.settingslabelStyle),
                      );
                    },
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value != null){
                        deleteValue = value;
                      }
                    });
                  },
                )
                ),
            ],
            ),
            ),
            SizedBox(width: !V4rs.xSmallModeWidth ? 50 : 30, child: 
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(0, V4rs.paddingValue(10), V4rs.paddingValue(10), V4rs.paddingValue(10)), 
              child: ButtonStyle1(
                glow: true,
                padding: 2,
                imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                onPressed: (){
                  BSSv4rs.deleteBookmarkedSS(deleteValue);
                  deleteValue = 0;
                }
              ), 
            ),
            )
          ]
      )
        : SizedBox.shrink()
    );
  }

  Widget bookmarkedRow(){
    return ValueListenableBuilder(
      valueListenable: BSSv4rs.bookmarkedSSCount, 
      builder: (context, count, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: !V4rs.xSmallMode ? 100 : 60, 
                  height: !V4rs.xSmallMode ? 60 : 50, 
                  child: bookmarkButton(),
                ),
                SizedBox(width: !V4rs.xSmallModeWidth ? 160 : 100, child: 
                deleteButton(),
                ),
                for (int i=0; i <(BSSv4rs.bookmarkedSS.length); i ++)...[
                  SizedBox(width: !V4rs.xSmallModeWidth ? 250 : 150, child: 
                  ButtonStyle2(
                    flex: 3,
                    maxLines: 3,
                    imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                    onPressed: (){
                      setState(() {
                        Sv4rs.speakInterfaceButtonsOnSelect = BSSv4rs.bookmarkedSS[i].interface;
                        Sv4rs.saveSpeakInterfaceButtonsOnSelect(BSSv4rs.bookmarkedSS[i].interface);
                        Bv4rs.navRowSpeakOnSelect = BSSv4rs.bookmarkedSS[i].nav;
                        Bv4rs.saveNavRowSpeakOnSelect(BSSv4rs.bookmarkedSS[i].nav);
                        Bv4rs.grammerRowSpeakOnSelect = BSSv4rs.bookmarkedSS[i].grammer; 
                        Bv4rs.savegrammerRowSpeakOnSelect(BSSv4rs.bookmarkedSS[i].grammer);
                        Bv4rs.subFolderSpeakOnSelect = BSSv4rs.bookmarkedSS[i].subFolder; 
                        Bv4rs.saveSubFolderSpeakOnSelect(BSSv4rs.bookmarkedSS[i].subFolder);
                        Bv4rs.buttonSpeakOnSelect = BSSv4rs.bookmarkedSS[i].button; 
                        Bv4rs.saveButtonSpeakOnSelect(BSSv4rs.bookmarkedSS[i].button);
                        Bv4rs.typingKeySpeakOnSelect = BSSv4rs.bookmarkedSS[i].typingKey; 
                        Bv4rs.savetypingKeySpeakOnSelect(BSSv4rs.bookmarkedSS[i].typingKey);
                        Bv4rs.pocketFolderSpeakOnSelect = BSSv4rs.bookmarkedSS[i].pocketFolder; 
                        Bv4rs.savepocketFolderSpeakOnSelect(BSSv4rs.bookmarkedSS[i].pocketFolder);
                        Bv4rs.folderSpeakOnSelect = BSSv4rs.bookmarkedSS[i].folder; 
                        Bv4rs.savefolderSpeakOnSelect(BSSv4rs.bookmarkedSS[i].folder);
                        Bv4rs.audioTileSpeakOnSelect = BSSv4rs.bookmarkedSS[i].audioTile; 
                        Bv4rs.saveaudioTileSpeakOnSelect(BSSv4rs.bookmarkedSS[i].audioTile);
                      });
                    },
                    label: '$i - (${BSSv4rs.bookmarkedSS[i].interface}, ${
                      BSSv4rs.bookmarkedSS[i].nav}, ${
                      BSSv4rs.bookmarkedSS[i].grammer}, ${
                      BSSv4rs.bookmarkedSS[i].subFolder}, ${
                      BSSv4rs.bookmarkedSS[i].button}, ${
                      BSSv4rs.bookmarkedSS[i].typingKey}, ${
                      BSSv4rs.bookmarkedSS[i].pocketFolder}, ${
                      BSSv4rs.bookmarkedSS[i].folder}, ${
                      BSSv4rs.bookmarkedSS[i].audioTile})' 
                  ),
                ),
                ], 
                SizedBox(width: widget.totalWidth - 160)
              ],
            ),
        );
      }
    );
  }
 
 @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Speak On Select:', style: Sv4rs.settingslabelStyle),
      collapsedBackgroundColor: Cv4rs.themeColor4,
      backgroundColor: Cv4rs.themeColor4,
      childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(20)),
      children: [
        Column(
          children: [
            
            //interface buttons
            Row(
              children: [
                Text('Interface Buttons:', style: Sv4rs.settingslabelStyle),
                Spacer(),
                Switch(
                  value: Sv4rs.speakInterfaceButtonsOnSelect, 
                  onChanged: (value) {
                    setState(() {
                      Sv4rs.speakInterfaceButtonsOnSelect = value;
                      Sv4rs.saveSpeakInterfaceButtonsOnSelect(value);
                    });
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                      V4rs.speakOnSelect(
                        'Interface speak on select $value', 
                        V4rs.selectedLanguage.value, 
                        widget.synth,
                        widget.speakSelectSherpaOnnxSynth,
                        widget.initForSS,
                        widget.playerForSS,
                      );
                    }
                  }
                )
              ]
            ),

            //nav row
            ExpansionTile(
              title: Text('Nav Row:', style: Sv4rs.settingslabelStyle),
              collapsedBackgroundColor: Cv4rs.themeColor4,
              backgroundColor: Cv4rs.themeColor4,
              childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(40)),
              children: [
                Column(children: [
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: Bv4rs.navRowSpeakOnSelect.toDouble(),
                          min: 1.0,
                          max: 3.0,
                          divisions: 2,
                          activeColor: Cv4rs.themeColor1,
                          inactiveColor: Cv4rs.themeColor3,
                          thumbColor: Cv4rs.themeColor1,
                          label: 'Nav Row SS: ${Bv4rs.navRowSpeakOnSelect}',
                          onChanged: (value) async {
                            setState(() {
                              Bv4rs.navRowSpeakOnSelect = value.toInt();
                              Bv4rs.saveNavRowSpeakOnSelect(value.toInt());
                            });
                          },
                        ),
                      ),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                      Text('Off', style: Sv4rs.settingslabelStyle),),
                      Spacer(flex: 3),
                      Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                      Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                      Spacer(flex: 3),
                      Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                      Text('Speak Alternate Label', style: Sv4rs.settingslabelStyle),),
                    ],
                  )
                 ]
                ),
              ]
            ),

            //grammer row
            ExpansionTile(
              title: Text('Grammer Row:', style: Sv4rs.settingslabelStyle),
              collapsedBackgroundColor: Cv4rs.themeColor4,
              backgroundColor: Cv4rs.themeColor4,
              childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(40)),
              children: [
              Column(children: [
                Row(children: [
                  Expanded(
                    child: Slider(
                      value: Bv4rs.grammerRowSpeakOnSelect.toDouble(),
                      min: 1.0,
                      max: 3.0,
                      divisions: 2,
                      activeColor: Cv4rs.themeColor1,
                      inactiveColor: Cv4rs.themeColor3,
                      thumbColor: Cv4rs.themeColor1,
                      label: 'Grammer SS: ${Bv4rs.grammerRowSpeakOnSelect}',
                      onChanged: (value) async {
                        setState(() {
                          Bv4rs.grammerRowSpeakOnSelect = value.toInt();
                          Bv4rs.savegrammerRowSpeakOnSelect(value.toInt());
                        });
                      },
                    ),
                  ),
                ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                    Text('Off', style: Sv4rs.settingslabelStyle),),
                    Spacer(flex: 3),
                    Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                    Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                    Spacer(flex: 3),
                    Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                    Text('Speak Change', style: Sv4rs.settingslabelStyle),),
                  ],
                )
              ]),
            ]
            ),
          
            //sub folders
            ExpansionTile(
              title: Text('Sub Folders:', style: Sv4rs.settingslabelStyle),
              collapsedBackgroundColor: Cv4rs.themeColor4,
              backgroundColor: Cv4rs.themeColor4,
              childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(40)),
              children: [
                Column(children: [
                  Row(children: [
                    Expanded(
                      child: Slider(
                        value: Bv4rs.subFolderSpeakOnSelect.toDouble(),
                        min: 1.0,
                        max: 3.0,
                        divisions: 2,
                        activeColor: Cv4rs.themeColor1,
                        inactiveColor: Cv4rs.themeColor3,
                        thumbColor: Cv4rs.themeColor1,
                        label: 'Sub Folder SS: ${Bv4rs.subFolderSpeakOnSelect}',
                        onChanged: (value) async {
                          setState(() {
                            Bv4rs.subFolderSpeakOnSelect = value.toInt();
                            Bv4rs.saveSubFolderSpeakOnSelect(value.toInt());
                          });
                        },
                      ),
                    ),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                      Text('Off', style: Sv4rs.settingslabelStyle),),
                      Spacer(flex: 3),
                      Expanded( flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                      Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                      Spacer(flex: 3),
                      Expanded( flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                      Text('Speak Alternate Label', style: Sv4rs.settingslabelStyle),),
                    ],
                  )
                 ]
                ),
              ]
            ),
              
            //board buttons
            ExpansionTile(
              title: Text('Board Buttons:', style: Sv4rs.settingslabelStyle),
              collapsedBackgroundColor: Cv4rs.themeColor4,
              backgroundColor: Cv4rs.themeColor4,
              childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(20)),
              children: [
                //button
                ExpansionTile(
                  title: Text('Button:', style: Sv4rs.settingslabelStyle),
                  collapsedBackgroundColor: Cv4rs.themeColor4,
                  backgroundColor: Cv4rs.themeColor4,
                  childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(40)),
                  children: [
                    Column(children: [
                      Row(children: [
                        Expanded(
                          child: Slider(
                            value: Bv4rs.buttonSpeakOnSelect.toDouble(),
                            min: 1.0,
                            max: 3.0,
                            divisions: 2,
                            activeColor: Cv4rs.themeColor1,
                            inactiveColor: Cv4rs.themeColor3,
                            thumbColor: Cv4rs.themeColor1,
                            label: 'Button SS: ${Bv4rs.buttonSpeakOnSelect}',
                            onChanged: (value) async {
                              setState(() {
                                Bv4rs.buttonSpeakOnSelect = value.toInt();
                                Bv4rs.saveButtonSpeakOnSelect(value.toInt());
                              });
                            },
                          ),
                        ),
                       ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Off', style: Sv4rs.settingslabelStyle),),
                          Spacer(flex: 3),
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                          Spacer(flex: 3),
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Speak Message ', style: Sv4rs.settingslabelStyle),),
                        ],
                      )
                      ]
                    ),
                   ]
                  ),
                //pocket folder
                ExpansionTile(
                  title: Text('Pocket Folder:', style: Sv4rs.settingslabelStyle),
                  collapsedBackgroundColor: Cv4rs.themeColor4,
                  backgroundColor: Cv4rs.themeColor4,
                  childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(40)),
                  children: [
                    Column(children: [
                      Row(children: [
                        Expanded(
                          child: Slider(
                            value: Bv4rs.pocketFolderSpeakOnSelect.toDouble(),
                            min: 1.0,
                            max: 3.0,
                            divisions: 2,
                            activeColor: Cv4rs.themeColor1,
                            inactiveColor: Cv4rs.themeColor3,
                            thumbColor: Cv4rs.themeColor1,
                            label: 'Pocket Folder SS: ${Bv4rs.pocketFolderSpeakOnSelect}',
                            onChanged: (value) async {
                              setState(() {
                                Bv4rs.pocketFolderSpeakOnSelect = value.toInt();
                                Bv4rs.savepocketFolderSpeakOnSelect(value.toInt());
                              });
                            },
                          ),
                        ),
                       ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Off', style: Sv4rs.settingslabelStyle),),
                          Spacer(flex: 3),
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                          Spacer(flex: 3),
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Speak Message ', style: Sv4rs.settingslabelStyle),),
                        ],
                      )
                      ]
                    ),
                  ]
                ),
                //folders
                ExpansionTile(
                  title: Text('Folders:', style: Sv4rs.settingslabelStyle),
                  collapsedBackgroundColor: Cv4rs.themeColor4,
                  backgroundColor: Cv4rs.themeColor4,
                  childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(40)),
                  children: [
                    Column(children: [
                      Row(children: [
                        Expanded(
                          child: Slider(
                            value: Bv4rs.folderSpeakOnSelect.toDouble(),
                            min: 1.0,
                            max: 3.0,
                            divisions: 2,
                            activeColor: Cv4rs.themeColor1,
                            inactiveColor: Cv4rs.themeColor3,
                            thumbColor: Cv4rs.themeColor1,
                            label: 'Folders SS: ${Bv4rs.folderSpeakOnSelect}',
                            onChanged: (value) async {
                              setState(() {
                                Bv4rs.folderSpeakOnSelect = value.toInt();
                                Bv4rs.savefolderSpeakOnSelect(value.toInt());
                              });
                            },
                          ),
                        ),
                      ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Off', style: Sv4rs.settingslabelStyle),),
                          Spacer(flex: 3),
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                          Spacer(flex: 3),
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Speak Message ', style: Sv4rs.settingslabelStyle),),
                        ],
                      )
                      ]
                    ),
                  ]
                ),
                //audio tile
                ExpansionTile(
                  title: Text('Audio Tile:', style: Sv4rs.settingslabelStyle),
                  collapsedBackgroundColor: Cv4rs.themeColor4,
                  backgroundColor: Cv4rs.themeColor4,
                  childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(40)),
                  children: [
                    Column(children: [
                      Row(children: [
                        Expanded(
                          child: Slider(
                            value: Bv4rs.audioTileSpeakOnSelect.toDouble(),
                            min: 1.0,
                            max: 3.0,
                            divisions: 2,
                            activeColor: Cv4rs.themeColor1,
                            inactiveColor: Cv4rs.themeColor3,
                            thumbColor: Cv4rs.themeColor1,
                            label: 'Audio Tile SS: ${Bv4rs.audioTileSpeakOnSelect}',
                            onChanged: (value) async {
                              setState(() {
                                Bv4rs.audioTileSpeakOnSelect = value.toInt();
                                Bv4rs.saveaudioTileSpeakOnSelect(value.toInt());
                              });
                            },
                          ),
                        ),
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Off', style: Sv4rs.settingslabelStyle),),
                          Spacer(flex: 3),
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                          Spacer(flex: 3),
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Speak Alternate Label ', style: Sv4rs.settingslabelStyle),),
                        ],
                      )
                      ]
                    ),
                  ]
                ),
                //typing button
                ExpansionTile(
                  title: Text('Typing Button:', style: Sv4rs.settingslabelStyle),
                  collapsedBackgroundColor: Cv4rs.themeColor4,
                  backgroundColor: Cv4rs.themeColor4,
                  childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(40)),
                  children: [
                    Column(children: [
                      Row(children: [
                        Expanded(
                          child: Slider(
                            value: Bv4rs.typingKeySpeakOnSelect.toDouble(),
                            min: 1.0,
                            max: 3.0,
                            divisions: 2,
                            activeColor: Cv4rs.themeColor1,
                            inactiveColor: Cv4rs.themeColor3,
                            thumbColor: Cv4rs.themeColor1,
                            label: 'Typing Button SS: ${Bv4rs.typingKeySpeakOnSelect}',
                            onChanged: (value) async {
                              setState(() {
                                Bv4rs.typingKeySpeakOnSelect = value.toInt();
                                Bv4rs.savetypingKeySpeakOnSelect(value.toInt());
                              });
                            },
                          ),
                        ),
                      ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Off', style: Sv4rs.settingslabelStyle),),
                          Spacer(flex: 3),
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                          Spacer(flex: 3),
                          Expanded(flex: V4rs.xSmallModeWidth ? 3 : 1, child:
                          Text('Speak Message ', style: Sv4rs.settingslabelStyle),),
                        ],
                      )
                      ]
                    ),
                  ]
                ),
              ]
            ),

            //bookmark row
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(0, 5, 0, 5),
              child: bookmarkedRow(),
            ),
          ]
        ),
      ]
    );
  }
}