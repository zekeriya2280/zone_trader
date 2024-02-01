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
            title: const Text('My Country List',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold,letterSpacing: 2),),
            centerTitle: true,
            backgroundColor: Colors.blue,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right:18.0),
                child: IconButton(
                  icon: const Icon(Icons.home,size: 30,color: Colors.white,), 
                  onPressed: ()async{ 
                    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                   },
                ),
              )
            ]
          ),
          body: 
          myCountryList.isEmpty ? const Center(child: Text('You have no country',style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),)) :
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
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              children: [
                
                Text('Price: ${country.price}'),
                Text('Income: ${country.income}'),
                Text('Owner: ${country.owner}'),
                Expanded(child: Container()),
                Center(child: Text('You should reload home page after selling', style: const TextStyle(fontSize: 13,color: Colors.red,fontWeight: FontWeight.bold),)),
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
}