import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:konekt_chat/common/widgets/colors.dart';
import 'package:konekt_chat/services/auth/screens/login_signup_screen.dart';
import 'package:lottie/lottie.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  static const routeName = '/intro-screen';

  @override
  State<IntroScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroScreen> {
  // 1. Define a `GlobalKey` as part of the parent widget's state
  // final _introKey = GlobalKey<IntroductionScreenState>();
  // String _status = 'Waiting...';

  // List<Widget> listPagesViewModel = [
  //   PageViewModel(
  //     title: "Title of custom body page",
  //     bodyWidget: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: const [
  //         Text("Click on "),
  //         Icon(Icons.edit),
  //         Text(" to edit a post"),
  //       ],
  //     ),
  //     image: const Center(child: Icon(Icons.android)),
  //   ),
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.black87,
        curve: Curves.bounceIn,
        pages: [
          PageViewModel(
            decoration: const PageDecoration(
              imagePadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              pageMargin: EdgeInsets.all(30),
              titleTextStyle: TextStyle(
                  color: tabColor, fontSize: 40, fontWeight: FontWeight.w700),
              bodyTextStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
            title: "Konekt",
            body: 'Where conversations come alive.',
            image: Lottie.asset(
              'assets/lottie/chat1.json',
            ),
          ),
          PageViewModel(
            decoration: const PageDecoration(
              imagePadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              pageMargin: EdgeInsets.all(20),
              titleTextStyle: TextStyle(
                  color: tabColor, fontSize: 40, fontWeight: FontWeight.w700),
              bodyTextStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.normal),
            ),
            title: "Konekt",
            body:
                'Read Our Privacy, Tap "Done" to accept the terms & services ',
            image: Lottie.asset(
              'assets/lottie/chat2.json',
            ),
          ),
        ],
        showNextButton: true,
        showBackButton: false,
        showSkipButton: true,
        next: const Text(
          'Next',
          style: TextStyle(color: Colors.white),
        ),
        back: const Text(
          'Back',
          style: TextStyle(color: Colors.black),
        ),
        skip: const Text(
          'Skip',
          style: TextStyle(color: Colors.grey),
        ),
        done: const Text(
          "Done",
          style: TextStyle(color: Colors.white),
        ),
        onDone: () {
          // On button pressed
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const LoginSignup(),
          ));
        },
      ),
    );
  }
}
