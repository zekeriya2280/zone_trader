
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zone_trader/constants/languages.dart';
import 'package:zone_trader/firebase/FBOp.dart';
import 'package:zone_trader/screens/intropage.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  double slidervalue = 0.1;
  Color appbarcolor = Colors.blue;
  Color scfoldbgcolor = Colors.white;
  Color randcol1 = Colors.blue;
  Color randcol2 = Colors.blue;
  List<Map<Color, Color>> colors = [];
  String dropdownvalue = 'EN';
  Color textcolors = Colors.black;
  var dropdownitems = [
    'EN',
    'TR',
    'ES',
    'JP',
  ];
   int langindex = 0;
  var langs = [
    'EN',
    'TR',
    'ES',
    'JP',
  ];
  @override
  void initState() {
    colorProducer();
    getLang();
    super.initState();
  }
 void getLang()async{
    await FBOp.getLanguage().then((value) {
      setState(() {
        langindex = langs.indexOf(value);
      });
    });
  }
  void colorProducer(){
    for (int i = 0; i < 6; i++) {
      randcol1 = Color.fromARGB(255 ,Random().nextInt(255), Random().nextInt(255),
          Random().nextInt(255), );
      randcol2 = Color.fromARGB(255 ,Random().nextInt(255), Random().nextInt(255),
          Random().nextInt(255));
      setState(() {
        colors.add({randcol1: randcol2});
      });
     }
 
  }

  @override
  Widget build(BuildContext context) {
    switch (slidervalue) {
      case 0.0:
        appbarcolor = colors[0].keys.first;
        scfoldbgcolor = colors[0].values.first;
        break;
      case 0.1:
        appbarcolor = colors[0].keys.first;
        scfoldbgcolor = colors[0].values.first;
        break;
      case 1.0:
        appbarcolor = colors[1].keys.first;
        scfoldbgcolor = colors[1].values.first;
        break;
      case 2.0:
        appbarcolor = colors[2].keys.first;
        scfoldbgcolor = colors[2].values.first;
        break;
      case 3.0:
        appbarcolor = colors[3].keys.first;
        scfoldbgcolor = colors[3].values.first;
        break;
      case 4.0:
        appbarcolor = colors[4].keys.first;
        scfoldbgcolor = colors[4].values.first;
        break;
      case 5.0:
        appbarcolor = colors[5].keys.first;
        scfoldbgcolor = colors[5].values.first;
        break;
      default:
    }
    return Scaffold(
      backgroundColor: scfoldbgcolor,
      appBar: AppBar(
          title: Text(
            Languages.settings[langindex],
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Times New Roman',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ),
          backgroundColor: appbarcolor,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.replay,
                color: Colors.white,
              ),
              onPressed: () async {
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const OptionsPage()),
                );
              },
            ),
            IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 27),
                onPressed: () async {
                  await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  const IntroPage()));
                })
          ]),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Container()),
                    Container(
                      height: 200,
                      width: 150,
                      decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            opacity: 0.8,
                            image: AssetImage('images/up.png'),
                          )),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                      '    ${Languages.settingsReloadSuggestion[langindex]}',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 20,
                        color: textcolors,
                      )),
                )
              ],
            ),
            const SizedBox(height: 10),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: SizedBox(
                      height: 50,
                      child: Text(Languages.changecolortheme[langindex],
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Times New Roman',
                            letterSpacing: 2,
                            color: textcolors,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 18,
                          elevation: 5,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 26,
                        ),
                        activeTrackColor: Colors.pink,
                        inactiveTrackColor: Colors.pink,
                        trackHeight: 24,
                      ),
                      child: Slider(
                          value: slidervalue,
                          min: 0,
                          max: 5,
                          divisions: 5,
                          thumbColor: Colors.pink,
                          label: (slidervalue.floor() + 1)
                              .toString(),
                          overlayColor:
                              const MaterialStatePropertyAll(Colors.orange),
                          inactiveColor: Colors.grey,
                          //activeColor: Color.fromARGB(228, 0, 0, 0),
                          onChanged: (value) { setState(() {
                                slidervalue = value;
                              });
                              if(colors[slidervalue.floor()].values.first.red + 
                                 colors[slidervalue.floor()].values.first.green +
                                 colors[slidervalue.floor()].values.first.blue >= 570){
                                setState(() {
                                  textcolors = Colors.black;
                                });
                              }
                              else{
                                setState(() {
                                  textcolors = Colors.white;
                                });
                              }
                          }
                          ),
                        ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: Container()),
                  Center(
                    child: SizedBox(
                      height: 50,
                      child: Text(Languages.changelanguage[langindex],
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Times New Roman',
                              letterSpacing: 2,
                              color: textcolors)),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: DropdownButton(
                        dropdownColor: const Color.fromARGB(236, 128, 0, 255),
                        alignment: Alignment.center,
                        iconEnabledColor: Colors.white,
                        value: dropdownvalue,
                        padding: const EdgeInsets.only(left: 18),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: dropdownitems.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Center(
                                child: Text(
                              items,
                              style: TextStyle(color: textcolors),
                            )),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: Container()),
                  ElevatedButton(
                      onPressed: () async{
                        await FBOp.updateColorTheme([colors[slidervalue.floor()].keys.first.red, 
                                                     colors[slidervalue.floor()].keys.first.green, 
                                                     colors[slidervalue.floor()].keys.first.blue],[
                                                     colors[slidervalue.floor()].values.first.red,
                                                     colors[slidervalue.floor()].values.first.green,
                                                     colors[slidervalue.floor()].values.first.blue]);
                        await FBOp.changeLanguage(dropdownvalue).then((value) async=> 
                                await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const IntroPage())));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(162, 33, 149, 243),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 5,
                      ),
                      child:  Text(
                        Languages.save[langindex],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontFamily: 'Times New Roman',
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(height: 50, child: Container())
                ]),
          ],
        ),
      ),
    );
  }
}
