import 'package:chat_app/helpers/prefs.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ConversationScreen extends StatefulWidget {

  final String recipientUsername;

  ConversationScreen({required this.recipientUsername});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  TextEditingController messageTextEditingController = TextEditingController();
  final DatabaseServices _databaseServices = DatabaseServices();

  late String myUsername;
  Stream<QuerySnapshot>? chatConversationStream;

  void sendThisMessage(String message) async {
    await _databaseServices.addMessageToConversation(widget.recipientUsername, myUsername, message);
    setState(() {
      messageTextEditingController.text = "";
    });
  }

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatConversationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          QuerySnapshot snapshotData = snapshot.data as QuerySnapshot;
          return ListView.builder(
              itemCount: snapshotData.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                    message: snapshotData.docs[index].get("message"),
                    isSentByMe: snapshotData.docs[index].get("sentBy") == myUsername,
                    isLastMessage: index == snapshotData.docs.length-1
                );
              }
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  void getMyConversationMessages() async {
    myUsername = (await Prefs.getPrefUsername())!;
    await _databaseServices.getConversationMessages(widget.recipientUsername, myUsername)
        .then((value) {
          setState(() {
            chatConversationStream = value;
          });
    });
  }


  @override
  void initState() {
    getMyConversationMessages();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Text(widget.recipientUsername),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  border: Border.all(
                      color: Colors.white54
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: textStyle(),
                        controller: messageTextEditingController,
                        decoration: InputDecoration(
                            hintText: "Type message",
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (messageTextEditingController.text.isNotEmpty) {
                          sendThisMessage(messageTextEditingController.text);
                        }
                      },
                      tooltip: "Send message",
                      icon: Icon(
                        Icons.send_rounded,
                        color: Colors.red,
                      ),
                      splashRadius: 24.0,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {

  final String message;
  final bool isSentByMe;
  final bool isLastMessage;

  MessageTile({ required this.message, required this.isSentByMe, required this.isLastMessage });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isLastMessage ? EdgeInsets.only(bottom: 64.0) : EdgeInsets.only(bottom: 0.0),
      width: MediaQuery.of(context).size.width,
      margin: isSentByMe ? EdgeInsets.only(left: 64.0) : EdgeInsets.only(right: 64.0),
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.white12 : Colors.red[900],
          borderRadius: isSentByMe ? BorderRadius.only(
            topRight: Radius.circular(24.0),
            topLeft: Radius.circular(24.0),
            bottomLeft: Radius.circular(24.0),
          ) : BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0
          ),
        ),
      ),
    );
  }
}

