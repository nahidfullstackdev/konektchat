import 'package:flutter/material.dart';
import 'package:konekt_chat/theme/pallete.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Pallete.blackColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.kdarkRecieverMsgColor,
        ),
      ),
      appBarTheme: AppBarTheme().copyWith(
        backgroundColor: Pallete.kdarkBGColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.all(20),
        enabledBorder: _border(Pallete.greyColor),
        focusedBorder: _border(Pallete.kBoarderColor),
      ));
}
