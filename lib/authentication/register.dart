
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zone_trader/authentication/signin.dart';
import 'package:zone_trader/screens/home.dart';
import 'package:zone_trader/screens/startpage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;
      String nickname = _nicknameController.text;
      //QuerySnapshot nicknameQuery = await FirebaseFirestore.instance
      //    .collection('users')
      //    .where('nickname', isEqualTo: nickname)
      //    .get();

      if (email == '' || password == '' || nickname == ''/*nicknameQuery.docs.isNotEmpty*/) {
        // The nickname is already in use, handle accordingly
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Please enter a valid nickname, email and password'),
              //content: Text('Please choose a different nickname.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('aaaaa');
        // The nickname is available, proceed with signing in
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email,password: password);
        //String userId = userCredential.user!.uid;
        print('a');
        await userCredential.user!.updateDisplayName(nickname);
        print('b');
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.displayName).set({
          'nickname' : nickname,
          'email': email,
          'money' : 100000,
          'bought' : [],
          'times' : []
          // Add other user-related data as needed
        });
        print('c');
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartPage()),
        );
      }
    } catch (e) {
      print("Error signing in: $e");
    }
  }

  // Rest of the code remains unchanged

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
        title: const Center(child: Text('Register',style: TextStyle(
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
                decoration: const InputDecoration(labelText: 'Nickname'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
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
                child: const Text('Register',style: TextStyle(
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
                  child: const Text('Sign In',style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}