// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konekt_chat/common/widgets/custom_textField.dart';
import 'package:konekt_chat/common/widgets/error.dart';
import 'package:konekt_chat/common/widgets/loader.dart';
import 'package:konekt_chat/services/auth/auth_service.dart';
import 'package:konekt_chat/services/chat/chat_service.dart';
import 'package:konekt_chat/services/chat/widget/chat_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
    required this.name,
    required this.uid,
  });

  static const routeName = '/chat-screen';

  final String name;
  final String uid;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void sendMessage() {
    //send the message
    if (_messageController.text.isNotEmpty) {
      ref
          .read(chatServiceProvider)
          .sendMessage(widget.uid, _messageController.text);
    }

    // clear text controller
    _messageController.clear();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          // display all messages
          Expanded(child: _buildMessageList()),

          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = ref.watch(authServiceProvider).getCurrentUser()!.uid;

    return StreamBuilder(
      stream: ref.read(chatServiceProvider).getMessages(widget.uid, senderID),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return ErrorText(error: 'error');
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        }

        // return list view
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser =
        data['senderID'] == ref.read(authServiceProvider).getCurrentUser()!.uid;

    // align message to the right if sender is the current user, otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
          ],
        ));
  }

//build message input
  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: CustomTextfield(
              hintText: 'Type a message', controller: _messageController),
        ),

        //send button
        IconButton(onPressed: sendMessage, icon: Icon(Icons.arrow_upward)),
      ],
    );
  }
}
