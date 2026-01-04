import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutterkeysaac/Variables/colors/color_pickers.dart';
import 'dart:async';



class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  @override
  OnboardingState createState() => OnboardingState();

}

class OnboardingState extends State<Onboarding> with WidgetsBindingObserver {

final List<String> languageWords = ['Language', 'langue', 'Idioma', '语言'];
int _index = 0;

 @override
//says we want to start observing
void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _index = (_index + 1) % languageWords.length;
       });
      }
    );
  }

@override
void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

@override 
void didChangeAppLifecycleState(AppLifecycleState state) {}

void _showPopUp() {
  showDialog(
    context: context, 
   builder: (BuildContext context) {
    return AlertDialog(
      title: Text('One Second...', style: TextStyle(color: Cv4rs.themeColor1),),
      backgroundColor: Cv4rs.themeColor4,
      content: Text('Was your keyboard up when you pressed continue? This makes sure your AAC is formatted correctly', style: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),),
      actions: [
        TextButton(
          child: Text('Yes', style: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),), 
          onPressed: () async {
            Navigator.of(context).pop();
            setState(() {
              V4rs.doOnboarding.value = false; // Set onboarding as completed
              V4rs.showSettings.value = false;
            });
            await V4rs.setOnboardingCompleteStatus(V4rs.doOnboarding.value);
           } 
          ),
        TextButton(
          child: Text('No', style: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),), 
          onPressed: () => Navigator.of(context).pop(),),
      ],
    );
   }
   );
  }

Widget textField() {
  return Padding( 
    padding: EdgeInsetsGeometry.all(V4rs.paddingValue(20)),
    child: TextField(
      style: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),
      textAlign: TextAlign.center,
      decoration: InputDecoration( 
        hintText: 'Tap Here to show keyboard',
        hintStyle: TextStyle(color: Cv4rs.themeColor2, fontSize: 16),
      ),
    ),
  );
} 

Widget continueButton(){
  return Padding( 
    padding: EdgeInsetsGeometry.all(V4rs.paddingValue(30)),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Cv4rs.themeColor2),
      child: Text('Continue to App!', style: TextStyle(color: Cv4rs.themeColor4, fontSize: 16),),
      onPressed: () async {
        final mediaQuery = MediaQuery.of(context);
        final keyboardHeight = mediaQuery.viewInsets.bottom;

        V4rs.keyboardheight = keyboardHeight > 0 ? keyboardHeight : 250.0; //  default keyboard height?

        //save to shared preferences
        await V4rs.savekeyboardheight(keyboardHeight);
        _showPopUp();
      },
    ),
  );
}

@override
  Widget build (BuildContext context) {
    return Scaffold (
      backgroundColor: Cv4rs.themeColor4,
      body: Center(
        child: SingleChildScrollView(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //welcome to flutter keys
            Padding( 
             padding: EdgeInsetsGeometry.symmetric(
              horizontal: V4rs.paddingValue(15), 
              vertical: V4rs.paddingValue(30)
            ),
             child: Text(
              'Welcome to Flutterkeys!',
              textAlign: TextAlign.center,
              style: TextStyle( 
                color: Cv4rs.themeColor1,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            ),
            //language
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child,);
              },
              child: Text(
                textAlign: TextAlign.center,
                languageWords[_index],
                key: ValueKey<int>(_index), 
                style: TextStyle(
                  color: Cv4rs.themeColor1,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),

            DropdownButton<String>(
                value: V4rs.interfaceLanguage, 
                dropdownColor: Cv4rs.themeColor4,
                hint: Text('Language dropdown'),
                items: V4rs.allInterfaceLanguages.map((language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language, style: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),),
                    );
                  }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      V4rs.interfaceLanguage = value;
                      V4rs.saveInterfaceLang(value);
                      });
                    }
                  },
                ),
            
              
            //theme colors
            Padding(
              padding: EdgeInsetsGeometry.all(V4rs.paddingValue(20)),
              child: ExpansionTile(
                collapsedIconColor: Cv4rs.themeColor2,
                title: Text('Theme Colors:', style: TextStyle( 
                    color: Cv4rs.themeColor1,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    ),),
                collapsedBackgroundColor: Cv4rs.themeColor4,
                backgroundColor: Cv4rs.themeColor4,
                childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(20)),
                children: [
                  //theme color 1
                  ExpansionTile(
                    collapsedIconColor: Cv4rs.themeColor2,
                    title: Row(
                      children: [
                        Text('Theme Color 1:', style: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),),
                        const Spacer(),
                        CircleAvatar(
                          backgroundColor: Cv4rs.themeColor3,
                          radius: 20,
                          child: Icon(Icons.circle, color: Cv4rs.themeColor1, size: 40, shadows: [
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
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: V4rs.paddingValue(40), 
                          vertical: V4rs.paddingValue(20)
                        ),
                        child: HexCodeInput(
                          startValue: Cv4rs.themeColor1.toHexString(),
                          textStyle: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),
                          hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                          onColorChanged: (color) {
                            setState(() {
                                Cv4rs.themeColor1 = color;
                                Cv4rs.savethemecolorone(color);
                             });
                          },
                        ),
                      ),
                      //color picker
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          V4rs.paddingValue(40), 
                          V4rs.paddingValue(0), 
                          V4rs.paddingValue(10), 
                          V4rs.paddingValue(10)),
                        child: ColorPicker(
                          pickerColor: Cv4rs.themeColor1, 
                          enableAlpha: false,
                          displayThumbColor: false,
                          labelTypes: ColorLabelType.values,
                          onColorChanged:  (Color color) {
                              setState(() {
                                Cv4rs.themeColor1 = color;
                                Cv4rs.savethemecolorone(color);
                             });
                          },
                        ),
                     ),
                    ],
                  ),
                  //theme color 2
                  ExpansionTile(
                    collapsedIconColor: Cv4rs.themeColor2,
                    title: Row(
                      children: [
                        Text('Theme Color 2:', style: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),),
                        const Spacer(),
                        CircleAvatar(
                          backgroundColor: Cv4rs.themeColor3,
                          radius: 20,
                          child: Icon(Icons.circle, color: Cv4rs.themeColor2, size: 40, shadows: [
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
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: V4rs.paddingValue(40), 
                          vertical: V4rs.paddingValue(20)
                        ),
                        child: HexCodeInput(
                          startValue: Cv4rs.themeColor2.toHexString(),
                          textStyle: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),
                          hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                          onColorChanged: (color) {
                            setState(() {
                                Cv4rs.themeColor2 = color;
                                Cv4rs.savethemecolortwo(color);
                             });
                          },
                        ),
                      ),
                      //color picker
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          V4rs.paddingValue(40), 
                          V4rs.paddingValue(0), 
                          V4rs.paddingValue(10), 
                          V4rs.paddingValue(10)
                        ),
                        child: ColorPicker(
                          pickerColor: Cv4rs.themeColor2, 
                          enableAlpha: false,
                          displayThumbColor: false,
                          labelTypes: ColorLabelType.values,
                          onColorChanged:  (Color color) {
                              setState(() {
                                Cv4rs.themeColor2 = color;
                                Cv4rs.savethemecolortwo(color);
                             });
                          },
                        ),
                     ),
                    ],
                  ),
                  //theme color 3
                  ExpansionTile(
                    collapsedIconColor: Cv4rs.themeColor2,
                    title: Row(
                      children: [
                        Text('Theme Color 3:', style: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),),
                        const Spacer(),
                        CircleAvatar(
                          backgroundColor: Cv4rs.themeColor3,
                          radius: 20,
                          child: Icon(Icons.circle, color: Cv4rs.themeColor3, size: 40, shadows: [
                            Shadow(
                              color: Cv4rs.themeColor4,
                              blurRadius: 6,
                            ),
                             Shadow(
                              color: Cv4rs.themeColor4,
                              blurRadius: 6,
                            ),
                             Shadow(
                              color: Cv4rs.themeColor4,
                              blurRadius: 6,
                            ),
                          ],
                          ),
                        ),
                      ]
                    ),
                    children: [
                      //hexcode input
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: V4rs.paddingValue(40), 
                          vertical: V4rs.paddingValue(20)),
                        child: HexCodeInput(
                          startValue: Cv4rs.themeColor3.toHexString(),
                          textStyle: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),
                          hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                          onColorChanged: (color) {
                             setState(() {
                                Cv4rs.themeColor3 = color;
                                Cv4rs.savethemecolorthree(color);
                             });
                          },
                        ),
                      ),
                      //color picker
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          V4rs.paddingValue(40), 
                          0, 
                          V4rs.paddingValue(10), 
                          V4rs.paddingValue(10)),
                        child: ColorPicker(
                          pickerColor: Cv4rs.themeColor3, 
                          enableAlpha: false,
                          displayThumbColor: false,
                          labelTypes: ColorLabelType.values,
                          onColorChanged:  (Color color) {
                              setState(() {
                                Cv4rs.themeColor3 = color;
                                Cv4rs.savethemecolorthree(color);
                             });
                          },
                        ),
                     ),
                    ],
                  ),
                  //theme color 4
                  ExpansionTile(
                    collapsedIconColor: Cv4rs.themeColor2,
                    title: Row(
                      children: [
                        Text('Theme Color 4:', style: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),),
                        const Spacer(),
                        CircleAvatar(
                          backgroundColor: Cv4rs.themeColor3,
                          radius: 20,
                          child: Icon(Icons.circle, color: Cv4rs.themeColor4, size: 40, shadows: [
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
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: V4rs.paddingValue(40), 
                          vertical: V4rs.paddingValue(20)),
                        child: HexCodeInput(
                          startValue: Cv4rs.themeColor4.toHexString(),
                          textStyle: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),
                          hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                          onColorChanged: (color) {
                            setState(() {
                                Cv4rs.themeColor4 = color;
                                Cv4rs.savethemecolorfour(color);
                             });
                          },
                        ),
                      ),
                      //color picker
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          V4rs.paddingValue(40), 
                          0, 
                          V4rs.paddingValue(10), 
                          V4rs.paddingValue(10)),
                        child: ColorPicker(
                          pickerColor: Cv4rs.themeColor4, 
                          enableAlpha: false,
                          displayThumbColor: false,
                          labelTypes: ColorLabelType.values,
                          onColorChanged:  (Color color) {
                              setState(() {
                                Cv4rs.themeColor4 = color;
                                Cv4rs.savethemecolorfour(color);
                             });
                          },
                        ),
                     ),
                    ],
                  ),
                  //interface icon color
                   ExpansionTile(
                    collapsedIconColor: Cv4rs.themeColor2,
                    title: Row(
                      children: [
                        Text('Interface Icon Color:', style: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),),
                        const Spacer(),
                        CircleAvatar(
                          backgroundColor: Cv4rs.themeColor3,
                          radius: 20,
                          child: Icon(Icons.circle, color: Cv4rs.uiIconColor, size: 40, shadows: [
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
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: V4rs.paddingValue(40), 
                          vertical: V4rs.paddingValue(20)),
                        child: HexCodeInput(
                          startValue: Cv4rs.uiIconColor.toHexString(),
                          textStyle: TextStyle(color: Cv4rs.themeColor1, fontSize: 16),
                          hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                          onColorChanged: (color) {
                             setState(() {
                                Cv4rs.uiIconColor = color;
                                Cv4rs.saveUIIconColor(color);
                             });
                          },
                        ),
                      ),
                      //color picker
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          V4rs.paddingValue(40), 
                          0, 
                          V4rs.paddingValue(10), 
                          V4rs.paddingValue(10)),
                        child: ColorPicker(
                          pickerColor: Cv4rs.uiIconColor, 
                          enableAlpha: false,
                          displayThumbColor: false,
                          labelTypes: ColorLabelType.values,
                          onColorChanged:  (Color color) {
                              setState(() {
                                Cv4rs.uiIconColor = color;
                                Cv4rs.saveUIIconColor(color);
                             });
                          },
                        ),
                     ),
                    ],
                  ),
                  ]),

            ),

            Padding( 
             padding: EdgeInsetsGeometry.all( V4rs.paddingValue(16)),
             child: Column(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, V4rs.paddingValue(5)),
                  child: Text(
                    'Before typing, turn your device to landcape mode', 
                    style: TextStyle(color: Cv4rs.themeColor1, fontSize: V4rs.fontValue(16)),
                  ),
                 ),
                Text(
                  'With your keyboard shown, continue to the app',
                  style: TextStyle(color: Cv4rs.themeColor1, fontSize: V4rs.fontValue(16)),
                ),
              ]
             ),
            ),
            
            (!V4rs.xSmallModeWidth) 
            ? Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(30)), 
              child: Row(children: [
                Expanded(child: 
                  textField(),
                ),
                continueButton(),
              ]
             )
            )
           : Column(children: [
              textField(),
              continueButton(),
            ]
           )
          ], //children
         ),
        ),
      ),
    );
  }
}