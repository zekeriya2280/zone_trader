import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:zone_trader/constants/languages.dart';
import 'package:zone_trader/firebase/FBOp.dart';
import 'package:zone_trader/models/country.dart';
import 'package:zone_trader/screens/game.dart';

class MyCountryList extends StatefulWidget {
  const MyCountryList({super.key});

  @override
  State<MyCountryList> createState() => _MyCountryListState();
}

class _MyCountryListState extends State<MyCountryList> {
  Color appBarColor = Colors.blue;
  Color bgcolor = Colors.white;
  int langindex = 0;
  Color textcolors = Colors.black;
  var langs = [
    'ENG',
    'TR',
    'ES',
    'JP',
  ];
  @override
  void initState() {
    playSampleSound('assets/sounds/pagechanged.mp3');
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
  void playSampleSound(String path) async {
     AudioPlayer player = AudioPlayer();
    await player.setAsset(path);
    await player.play();
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
    if (bgcolor.red + bgcolor.green + bgcolor.blue >= 570) {
      setState(() {
        textcolors = Colors.black;
      });
    } else {
      setState(() {
        textcolors = Colors.white;
      });
    }
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
            automaticallyImplyLeading: false,
            title: Text(Languages.mycountrylist[langindex],style: const TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold,letterSpacing: 2),),
            centerTitle: true,
            backgroundColor: appBarColor,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right:18.0),
                child: IconButton(
                  icon: const Icon(Icons.home,size: 30,color: Colors.white,), 
                  onPressed: ()async{ 
                    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Game()));
                   },
                ),
              )
            ]
          ),
          body: 
          myCountryList.isEmpty ? Center(child: Text(Languages.youhavenocountry[langindex],style: TextStyle(fontSize: 22,color: textcolors,fontWeight: FontWeight.bold),)) :
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
                          '${Languages.price[langindex]} ${myCountryList[index].price} - ${Languages.income[langindex]}: ${myCountryList[index].income} '
                          '- ${Languages.owner[langindex]}: ${myCountryList[index].owner}'),
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
                Text('${Languages.price[langindex]}: ${country.price}'),
                Text('${Languages.income[langindex]}: ${country.income}'),
                Text('${Languages.owner[langindex]}: ${country.owner}'),
                Expanded(child: Container()),
                Center(child: Text(Languages.youshouldreloadReminderSelling[langindex], style: const TextStyle(fontSize: 13,color: Colors.red,fontWeight: FontWeight.bold),)),
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
                child: Text(Languages.cancel[langindex],style: const TextStyle(color: Colors.white),),
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
              child: Text(Languages.sell[langindex],style: const TextStyle(color: Colors.white),),
            ),
            ),
          ],
        );
      },
    );
  }
}