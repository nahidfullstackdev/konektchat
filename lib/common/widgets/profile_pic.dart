import 'dart:io';

import 'package:flutter/material.dart';
import 'package:konekt_chat/common/utils/utils.dart';



class ProfilePic extends StatelessWidget {
  const ProfilePic({super.key, required this.image, required this.selectImage});

  final File? image;
  final VoidCallback selectImage;

  @override
  Widget build(BuildContext context) {
    return
        // profile pic
        Stack(
      children: [
        image == null
            ? const CircleAvatar(
                backgroundImage: NetworkImage(
                  profileAvatar,
                ),
                radius: 64,
              )
            : CircleAvatar(
                backgroundImage: FileImage(image!),
                radius: 64,
              ),
        Positioned(
          bottom: -10,
          left: 80,
          child: IconButton(
            onPressed:  selectImage,
            icon: const Icon(
              Icons.add_a_photo_sharp,
            ),
          ),
        ),
      ],
    );
  }
}
