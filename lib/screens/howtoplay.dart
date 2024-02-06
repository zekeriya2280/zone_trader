import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zone_trader/constants/languages.dart';
import 'package:zone_trader/firebase/FBOp.dart';
import 'package:zone_trader/screens/intropage.dart';

class HowtPlay extends StatefulWidget {
  const HowtPlay({super.key});

  @override
  State<HowtPlay> createState() => _HowtPlayState();
}

class _HowtPlayState extends State<HowtPlay> with TickerProviderStateMixin{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Color appBarColor = Colors.blue;
  Color bgcolor = Colors.white;
  int langindex = 0;
  var langs = [
    'ENG',
    'TR',
    'ES',
    'JP',
  ];
  List<String> introimages = ["images/htp1.png", "images/htp1tr.png", "images/htp1es.png", "images/htp1jp.png",];
  List<String> introimagessignout = ["images/htp1signout.png", "images/htp1trsignout.png", "images/htp1essignout.png", "images/htp1jpsignout.png",];
  List<String> settingsimages = ['images/settings.png', 'images/settingstr.png', 'images/settingses.png', 'images/settingsjp.png',];
  List<String> settingsimagesreload = ['images/settingsreload.png', 'images/settingsreloadtr.png', 'images/settingsreloades.png', 'images/settingsreloadjp.png',];
  List<String> settingsimageshome = ['images/settingshome.png', 'images/settingshometr.png', 'images/settingshomees.png', 'images/settingshomejp.png',];
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: const Cubic(0.01, 0.01, 0.01, 1.0),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  void initState() {
    getLang();
    colorProducer();
    super.initState();
  }
  void getLang()async{
    await FBOp.getLanguage().then((value) {
      setState(() {
        langindex = langs.indexOf(value);
      });
    });
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  colorProducer() async {
    await FBOp.getAppColorTheme().then((value) {
      setState(() {
        appBarColor = Color.fromARGB(255, value[0], value[1], value[2]);
      });
    });
    await FBOp.getBGColorTheme().then((value) {
      setState(() {
        bgcolor = Color.fromARGB(255, value[0], value[1], value[2]);
      });
    });
  }
  List<Widget> getTextAndPictures(int numberindex,String langtext,double upheight,double downheight) {
    if(numberindex <= 4){
      return [
      Text('*   $langtext',style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Image.asset(numberindex == 1 ? introimagessignout[langindex] : introimages[langindex],width: MediaQuery.of(context).size.width * 0.5,height: 400,),
        Column(
          children: [
            SizedBox(height: upheight,child: Container()),
            ScaleTransition(
              scale: _animation,
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(270 / 360),
                child: Image(image: AssetImage('images/up.png'),width: 70,height: 150,)),
            ),
            SizedBox(height: downheight,child: Container()),
          ],
        ),
      ],),
    ];
    }
    else if(numberindex >= 5 && numberindex <= 9){
      return [
      Text('*   $langtext',style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Image.asset(numberindex == 5 ? settingsimagesreload[langindex] :  numberindex == 6 ? settingsimageshome[langindex] : settingsimages[langindex],width: MediaQuery.of(context).size.width * 0.5,height: 400,),
        Column(
          children: [
            SizedBox(height: upheight,child: Container()),
            ScaleTransition(
              scale: _animation,
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(270 / 360),
                child: Image(image: AssetImage('images/up.png'),width: 70,height: 150,)),
            ),
            SizedBox(height: downheight,child: Container()),
          ],
        ),
      ],),];
    
    }else{
      return [
        
      ];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: Text(Languages.howtoplay[langindex],style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Times New Roman',
                            fontStyle: FontStyle.italic,
                            letterSpacing: 2),),
        backgroundColor: appBarColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 27),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const IntroPage()));
            }
          )
        ]
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              ...getTextAndPictures(1, Languages.howtoplaytext1[langindex],1,370),
              ...getTextAndPictures(2, Languages.howtoplaytext2[langindex],50,250),
              ...getTextAndPictures(3, Languages.howtoplaytext3[langindex],150,120),
              ...getTextAndPictures(4, Languages.howtoplaytext4[langindex],270,30),
              ...getTextAndPictures(5, Languages.howtoplaytext5[langindex],1,370),
              ...getTextAndPictures(6, Languages.howtoplaytext6[langindex],1,370),
              ...getTextAndPictures(7, Languages.howtoplaytext7[langindex],200,150),
              ...getTextAndPictures(8, Languages.howtoplaytext8[langindex],270,60),
              ...getTextAndPictures(9, Languages.howtoplaytext9[langindex],350,10),
            ]
          ),
        ))
    );
  }
}