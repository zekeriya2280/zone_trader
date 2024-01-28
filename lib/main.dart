
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zone_trader/screens/wrapper.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   options: 
   const FirebaseOptions(
     apiKey: 'AIzaSyASOup4EQbXqsDWFWjp9DCyr4YlC7y3FMc', 
     appId: '1:695924119809:android:267ba3c155e3c3386d6300', 
     messagingSenderId: '695924119809', 
     projectId: 'zone-trader')
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(),
    );
  }
}

class GoodsListScreen extends StatelessWidget {
  const GoodsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goods List'),
      ),
      body: const GoodsList(),
    );
  }
}

class GoodsList extends StatelessWidget {
  const GoodsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('goods').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<GoodsItem> goodsList = [];
        for (var doc in snapshot.data!.docs) {
          var data = doc.data() as Map<String, dynamic>;
          goodsList.add(GoodsItem(
            name: data['name'],
            amount: data['amount'],
            price: double.parse(data['price'].toString()),
          ));
        }

        return ListView.builder(
          itemCount: goodsList.length,
          itemBuilder: (context, index) {
            return Card(
              child: InkWell(
                onTap: () {
                  _showPopup(context, goodsList[index]);
                },
                child: ListTile(
                  title: Text(goodsList[index].name),
                  subtitle: Text(
                      'Amount: ${goodsList[index].amount} - Price: ${goodsList[index].price.floor()}'),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPopup(BuildContext context, GoodsItem goodsItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(goodsItem.name),
          content: Column(
            children: [
              Text('Amount: ${goodsItem.amount}'),
              Text('Price: ${goodsItem.price.floor()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel button
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _buyGoods(context, goodsItem);
              },
              child: const Text('Buy'),
            ),
          ],
        );
      },
    );
  }

  void _buyGoods(BuildContext context, GoodsItem goodsItem) async {
    try {
      // Add the selected goods to the 'mygoods' collection
      String userId = FirebaseAuth.instance.currentUser!.uid;
      int lastamount = 1;
      await FirebaseFirestore.instance.collection('users').doc(userId).get().then((value) => lastamount = value.data()![goodsItem.name]['amount']);
      await FirebaseFirestore.instance.collection('users').doc(userId).update({goodsItem.name : {
        'name': goodsItem.name,
        'amount':  lastamount+1,
        'price': goodsItem.price,
      }});

      Navigator.of(context).pop(); // Close the popup

      // Show a snackbar or other indication that the goods have been bought successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${goodsItem.name} bought successfully!'),
        ),
      );
    } catch (e) {
      print("Error buying goods: $e");
    }
  }
}


class GoodsItem {
  final String name;
  final int amount;
  final double price;

  GoodsItem({required this.name, required this.amount, required this.price});
}
