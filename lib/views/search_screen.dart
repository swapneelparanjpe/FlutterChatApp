import 'package:chat_app/helpers/prefs.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final DatabaseServices _databaseServices = DatabaseServices();
  TextEditingController searchUsername = TextEditingController();
  QuerySnapshot? _querySnapshots;

  bool isSearchingUser = false;

  Widget searchList() {
    int itemCount = _querySnapshots!.docs.length;
    if (itemCount != 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return SearchResultTile(
                username: _querySnapshots!.docs[index].get("username"),
                email: _querySnapshots!.docs[index].get("email")
            );
          }
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text(
          "No such username exists",
          style: TextStyle(
              color: Colors.red,
              fontSize: 16.0
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Text("Chat App"),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white54
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchUsername,
                      style: textStyle(),
                      decoration: InputDecoration(
                          hintText: "Search user",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        QuerySnapshot searchResults = await _databaseServices.getUsersByUsername(searchUsername.text);
                        setState(() {
                          _querySnapshots = searchResults;
                          isSearchingUser = true;
                        });
                      },
                      tooltip: "Search",
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      splashRadius: 24.0,
                  )
                ],
              ),
            ),
            SizedBox(height: 32.0),
            isSearchingUser ? searchList() : SizedBox()
          ],
        ),
      ),
    );
  }
}


class SearchResultTile extends StatelessWidget {

  final String username;
  final String email;

  SearchResultTile({ required this.username, required this.email });

  @override
  Widget build(BuildContext context) {

    final DatabaseServices _databaseServices = DatabaseServices();

    return Padding(
      padding: EdgeInsets.only(top: 4.0),
      child: Card(
          color: Colors.white10,
          child: ListTile(
            trailing: IconButton(
              onPressed: () async {
                String? myUsername = await Prefs.getPrefUsername();
                await _databaseServices.createChatRoom(username, myUsername!);
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ConversationScreen(recipientUsername: username)
                ));
              },
              icon: Icon(Icons.message),
              color: Colors.white70,
            ),
            title: Text(
                username,
              style: TextStyle(color: Colors.white70),
            ),
            subtitle: Text(
              email,
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
    );
  }
}

