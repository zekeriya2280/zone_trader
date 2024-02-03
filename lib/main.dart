
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zone_trader/screens/wrapper.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   options: 
   const FirebaseOptions(
     apiKey: 'AIzaSyASOup4EQbXqsDWFWjp9DCyr4YlC7y3FMc', 
     appId: '1:695924119809:android:267ba3c155e3c3386d6300', 
     messagingSenderId: '695924119809', 
     projectId: 'zone-trader')
  );
  SharedPreferences.setMockInitialValues({});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(),
    );
  }
}
