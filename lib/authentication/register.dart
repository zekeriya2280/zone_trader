import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zone_trader/authentication/signin.dart';
import 'package:zone_trader/constants/languages.dart';
import 'package:zone_trader/firebase/FBOp.dart';
import 'package:zone_trader/screens/startpage.dart';

class RegisterScreen extends StatefulWidget {
  int? langindex;
  RegisterScreen({langindex, super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errortext = "";
  int langindex = 0;
  String dropdownvalue = 'EN';
  var dropdownitems = [
    'EN',
    'TR',
    'ES',
    'JP',
  ];

  @override
  void initState() {
    langChecker();
    super.initState();
  }

  void langChecker() async {}

  Future _register() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;
      String nickname = _nicknameController.text;
      if (email == '' || password == '' || nickname == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text(Languages.pleaseenteravalidnicknameemailpass[langindex]),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(Languages.ok[langindex]),
                ),
              ],
            );
          },
        );
      } else {
        try {
          late UserCredential userCredential;
          await FBOp.registerUserFB(nickname, email, dropdownvalue)
              .then((value) async {
                print(value);
            if (value.isNotEmpty) {
              setState(() {
                errortext = Languages.nicknameAlreadyInUse[langindex];
              });
            } else {
              userCredential = await _auth.createUserWithEmailAndPassword(
                  email: email, password: password);
            }
          });

          if (userCredential.user != null) {
            await userCredential.user!.updateDisplayName(nickname);
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StartPage()),
            );
          }
          else{
            return Center(child: CircularProgressIndicator(strokeWidth: 2,color: Colors.green,));
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            setState(() {
              errortext = Languages.firebaseautherror1[langindex];
            });
          } else if (e.code == 'invalid-email') {
            setState(() {
              errortext = Languages.firebaseautherror3[langindex];
            });
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              errortext = Languages.firebaseautherror2[langindex];
            });
          } else if (e.code == 'user-disabled') {
            setState(() {
              errortext = Languages.firebaseautherror6[langindex];
            });
          } else {
            setState(() {
              errortext = Languages.firebaseautherror7[langindex];
            });
          }
        }
      }
    } catch (e) {
      print("Error signing in: $e");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 169, 197, 246),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(
            child: Text(
          Languages.register[langindex],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(34),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                          child: Center(
                    child: Text(Languages.chooseyourlanguage[langindex],
                        style: const TextStyle(
                            color: Colors.purple,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ))),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: DropdownButton(
                        iconDisabledColor: Colors.yellow,
                        dropdownColor: const Color.fromARGB(252, 155, 99, 210),
                        alignment: Alignment.center,
                        iconEnabledColor: Colors.purple,
                        value: dropdownvalue,
                        padding: const EdgeInsets.only(left: 18),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: dropdownitems.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Center(
                                child: Text(
                              items,
                              style: const TextStyle(color: Colors.black),
                            )),
                          );
                        }).toList(),
                        onChanged: (String? newValue) async {
                          setState(() {
                            dropdownvalue = newValue!;
                            langindex = dropdownitems.indexOf(newValue);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextField(
                controller: _nicknameController,
                style: TextStyle(
                    color: errortext.isEmpty ? Colors.black : Colors.red),
                decoration: InputDecoration(
                    hintText: Languages.nickname[langindex],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.purple.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.person)),
                // decoration:
                //     InputDecoration(labelText: Languages.nickname[langindex]),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    hintText: Languages.email[langindex],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.purple.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.email)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: Languages.password[langindex],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.purple.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.password)),
              ),
              const SizedBox(height: 20),
              Text(
                errortext,
                style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.purple,
                    elevation: 5,
                    minimumSize: const Size(200, 70),
                  ),
                  child: Text(
                    Languages.register[langindex],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(76.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    backgroundColor: Colors.purple,),
                  onPressed: () async {
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    );
                  },
                  child: Text(
                    Languages.signin[langindex],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
