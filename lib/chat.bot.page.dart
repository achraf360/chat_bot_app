import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//key :
//sk-proj-bZuxwxb4yxFfAtALLg10T3BlbkFJhCGOdwNxIGlJcdYtXgzv

class ChatBotPage extends StatefulWidget {
  ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  List messages = [
    //{"message": "Hello", "type": "user"},
    {"message": "Hello How can I help you", "type": "assistant"},
  ];
  List<Map<String, dynamic>> chatHistory = [];
  TextEditingController queryController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "ChatBot",
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: chatHistory.length,
                  itemBuilder: (context, index) {
                    //bool isUser = messages[index]['type'] == 'user';
                    /*return Column(
                      children: [
                        ListTile(
                          leading: !isUser ? Icon(Icons.support_agent) : null,
                          trailing: isUser ? Icon(Icons.person) : null,
                          title: Row(
                            children: [
                              SizedBox(
                                width: isUser ? 100 : 0,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(chatHistory[index]["message"],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: chatHistory[index]["isSender"]
                                              ? Colors.white
                                              : Colors.black)),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isUser
                                        ? Color.fromARGB(100, 4, 115, 179)
                                        : Color.fromARGB(100, 179, 181, 183),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: isUser ? 0 : 100,
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                        )
                      ],
                    );*/
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: (chatHistory[index]["isSender"]
                            ? Alignment.topRight
                            : Alignment.topLeft),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            color: (chatHistory[index]["isSender"]
                                ? Color(0xFFF044C83)
                                : Colors.white),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text(chatHistory[index]["message"],
                              style: TextStyle(
                                  fontSize: 15,
                                  color: chatHistory[index]["isSender"]
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: queryController,
                    decoration: InputDecoration(
                      hintText: "Message ChatBot",
                      hintStyle: const TextStyle(color: Colors.black38),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: const Icon(Icons.textsms_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    /*onPressed: () {
                      String query = queryController.text;
                      var openAiLLMUri =
                          Uri.https("api.openai.com", "/v1/chat/completions");
                      Map<String, String> headers = {
                        "Content-type": "application/json",
                        "Authorization":
                            "Bearer AIzaSyDac0B63mLaLPerae27WSXSLXtlSZk81uY"
                      };
                      var prompt = {
                        "model": "gpt-3.5-turbo",
                        "messages": [
                          {"role": "user", "content": query}
                        ],
                        "temperature": 0
                      };

                      http
                          .post(openAiLLMUri,
                              headers: headers, body: json.encode(prompt))
                          .then((resp) {
                        var responseBody = resp.body;
                        print("response1 :  ${responseBody}");
                        var llmResponse = json.decode(responseBody);
                        String responseContent =
                            llmResponse['choices'][0]['message']['content'];
                        print("response :  ${responseContent}");
                        setState(() {
                          messages.add({"message": query, "type": "user"});
                          messages.add({
                            "message": responseContent,
                            "type": "assistant"
                          });
                          scrollController.jumpTo(
                              scrollController.position.maxScrollExtent + 200);
                        });
                      }, onError: (err) {
                        print("****** Error *******");
                        print(err);
                      });
                    },*/
                    onPressed: () {
                      setState(() {
                        if (queryController.text.isNotEmpty) {
                          chatHistory.add({
                            "time": DateTime.now(),
                            "message": queryController.text,
                            "isSender": true,
                          });
                          queryController.clear();
                        }
                      });
                      scrollController.jumpTo(
                        scrollController.position.maxScrollExtent + 100,
                      );
                      getAnswer();
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getAnswer() async {
    final url =
        "https://generativelanguage.googleapis.com/v1beta2/models/chat-bison-001:generateMessage?key=AIzaSyDac0B63mLaLPerae27WSXSLXtlSZk81uY";
    final uri = Uri.parse(url);
    List<Map<String, String>> msg = [];
    for (var i = 0; i < chatHistory.length; i++) {
      if (chatHistory != null && i < chatHistory.length) {
        msg.add({"content": chatHistory[i]["message"]});
      }
    }

    Map<String, dynamic> request = {
      "prompt": {
        "messages": [msg]
      },
      "temperature": 0.25,
      "candidateCount": 3,
      "topP": 1,
      "topK": 1
    };

    final responseBody = await http.post(uri, body: jsonEncode(request));
    /*final llmResponse =
        json.decode(responseBody.body)["candidates"][0]["content"];
    print("resp : ${llmResponse}");*/
    setState(() {
      chatHistory.add({
        "time": DateTime.now(),
        "message": json.decode(responseBody.body)["candidates"][0]["content"],
        "isSender": false,
      });
    });

    scrollController.jumpTo(
      scrollController.position.maxScrollExtent + 100,
    );
  }
}
