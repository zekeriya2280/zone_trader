import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zone_trader/models/country.dart';

class FBOp {
  static CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');
  static CollectionReference<Map<String, dynamic>> countries =
      FirebaseFirestore.instance.collection('countries');
  static Future<String> registerUserFB(
      String nickname, String email, String dropdownvalue) async {
    if (await users.get().then(
        (value) => value.docs.every((element) => element.id != nickname))) {
      await users.doc(nickname).set({
        'nickname': nickname,
        'email': email,
        'money': 2000,
        'bought': List<bool>.filled(48, false),
        'times': List<Map<String, dynamic>>.filled(48, {'60': 60}),
        'language': dropdownvalue,
        'appcolorTheme': [],
        'bgcolorTheme': []
      });
      return '';
    } else {
      return 'Nickname already exists';
    }
  }

  static addCountryTOusers(String name, int price, int income) async {
    countries.add({
      'name': name,
      'price': price,
      'income': income,
    });
  }

  static Future<List<Country>> fetchFromFBTOCountry() async {
    List<Country> cl = [];
    await countries.get().then((value) => value.docs.map((e) => cl.add(Country(
        name: e.data()['name'],
        price: e.data()['price'],
        income: e.data()['income'],
        owners: e.data()['owners'],
        productions: e.data()['productions']))));
    return cl;
  }

  static Future<void> updateMoneyFB(int money) async {
    users
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .update({'money': money});
  }

  static Future<void> updateBoughtColorsFB(List<bool> bought) async {
    await users
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .update({'bought': bought});
  }

  static Future<void> resetTimesFB(List<Map<String, dynamic>> times) async {
    await users
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .update({'times': times});
  }

  static Future<void> updateCountryOwners() async {
    await countries.get().then((value) => value.docs.forEach((e) => countries
            .doc(e.id)
            .update({
          'owners': List<String>.filled(0, ''),
          'owner': FieldValue.delete()
        })));
  }

  static Future<void> updateProductionsFB() async {
    List<String> productions = [];
    await countries.get().then((value) => value.docs.forEach((e) {
          productions.add(e.data()['production']);
        }));
    await countries.get().then((value) => value.docs.forEach((e) {
          countries.doc(e.id).update({
            'productions': List<String>.filled(0, ''),
            'production': FieldValue.delete()
          });
        }));
    await countries.get().then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        List<String> productions2 = [];
        productions2.add(productions[i]);
        countries.doc(value.docs[i].id).update({'productions': productions2});
      }
      //value.docs.forEach((e) {
      //}
      //);
    });
  }

  static Future<List<bool>> fetchBoughtColorsFB() async {
    return List<bool>.from(await users
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .get()
        .then((value) => value.data()!['bought']));
  }

  static Future<void> updateUserTimesAndOwnersFB(
      List<Map<String, dynamic>> times, int index) async {
    await users
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .update({'times': times});
    List<String> owners = [];
    await countries.get().then((value) =>
        owners = List<String>.from(value.docs[index].data()['owners']));
    owners.add(FirebaseAuth.instance.currentUser!.displayName!);
    await countries.get().then((value) =>
        countries.doc(value.docs[index].id).update({'owners': owners}));
  }

  static Future<List<String>> fetchownersFB(int index) async {
    List<String> owners = [];
    await countries.get().then((value) =>
        owners = List<String>.from(value.docs[index].data()['owners']));
    return owners;
  }

  static Future<List<Map<String, dynamic>>> fetchUserTimesFB() async {
    return List<Map<String, dynamic>>.from(await users
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .get()
        .then((value) => Map<String, dynamic>.from(value.data()!)['times']));
  }

  static Future<List<Map<String, int>>>
      fetchBoughtIndexHourAndMinutesFB() async {
    List<Map<String, int>> a = [];

    List<Map<String, dynamic>> times =
        await fetchUserTimesFB().then((value) => value);
    for (int i = 0; i < times.length; i++) {
      times[i].forEach((key, value) {
        if (value != 60) {
          a.add({times[i].keys.first: times[i].values.first});
        }
      });
    }
    return a;
  }

  static Future<List<int>> fetchBoughtIndexFB() async {
    List<int> a = [];
    List<Map<String, dynamic>> times =
        await fetchUserTimesFB().then((value) => value);
    for (int i = 0; i < times.length; i++) {
      times[i].forEach((key, value) {
        if (value != 60) {
          a.add(i);
        }
      });
    }

    return a;
  }

  static Future<int> findCountryIncomeAndAddFB(
      List<double> howmanyincomes) async {
    List<int> indexes = [];
    await fetchBoughtIndexFB().then((value) {
      indexes = value;
    });

    List<int> incomes = [];
    for (var i = 0; i < indexes.length; i++) {
      incomes.add(await countries
          .get()
          .then((value) => value.docs[indexes[i]].data()['income']));
    }
    int oldmoney = await users
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .get()
        .then((value) => Map<String, dynamic>.from(value.data()!)['money']);
    List<Map<String, int>> test = List<Map<String, int>>.filled(48, {'60': 60});
    for (var i = 0; i < indexes.length; i++) {
      test[indexes[i]] = {
        DateTime.now().hour.toString(): DateTime.now().minute
      };
    }
    int sum = 0;
    for (var i = 0; i < incomes.length; i++) {
      sum = sum + (incomes[i] * howmanyincomes[i]).floor();
    }
    //print('sum $sum');
    users.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'money': (oldmoney + sum),
      'times': test,
    });
    return sum;
  }

  static Future<void> updateCountriesIncomesFB() async {
    List<int> prices = [];
    for (var i = 0; i < 48; i++) {
      prices.add(
          await countries.get().then((value) => value.docs[i].data()['price']));
    }
    for (var i = 0; i < 48; i++) {
      countries.get().then((value) => countries
          .doc(value.docs[i].id)
          .update({'income': (prices[i] * 0.15).floor()}));
    }
  }

  static Future<void> changeSamePricesFB() async {
    List<int> prices = [];
    List<int> samenumbers = [];
    for (var i = 0; i < 48; i++) {
      prices.add(
          await countries.get().then((value) => value.docs[i].data()['price']));
    }
    for (var i = 0; i < prices.length; i++) {
      for (var j = 1; j < prices.length; j++) {
        if (i != j && prices[i] == prices[j]) {
          samenumbers.add(prices[i]);
          countries
              .get()
              .then((value) => countries.doc(value.docs[i].id).update({
                    'price': ((prices[i] * 3).floor() / 20).floor() * 10,
                  }));
        }
      }
    }
    for (var i = 0; i < prices.length; i++) {
      if ((prices[i] / 10000).floor() > 1) {
        countries.get().then((value) => countries.doc(value.docs[i].id).update({
              'price': ((prices[i] / 10).floor() / 10).floor() * 10,
            }));
      } else if ((prices[i] / 1000).floor() == 0) {
        countries.get().then((value) => countries.doc(value.docs[i].id).update({
              'price': prices[i] * 10,
            }));
      } else {
        continue;
      }
    }
  }

  static Future<void> sellCountryFB(Country country) async {
    int index = 0;
    //print(country.price);
    await countries.get().then((value) async {
      for (var i = 0; i < value.docs.length; i++) {
        if (value.docs[i].data()['name'] == country.name) {
          index = i;
        }
      }
      List<String> owners = await fetchownersFB(index);
      owners.remove(FirebaseAuth.instance.currentUser!.displayName);
      await countries.doc(value.docs[index].id).update({
        'owners': owners,
      });
    });
    await users.get().then((value) => users
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .get()
        .then((value2) =>
            users.doc(FirebaseAuth.instance.currentUser!.displayName).update({
              'money': value2.data()!['money'] + country.price,
              'bought': List.from(value2.data()!['bought'])..[index] = false,
              'times': List.from(value2.data()!['times'])..[index] = {'60': 60},
            })));
  }

  static Future<void> changeLanguage(String lang) async {
    await users
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .update({'language': lang});
  }

  static Future<String> getLanguage() async {
    String returnvalue = '';
    print(FirebaseAuth.instance.currentUser!.displayName);
    await users
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .get()
        .then((value) => returnvalue = value.data()!['language']);
    return returnvalue;
  }

  static Future<void> updateColorTheme(List<int> c1, List<int> c2) async {
    await users
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .update({'appcolorTheme': c1, 'bgcolorTheme': c2});
  }

  static Future<List<int>> getAppColorTheme() async {
    List<int> returnvalue = [];
    await users.doc(FirebaseAuth.instance.currentUser!.displayName).get().then(
        (value) =>
            returnvalue = List<int>.from(value.data()!['appcolorTheme']));
    return returnvalue;
  }

  static Future<List<int>> getBGColorTheme() async {
    List<int> returnvalue = [];
    await users.doc(FirebaseAuth.instance.currentUser!.displayName).get().then(
        (value) => returnvalue = List<int>.from(value.data()!['bgcolorTheme']));
    return returnvalue;
  }

  static Future<String> changeUserNickname(String name) async {
    String? oldname = FirebaseAuth.instance.currentUser!.displayName;
    QuerySnapshot<Map<String, dynamic>> fbget = await users.get();
    if (fbget.docs.every((element) => element.id != name)) {
      await users.get().then((value) => value.docs.forEach((element) {
            if (element.id == oldname) {
              users.doc(oldname).get().then((doc) {
                if (doc.exists) {
                  var data = doc.data();
                  users.doc(name).set(data!).then((value) {
                    users.doc(oldname).delete();
                  });
                }
              });
            }
          }));
      //await users.doc(name).update({
      //  'nickname' : name
      //});
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    } else {
      return '1';
    }
    return '0';
  }

  static Future<void> updateNicknameHelper(String name) async {
    await users.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'nickname': users.doc(FirebaseAuth.instance.currentUser!.displayName).id
    });
  }

  static Future<bool> checkOwnerFB(int index) async {
    await countries.get().then((value) {
      if (value.docs[index].data()['owners'] != []) {
        return true;
      } else {
        return false;
      }
    });
    return false;
  }

/*
  static Future<void> addToCountriesNewVariablesFB(
      Map<String, String> data,
      Map<String, String> data2,
      Map<String, String> data3,
      Map<String, String> data4,
      Map<String, String> data5,
      Map<String, String> data6,
      Map<String, String> data7,
      Map<String, String> data8,
      Map<String, String> data9,
      Map<String, String> data10,
      Map<String, String> data11,
      Map<String, String> data12,
      Map<String, String> data13,
      Map<String, String> data14,
      Map<String, String> data15,
      Map<String, String> data16,
      Map<String, String> data17) async {
    await countries.get().then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        if (value.docs[i].data()['price'] >= 1000 &&
            value.docs[i].data()['price'] < 2000) {
          countries.doc(value.docs[i].id).update(data);
        } else if (value.docs[i].data()['price'] >= 2000 &&
            value.docs[i].data()['price'] < 3000) {
          countries.doc(value.docs[i].id).update(data2);
        } else if (value.docs[i].data()['price'] >= 3000 &&
            value.docs[i].data()['price'] < 4000) {
          countries.doc(value.docs[i].id).update(data3);
        } else if (value.docs[i].data()['price'] >= 4000 &&
            value.docs[i].data()['price'] < 5000) {
          countries.doc(value.docs[i].id).update(data4);
        } else if (value.docs[i].data()['price'] >= 5000 &&
            value.docs[i].data()['price'] < 6000) {
          countries.doc(value.docs[i].id).update(data5);
        } else if (value.docs[i].data()['price'] >= 6000 &&
            value.docs[i].data()['price'] < 7000) {
          countries.doc(value.docs[i].id).update(data6);
        } else if (value.docs[i].data()['price'] >= 7000 &&
            value.docs[i].data()['price'] < 8000) {
          countries.doc(value.docs[i].id).update(data7);
        } else if (value.docs[i].data()['price'] >= 8000 &&
            value.docs[i].data()['price'] < 9000) {
          countries.doc(value.docs[i].id).update(data8);
        } else if (value.docs[i].data()['price'] >= 9000 &&
            value.docs[i].data()['price'] < 10000) {
          countries.doc(value.docs[i].id).update(data9);
        } else if (value.docs[i].data()['price'] >= 10000 &&
            value.docs[i].data()['price'] < 11000) {
          countries.doc(value.docs[i].id).update(data10);
        } else if (value.docs[i].data()['price'] >= 11000 &&
            value.docs[i].data()['price'] < 12000) {
          countries.doc(value.docs[i].id).update(data11);
        } else if (value.docs[i].data()['price'] >= 12000 &&
            value.docs[i].data()['price'] < 13000) {
          countries.doc(value.docs[i].id).update(data12);
        } else if (value.docs[i].data()['price'] >= 13000 &&
            value.docs[i].data()['price'] < 14000) {
          countries.doc(value.docs[i].id).update(data13);
        } else if (value.docs[i].data()['price'] >= 14000 &&
            value.docs[i].data()['price'] < 15000) {
          countries.doc(value.docs[i].id).update(data14);
        } else if (value.docs[i].data()['price'] >= 15000 &&
            value.docs[i].data()['price'] < 16000) {
          countries.doc(value.docs[i].id).update(data15);
        } else if (value.docs[i].data()['price'] >= 16000 &&
            value.docs[i].data()['price'] < 17000) {
          countries.doc(value.docs[i].id).update(data16);
        } else if (value.docs[i].data()['price'] >= 17000) {
          countries.doc(value.docs[i].id).update(data17);
        }
      }
    });
  }
*/
  static Future<Map<bool, String>> checkNeededProductionsBoughtBefore(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      List<Map<String, List<String>>> pairs,
      String wanttobuyproduct) async {
    List<String> counter = [];
    if (pairs.every((element) => element.keys.first != wanttobuyproduct)) {
      return {true: ''};
    } else {
      for (var element in pairs) {
        if (element.keys.first == wanttobuyproduct) {
          element.values.first.forEach((value0) async {
            for (var value2 in snapshot.data!.docs)  {
              if(value2.data()['productions'].contains(value0) && !value2
                    .data()['owners']
                    .contains(FirebaseAuth.instance.currentUser!.displayName)  ){
                     //print('a');
                counter.add(value0);
              }
              else if(value2.data()['productions'].contains(value0) && value2
                    .data()['owners']
                    .contains(FirebaseAuth.instance.currentUser!.displayName)){
                      //print('b');
                      counter.remove(value0);
                      break;
              }
              else{
                //print('c');
              }
            }
          });
        }
      }
      print(counter);
    }
    return counter == [] || counter.isEmpty
        ? {true: ''}
        : {false: '\n     ' + counter.toSet().join('  ,  ').toUpperCase()};
  }

  static Future<void> updateCountriesPriceAndIncomesFB() async {
    await countries.get().then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        countries
            .doc(value.docs[i].id)
            .update({'price': ((i / 3).floor() + 1) * 1000});
        countries
            .doc(value.docs[i].id)
            .update({'income': (value.docs[i].data()['price'] * 0.15).floor()});
      }
    });
  }
  static Future<List<String>> fetchIndexProductions(int index)async{
    List<String> items = [];
    await countries.get().then((value) {
      items = List<String>.from(value.docs[index].data()['productions']);
    });
    return items;
  }
  static Future<void> upgradeCountryItemFB(int index, String newitem)async{
    print('index' + index.toString() + 'newitem' + newitem);
    List<String> items = [];
    await fetchIndexProductions(index).then((value) => items = value).then((value) => {
      items.add(newitem),
    });
    await countries.get().then((value) {
      countries
          .doc(value.docs[index].id)
          .update({'productions': items});
    });
  }
}
