import 'package:flutter/material.dart';
import 'package:konekt_chat/common/widgets/colors.dart';


class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, required this.onPressed, required this.widget});

  final VoidCallback onPressed;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: tabColor,
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: onPressed,
      child: widget,
    );
  }
}
