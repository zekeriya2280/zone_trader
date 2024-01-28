import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zone_trader/authentication/signin.dart';
import 'package:zone_trader/firebase/FBOp.dart';
import 'package:zone_trader/main.dart';
import 'package:zone_trader/models/country.dart';
import 'package:zone_trader/models/player.dart';

class HomeScreen extends StatefulWidget {
  final String? nickname;
  final String email;

  const HomeScreen(this.nickname, this.email, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Country> allcountries = [
    Country(name: 'Russia', price: 0, income: 0),
    Country(name: 'Antarctica', price: 0, income: 0),
    Country(name: 'United States', price: 0, income: 0),
    Country(name: 'China', price: 0, income: 0),
    Country(name: 'Brazil', price: 0, income: 0),
    Country(name: 'Australia', price: 0, income: 0),
    Country(name: 'India', price: 0, income: 0),
    Country(name: 'Argentina', price: 0, income: 0),
    Country(name: 'Kazakhstan', price: 0, income: 0),
    Country(name: 'Algeria', price: 0, income: 0),
    Country(name: 'Egypt', price: 0, income: 0),
    Country(name: 'Venezuela', price: 0, income: 0),
    Country(name: 'Canada', price: 0, income: 0),
    Country(name: 'Japan', price: 0, income: 0),
    Country(name: 'Malaysia', price: 0, income: 0),
    Country(name: 'Mexico', price: 0, income: 0),
    Country(name: 'Peru', price: 0, income: 0),
    Country(name: 'Philippines', price: 0, income: 0),
  ];
  List<Country> countries = []; //
  int money = 10000;
  bool countryBreaker = false;
  Player player = Player('', '', 0,[],[]);
  List<bool> bought = [];
  List<Timer> timers = [];
  List<Map<String,dynamic>> boughttimes = List<Map<String,dynamic>>.filled(48, {'60':60});

  @override
  void initState() {
    //countries = List.generate(
    //  10,
    //  (index) => Country(
    //    name: allcountries.reversed.toList()[index].name,
    //    price: 1000.0 + index * 500.0,
    //    income: 500.0 + index * 300.0,
    //  ),
    //);
  //for (var i = 0; i < allcountries.length; i++) {
  //   if(!countries.any((val) => val.name == allcountries[i].name)){
  //     FBOp.addCountryTOFB(allcountries[i].name, 1000+i*500, 300+ i*500);
  //   }
  //   
  // } 
   
    updateBought();
    super.initState();
  }
 // @override
 // void dispose() {
 //   for (var timer in timers) {
 //     timer.cancel();
 //   }
 //   super.dispose();
 // }
  Future<void> updateBought()async{
      //await FBOp.updateBoughtColorsFB(List<bool>.filled(48, false)); // ALL COUNTRIES ARE NOT BOUGHT---RESET!!!
      //await FBOp.updateCountriesIncomesFB(); // MAKE ALL INCOMES 20% OF THE PRICES FB---RESET!!!
      //await FBOp.changeSamePricesFB(); // CHANGE SAME PRICES FB---RESET!!!
      await FBOp.fetchBoughtColorsFB().then((value) {
      setState(() {
        bought = value;
      });
      }
      );
      DateTime now = DateTime.now();
      List<Map<String,int>> oldtimelist = [];
      int moneychange = 0;
      await FBOp.fetchBoughtIndexHourAndMinutesFB().then((value) => oldtimelist = value);
      print('oldtimelist $oldtimelist');
      List<int> allsubmin = []; 
      for (var time in oldtimelist) {
        allsubmin.add(((now.minute + 
                  (now.hour-int.parse(time.keys.first)) 
                        * 60) 
                        - time.values.first));
      }
      print('allsubmin $allsubmin');
      List<double> howmanyincomes = [];
      for (var submin in allsubmin) {
        howmanyincomes.add(submin/2);
      }
      
      await FBOp.findCountryIncomeAndAddFB(howmanyincomes).then((value) => moneychange = value);
      print(moneychange);
      _showMoneyChange(context, moneychange);
  }
  //void updateFirebase
  Future<void> greenBGColorFiller() async {
    
    await FBOp.updateBoughtColorsFB(bought);
    //print(countries);
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    ); // Go back to the sign-in screen
  }
  void _showCountryDetails(BuildContext context, Country country,int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(country.name)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Price: \$${country.price.toStringAsFixed(2)}'),
              Text('Income: \$${country.income.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            Row(children: [
              bought[index] ? const Text('') :
              TextButton(
              onPressed:
              money < country.price.floor() ? null :
              ()async{ 
                //print(country.price.floor());
                money < country.price.floor() ? null : buythiscard(country,index);
                DateTime now = DateTime.now();
                await FBOp.fetchUserTimesFB().then((value){ //FETCH TIMES FROM FB
                  setState(() {
                    boughttimes = value;
                  });});
                boughttimes[index] = {now.hour.toString().trim() : now.minute};
                await FBOp.updateUserTimesFB(boughttimes); // UPDATE TIMES IN FB
                await greenBGColorFiller(); // WHEN COUNTRY IS BOUGHT UPDATE COLORS IN FB
              },
              child: Text(
                'Buy',
                style: TextStyle(color: money >= country.price.floor() ? Colors.green : Colors.red, fontSize: 20),
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
            ],),
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
          title: const Center(child: Text('Congratulations!!!',style: TextStyle(color: Colors.white,fontSize: 30),)),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('You earned from countries', style: TextStyle(color: Colors.white,fontSize: 19),),
                  Text('\$$moneychange', style: TextStyle(color: Colors.white,fontSize: 19),),
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
                  child: const Text(
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

  void buythiscard(Country country,int index)async {
    
    if(money >= country.price.floor()){
      setState(() {
        money -= country.price.floor();
      });
    }
    else{
       // _showNotEnoughMoneyError(context);
    }
    
    setState(() {
      bought[index] = true;
    });
    await FBOp.updateMoneyFB(money);
    Navigator.of(context).pop();
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
                title: Text(widget.nickname ?? ''),
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
                      title: Text(widget.nickname ?? ''),
                      backgroundColor: Colors.blue,
                    ),
                    body: const CircularProgressIndicator(),
                  ),
                );
              }
              
              if(!countryBreaker){
                for (var doc in countriessnapshot.data!.docs) {
                 countries.add(Country(name: doc.data()['name'], price: doc.data()['price'], income: doc.data()['income'])); 
                }
                //print(countries.length);
                //bought = List<bool>.generate(countries.length, (index) => false);

               // for (var element in userssnapshot.data!.docs) {
               //   Map<String, dynamic> dt = element.data() as Map<String, dynamic>;
               //   if(dt['nickname'] == widget.nickname){
               //     FirebaseFirestore.instance.collection('users').doc(widget.nickname).update({'bought': List<bool>.generate(countries.length, (index) => false)});
               //     //dt['bought'] = List<bool>.generate(countries.length, (index) => false);
               //   }
               // }

                  countryBreaker = true;
              }
              for (var doc in userssnapshot.data!.docs) {
                var map = doc.data() as Map<String, dynamic>;
                
                if (map['nickname'] == widget.nickname) {
                    //print(map['bought'].runtimeType);
                    player = Player(map['nickname'], map['email'], map['money'], List<bool>.from(map['bought']) , List<Map<String,dynamic>>.from(map['times'])).getPlayer;
                    
                } 
                
               // if (doc.data()['nickname'] == widget.nickname) {
               //   
               // } 
              }
              money = player.money!;
              
              return Scaffold(
                appBar: AppBar(
                  //leading: 
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
                                        style: const TextStyle(fontSize: 18, color: Colors.yellow,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                      ),
                      SizedBox(width: 110,height: 50, child: Center(child: Text('${widget.nickname ?? player.nickname}', style: const TextStyle(fontSize: 22, color: Colors.white),))),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.blue[400],
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.list,color: Colors.white,),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GoodsListScreen()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.exit_to_app,color: Colors.white,),
                      onPressed: () => _signOut(context),
                    ),
                  ],
                ),
                body: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: bought.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              _showCountryDetails(context, countries[index],index);
                            },
                            child: Container(
                              
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                border: Border.all(color: Colors.blue,width: 0.1),
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Card(
                                color: bought[index] ? Colors.green : Colors.white,
                                elevation: 5,
                                child: Center(
                                  child: Text(
                                    countries[index].name,
                                    style: const TextStyle(fontSize: 16),
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
