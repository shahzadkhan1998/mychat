import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/constant/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: non_constant_identifier_names
User? LoggedInUser;
var key;

class ChatScreen extends StatefulWidget {
  static const String id = 'ChatScreen';

  const ChatScreen({Key? key}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messagesTextEditingController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  // ignore: non_constant_identifier_names

  // ignore: unused_field
  String? _messageText;

  void getSreamData() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        key = message.reference.id;
        // ignore: avoid_print
        print("key    is  ...............................: $key");
        print(message.data());
      }
    }
  }

  getCurrentUser() async {
    try {
      var user = await auth.currentUser!;
      if (user != null) {
        LoggedInUser = user;
        // ignore: avoid_print
        print(
            "The new User is........................................ : ${LoggedInUser!.email}");
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              auth.signOut();
              Navigator.pushNamed(context, "/");
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const StreamMessage(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messagesTextEditingController,
                      onChanged: (value) {
                        //Do something with the user input.
                        _messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () {
                      messagesTextEditingController.clear();
                      //Implement send functionality.
                      _firestore.collection('messages').add({
                        'text': _messageText,
                        'sender': LoggedInUser?.email,
                        'keys': key,
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getSreamData();
    // ignore: avoid_print
   
  }
}

class StreamMessage extends StatelessWidget {
  const StreamMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('messages').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }

          final messages = snapshot.data!.docs;
          messages
              .sort((a, b) => a.data()['sender'].compareTo(b.data()['sender']));
          //  messages.sort((a, b) {
          //   return a.data()['keys'].compareTo(b.data()['keys']);
          // });
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final messageText = message.data()!["text"].toString();
            final messageSender = message.data()!['sender'].toString();
            final currentUser = LoggedInUser!.email;

            final messageWidget = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );
            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              children: messageWidgets,
            ),
          );
        });
  }
}

/////////////////////////////////////////////////////////////////////////////////////////
class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  const MessageBubble(
      {Key? key, required this.sender, required this.text, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(color: Colors.black45, fontSize: 10),
          ),
          Material(
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            elevation: 5.0,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                text,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
