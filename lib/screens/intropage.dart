import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zone_trader/authentication/signin.dart';
import 'package:zone_trader/constants/languages.dart';
import 'package:zone_trader/firebase/FBOp.dart';
import 'package:zone_trader/screens/home.dart';
import 'package:zone_trader/screens/howtoplay.dart';
import 'package:zone_trader/screens/optionspage.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!snapshot.hasData) {
            Future.delayed(
                const Duration(milliseconds: 200),
                () => Navigator.of(context).pushReplacement<void, void>(
                      MaterialPageRoute<void>(
                          builder: (context) =>  const SignInScreen()),
                    ));
          }
          return Scaffold(
              //backgroundColor: bgcolor,
              appBar: AppBar(
                  backgroundColor: appBarColor,
                  title: const SizedBox(
                    width: 250,
                    child: Center(
                      child: Text(
                        'Zone Trader',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Times New Roman',
                            fontStyle: FontStyle.italic,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.exit_to_app,
                        color: Color.fromARGB(208, 255, 255, 255),
                        size: 26,
                      ),
                      onPressed: () async {
                        await signOut(context);
                      },
                    )
                  ]),
              body: Stack( fit: StackFit.expand, children: [
                Container(
                    decoration: BoxDecoration(
                        color: bgcolor,
                        image: const DecorationImage(
                            image: AssetImage('images/intro.jpeg'),
                            fit: BoxFit.cover,
                            opacity: 0.5))),
                Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      SizedBox(
                        height: 90,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(210, 33, 149, 243),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                            ),
                            child:  Text(
                              Languages.start[langindex],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'Times New Roman',
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      SizedBox(
                        height: 90,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HowtPlay()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(210, 33, 149, 243),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                            ),
                            child:  Text(
                              Languages.howtoplay[langindex],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'Times New Roman',
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      SizedBox(
                        height: 90,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OptionsPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(210, 33, 149, 243),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                            ),
                            child:  Text(
                              Languages.settings[langindex],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'Times New Roman',
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ]))
              ]));
        });
  }
}
