import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  List<List<String>> boughttimes = List<List<String>>.filled(
      CountryImageNames.countryandcitynumber,
      ['9999', '99', '99', '60', '60', '60']);
  Color appBarColor = Colors.blue;
  Color bgcolor = Colors.white;
  int langindex = 0;
  List<int> enoughmoneycountries = [];
  bool canbebought = false;
  String wrongproductionerror = '';
  Color buttoncolor = Colors.red;
  int currentUserRowIndexGS = 0;
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
  DateTime oldboughttime = DateTime.now();
  DateTime newboughttime = DateTime.now();
  @override
  void initState() {
    updateBought();
    getLang();
    updateNickname();
    colorProducer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  void playSampleSound(String path) async {
    AudioPlayer player = AudioPlayer();
    await player.setAsset(path);
    await player.play();
  }

  Future<void> updateBought() async {
    //await GSheet().updateIncomesByPrices(); // UPDATE COUNTRIES INCOMES GSHEETS---RESET
    List<List<dynamic>> newcountries = [];
    await GSheet().getAllRows(0).then((value) => newcountries = value);
    for (var coun in newcountries) {
      setState(() {
        countries.add(Country(
          name: coun[1],
          price: int.parse(coun[2]),
          income: int.parse(coun[3]),
          owners: [coun[4]],
          production: coun[5],
        ));
      });
    }
    currentUserRowIndexGS =
        await GSheet().findCurrentUserRowIndex().then((value) => value + 1);
    List<String> userinfo = await GSheet()
        .getRowValues(1, currentUserRowIndexGS)
        .then((value) => value);
    setState(() {
      player = Player(
              userinfo[6],
              userinfo[3],
              int.parse(userinfo[5]),
              List<bool>.from(
                  userinfo[2].split(',').map((e) => e == 'true').toList()),
              List<List<String>>.from(userinfo[7]
                  .split(',')
                  .map((e) =>
                      e.split(' ')[0].split('-') + e.split(' ')[1].split(':'))
                  .toList()),
              List<int>.from(
                  userinfo[0].split(',').map((e) => int.parse(e)).toList()),
              List<int>.from(
                  userinfo[1].split(',').map((e) => int.parse(e)).toList()),
              userinfo[4])
          .getPlayer;
    });
    await GSheet().getBoughtValues(currentUserRowIndexGS).then((value) {
      setState(() {
        bought = value.map((e) => e == "true" ? true : false).toList();
      });
    });
    List<List<String>> oldtimelist = [];
    int moneychange = 0;
    oldtimelist = player.times;
    List<int> allsubmin = [];
    for (var time in oldtimelist) {
      String month = time[1].length == 1 ? '0' + time[1] : time[1];
      String day = time[2].length == 1 ? '0' + time[2] : time[2];
      String hour = time[3].length == 1 ? '0' + time[3] : time[3];
      String minute = time[4].length == 1 ? '0' + time[4] : time[4];
      String second = time[5].length == 1 ? '0' + time[5] : time[5];
      allsubmin.add(DateTime.now()
          .difference(DateTime.parse(time[0] +
              '-' +
              month +
              '-' +
              day +
              ' ' +
              hour +
              ':' +
              minute +
              ':' +
              second))
          .inMinutes);
    }
    //print('allsubmin : ' + allsubmin.toString());
    List<double> howmanyincomes = [];
    for (var submin in allsubmin) {
      if (submin > 0) {
        howmanyincomes.add(submin % 5 == 0 ? submin / 5 : 0.0);
      } else {
        howmanyincomes.add(0.0);
      }
    }
    //print('howmanyincomes : $howmanyincomes');
    await GSheet()
        .findCountryIncomeAndAddGS(howmanyincomes, currentUserRowIndexGS)
        .then((value) => moneychange = value);
    moneychange != 0
        ? playSampleSound('assets/sounds/homeinitpopup.mp3')
        : false;
    howmanyincomes.any((element) => element != 0.0)
        ? await GSheet().updateIndexedTimesGS(currentUserRowIndexGS)
        : false;
    moneychange != 0 ? _showMoneyChange(context, moneychange) : false;
  }

  //void updateFirebase
  Future<void> greenBGColorFiller() async {
    await GSheet().updateBoughtColorsGS(bought, currentUserRowIndexGS);
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
                Text('${Languages.production[langindex]}:',
                    style: detailtextstyle),
                Text(country.production == 'water'
                    ? Languages.water[langindex]
                    : '${country.production}'),
                Image.asset(
                  CountryImageNames.countryImageNames[index],
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.99,
                ),
                SizedBox(
                    child: Container(
                  height: 10,
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
                                  await GSheet()
                                      .fetchUserTimesGS(currentUserRowIndexGS)
                                      .then((value) {
                                    //FETCH TIMES FROM FB
                                    setState(() {
                                      boughttimes = value;
                                    });
                                  });
                                  //print(boughttimes);
                                  setState(() {
                                    boughttimes[index] = [
                                      DateTime.now().year.toString(),
                                      DateTime.now().month.toString(),
                                      DateTime.now().day.toString(),
                                      DateTime.now().hour.toString(),
                                      DateTime.now().minute.toString(),
                                      DateTime.now().second.toString()
                                    ];
                                  });
                                  print('last boughttimes : ' +
                                      boughttimes.toString());
                                  await GSheet().updateUserTimesGS(
                                      boughttimes, currentUserRowIndexGS);
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
                ? bought[index]
                    ? const Text('')
                    : Center(
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
    );
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
                onPressed: () async {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const Game()));
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
    } else {}

    setState(() {
      bought[index] = true;
    });
    await GSheet().updateUserMoney(money.toString(), currentUserRowIndexGS);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      oldboughttime = DateTime.now();
    });
    String month = oldboughttime.month.toString().characters.length == 1
        ? '0' + oldboughttime.month.toString()
        : oldboughttime.month.toString();
    String day = oldboughttime.day.toString().characters.length == 1
        ? '0' + oldboughttime.day.toString()
        : oldboughttime.day.toString();
    String hour = oldboughttime.hour.toString().characters.length == 1
        ? '0' + oldboughttime.hour.toString()
        : oldboughttime.hour.toString();
    String minute = oldboughttime.minute.toString().characters.length == 1
        ? '0' + oldboughttime.minute.toString()
        : oldboughttime.minute.toString();
    String second = oldboughttime.second.toString().characters.length == 1
        ? '0' + oldboughttime.second.toString()
        : oldboughttime.second.toString();
    await prefs.setString(
        'oldboughttime',
        oldboughttime.year.toString() +
            '-' +
            month +
            '-' +
            day +
            ' ' +
            hour +
            ':' +
            minute +
            ':' +
            second);
  }

  Future<void> timerManager() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      newboughttime = DateTime.now();
      oldboughttime = DateTime.parse(prefs.getString('oldboughttime') ??
          DateTime.now().add(Duration(days: 365)).toString());
    });
  }
  GradientTransform? RotationGradientTransform(double angle) {
    return angle == 0.0
        ? null
        : GradientRotation(angle * 3.1415926535897932 / 180);
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    timerManager();
    bool appbarbool = newboughttime.difference(oldboughttime).inSeconds >
        Duration(seconds: 30).inSeconds;
    money = player.money;
    for (var element in countries) {
      if (money >= element.price.floor()) {
        enoughmoneycountries.add(countries.indexOf(element));
      }
    }
    return countries.isEmpty || player.nickname == ''
        ? SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  FirebaseAuth.instance.currentUser!.displayName ?? '',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue,
              ),
              body: Center(
                  child: const CircularProgressIndicator(
                strokeWidth: 10,
                color: Colors.amber,
              )),
            ),
          )
        : Scaffold(
            backgroundColor: bgcolor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    //color: Colors.red,
                    width: 80,
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
                    width: 40,
                    height: 60,
                    child: Center(
                      child: Text(
                        '${newboughttime.difference(oldboughttime).inSeconds > 30 || newboughttime.difference(oldboughttime).inSeconds < 0 ? 'BUY' : (30 - newboughttime.difference(oldboughttime).inSeconds).toString()}',
                        style: TextStyle(
                            background: Paint()
                              ..shader = LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.repeated,
                                      transform: RotationGradientTransform(30.0),
                                      colors: [Colors.yellow.shade800, Colors.brown.shade800])
                                  .createShader(
                                      Rect.fromLTWH(0.0, 0.0, 5.0, 2.0)),
                            fontSize: 18,
                            color:Colors.white,
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
                    MaterialPageRoute(builder: (context) => const IntroPage()),
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
                              onTap: !appbarbool &&
                                      oldboughttime.isBefore(new DateTime.now())
                                  ? null
                                  : () async {
                                      await GSheet()
                                          .checkNeededProductionsBoughtBeforeGS(
                                              productionpairs,
                                              countries[index].production,
                                              countries
                                                  .map((e) => e.production)
                                                  .toList(),
                                              countries
                                                  .map((e) => e.owners)
                                                  .toList())
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
                                  color: bought[index]
                                      ? Colors.green
                                      : enoughmoneycountries.contains(index)
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
                                            countries[index].name.contains(' ')
                                                ? countries[index]
                                                    .name
                                                    .split(' ')
                                                    .join('\n')
                                                : countries[index].name,
                                            style: bought[index]
                                                ? const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1)
                                                : const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            countries[index].production ==
                                                    'water'
                                                ? Languages.water[langindex]
                                                : countries[index].production,
                                            //maxLines: 3,
                                            overflow: TextOverflow.fade,
                                            style: bought[index]
                                                ? const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
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
  }
}
