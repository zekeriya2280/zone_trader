import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zone_trader/models/country.dart';

class FBOp {
  //CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('countries');
  static addCountryTOFB(String name, int price, int income)async{
    CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('countries');
    fb.add({
      'name': name,
      'price': price,
      'income': income,
    });
  }

  static Future<List<Country>> fetchFromFBTOCountry()async{
    List<Country> cl = [];
    CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('countries');
    await fb.get().then((value) => value.docs.map((e) => cl.add(Country(
      name: e.data()['name'],
      price: e.data()['price'],
      income: e.data()['income'],
    ))));
    return cl;
  }

  static Future<void> updateMoneyFB(int money)async{
    CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('users');
    fb.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'money' : money
    });
  }

  static Future<void> updateBoughtColorsFB(List<bool> bought)async{
    CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('users');
    
    await fb.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'bought' : bought
    });
    
  }

  static Future<List<bool>> fetchBoughtColorsFB()async{
    CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('users');
    return List<bool>.from(await fb.doc(FirebaseAuth.instance.currentUser!.displayName).get().then((value) => value.data()!['bought']));
  }

  static Future<void> updateUserTimesFB(List<Map<String,dynamic>> times)async{
    CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('users');
    await fb.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'times' : times
    });
  }

  static Future<List<Map<String,dynamic>>> fetchUserTimesFB()async{
    CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('users');
    return List<Map<String,dynamic>>.from(await fb.doc(FirebaseAuth.instance.currentUser!.displayName).
                                    get().
                                      then((value) => Map<String, dynamic>.from(value.data()!)['times']));
  }

  static Future<List<Map<String,int>>> fetchBoughtIndexHourAndMinutesFB()async{
    List<Map<String,int>> a = [];
    CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('users');
    List<Map<String,dynamic>> times = 
    List<Map<String,dynamic>>.from(await fb.doc(FirebaseAuth.instance.currentUser!.displayName).get().
                                          then((value) => Map<String, dynamic>.from(value.data()!)['times']));
    for(int i = 0; i < times.length; i++){
      times[i].forEach((key, value) {
        if(value != 60){
          a.add({times[i].keys.first : times[i].values.first});
        }
      });
    }
    return a;
  }

  static Future<List<int>> fetchBoughtIndexFB()async{
    List<int> a = [];
    CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('users');
    List<Map<String,dynamic>> times = List<Map<String,dynamic>>.from(await fb.doc(FirebaseAuth.instance.currentUser!.displayName).get().
                                          then((value) => Map<String, dynamic>.from(value.data()!)['times']));
    for(int i = 0; i < times.length; i++){
      times[i].forEach((key, value) {
        if(value != 60){
          a.add(i); 
        }
      });
    }
    
    return a;
  }

  static Future<int> findCountryIncomeAndAddFB(List<double> howmanyincomes)async{
    List<int> indexes = [];
    await fetchBoughtIndexFB().then((value) { indexes = value; });
    
    CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('countries');
    List<int> incomes = [];
    for (var i = 0; i < indexes.length; i++) {
      incomes.add(await fb.get().then((value) => value.docs[indexes[i]].data()['income']));
    }
    CollectionReference<Map<String, dynamic>> fb2 = FirebaseFirestore.instance.collection('users');
    int oldmoney  = await fb2.doc(FirebaseAuth.instance.currentUser!.displayName).get().then((value) => Map<String, dynamic>.from(value.data()!)['money']);
    List<Map<String,int>> test =  List<Map<String,int>>.filled(48, {'60':60});
    for (var i = 0; i < indexes.length; i++) {
      test[indexes[i]] = {DateTime.now().hour.toString() : DateTime.now().minute};
    }
    int sum = 0;
    for (var i = 0; i < incomes.length; i++) {
      sum = sum + (incomes[i] * howmanyincomes[i]).floor();
    }
    //print('sum $sum');
    fb2.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'money' : (oldmoney + sum),
      'times' : test,
    });
    return sum;
  }
  static Future<void> updateCountriesIncomesFB()async{
    CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('countries');
    List<int> prices = [];
    for (var i = 0; i < 48; i++) {
      prices.add(await fb.get().then((value) => value.docs[i].data()['price']));
    }
    print(prices);
    CollectionReference<Map<String, dynamic>> fb2 = FirebaseFirestore.instance.collection('countries');
    for (var i = 0; i < 48; i++) {
      fb2.get().then((value) => fb2.doc(value.docs[i].id).update({
        'income' : (prices[i] * 0.15).floor()
      }));
    }
  }
  static Future<void> changeSamePricesFB() async{
    CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('countries');
    List<int> prices = [];
    List<int> samenumbers = [];
    for (var i = 0; i < 48; i++) {
      prices.add(await fb.get().then((value) => value.docs[i].data()['price']));
    }
    for (var i = 0; i < prices.length; i++) {
      for (var j = 1; j < prices.length; j++) {
        if(i != j && prices[i] == prices[j]){
          samenumbers.add(prices[i]);
          fb.get().then((value) => fb.doc(value.docs[i].id).update({
            'price' : ((prices[i] * 3).floor() / 20).floor() * 10,
          }));
        }
      }
    }
    print(samenumbers);
    for (var i = 0; i < prices.length; i++) {
        if((prices[i]/10000).floor() > 1){
          fb.get().then((value) => fb.doc(value.docs[i].id).update({
            'price' : ((prices[i] / 10).floor() / 10).floor() * 10,
          }));
        } 
        else if((prices[i]/1000).floor() == 0) { 
          fb.get().then((value) => fb.doc(value.docs[i].id).update({
            'price' : prices[i] * 10,
          }));
        }
        else{
          continue;
        }
    }
  }
  
}