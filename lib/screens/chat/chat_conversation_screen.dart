import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:haggle/screens/chat/chat_stream.dart';
import 'package:haggle/services/firebase_services.dart';

class ChatConversations extends StatefulWidget {
  const ChatConversations({Key? key, required this.chatRoomId})
      : super(key: key);
  final String chatRoomId;

  @override
  State<ChatConversations> createState() => _ChatConversationsState();
}

class _ChatConversationsState extends State<ChatConversations> {
  // late Stream chatMessageStream;
  FirebaseService _service = FirebaseService();
  // Stream<QuerySnapshot> chatMessageStream =
  //     FirebaseFirestore.instance.collection('users').snapshots();

  var chatController = TextEditingController();
  bool _send = false;

  sendMessage() {
    if (chatController.text.isNotEmpty) {
      FocusScope.of(context).unfocus(); //closes the keyboard
      Map<String, dynamic> messsage = {
        'message': chatController.text,
        'sentBy': _service.user!.uid,
        'time': DateTime.now().microsecondsSinceEpoch,
      };
      _service.createChat(widget.chatRoomId, messsage);
      chatController.clear();
    }
  }

  // @override
  // void initState() {
  //   _service.getChat(widget.chatRoomId).then((value) {
  //     setState(() {
  //       chatMessageStream = value;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(238, 242, 246, 170),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          _service.popUpMenue(widget.chatRoomId, context),
        ],
        shape: const Border(
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatStream(chatRoomId: widget.chatRoomId),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],

                  // border: const Border(
                  //   top: BorderSide(color: Colors.black),
                  // ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: TextField(
                            
                            cursorColor: Colors.black,
                            controller: chatController,
                            style: const TextStyle(
                              color: Colors.black,
                              height: 1,
                              fontSize: 16,
                            ),
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white60,
                              isDense: true, // Added this
                              contentPadding: EdgeInsets.all(12),
                              hintText: 'Message',
                              hintStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  _send = true;
                                });
                              } else {
                                setState(() {
                                  _send = false;
                                });
                              }
                            },
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                sendMessage(); //send message by enter
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.black12,
                          // border: const Border(
                          //   top: BorderSide(color: Colors.black),
                          // ),
                        ),
                        child: IconButton(
                          onPressed: sendMessage,
                          icon: const Icon(
                            Icons.send,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
