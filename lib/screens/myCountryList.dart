import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zone_trader/firebase/FBOp.dart';
import 'package:zone_trader/models/country.dart';
import 'package:zone_trader/screens/home.dart';

class MyCountryList extends StatelessWidget {
  const MyCountryList({super.key});

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
          backgroundColor: const Color.fromARGB(255, 169, 197, 246),
          appBar: AppBar(
            title: const Text('My Country List'),
            centerTitle: true,
            backgroundColor: Colors.blue,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right:18.0),
                child: IconButton(
                  icon: const Icon(Icons.home,size: 30,color: Colors.white,), 
                  onPressed: () { 
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                   },
                ),
              )
            ]
          ),
          body: ListView.builder(
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
            height: MediaQuery.of(context).size.height * 0.1,
            child: Column(
              children: [
                
                Text('Price: ${country.price}'),
                Text('Income: ${country.income}'),
                Text('Owner: ${country.owner}'),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: () {
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
               await FBOp.sellCountryFB(country).then((value) => Navigator.of(context).pop());
              },
              child: const Text('Sell',style: TextStyle(color: Colors.white),),
            ),
            ),
          ],
        );
      },
    );
  }

 // void _buyGoods(BuildContext context, Country country) async {
 //   try {
 //     // Add the selected goods to the 'mygoods' collection
 //     String userId = FirebaseAuth.instance.currentUser!.uid;
 //     int lastamount = 1;
 //     await FirebaseFirestore.instance.collection('users').doc(userId).get().then((value) => lastamount = value.data()![country.name]['amount']);
 //     await FirebaseFirestore.instance.collection('users').doc(userId).update({country.name : {
 //       'name': country.name,
 //       'amount':  lastamount+1,
 //       'price': country.price,
 //     }});
//
 //     Navigator.of(context).pop(); // Close the popup
//
 //     // Show a snackbar or other indication that the goods have been bought successfully
 //     ScaffoldMessenger.of(context).showSnackBar(
 //       SnackBar(
 //         content: Text('${country.name} bought successfully!'),
 //       ),
 //     );
 //   } catch (e) {
 //     print("Error buying goods: $e");
 //   }
 // }
}