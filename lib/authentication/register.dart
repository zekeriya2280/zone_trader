
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zone_trader/authentication/signin.dart';
import 'package:zone_trader/constants/languages.dart';
import 'package:zone_trader/screens/startpage.dart';

class RegisterScreen extends StatefulWidget {
  int? langindex;
  RegisterScreen({langindex,super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int langindex = 0;
  String dropdownvalue = 'ENG';
  var dropdownitems = [
    'ENG',
    'TR',
    'ES',
    'JP',
  ];

  @override
  void initState() {
    langChecker();
    super.initState();
  }
  void langChecker()async{
  }

  Future<void> _register() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;
      String nickname = _nicknameController.text;
      if (email == '' || password == '' || nickname == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:  Text(Languages.pleaseenteravalidnicknameemailpass[langindex]),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:  Text(Languages.ok[langindex]),
                ),
              ],
            );
          },
        );
      } else {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email,password: password);
        await userCredential.user!.updateDisplayName(nickname);
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.displayName).set({
          'nickname' : nickname,
          'email': email,
          'money' : 100000,
          'bought' : List<bool>.filled(48, false),
          'times' : List<Map<String,dynamic>>.filled(48, {'60':60}),
          'language' : dropdownvalue,
          'appcolorTheme' : [],
          'bgcolorTheme' : []
        });
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartPage()),
        );
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
        backgroundColor: Colors.blue,
        title:  Center(child: Text( Languages.register[langindex],style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nicknameController,
                decoration:  InputDecoration(labelText: Languages.nickname[langindex]),
              ),
              TextField(
                controller: _emailController,
                decoration:  InputDecoration(labelText: Languages.email[langindex]),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration:  InputDecoration(labelText: Languages.password[langindex]),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  minimumSize: const Size(200, 70),
                ),
                child:  Text(Languages.register[langindex],style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),)
              ),
              Padding(
                padding: const EdgeInsets.all(76.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue
                  ),
                  onPressed: ()async {
                    await Navigator.pushReplacement(
                      context,MaterialPageRoute(builder: (context) => const SignInScreen()),
                    );
                  },
                  child: Text(Languages.signin[langindex],style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),),
                ),
              ),
              Row(
                children: [
                  Expanded(child: Container(
                    child: Center(
                      child: Text(Languages.chooseyourlanguage[langindex],style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )),
                    )
                  )),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: DropdownButton(
                        iconDisabledColor: Colors.yellow,
                        dropdownColor: const Color.fromARGB(252, 155, 99, 210),
                        alignment: Alignment.center,
                        iconEnabledColor: Colors.red,
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
                        onChanged: (String? newValue) async{
                          setState(() {
                            dropdownvalue = newValue!;
                            langindex = dropdownitems.indexOf(newValue);
                          });
                          
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}