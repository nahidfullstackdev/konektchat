// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:konekt_chat/theme/pallete.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  final String message;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 3.5, horizontal: 20),
      decoration: BoxDecoration(color: Pallete.kdarkSenderMsgColor,borderRadius: BorderRadius.circular(10)),
      child: Text(message),
    );
  }
}
