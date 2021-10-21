import 'package:chat_app/helpers/authenticate.dart';
import 'package:chat_app/helpers/prefs.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation.dart';
import 'package:chat_app/views/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  final AuthServices _authServices = AuthServices();
  final DatabaseServices _databaseServices = DatabaseServices();

  late String myUsername;
  Stream<QuerySnapshot>? chatRoomsStream;

  void getMyChatRooms() async {
    myUsername = (await Prefs.getPrefUsername())!;
    await _databaseServices.getMyChatRooms(myUsername)
        .then((value) {
          setState(() {
            chatRoomsStream = value;
          });
    });
  }

  @override
  void initState() {
    getMyChatRooms();
    super.initState();
  }

  Widget ChatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          QuerySnapshot snapshotData = snapshot.data as QuerySnapshot;
          return ListView.builder(
              itemCount: snapshotData.docs.length,
              itemBuilder: (context, index) {
                String username = snapshotData.docs[index].get("chatRoomId").replaceAll("-", "").toString().replaceAll(myUsername, "");
                return ChatRoomsTile(username: username);
              }
          );
        } else {
          return SizedBox.shrink();
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Text("Chat App"),
        actions: [
          GestureDetector(
            onTap: () async {
              await _authServices.signOut();
              await Prefs.setPrefIsLoggedIn(false);
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Authenticate()
              ));
            },
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                child: Icon(Icons.logout)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()
          ));
        },
        child: Icon(Icons.search),
        backgroundColor: Colors.red[800],
      ),
      body: Container(
          child: ChatRoomsList(),
      ),
    );
  }
}


class ChatRoomsTile extends StatelessWidget {

  final String username;

  ChatRoomsTile({ required this.username });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(recipientUsername: username)
        ));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                "${username.substring(0,1).toUpperCase()}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0),
              ),
              decoration: BoxDecoration(
                color: Colors.red[900],
                borderRadius: BorderRadius.circular(50.0)
              ),
              width: 40.0,
              height: 40.0,
            ),
            SizedBox(width: 16.0),
            Text(
              "$username",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }
}