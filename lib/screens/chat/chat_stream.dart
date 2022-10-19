import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, FirebaseFirestore, QuerySnapshot;
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:haggle/services/firebase_services.dart';
import 'package:intl/intl.dart';

class ChatStream extends StatefulWidget {
  const ChatStream({Key? key, required this.chatRoomId}) : super(key: key);
  final String chatRoomId;

  @override
  State<ChatStream> createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  final FirebaseService _service = FirebaseService();
  DocumentSnapshot? chatDoc;
  Stream<QuerySnapshot> chatMessageStream =
  FirebaseFirestore.instance.collection('users').snapshots();
  final _format = NumberFormat("##,##,##0");
  ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    _service.getChat(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    _service.messages.doc(widget.chatRoomId).get().then((value) {
      setState(() {
        chatDoc = value;
      });
    });
  }

  String _priceFormatted(price) {
    var _price = int.parse(price);
    var _formattedPrice = _format.format(_price);
    return _formattedPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: chatMessageStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            );
          }

          return snapshot.hasData
              ? Column(
            children: [
              SizedBox(height: 10,),
              if (chatDoc != null)
                ListTile(
                  leading: Container(
                      width: 60,
                      height: 60,
                      child: Image.network(
                          chatDoc!['product']['productImage'])),
                  title: Text(
                    chatDoc!['product']['productname'].toUpperCase(),
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'PRICE: ₹${_priceFormatted(
                          chatDoc!['product']['price'],
                        )}',
                        style:
                        const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    controller: listScrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      print('datatat: ${snapshot.data!.docs[index]}');
                      Future.delayed(Duration(seconds: 1),(){
                        final position = listScrollController.position.maxScrollExtent;
                        listScrollController.jumpTo(position);
                      });

                      String sentBy =
                      snapshot.data!.docs[index]['sentBy'];
                      String me = _service.user!.uid;
                      String lastChatDate;
                      var _date = DateFormat.yMMMd().format(
                        DateTime.fromMicrosecondsSinceEpoch(
                          snapshot.data!.docs[index]['time'],
                        ),
                      );
                      var _today = DateFormat.yMMMd().format(
                        DateTime.fromMicrosecondsSinceEpoch(
                          DateTime.now().microsecondsSinceEpoch,
                        ),
                      );
                      if (_date == _today) {
                        lastChatDate = DateFormat('hh:mm').format(
                          DateTime.fromMicrosecondsSinceEpoch(
                            snapshot.data!.docs[index]['time'],
                          ),
                        );
                      } else {
                        lastChatDate = _date.toString();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0,right: 5,bottom: 5),
                        child: Column(
                          children: [
                            ChatBubble(
                              alignment: sentBy == me
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              backGroundColor: sentBy == me
                                  ? Colors.orange[50]
                                  : Colors.white,
                              shadowColor:
                              Colors.black,
                              clipper: ChatBubbleClipper2(
                                  type: sentBy == me
                                      ? BubbleType.sendBubble
                                      : BubbleType.receiverBubble),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                  MediaQuery.of(context).size.width *
                                      0.7,
                                ),
                                child: Text(
                                  snapshot.data!.docs[index]['message'],
                                  style: TextStyle(
                                    color: sentBy == me
                                        ? Colors.black
                                        : const Color.fromARGB(
                                        255, 100, 40, 0),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: sentBy == me
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  lastChatDate,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          )
              : Container();
        },
      ),
    );
  }
}
