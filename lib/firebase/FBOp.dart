import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zone_trader/models/country.dart';

class FBOp {
  static CollectionReference<Map<String, dynamic>> fb = FirebaseFirestore.instance.collection('users');
  static CollectionReference<Map<String, dynamic>> fb2 = FirebaseFirestore.instance.collection('countries');
  static Future<String> registerUserFB(String nickname, String email, String dropdownvalue)async {
    String result = '';
    if(await fb.get().then((value) => value.docs.every((element) => element.id != nickname))){
      await fb.doc(nickname).set({
        'nickname' : nickname,
        'email': email,
        'money' : 10000,
        'bought' : List<bool>.filled(48, false),
        'times' : List<Map<String,dynamic>>.filled(48, {'60':60}),
        'language' : dropdownvalue,
        'appcolorTheme' : [],
        'bgcolorTheme' : []
      });
      return result = '';
    }
    else{
      return result = 'Nickname already exists';
    }
  }
  static addCountryTOFB(String name, int price, int income)async{
    fb2.add({
      'name': name,
      'price': price,
      'income': income,
    });
  }

  static Future<List<Country>> fetchFromFBTOCountry()async{
    List<Country> cl = [];
    await fb2.get().then((value) => value.docs.map((e) => cl.add(Country(
      name: e.data()['name'],
      price: e.data()['price'],
      income: e.data()['income'],
      owner: e.data()['owner'],
    ))));
    return cl;
  }

  static Future<void> updateMoneyFB(int money)async{
    fb.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'money' : money
    });
  }

  static Future<void> updateBoughtColorsFB(List<bool> bought)async{
    await fb.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'bought' : bought
    });
  }
  static Future<void> resetTimesFB(List<Map<String,dynamic>> times)async{
    await fb.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'times' : times
    });
  }
  static Future<void> updateCountryOwners()async{
    await fb2.get().then((value) => value.docs.forEach((e) => fb2.doc(e.id).update({
      'owner' : ''
    })));
  }

  static Future<List<bool>> fetchBoughtColorsFB()async{
    return List<bool>.from(await fb.doc(FirebaseAuth.instance.currentUser!.displayName).get().then((value) => value.data()!['bought']));
  }

  static Future<void> updateUserTimesAndOwnerFB(List<Map<String,dynamic>> times,int index)async{
    await fb.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'times' : times
    });
    await fb2.get().then((value) => fb2.doc(value.docs[index].id).update({
      'owner' : FirebaseAuth.instance.currentUser!.displayName
    }));
  }

  static Future<List<Map<String,dynamic>>> fetchUserTimesFB()async{
    return List<Map<String,dynamic>>.from(await fb.doc(FirebaseAuth.instance.currentUser!.displayName).
                                    get().
                                      then((value) => Map<String, dynamic>.from(value.data()!)['times']));
  }

  static Future<List<Map<String,int>>> fetchBoughtIndexHourAndMinutesFB()async{
    List<Map<String,int>> a = [];
    
    List<Map<String,dynamic>> times = await fetchUserTimesFB().then((value) => value);
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
    List<Map<String,dynamic>> times = await fetchUserTimesFB().then((value) => value);
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
    
    List<int> incomes = [];
    for (var i = 0; i < indexes.length; i++) {
      incomes.add(await fb2.get().then((value) => value.docs[indexes[i]].data()['income']));
    }
    int oldmoney  = await fb.doc(FirebaseAuth.instance.currentUser!.displayName).get().then((value) => Map<String, dynamic>.from(value.data()!)['money']);
    List<Map<String,int>> test =  List<Map<String,int>>.filled(48, {'60':60});
    for (var i = 0; i < indexes.length; i++) {
      test[indexes[i]] = {DateTime.now().hour.toString() : DateTime.now().minute};
    }
    int sum = 0;
    for (var i = 0; i < incomes.length; i++) {
      sum = sum + (incomes[i] * howmanyincomes[i]).floor();
    }
    //print('sum $sum');
    fb.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'money' : (oldmoney + sum),
      'times' : test,
    });
    return sum;
  }
  static Future<void> updateCountriesIncomesFB()async{
    List<int> prices = [];
    for (var i = 0; i < 48; i++) {
      prices.add(await fb2.get().then((value) => value.docs[i].data()['price']));
    }
    for (var i = 0; i < 48; i++) {
      fb2.get().then((value) => fb2.doc(value.docs[i].id).update({
        'income' : (prices[i] * 0.15).floor()
      }));
    }
  }
  static Future<void> changeSamePricesFB() async{
    List<int> prices = [];
    List<int> samenumbers = [];
    for (var i = 0; i < 48; i++) {
      prices.add(await fb2.get().then((value) => value.docs[i].data()['price']));
    }
    for (var i = 0; i < prices.length; i++) {
      for (var j = 1; j < prices.length; j++) {
        if(i != j && prices[i] == prices[j]){
          samenumbers.add(prices[i]);
          fb2.get().then((value) => fb2.doc(value.docs[i].id).update({
            'price' : ((prices[i] * 3).floor() / 20).floor() * 10,
          }));
        }
      }
    }
    for (var i = 0; i < prices.length; i++) {
        if((prices[i]/10000).floor() > 1){
          fb2.get().then((value) => fb2.doc(value.docs[i].id).update({
            'price' : ((prices[i] / 10).floor() / 10).floor() * 10,
          }));
        } 
        else if((prices[i]/1000).floor() == 0) { 
          fb2.get().then((value) => fb2.doc(value.docs[i].id).update({
            'price' : prices[i] * 10,
          }));
        }
        else{
          continue;
        }
    }
  }
  static Future<void> sellCountryFB(Country country)async{
    int index = 0;
    //print(country.price);
    await fb2.get().then((value)async { 
      for (var i = 0; i < value.docs.length; i++) {
        if (value.docs[i].data()['name'] == country.name) {
          index = i;
        }
      }
      await fb2.doc(value.docs[index].id).update({
        'owner' : '',
      });
    });
    await fb.get().then((value) => fb.doc(FirebaseAuth.instance.currentUser!.displayName).get().then((value2) => fb.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'money' : value2.data()!['money'] + country.price,
      'bought' : List.from(value2.data()!['bought'])..[index] = false,
      'times' : List.from(value2.data()!['times'])..[index] = {'60' : 60},
    })));
  }
  static Future<void> changeLanguage(String lang)async{
    await fb.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'language' : lang
    });
  }
  static Future<String> getLanguage()async{
    String returnvalue = '';
    print(FirebaseAuth.instance.currentUser!.displayName);
    await fb.doc(FirebaseAuth.instance.currentUser!.displayName).get().then((value) => returnvalue = value.data()!['language']);
    return returnvalue;
  }
  static Future<void> updateColorTheme(List<int> c1, List<int> c2)async{
    await fb.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'appcolorTheme' : c1,
      'bgcolorTheme' : c2
    });
  }
  static Future<List<int>> getAppColorTheme()async{
    List<int> returnvalue = [];
    await fb.doc(FirebaseAuth.instance.currentUser!.displayName).get().then((value) => returnvalue = List<int>.from(value.data()!['appcolorTheme']));
    return returnvalue;
  } 
  static Future<List<int>> getBGColorTheme()async{
    List<int> returnvalue = [];
    await fb.doc(FirebaseAuth.instance.currentUser!.displayName).get().then((value) => returnvalue = List<int>.from(value.data()!['bgcolorTheme']));
    return returnvalue;
  } 
  static Future<String> changeUserNickname(String name)async{

    String? oldname = FirebaseAuth.instance.currentUser!.displayName;
    QuerySnapshot<Map<String, dynamic>> fbget = await fb.get();
    if(fbget.docs.every((element) => element.id != name)){
      await fb.get().then((value) => value.docs.forEach((element) {
      if(element.id == oldname){
        fb.doc(oldname).get().then((doc) {
            if (doc.exists) {
                var data = doc.data();
                fb.doc(name).set(data!).then((value) {
                  fb.doc(oldname).delete();
                });
            }
        });
      }
      }));
      //await fb.doc(name).update({
      //  'nickname' : name
      //});
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    }
    else{
      return '1';
    }
    return '0';
  }
  static Future<void> updateNicknameHelper(String name)async{
    await fb.doc(FirebaseAuth.instance.currentUser!.displayName).update({
      'nickname' : fb.doc(FirebaseAuth.instance.currentUser!.displayName).id
    });
  }
  static Future<bool> checkOwnerFB(int index)async{
    await fb2.get().then((value) {
      if(value.docs[index].data()['owner'] != ''){
        return true;        
      }
      else{
        return false;
      }
    });
    return false;
  }
}