import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zone_trader/authentication/signin.dart';
import 'package:zone_trader/screens/home.dart';
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

  @override
  void initState() {
    colorProducer();
    super.initState();
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  colorProducer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      appBarColor = Color.fromARGB(
          255,
          int.parse(prefs.getStringList('appcolor') == null ? '0' : prefs.getStringList('appcolor')![1]),
          int.parse(prefs.getStringList('appcolor') == null ? '0' : prefs.getStringList('appcolor')![2]),
          int.parse(prefs.getStringList('appcolor') == null ? '255' : prefs.getStringList('appcolor')![3]));
      bgcolor = Color.fromARGB(
          255,
          int.parse(prefs.getStringList('bgcolor') == null ? '255' : prefs.getStringList('bgcolor')![1]),
          int.parse(prefs.getStringList('bgcolor') == null ? '255' : prefs.getStringList('bgcolor')![2]),
          int.parse(prefs.getStringList('bgcolor') == null ? '255' : prefs.getStringList('bgcolor')![3]));
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
                          builder: (context) => const SignInScreen()),
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
                        color: Color.fromARGB(208, 244, 67, 54),
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
                                  Color.fromARGB(210, 33, 149, 243),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Start',
                              style: TextStyle(
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
                                          const HomeScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(210, 33, 149, 243),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'How to Play',
                              style: TextStyle(
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
                                  Color.fromARGB(210, 33, 149, 243),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Options',
                              style: TextStyle(
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
