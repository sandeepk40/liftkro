import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:haggle/model/popup_menu_model.dart';
import 'package:haggle/screens/chat/chat_conversation_screen.dart';
import 'package:intl/intl.dart';
import '../../services/firebase_services.dart';

class ChatCard extends StatefulWidget {
  ChatCard({Key? key, this.chatData}) : super(key: key);
  Map<String, dynamic>? chatData;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final FirebaseService _service = FirebaseService();

  DocumentSnapshot? doc;
  String _lastChatDate = '';

  @override
  void initState() {
    getProductDetails();
    getChatTime();
    super.initState();
  }

  getProductDetails() {
    _service
        .getProductDetails(widget.chatData!['product']['productId'])
        .then((value) {
      print("product value: ${widget.chatData!['product']}");
      if(value != null) {
        setState(() {
          doc = value;
        });
        print('document: ${doc!.data()}');
      }else{

      }
    });
  }

  getChatTime() {
    var _date = DateFormat.yMMMd().format(
      DateTime.fromMicrosecondsSinceEpoch(
        DateTime.now().microsecondsSinceEpoch,
      ),
    );
    var _today = DateFormat.yMMMd().format(
      DateTime.fromMicrosecondsSinceEpoch(
        widget.chatData!['lastChatTime'],
      ),
    );
    if (_date == _today) {
      setState(() {
        _lastChatDate = 'Today';
      });
    } else {
      setState(() {
        _lastChatDate = _date.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return doc == null
        ? Container()
        : Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      child: Stack(
        children: [
          ListTile(
            onTap: () {
              _service.messages
                  .doc(widget.chatData!['chatRoomId'])
                  .update({
                'read': 'true',
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ChatConversations(
                    chatRoomId: widget.chatData!['chatRoomId'],
                  ),
                ),
              );
            },
            leading: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(doc!['images'][0])),
              ),
            ),
            title: Text(
              doc!['type'].toUpperCase(),
              maxLines: 1,
              style: TextStyle(
                fontWeight: widget.chatData!['read'] == false
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 15,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(
                  doc!['description'],
                  // 'description',
                  maxLines: 1,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                if (widget.chatData!['lastChat'] != null)
                  Text(
                    widget.chatData!['lastChat'],
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.brown[900],
                    ),
                  ),
              ],
            ),
            trailing: _service.popUpMenue(widget.chatData, context),
          ),
          Positioned(
            top: 10,
            right: 60,
            child: Text(
              _lastChatDate,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
