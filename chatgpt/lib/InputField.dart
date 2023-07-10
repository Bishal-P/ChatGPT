// ignore_for_file: non_constant_identifier_names

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// Widget inputArea(textFieldController) {
//   return;

// }
bool IsConnected = true;

Widget messages(context, valueOfText, sender) {
  return Column(
    children: [
      Column(
        crossAxisAlignment:
            sender == "gpt" ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8),
            margin: sender == "gpt"
                ? const EdgeInsets.only(left: 5, top: 6, bottom: 5)
                : const EdgeInsets.only(right: 5, top: 6, bottom: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.transparent,
                // color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(255, 24, 213, 213), spreadRadius: 2)
                ]),
            child: Text(
              valueOfText,
              textScaleFactor: 1.3,
              style: const TextStyle(fontFamily: "newFont"),
            ),
          ),
          Row(
            mainAxisAlignment: sender == "gpt"
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              CircleAvatar(
                  radius: 15,
                  child: sender == "gpt"
                      ? const Image(
                          image: AssetImage("asset/images/chatgpt.png"))
                      : const Image(
                          image: AssetImage("asset/images/user.png"))),
            ],
          )
        ],
      )
    ],
  );
}

Widget temporaryWidget() {
  return Center(
    child: Lottie.network(
      "https://assets6.lottiefiles.com/packages/lf20_9CC6GxueqQ.json",
    ),
  );
}

is_connected_fun() async {
  var is_connected1 = await (Connectivity().checkConnectivity());
  if (is_connected1 != ConnectivityResult.none) {
    // print("You are connected : true");
    IsConnected = true;
  } else {
    IsConnected = false;
  }
}

bool is_connected_fun1() {
  is_connected_fun();
  return IsConnected;
}
