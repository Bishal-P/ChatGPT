import 'dart:async';

import 'package:chatgpt/InputField.dart';
import 'package:chatgpt/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  bool splashTime = false;
  bool isConnected = true;
  @override
  void initState() {
    Timer(const Duration(seconds: 5), () {
      splashTime = true;
    });
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      isConnected = is_connected_fun1();
      setState(() {});
      if (isConnected && splashTime) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MyApp()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool isConnected = is_connected_fun1();
    return Scaffold(
      body: Center(
        child: isConnected
            ? Lottie.asset("asset/images/bot.json")
            : Lottie.asset("asset/images/internet.json"),
      ),
    );
  }
}
