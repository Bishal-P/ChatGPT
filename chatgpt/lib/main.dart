// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:chatgpt/InputField.dart';
import 'package:chatgpt/splashscreen.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    title: "ChatGpt",
    home: const SplashScreen(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic messagesList = [];
  ScrollController scrollcontroller = ScrollController();
  TextEditingController textFieldController = TextEditingController();
  int loading = 0;
  bool IsConnected = false;
  Timer? timer;
  bool count = false;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      IsConnected = is_connected_fun1();
      setState(() {});
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
    IsConnected = is_connected_fun1();

    scrollToBottom() {
      if (messagesList.length != 0) {
        if (count) {
          count = false;
          scrollcontroller.jumpTo(scrollcontroller.position.maxScrollExtent);
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: const Color.fromARGB(77, 25, 4, 4),
        backgroundColor: const Color(0xff00FFFF),
        toolbarHeight: 80,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Welcome to ChatGPT"),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Expanded(
                  flex: 9,
                  child: messagesList.length != 0
                      ? ListView.builder(
                          controller: scrollcontroller,
                          primary: false,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: messagesList.length,
                          itemBuilder: (context, i) {
                            return messages(context, messagesList[i][0],
                                messagesList[i][1]);
                          })
                      : Center(
                          child: IsConnected
                              ? Lottie.network(
                                  "https://assets9.lottiefiles.com/packages/lf20_5rImXbDsO1.json")
                              : Lottie.asset("asset/images/internet.json"),
                        )),
              Expanded(
                flex: loading,
                child: Container(
                  child: loading != 0
                      ? temporaryWidget()
                      : IsConnected
                          ? const Text("")
                          : const Text("Check your Internet Connection..."),
                ),
              ),
              ////////////////////////////////////////////////////textfield---------------input------------------///////////////////////////
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent),
                child: Row(children: [
                  Expanded(
                      child: TextField(
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                        fontFamily: "newFont"),
                    // autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: textFieldController,
                    decoration: InputDecoration(
                        hintText: "Enter your query....",
                        hintStyle: const TextStyle(
                            color: Colors.black, fontFamily: "newFont"),
                        fillColor: const Color.fromARGB(217, 0, 255, 255),
                        filled: true,
                        // focusColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xff00FFFF)),
                            borderRadius: BorderRadius.circular(20)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.all(10)),
                  )),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.only(left: 5, top: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xff00FFFF)),
                    child: IconButton(
                        iconSize: 30,
                        alignment: Alignment.topRight,
                        onPressed: () {
                          var inptSms = textFieldController.text;
                          if (inptSms != "") {
                            loading = 4;
                            String msg = textFieldController.text;
                            // print(msg);
                            messages(context, msg, "user");
                            List row = [msg, "user"];
                            messagesList.add(row);
                            // print(messagesList);
                            setState(() {
                              gpt(msg);
                            });
                          }
                          textFieldController.clear();
                          count = true;
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.black,
                        )),
                  )
                ]),
              )
            ],
          )),
    );
  }

  gpt(query) async {
    try {
      String key = "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";
      final respose = await http.post(
          Uri.parse("https://api.openai.com/v1/completions"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $key'
          },
          body: jsonEncode({
            "model": "text-davinci-003",
            "prompt": "$query",
            "max_tokens": 400,
            "temperature": 0,
            "top_p": 1,
          }));
      Map<String, dynamic> response1 = jsonDecode(respose.body);
      String responsetxt = response1['choices'][0]['text'];
      // String responsetxt =
      //     "\nthe prime minister of india is narendra modihgfgffcghhjghjfhgfghfghfg fgh fghfh hg fgfgh.";
      responsetxt = responsetxt.replaceFirst("\n", " ");
      List row = [responsetxt, "gpt"];
      messagesList.add(row);
    } on Exception {
      List row = ["Something went Wrong 🥹🥹", "gpt"];
      messagesList.add(row);
    }
    count = true;
    // print(responsetxt);
    setState(() {
      loading = 0;
      // scrollcontroller.jumpTo(scrollcontroller.position.maxScrollExtent);
    });
  }
}
