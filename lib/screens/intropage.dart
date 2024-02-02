import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zone_trader/authentication/signin.dart';
import 'package:zone_trader/screens/home.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Go back to the sign-in screen
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
              appBar: AppBar(
                  backgroundColor: Colors.blue,
                  title: const Center(
                      child: Text(
                    'Zone Trader',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Times New Roman',
                        fontStyle: FontStyle.italic,
                        letterSpacing: 2),
                  )),
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
              body: Stack(fit: StackFit.expand, children: [
                Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/intro.jpeg'),
                            fit: BoxFit.cover,
                            opacity: 0.2))),
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
                                  builder: (context) => const HomeScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(162, 33, 149, 243),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 5,
                        ),
                        child: const Text('Start',style: TextStyle(color: Colors.white,fontSize: 30,fontFamily: 'Times New Roman',
                        fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),)),
                  ),
                  SizedBox(
                    height: 90,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(162, 33, 149, 243),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 5,
                        ),
                        child: const Text('How to Play',style: TextStyle(color: Colors.white,fontSize: 30,fontFamily: 'Times New Roman',
                        fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),)),
                  ),
                  SizedBox(
                    height: 90,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(162, 33, 149, 243),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 5,
                        ),
                        child: const Text('Options',style: TextStyle(color: Colors.white,fontSize: 30,fontFamily: 'Times New Roman',
                        fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),)),
                  ),
                ]))
              ]));
        });
  }
}
