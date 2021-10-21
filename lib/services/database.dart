import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference chatRoomsCollection = FirebaseFirestore.instance.collection("chatRooms");

  Future addUserDataToFirestore(String username, String email) async {
    return await usersCollection.doc().set({
      "username": username,
      "email": email,
    });
  }

  Future getUsersByUsername(String username) async {
    return await usersCollection.where("username", isEqualTo: username).get();
  }

  Future getUserByEmail(String email) async {
    return await usersCollection.where("email", isEqualTo: email).get();
  }

  Future createChatRoom(String username1, String username2) async {

    String chatRoomId = (username1.hashCode > username2.hashCode) ? "$username1-$username2" : "$username2-$username1";
    return await chatRoomsCollection.doc(chatRoomId).set({
      "chatRoomId": chatRoomId,
      "usersChatting": [username1, username2],
    });
  }

  Future getConversationMessages(String recipient, String sender) async {
    String chatRoomId = (recipient.hashCode > sender.hashCode) ? "$recipient-$sender" : "$sender-$recipient";
    return await chatRoomsCollection.doc(chatRoomId).collection("chats").orderBy("timeStamp").snapshots();
  }

  Future addMessageToConversation(String recipient, String sender, String message) async {
    String chatRoomId = (recipient.hashCode > sender.hashCode) ? "$recipient-$sender" : "$sender-$recipient";
    return await chatRoomsCollection.doc(chatRoomId).collection("chats").add({
      "message": message,
      "sentBy": sender,
      "timeStamp": DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future getMyChatRooms(String myUsername) async {
    return await chatRoomsCollection.where("usersChatting", arrayContains: myUsername).snapshots();
  }

}