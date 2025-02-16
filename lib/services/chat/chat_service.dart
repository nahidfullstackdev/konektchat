// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konekt_chat/models/message.dart';

import 'package:konekt_chat/models/user_model.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
});

class ChatService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatService({
    required this.firestore,
    required this.auth,
  });

// get all users...
  Stream<List<UserModel>> getUserStream() {
    return firestore.collection("users").snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return UserModel.fromMap(doc.data()); // Assuming fromMap exists
          },
        ).toList();
      },
    );
  }

  // send message....

  Future<void> sendMessage(String receiverID, message) async {
    final String currentUserID = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // sort the ids (this ensure the chatRoomID is the same for any 2 people)
    String chatRoomID = ids.join('_');

    // add new message to database
    await firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get message....

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    // Construct a chatroom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort(); // Sort ensures a unique chat room ID
    String chatRoomID = ids.join('_');

    return firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
