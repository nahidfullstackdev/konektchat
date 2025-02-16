import 'package:konekt_chat/common/widgets/error.dart';
import 'package:konekt_chat/screens/introduction_screen.dart';

import 'package:flutter/material.dart';
import 'package:konekt_chat/screens/home_screen.dart';
import 'package:konekt_chat/services/chat/screen/chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name']!;
      final uid = arguments['uid']!;
      return MaterialPageRoute(
        builder: (context) => ChatScreen(
          name: name,
          uid: uid,
        ),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );

    case IntroScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const IntroScreen(),
      );

    // case SelectContactScreen.routeName:
    //   return MaterialPageRoute(
    //     builder: (context) => const SelectContactScreen(),
    //   );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorText(error: 'This page doesn\'t exists'),
        ),
      );
  }
}
