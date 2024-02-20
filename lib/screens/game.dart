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
  List<bool> bought = List<bool>.filled(48, false);
  List<Map<String, dynamic>> boughttimes =
      List<Map<String, dynamic>>.filled(48, {'60': 60});
  Color appBarColor = Colors.blue;
  Color bgcolor = Colors.white;
  int langindex = 0;
  List<int> buyablecountries = [];
  var langs = [
    'ENG',
    'TR',
    'ES',
    'JP',
  ];
  String nickname = "";
  String chooseAUniqueNickname = "";

  @override
  void initState() {
    updateBought();
    getLang();
    updateNickname();
    colorProducer();
    super.initState();
  }
  void getLang()async{
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

  void playSampleSound(String path) async {
    AudioPlayer player = AudioPlayer();
    await player.setAsset(path);
    await player.play();
  }

  Future<void> updateBought() async {
    //await FBOp.resetTimesFB(boughttimes); //RESETS TIMES FB---RESET!!!
    //await FBOp.updateCountryOwners(); //ADDS OWNER FIELDS TO ALL COUNTRIES FB---RESET!!!
    //await FBOp.updateBoughtColorsFB(List<bool>.filled(48, false)); // ALL COUNTRIES ARE NOT BOUGHT---RESET!!!
    //await FBOp.updateCountriesIncomesFB(); // MAKE ALL INCOMES 20% OF THE PRICES FB---RESET!!!
    //await FBOp.changeSamePricesFB(); // CHANGE SAME PRICES FB---RESET!!!
    /*
    await FBOp.addToCountriesNewVariablesFB(// ADD NEW VARIABLES TO COUNTRIES FB---RESET!!!
      {'production': 'banana'},
      {'production': 'apple'},
      {'production': 'milk'},
      {'production': 'cheese'},
      {'production': 'wheat'},
      {'production': 'bread'},
      {'production': 'sugar'},
      {'production': 'rice'},
      {'production': 'fish'},
      {'production': 'beef'},
      {'production': 'cotton'},
      {'production': 'rubber'},
      {'production': 'iron'},
      {'production': 'silver'},
      {'production': 'copper'},
      {'production': 'gold'},
      {'production': 'coal'},); 
    */
    await FBOp.fetchBoughtColorsFB().then((value) {
      setState(() {
        bought = value;
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
      howmanyincomes.add(submin / 5);
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
    await FBOp.updateBoughtColorsFB(bought);
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

  void _showCountryDetails(BuildContext context, Country country, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(country.name)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${Languages.price[langindex]}: \$${country.price.floor()}'),
              Text('${Languages.income[langindex]}: \$${country.income.floor()}'),
              Text(country.owner.isEmpty ? '${Languages.owner[langindex]}: ${Languages.yok[langindex]}' : '${Languages.owner[langindex]}: ${country.owner}'),
              Text('${Languages.production[langindex]}: ${country.production}'),
              Image.asset(
                CountryImageNames.countryImageNames[index],
                alignment: Alignment.center,
              ),
              SizedBox(
                  child: Container(
                height: 10,
              )),
              country.owner.isNotEmpty
                  ? const Text('')
                  : Center(
                      child: Text(
                      Languages.youshouldreloadReminderBuying[langindex],
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                bought[index] || country.owner.isNotEmpty
                    ? const Text('')
                    : TextButton(
                        onPressed: money < country.price.floor()
                            ? null
                            : () async {
                                //print(country.price.floor());
                                money < country.price.floor()
                                    ? null
                                    : buythiscard(context, country, index);
                                playSampleSound('assets/sounds/bought.mp3');
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
                                await FBOp.updateUserTimesAndOwnerFB(
                                    boughttimes,
                                    index); // UPDATE TIMES AND OWNER IN FB
                                await greenBGColorFiller(); // WHEN COUNTRY IS BOUGHT UPDATE COLORS IN FB
                                await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Game()));
                              },
                        child: Text(
                          Languages.buy[langindex],
                          style: TextStyle(
                              color: money >= country.price.floor()
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 20),
                        ),
                      ),
                const SizedBox(
                  width: 60,
                  child: Text(''),
                ),
                TextButton(
                  onPressed: () {
                    playSampleSound('assets/sounds/close.mp3');
                    Navigator.of(context).pop();
                  },
                  child:  Text(
                    Languages.cancel[langindex],
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
                      child:  Text(
                        Languages.notenoughtmoney[langindex],
                        style: const TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ),
                  )
                : const Text(''),
          ],
        );
      },
    );//.whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Game())));
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
                    Languages.cancel[langindex],                    
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
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          nickname = value;
                        });
                      }
                    ),
                  ),
                  Center(child: Text(
                      Languages.chooseAUniqueNickname[langindex],
                      style: const TextStyle(color: Colors.red, fontSize: 14),)),
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
                    onPressed: () async{
                      if(nickname.isNotEmpty){
                        
                        await FBOp.changeUserNickname(nickname).then((value) => {
                          Navigator.of(context).pop()
                        });
                      }
                      else{
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
    await FBOp.updateMoneyFB(money);
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    
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
              for (var doc in userssnapshot.data!.docs) {
                var map = doc.data() as Map<String, dynamic>;

                if (map['nickname'] ==
                    FirebaseAuth.instance.currentUser!.displayName) {
                  //print(map['bought'].runtimeType);
                  player = Player(
                          map['nickname'],
                          map['email'],
                          map['money'],
                          List<bool>.from(map['bought']),
                          List<Map<String, dynamic>>.from(map['times']),
                          List<int>.from(map['appcolorTheme']),
                          List<int>.from(map['bgcolorTheme']),
                          map['language'])
                      .getPlayer;
                }
              }
              money = player.money!;
              
              
              if (!countryBreaker) {
                for (var doc in countriessnapshot.data!.docs) {
                  countries.add(Country(
                      name: doc.data()['name'],
                      price: doc.data()['price'],
                      income: doc.data()['income'],
                      owner: doc.data()['owner'],
                      production: doc.data()['production']),);
                }
                for (var element in countries) {
                if (money > element.price.floor()) {
                    buyablecountries.add(countries.indexOf(element));
                  }
                }
                countryBreaker = true;
              }
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
                          MaterialPageRoute(
                              builder: (context) => const Game()),
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
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: bought.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              _showCountryDetails(
                                  context, countries[index], index);
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                //image: index != 0 ? null :
                                //Image.asset('images/australia.jpg',fit: BoxFit.fill, scale: 1.5),

                                color: countries[index].owner.isEmpty ? buyablecountries.contains(index) ? Colors.blue : Colors.red : Colors.white,
                                border:
                                    Border.all(color: Colors.blue, width: 0.1),
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                              child: Card(
                                color: bought[index] ||
                                        countries[index].owner != ''
                                    ? Colors.green
                                    : Colors.white,
                                elevation: 5,
                                child: Center(
                                  child: Text(
                                    countries[index].name.contains(' ')
                                        ? countries[index]
                                            .name
                                            .split(' ')
                                            .join('\n')
                                        : countries[index].name,
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
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
