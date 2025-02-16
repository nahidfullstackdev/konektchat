import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:konekt_chat/common/widgets/colors.dart';
import 'package:konekt_chat/common/widgets/error.dart';
import 'package:konekt_chat/common/widgets/loader.dart';
import 'package:konekt_chat/common/widgets/user_tile.dart';
import 'package:konekt_chat/models/user_model.dart';

import 'package:konekt_chat/screens/settings_screen.dart';
import 'package:konekt_chat/services/auth/auth_service.dart';
import 'package:konekt_chat/services/chat/chat_service.dart';
import 'package:konekt_chat/services/chat/screen/chat_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home-screen';

  @override
  ConsumerState<HomeScreen> createState() {
    return _MobileScreenState();
  }
}

class _MobileScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Konekt',
            style: TextStyle(color: tabColor, fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MySettings(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: ref.read(chatServiceProvider).getUserStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return ErrorText(error: 'error');
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        }
        return

            //return list view
            ListView(
          children: snapshot.data!
              .map<Widget>((userdata) => _buildUserItem(userdata, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserItem(UserModel userData, BuildContext context) {
    if (userData.email !=
        ref.read(authServiceProvider).getCurrentUser()!.email) {
      return UserTile(
          userData: userData,
          onTap: () {
            Navigator.pushNamed(context, ChatScreen.routeName, arguments: {
              'name': userData.name,
              'uid': userData.uid,
            });
          });
    }
    return Container();
  }
}
