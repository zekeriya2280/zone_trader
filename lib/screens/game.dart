import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:zone_trader/authentication/signin.dart';
import 'package:zone_trader/constants/countryImageNames.dart';
import 'package:zone_trader/constants/languages.dart';
import 'package:zone_trader/firebase/FBOp.dart';
import 'package:zone_trader/models/country.dart';
import 'package:zone_trader/models/gsheet.dart';
import 'package:zone_trader/models/player.dart';
import 'package:zone_trader/screens/intropage.dart';
import 'package:zone_trader/screens/myCountryList.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  List<Country> countries = []; //
  int money = 10000;
  bool countryBreaker = false;
  Player player = Player('', '', 0, [], [], [], [], 'ENG');
  List<bool> bought =
      List<bool>.filled(CountryImageNames.countryandcitynumber, false);
  List<Map<String, dynamic>> boughttimes = List<Map<String, dynamic>>.filled(
      CountryImageNames.countryandcitynumber, {'60': 60});
  Color appBarColor = Colors.blue;
  Color bgcolor = Colors.white;
  int langindex = 0;
  List<int> buyablecountries = [];
  bool canbebought = false;
  String wrongproductionerror = '';
  Color buttoncolor = Colors.red;
  //List<Map<String, int>> upgradelistviewitems = [
  //  {'water': 1200},
  //  {'sugar': 1500},
  //  {'salt': 1800},
  //  {'orange': 2100},
  //  {'banana': 2400},
  //  {'flour': 1900},
  //  {'yeast': 2200},
  //  {'milk': 1400},
  //  {'honey': 2500},
  //  {'cocoa': 2800},
  //  {'potato': 3100},
  //  {'olives': 3400},
  //  {'tomato': 3700},
  //  {'bread': 4100},
  //  {'bronze': 4400},
  //  {'silver': 4700},
  //  {'gold': 5000},
  //  {'iron': 4300},
  //  {'copper': 4600},
  //  {'coal': 4200},
  //  {'meat': 3300},
  //  {'eggs': 3100},
  //  {'beef': 3600},
  //  {'leather': 4000},
  //  {'mutton': 4100},
  //  {'wool': 3800},
  //  {'wood': 2400},
  //  {'timber': 4000},
  //  {'chair': 5000},
  //  {'table': 5200},
  //  {'ceramic': 3400},
  //  {'washroom': 5500},
  //  {'door': 5200},
  //  {'plastic': 3300},
  //  {'bottle': 4000},
  //  {'glass': 4000},
  //  {'window': 6000},
  //  {'house': 10000},
  //  {'rubber': 4000},
  //  {'tire': 5200},
  //  {'engine': 7000},
  //  {'car': 15000},
  //  {'watersoda': 3300},
  //  {'bananajuice': 4500},
  //  {'orangejuice': 4500},
  //  {'steel': 4700},
  //  {'cans': 5700},
  //  {'bananasmoothie': 6000},
  //];
  var langs = [
    'ENG',
    'TR',
    'ES',
    'JP',
  ];
  String nickname = "";
  String chooseAUniqueNickname = "";
  List<Map<String, List<String>>> productionpairs = [
    {
      'watersoda': ['water', 'sugar']
    },
    {
      'beet': ['sugar', 'water']
    },
    {
      'orangejuice': ['orange', 'water']
    },
    {
      'bananajuice': ['banana', 'milk']
    },
    {
      'yoghurt': ['water', 'milk']
    },
    {
      'cheese': ['yeast', 'milk', 'salt']
    },
    {
      'butter': ['water', 'oil']
    },
    {
      'yeast': ['water', 'floor']
    },
    {
      'meat': ['cow']
    },
    {
      'sandwich': ['bread', 'meat']
    },
    {
      'pizza': ['bread', 'tomato', 'cheese']
    },
    {
      'melonjuice': ['melon', 'water']
    },
    {
      'bread': ['floor', 'yeast', 'water', 'milk', 'salt']
    },
    {
      'paste': ['yeast', 'water', 'salt']
    },
    {
      'wood': ['tree']
    },
    {
      'timber': ['wood', 'axe']
    },
    {
      'chair': ['timber', 'glue']
    },
    {
      'table': ['timber', 'shave']
    },
    {
      'washroom': ['ceramic', 'mirror', 'faucet']
    },
    {
      'mirror': ['glass', 'silver']
    },
    {
      'mud': ['clay', 'water']
    },
    {
      'ceramic': ['mud', 'kiln']
    },
    {
      'bananasmoothie': ['bananajuice', 'sugar', 'ice']
    },
    {
      'door': ['wood', 'hinge']
    },
    {
      'window': ['glass', 'plastic']
    },
    {
      'glass': ['lime', 'sand', 'watersoda']
    },
    {
      'lime': ['limestone']
    },
    {
      'sand': ['limestone']
    },
    {
      'plastic': ['gas', 'coal', 'petrol']
    },
    {
      'hotwater': ['gas']
    },
    {
      'electric': ['coal']
    },
    {
      'tire': ['rubber']
    },
    {
      'window': ['hinge', 'plastic', 'glass']
    },
    {
      'house': ['window', 'table', 'chair', 'washroom', 'door']
    },
    {
      'steel': ['coal', 'iron']
    },
    {
      'cans': ['steel']
    },
    {
      'conserve': ['cans', 'tin']
    },
    {
      'bottle': ['plastic', 'label']
    },
    {
      'engine': ['steel', 'plastic', 'piston']
    },
    {
      'car': ['engine', 'tire', 'plastic', 'steel', 'key']
    },
    {
      'cement': ['marn', 'clay', 'lime']
    },
    {
      'concrete': ['agrega', 'cement', 'water']
    },
    {
      'tile': ['clay']
    },
    {
      'roof': ['tile', 'concrete', 'plastic']
    },
    {
      'cement': ['marn', 'clay', 'lime']
    },
    {
      'building': ['steel', 'roof', 'concrete', 'house']
    },
    {
      'asphalt': ['sand', 'gravel', 'cement', 'petrol']
    },
    {
      'chalk': ['calcite']
    },
    {
      'blackboard': ['chalk', 'laminate']
    },
    {
      'cellulose': ['wood']
    },
    {
      'paper': ['cellulose']
    },
    {
      'book': ['cover', 'paper']
    },
    {
      'pencil': ['coal', 'wood']
    },
    {
      'school': ['blackboard', 'building', 'book', 'pencil']
    },
    {
      'greengrocer': ['building', 'vegetables']
    },
    {
      'grocery': [
        'building',
        'refrigerator',
        'vegetables',
        'orangejuice',
        'bananajuice',
        'melonjuice',
        'bread',
        'meat'
      ]
    },
    {
      'barber': ['building', 'scissors', 'mirror', 'chair']
    },
    {
      'bedroom': ['window', 'bed', 'door']
    },
  ];

  @override
  void initState() {
    updateBought();
    getLang();
    updateNickname();
    colorProducer();
    super.initState();
  }

  void getLang() async {
    await FBOp.getLanguage().then((value) {
      setState(() {
        langindex = langs.indexOf(value);
      });
    });
  }

  updateNickname() async {
    await FBOp.updateNicknameHelper(nickname);
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

  //List<Map<String, int>> findupgradableitems(int money, List<String> olditems) {
  //  List<Map<String, int>> temp = [];
  //  for (var item in upgradelistviewitems) {
  //    if (money >= item.values.first &&
  //        olditems.every((element) => element != item.keys.first)) {
  //      temp.add(item);
  //      //print(temp);
  //    }
  //  }
  //  return temp;
  //}

  void playSampleSound(String path) async {
    AudioPlayer player = AudioPlayer();
    await player.setAsset(path);
    await player.play();
  }

  Future<void> updateBought() async {
    //await FBOp.resetTimesAndBoughtFB(boughttimes,bought); //RESETS TIMES AND BOUGHT FB---RESET!!!
    //await FBOp.updateCountryOwners(); //ADDS OWNER FIELDS TO ALL COUNTRIES FB---RESET!!!
    //await FBOp.updateBoughtColorsFB(List<bool>.filled(CountryImageNames.countryandcitynumber, false)); // ALL COUNTRIES ARE NOT BOUGHT---RESET!!!
    //await FBOp.updateCountriesIncomesFB(); // MAKE ALL INCOMES 20% OF THE PRICES FB---RESET!!!
    //await FBOp.changeSamePricesFB(); // CHANGE SAME PRICES FB---RESET!!!
    /*
    await FBOp.addToCountriesNewVariablesFB(// ADD NEW VARIABLES TO COUNTRIES FB---RESET!!!
      {'production': 'water'},
      {'production': 'sugar'},
      {'production': 'salt'},
      {'production': 'orange'},
      {'production': 'banana'},
      {'production': 'wheat'},
      {'production': 'yeast'},
      {'production': 'bread'},
      {'production': 'milk'},
      {'production': 'honey'},
      {'production': 'melon'},
      {'production': 'watersoda'},
      {'production': 'orangejuice'},
      {'production': 'melonjuice'},
      {'production': 'bananajuice'},
      {'production': 'bananasmoothie'},
      {'production': 'bananashake'},); 
    */
    //await FBOp.updateCountriesPriceAndIncomesFB();// UPDATE COUNTRIES PRICES AND INCOMES FB---RESET!!!
    //await FBOp.updateProductionsFB();// UPDATE COUNTRIES PRODUCTIONS to LISTs FB---RESET
    //await FBOp.updateAllPricesFB(upgradelistviewitems);// UPDATE COUNTRIES PRICES AND INCOMES FB---RESET
    //await GSheet().updateIncomesByPrices(); // UPDATE COUNTRIES INCOMES GSHEETS---RESET
    List<List<dynamic>> newcountries = [];
    await GSheet().getAllRows(0).then((value) => newcountries = value);
    //for (var doc in countriessnapshot.data!.docs) {
    //  countries.add(
    //    Country(
    //        name: doc.data()['name'],
    //        price: doc.data()['price'],
    //        income: doc.data()['income'],
    //        owners: List<String>.from(doc.data()['owners']),
    //        productions:
    //            List<String>.from(doc.data()['productions'])),
    //  );
    //}

    for (var coun in newcountries) {
      //print(coun);
      setState(() {
        countries.add(Country(
          name: coun[1],
          price: int.parse(coun[2]),
          income: int.parse(coun[3]),
          owners: [coun[4]],
          productions: [coun[5]],
        ));
      });
    }
    //List<String> player = [];
    int userrowindex =
        await GSheet().findCurrentUserRowIndex().then((value) => value + 1);
    List<String> userinfo =
        await GSheet().getRowValues(1, userrowindex).then((value) => value);

    //for (var doc in countriessnapshot.data!.docs) {
    //  countries.add(
    //    Country(
    //        name: doc.data()['name'],
    //        price: doc.data()['price'],
    //        income: doc.data()['income'],
    //        owners: List<String>.from(doc.data()['owners']),
    //        productions:
    //            List<String>.from(doc.data()['productions'])),
    //  );
    //}

   // for (var info in userinfo) {
      //print(coun);
      setState(() {
        player = Player(
          userinfo[6],
          userinfo[3],
          int.parse(userinfo[5]),
          List<bool>.from(userinfo[2].split(',').map((e) => e == 'true').toList()),
          List<Map<String, dynamic>>.from(userinfo[7].split(',').map((e) => {e.split(':')[0] : e.split(':')[1]}).toList()),
          List<int>.from(userinfo[0].split(',').map((e) => int.parse(e)).toList()),
          List<int>.from(userinfo[1].split(',').map((e) => int.parse(e)).toList()),
          userinfo[4]
        ).getPlayer;
      });
   // }

    await GSheet().getBoughtValues().then((value) {
      print('value: ' + value.toString());
      setState(() {
        bought = value.map((e) => e == "true" ? true : false).toList();
      });
    });

    DateTime now = DateTime.now();
    List<Map<String, int>> oldtimelist = [];
    int moneychange = 0;
    await FBOp.fetchBoughtIndexHourAndMinutesFB()
        .then((value) => oldtimelist = value);
    //print('oldtimelist $oldtimelist');
    List<int> allsubmin = [];
    for (var time in oldtimelist) {
      if (now.hour < int.parse(time.keys.first)) {
        allsubmin.add(
            (now.minute + (24 - (int.parse(time.keys.first) - now.hour)) * 60) -
                time.values.first);
      } else {
        allsubmin.add(
            ((now.minute + (now.hour - int.parse(time.keys.first)) * 60) -
                time.values.first));
      }
    }
    //print('allsubmin $allsubmin');
    List<double> howmanyincomes = [];
    for (var submin in allsubmin) {
      howmanyincomes.add(submin / 10);
    }

    await FBOp.findCountryIncomeAndAddFB(howmanyincomes)
        .then((value) => moneychange = value);
    playSampleSound('assets/sounds/homeinitpopup.mp3');
    //AudioCache cache = AudioCache();
    //const alarmAudioPath = "sounds/homeinitpopup.mp3";
    //await cache.load(alarmAudioPath).then((value) => cache.clear(alarmAudioPath));
    moneychange != 0 ? _showMoneyChange(context, moneychange) : false;
  }

  //void updateFirebase
  Future<void> greenBGColorFiller() async {
    await GSheet().updateBoughtColorsGS(bought);
    //print(countries);
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance
        .signOut()
        .then((value) async => await Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            ));
    // Go back to the sign-in screen
  }

  TextStyle detailtextstyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blue,
      shadows: [
        Shadow(color: Colors.yellow, offset: Offset(0.1, 0.1), blurRadius: 2)
      ]);
  _showCountryDetails(BuildContext context, Country country, bool canbeboughtt,
      int index) async {
    // print(country.productions);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Center(
              child: Text(
            country.name,
            style: detailtextstyle,
          )),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            //height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${Languages.price[langindex]}: ',
                        style: detailtextstyle),
                    Text('\$${country.price.floor()}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${Languages.income[langindex]}: ',
                        style: detailtextstyle),
                    Text('\$${country.income.floor()}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${Languages.owners[langindex]}: ',
                        style: detailtextstyle),
                    Text(country.owners[0] == 'No owner'
                        ? Languages.yok[langindex]
                        : country.owners[0].split(',').length > 2
                            ? country.owners[0]
                                .split(',')
                                .map((e) =>
                                    country.owners[0].split(',').indexOf(e) %
                                                2 ==
                                            1
                                        ? e = e + '\n'
                                        : e = e)
                                .join(' , ')
                            : country.owners[0]),
                  ],
                ),
                // Text(country.owners.isEmpty
                //     ? '${Languages.owners[langindex]}: ${Languages.yok[langindex]}'
                //     : '${Languages.owners[langindex]}: ${country.owners.join(', ')}'),
                Text('${Languages.productions[langindex]}:',
                    style: detailtextstyle),
                Text(country.productions[0] == 'water'
                    ? Languages.water[langindex]
                    : country.productions[0].split(',').length > 3
                        ? country.productions[0]
                            .split(',')
                            .map((e) =>
                                country.productions[0].split(',').indexOf(e) %
                                            3 ==
                                        2
                                    ? e = e + '\n'
                                    : e = e)
                            .join(' , ')
                        : '${country.productions[0].split(',').join(' , ')}'),
                Image.asset(
                  CountryImageNames.countryImageNames[index],
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.99,
                ),
                SizedBox(
                    child: Container(
                  height: 10,
                )),
                Center(
                    child: Text(
                  Languages.youshouldreloadReminderBuying[langindex],
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                )),
                Text(wrongproductionerror,
                    style: const TextStyle(
                      color: Colors.red,
                    )),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /*
                !bought[index]
                    ? const Text('')
                    : TextButton(
                        onPressed:
                            //money < country.price.floor() || !canbebought
                            //? null
                            //:
                            () async {
                          ///////////////// SECOND DIALOG ////////////////////////
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(240, 27, 29, 27),
                                title: Center(
                                    child: Text(
                                  Languages.youcanbuythese[langindex] + ' : ',
                                  style: TextStyle(color: Colors.white),
                                )),
                                content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      findupgradableitems(money,
                                                      country.productions)
                                                  .length ==
                                              0
                                          ? Center(
                                              child: Text(
                                                  '${Languages.youdonthaveenoughmoney[langindex]}',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20)),
                                            )
                                          : Center(
                                              child: SizedBox(
                                                height: 60 *
                                                            upgradelistviewitems
                                                                .length
                                                                .toDouble() <
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5
                                                    ? 60 *
                                                        upgradelistviewitems
                                                            .length
                                                            .toDouble()
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.5,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: ListView.builder(
                                                    itemCount:
                                                        findupgradableitems(
                                                                money,
                                                                country
                                                                    .productions)
                                                            .length,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemBuilder: (context,
                                                        listviewindex) {
                                                      return Card(
                                                          child: InkWell(
                                                              onTap: () async {
                                                                /////////////// UPGRADE LAST CHECK DIALOG /////////////////////
                                                                await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        title: Center(
                                                                            child: Column(
                                                                          children: [
                                                                            Text(
                                                                              findupgradableitems(money, country.productions)[listviewindex].keys.first,
                                                                              style: const TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromARGB(158, 33, 149, 243),
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              findupgradableitems(money, country.productions)[listviewindex].values.first.toString() + "\$",
                                                                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text(
                                                                              Languages.doyouwanttoupgrade[langindex] + ' : ',
                                                                              style: const TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromARGB(158, 33, 149, 243),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                        actions: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              TextButton(
                                                                                onPressed: () async {
                                                                                  await FBOp.upgradeCountryItemFB(index, findupgradableitems(money, country.productions)[listviewindex]).then((value) => {
                                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Game()))
                                                                                      });
                                                                                },
                                                                                child: Text(
                                                                                  Languages.upgrade[langindex] == "アップグレード" ? Languages.upgrade[langindex].substring(0, 3) + '\n' + Languages.upgrade[langindex].substring(3) : Languages.upgrade[langindex],
                                                                                  style: const TextStyle(color: Colors.green, fontSize: 20),
                                                                                ),
                                                                              ),
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  playSampleSound('assets/sounds/close.mp3');
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Text(
                                                                                  Languages.cancel[langindex],
                                                                                  style: const TextStyle(color: Colors.red, fontSize: 20),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      );
                                                                    });
                                                                //////////////// END OF THE THIRD DIALOG /////////////////
                                                              },
                                                              child: ListTile(
                                                                //title: Center(child: Text(myCountryList[index].name,style: const TextStyle(fontSize: 22,color: Colors.blue,fontWeight: FontWeight.bold),)),
                                                                subtitle:
                                                                    Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                          findupgradableitems(money, country.productions)[listviewindex]
                                                                              .keys
                                                                              .first
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              color: Colors.green,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Text(
                                                                          findupgradableitems(money, country.productions)[listviewindex].values.first.toString() +
                                                                              "\$",
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: Colors.orange,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )));
                                                    }),
                                              ),
                                            ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ]),
                                actions: [
                                  Center(
                                    child: TextButton(
                                        onPressed: () {
                                          playSampleSound(
                                              'assets/sounds/close.mp3');
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          Languages.cancel[langindex],
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 19,
                                              letterSpacing: 2),
                                        )),
                                  )
                                ],
                              );
                            },
                          );
                          ////////////// END OF THE SECOND DIALOG  //////////////////////
                        },
                        child: Text(
                          Languages.upgrade[langindex] == "アップグレード"
                              ? Languages.upgrade[langindex].substring(0, 3) +
                                  '\n' +
                                  Languages.upgrade[langindex].substring(3)
                              : Languages.upgrade[langindex],
                          style: TextStyle(
                              color: // money >= country.price.floor()
                                  //?
                                  Colors.green,
                              // : Colors.red,
                              fontSize: 20),
                        ),
                      ),
                */
                bought[index]
                    ? const Text('')
                    : TextButton(
                        onPressed: money < country.price.floor() || !canbebought
                            ? null
                            : () async {
                                //print(canbebought);
                                if (canbebought) {
                                  money < country.price.floor()
                                      ? null
                                      : buythiscard(context, country, index);
                                  playSampleSound('assets/sounds/bought.mp3');
                                  /*
                                  DateTime now = DateTime.now();
                                  
                                  await FBOp.fetchUserTimesFB().then((value) {
                                    //FETCH TIMES FROM FB
                                    setState(() {
                                      boughttimes = value;
                                    });
                                  });
                                  boughttimes[index] = {
                                    now.hour.toString().trim(): now.minute
                                  };
                                  await FBOp.updateUserTimesAndOwnersFB(
                                      boughttimes,
                                      index); // UPDATE TIMES AND OWNER IN FB
                                  
                                }
                                */
                                  await GSheet().countryOwnerUpdate(
                                      country.name,
                                      FirebaseAuth
                                          .instance.currentUser!.displayName!);
                                  await greenBGColorFiller().then((value) =>
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Game()))); // WHEN COUNTRY IS BOUGHT UPDATE COLORS IN FB
                                }
                              },
                        child: Text(
                          Languages.buy[langindex],
                          style: TextStyle(
                              color: money >= country.price.floor()
                                  ? buttoncolor
                                  : Colors.red,
                              fontSize: 20),
                        ),
                      ),
                const SizedBox(
                  width: 50,
                  child: Text(''),
                ),
                TextButton(
                  onPressed: () {
                    playSampleSound('assets/sounds/close.mp3');
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    Languages.close[langindex],
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
              ],
            ),
            money < country.price.floor()
                ? Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        children: [
                          Text(
                            Languages.notenoughtmoney[langindex],
                            style: const TextStyle(
                                color: Colors.red, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  )
                : const Text(''),
          ],
        );
      },
    ); //.whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Game())));
  }

  void _showMoneyChange(BuildContext context, int moneychange) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.lightGreen[300],
          title: Center(
              child: Text(
            Languages.congratulations[langindex],
            style: const TextStyle(color: Colors.white, fontSize: 30),
          )),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    Languages.youearnedfromcountries[langindex],
                    style: const TextStyle(color: Colors.white, fontSize: 19),
                  ),
                  Text(
                    '\$$moneychange',
                    style: const TextStyle(color: Colors.white, fontSize: 19),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Text(
                    Languages.ok[langindex],
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _userNameChange(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.lightGreen[300],
          title: Center(
              child: Text(
            Languages.changeUserNickname[langindex],
            style: const TextStyle(color: Colors.white, fontSize: 19),
          )),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(onChanged: (value) {
                      setState(() {
                        nickname = value;
                      });
                    }),
                  ),
                  Center(
                      child: Text(
                    Languages.chooseAUniqueNickname[langindex],
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  )),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (nickname.isNotEmpty) {
                        await FBOp.changeUserNickname(nickname)
                            .then((value) => {Navigator.of(context).pop()});
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Center(
                      child: Text(
                        Languages.ok[langindex],
                        style: const TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void buythiscard(BuildContext context, Country country, int index) async {
    if (money >= country.price.floor()) {
      setState(() {
        money -= country.price.floor();
      });
    } else {
      // _showNotEnoughMoneyError(context);
    }

    setState(() {
      bought[index] = true;
    });
    await GSheet().updateUserMoney(money.toString());
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    FBOp.updateCountriesNewIncomesFB();
    //FBOp.allCountryManagementFB(temp);// UPDATE COUNTRIES PRICES AND INCOMES FB---RESET
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> userssnapshot) {
        if (!userssnapshot.hasData) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title:
                    Text(FirebaseAuth.instance.currentUser!.displayName ?? ''),
                backgroundColor: Colors.blue,
              ),
              body: const CircularProgressIndicator(),
            ),
          );
        }
        //countries = [];
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream:
                FirebaseFirestore.instance.collection('countries').snapshots(),
            builder: (context, countriessnapshot) {
              if (!countriessnapshot.hasData) {
                return SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(
                          FirebaseAuth.instance.currentUser!.displayName ?? ''),
                      backgroundColor: Colors.blue,
                    ),
                    body: const CircularProgressIndicator(),
                  ),
                );
              }
              //for (var doc in userssnapshot.data!.docs) {
              //  var map = doc.data() as Map<String, dynamic>;
//
              //  if (map['nickname'] ==
              //      FirebaseAuth.instance.currentUser!.displayName) {
              //    //print(map['bought'].runtimeType);
              //    player = Player(
              //            map['nickname'],
              //            map['email'],
              //            map['money'],
              //            List<bool>.from(map['bought']),
              //            List<Map<String, dynamic>>.from(map['times']),
              //            List<int>.from(map['appcolorTheme']),
              //            List<int>.from(map['bgcolorTheme']),
              //            map['language'])
              //        .getPlayer;
              //  }
              //}
              money = player.money!;

              // if (!countryBreaker) {

              for (var element in countries) {
                if (money >= element.price.floor()) {
                  buyablecountries.add(countries.indexOf(element));
                }
              }
              //  countryBreaker = true;
              //}
              //countries.forEach((element) { print(element.owner);});
              return Scaffold(
                backgroundColor: bgcolor,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        //color: Colors.red,
                        width: 120,
                        height: 50,
                        child: Center(
                          child: Text(
                            '${player.money}\$',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                          width: 90,
                          height: 50,
                          child: Center(
                              child: InkWell(
                            onTap: () => _userNameChange(context),
                            child: Text(
                              '${FirebaseAuth.instance.currentUser!.displayName ?? player.nickname}',
                              style: const TextStyle(
                                  fontSize: 22, color: Colors.white),
                            ),
                          ))),
                    ],
                  ),
                  centerTitle: true,
                  backgroundColor: appBarColor,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.replay,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Game()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.list,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyCountryList()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IntroPage()),
                      ),
                    ),
                  ],
                ),
                body: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: countries.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 10, color: Colors.amber),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: CountryImageNames.countryandcitynumber,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () async {
                                    await FBOp
                                            .checkNeededProductionsBoughtBefore(
                                                countriessnapshot,
                                                productionpairs,
                                                countries[index]
                                                    .productions
                                                    .first
                                                    .toString())
                                        .then((value) {
                                      value.keys.first == true
                                          ? setState(() {
                                              canbebought = true;
                                            })
                                          : setState(() {
                                              canbebought = false; ////
                                            });
                                      setState(() {
                                        canbebought
                                            ? wrongproductionerror = ''
                                            : wrongproductionerror = Languages
                                                        .wrongproductionerror[
                                                    langindex] +
                                                ':    ${value.values.first}';
                                        canbebought
                                            ? buttoncolor = Colors.green
                                            : buttoncolor = Colors.red;
                                      });
                                    }).then((value) => _showCountryDetails(
                                            context,
                                            countries[index],
                                            canbebought,
                                            index));
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      //image: index != 0 ? null :
                                      //Image.asset('images/australia.jpg',fit: BoxFit.fill, scale: 1.5),

                                      color: bought[index]
                                          ? Colors.green
                                          : buyablecountries.contains(index)
                                              ? Colors.blue
                                              : Colors.red,
                                      border: Border.all(
                                          color: Colors.blue, width: 0.1),
                                      shape: BoxShape.rectangle,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    child: Card(
                                      color: bought[index]
                                          ? Colors.green
                                          : Colors.white,
                                      elevation: 5,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text(
                                                countries[index]
                                                        .name
                                                        .contains(' ')
                                                    ? countries[index]
                                                        .name
                                                        .split(' ')
                                                        .join('\n')
                                                    : countries[index].name,
                                                style: bought[index]
                                                    ? const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1)
                                                    : const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                countries[index]
                                                            .productions[0] ==
                                                        'water'
                                                    ? Languages.water[langindex]
                                                    : countries[index]
                                                                .productions
                                                                .length >
                                                            3
                                                        ? countries[index]
                                                                    .productions[
                                                                0] +
                                                            '\n' +
                                                            countries[index]
                                                                    .productions[
                                                                1] +
                                                            '\n' +
                                                            countries[index]
                                                                    .productions[
                                                                2] +
                                                            "\n  ::::: "
                                                        : countries[index]
                                                                .productions
                                                                .join('\n') +
                                                            "\n   + ",
                                                //maxLines: 3,
                                                overflow: TextOverflow.fade,
                                                style: bought[index]
                                                    ? const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1)
                                                    : const TextStyle(
                                                        fontSize: 10,
                                                        color: Color.fromARGB(
                                                            255, 255, 64, 0)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            },
                          )),
              );
            });
      },
    );
  }
}
