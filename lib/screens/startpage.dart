import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zone_trader/screens/intropage.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _start = 5;

  Timer _timer = Timer(const Duration(seconds: 5), () {});
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  waitFiveSeconds()async  {
    if (_start == 0) {
      await Future.delayed(const Duration(milliseconds: 200), () =>
           Navigator.of(context).pushReplacement<void, void>(
            MaterialPageRoute<void>(builder: (context) => const IntroPage()),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(_start);
    waitFiveSeconds();
    return Scaffold(
        body: Stack(
            //OUTER STACK
            fit: StackFit.expand,
            children: [
          Stack(
              //INNER STACK
              fit: StackFit.expand,
              children: [
                Container(
                    decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/start.jpeg'),
                      fit: BoxFit.cover),
                )),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.1,
                    left: MediaQuery.of(context).size.width * 0.2,
                    child: Container(
                        child: const Text(
                      'Zone',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    ))),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.5,
                    left: MediaQuery.of(context).size.width * 0.456,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.green,
                      color: Colors.white,
                      strokeWidth: 100,
                      value: _start / 5,
                    )),
              ]),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              left: MediaQuery.of(context).size.width * 0.5,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black38,
                  child: const Text(
                    'Trader',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ))),
        ]));
  }
}
