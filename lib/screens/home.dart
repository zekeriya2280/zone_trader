import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zone_trader/authentication/signin.dart';
import 'package:zone_trader/constants/countryImageNames.dart';
import 'package:zone_trader/firebase/FBOp.dart';
import 'package:zone_trader/models/country.dart';
import 'package:zone_trader/models/player.dart';
import 'package:zone_trader/screens/myCountryList.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Country> countries = []; //
  int money = 10000;
  bool countryBreaker = false;
  Player player = Player('', '', 0, [], []);
  List<bool> bought = List<bool>.filled(48, false);
  List<Map<String, dynamic>> boughttimes =
      List<Map<String, dynamic>>.filled(48, {'60': 60});

  @override
  void initState() {
    updateBought();
    super.initState();
  }

  Future<void> updateBought() async {
    //await FBOp.resetTimesFB(boughttimes); //RESETS TIMES FB---RESET!!!
    //await FBOp.updateCountryOwners(); //ADDS OWNER FIELDS TO ALL COUNTRIES FB---RESET!!!
    //await FBOp.updateBoughtColorsFB(List<bool>.filled(48, false)); // ALL COUNTRIES ARE NOT BOUGHT---RESET!!!
    //await FBOp.updateCountriesIncomesFB(); // MAKE ALL INCOMES 20% OF THE PRICES FB---RESET!!!
    //await FBOp.changeSamePricesFB(); // CHANGE SAME PRICES FB---RESET!!!
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
      allsubmin.add(
          ((now.minute + (now.hour - int.parse(time.keys.first)) * 60) -
              time.values.first));
    }
    //print('allsubmin $allsubmin');
    List<double> howmanyincomes = [];
    for (var submin in allsubmin) {
      howmanyincomes.add(submin / 5);
    }

    await FBOp.findCountryIncomeAndAddFB(howmanyincomes)
        .then((value) => moneychange = value);
    //print(moneychange);
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
              Text('Price:           \$${country.price.floor()}'),
              Text('Income:        \$${country.income.floor()}'),
              Text('Owner:         ${country.owner}'),
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
                      'You should reload home page after buying!!',
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )),
            ],
          ),
          actions: [
            Row(
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
                              },
                        child: Text(
                          'Buy',
                          style: TextStyle(
                              color: money >= country.price.floor()
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 20),
                        ),
                      ),
                const SizedBox(
                  width: 110,
                  child: Text(''),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.red, fontSize: 20),
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
                      child: const Text(
                        'NOT ENOUGH MONEY',
                        style: TextStyle(color: Colors.red, fontSize: 15),
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
          title: const Center(
              child: Text(
            'Congratulations!!!',
            style: TextStyle(color: Colors.white, fontSize: 30),
          )),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'You earned from countries',
                    style: TextStyle(color: Colors.white, fontSize: 19),
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
                child: const Center(
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
              ),
            ),
            /*
            money < country.price.floor() ? 
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'NOT ENOUGH MONEY',
                  style: TextStyle(color: Colors.red, fontSize: 15),
                ),
              ),
            )
            : const Text(''),
            */
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
    Navigator.of(context).pop();

    //Navigator.push(
    //  this.context,MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
    //);
  }

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

              if (!countryBreaker) {
                for (var doc in countriessnapshot.data!.docs) {
                  countries.add(Country(
                      name: doc.data()['name'],
                      price: doc.data()['price'],
                      income: doc.data()['income'],
                      owner: doc.data()['owner']));
                }
                countryBreaker = true;
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
                          List<Map<String, dynamic>>.from(map['times']))
                      .getPlayer;
                }
              }
              money = player.money!;

              return Scaffold(
                backgroundColor: const Color.fromARGB(255, 169, 197, 246),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        //color: Colors.red,
                        width: 130,
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
                          width: 100,
                          height: 50,
                          child: Center(
                              child: Text(
                            '${FirebaseAuth.instance.currentUser!.displayName ?? player.nickname}',
                            style: const TextStyle(
                                fontSize: 22, color: Colors.white),
                          ))),
                    ],
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.blue[400],
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
                              builder: (context) => const HomeScreen()),
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
                        Icons.exit_to_app,
                        color: Colors.red,
                        size: 16,
                      ),
                      onPressed: () => signOut(context),
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

                                color: Colors.yellow,
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
