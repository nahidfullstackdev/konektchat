// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:konekt_chat/models/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel userData;
  final VoidCallback? onTap;

  const UserTile({
    super.key,
    required this.userData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        contentPadding: EdgeInsets.all(5),
        title: Text(
          userData.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(userData.profilePic!),
        ),
        subtitle: Text('Last message'),
        trailing: Text('2:00 pm'),
      ),
    );
  }
}
