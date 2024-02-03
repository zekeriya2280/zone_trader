import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zone_trader/firebase/FBOp.dart';
import 'package:zone_trader/models/country.dart';
import 'package:zone_trader/screens/home.dart';

class MyCountryList extends StatefulWidget {
  const MyCountryList({super.key});

  @override
  State<MyCountryList> createState() => _MyCountryListState();
}

class _MyCountryListState extends State<MyCountryList> {
  Color appBarColor = Colors.blue;
  Color bgcolor = Colors.white;
  @override
  void initState() {
    playSampleSound('assets/sounds/pagechanged.mp3');
    colorProducer();
    super.initState();
  }
  void playSampleSound(String path) async {
     AudioPlayer player = AudioPlayer();
    await player.setAsset(path);
    await player.play();
  }
  colorProducer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      appBarColor = Color.fromARGB(
          255,
          int.parse(prefs.getStringList('appcolor')![1]),
          int.parse(prefs.getStringList('appcolor')![2]),
          int.parse(prefs.getStringList('appcolor')![3]));
      bgcolor = Color.fromARGB(
          255,
          int.parse(prefs.getStringList('bgcolor')![1]),
          int.parse(prefs.getStringList('bgcolor')![2]),
          int.parse(prefs.getStringList('bgcolor')![3]));
    });
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('countries').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Country> myCountryList = [];
        for (var doc in snapshot.data!.docs) {
          var data = doc.data() as Map<String, dynamic>;
          if(data['owner'] == FirebaseAuth.instance.currentUser!.displayName){
            myCountryList.add(Country(
            name: data['name'],
            income: data['income'],
            price: data['price'], 
            owner: data['owner'],
          ));
          }
        }

        return Scaffold(
          backgroundColor: bgcolor,
          appBar: AppBar(
            title: const Text('My Country List',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold,letterSpacing: 2),),
            centerTitle: true,
            backgroundColor: appBarColor,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right:18.0),
                child: IconButton(
                  icon: const Icon(Icons.home,size: 30,color: Colors.white,), 
                  onPressed: ()async{ 
                    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                   },
                ),
              )
            ]
          ),
          body: 
          myCountryList.isEmpty ? const Center(child: Text('You have no country',style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),)) :
          ListView.builder(
            itemCount: myCountryList.length,
            itemBuilder: (context, index) {
              return Card(
                child: InkWell(
                  onTap: () {
                    _showPopup(context, myCountryList[index]);
                  },
                  child: ListTile(
                    title: Center(child: Text(myCountryList[index].name,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                    subtitle: Center(
                      child: Text(
                          'Price: ${myCountryList[index].price} - Income: ${myCountryList[index].income} '
                          '- Owner: ${myCountryList[index].owner}'),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showPopup(BuildContext context, Country country) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(country.name,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              children: [
                
                Text('Price: ${country.price}'),
                Text('Income: ${country.income}'),
                Text('Owner: ${country.owner}'),
                Expanded(child: Container()),
                const Center(child: Text('You should reload home page after selling', style: TextStyle(fontSize: 13,color: Colors.red,fontWeight: FontWeight.bold),)),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: () {
                  playSampleSound('assets/sounds/close.mp3');
                  Navigator.of(context).pop(); // Cancel button
                },
                child: const Text('Cancel',style: TextStyle(color: Colors.white),),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: ()async {
               await FBOp.sellCountryFB(country).then((value) { 
                playSampleSound('assets/sounds/bought.mp3');
                Navigator.of(context).pop();});
              },
              child: const Text('Sell',style: TextStyle(color: Colors.white),),
            ),
            ),
          ],
        );
      },
    );
  }
}