import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:konekt_chat/common/utils/utils.dart';
import 'package:konekt_chat/common/widgets/colors.dart';
import 'package:konekt_chat/common/widgets/loader.dart';
import 'package:konekt_chat/services/auth/auth_service.dart';

import 'package:konekt_chat/common/widgets/custom_textField.dart';
import 'package:konekt_chat/common/widgets/my_button.dart';
import 'package:konekt_chat/common/widgets/profile_pic.dart';

class LoginSignup extends ConsumerStatefulWidget {
  const LoginSignup({super.key});

  @override
  ConsumerState<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends ConsumerState<LoginSignup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  bool isLogin = true;
  bool isloading = false;

  File? image;

  void login(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isloading = true;
    });

    try {
      ref.read(authServiceProvider).signInwithEmail(
            context,
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    } catch (e) {
      if (mounted) {
        showSnackBar(
            context: context,
            content: 'Failed to login. Please check your credentials.');
      }
    } finally {
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  void signup(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _cpasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Passwords do not match!'),
          content: Text('Please make sure both passwords are identical.'),
        ),
      );
      return;
    }

    if (image == null) {
      showSnackBar(
          context: context, content: 'Please select a profile picture.');
      return;
    }

    setState(() {
      isloading = true;
    });

    try {
      ref.read(authServiceProvider).signUpwithEmail(
            context,
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

      // Ensure the user is authenticated before saving data
      ref.read(authServiceProvider).saveUserDataToFirestore(
          context: context,
          username: _nameController.text.trim(),
          password: _passwordController.text.trim(),
          profilePic: image);
    } catch (e) {
      if (mounted) {
        showSnackBar(
            context: context,
            content: 'Failed to create account. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  void selectImage() async {
    image = await pickedImageFromGalary(context);
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _cpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  // logo
                  Icon(
                    Icons.message_rounded,
                    size: 60,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // welcome back message
                  Text(
                    isLogin
                        ? 'Welcome Back, You have been missed!'
                        : 'Create your account now!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //  textfield
                  if (!isLogin)
                    Column(
                      spacing: 16,
                      children: [
                        ProfilePic(image: image, selectImage: selectImage),
                        CustomTextfield(
                          hintText: 'Name',
                          controller: _nameController,
                        ),
                      ],
                    ),
                  CustomTextfield(
                    hintText: 'Email',
                    controller: _emailController,
                  ),
                  CustomTextfield(
                    hintText: 'Pasword',
                    controller: _passwordController,
                    obsecuretext: true,
                  ),

                  if (!isLogin)
                    CustomTextfield(
                      hintText: 'Confirm Password',
                      controller: _cpasswordController,
                    ),

                  // login button
                  isloading
                      ? Loader()
                      : MyButton(
                          text: isloading
                              ? (isLogin ? 'Logging in...' : 'Signing up...')
                              : (isLogin ? 'Login' : 'Sign Up'),
                          onTap: () {
                            isLogin ? login(context) : signup(context);
                          }),

                  // register now toggle
                  RichText(
                    text: TextSpan(
                      text: isLogin
                          ? 'Doesn\'t have an account? '
                          : 'Already have an account? ',
                      children: [
                        TextSpan(
                            text: isLogin ? 'Sign Up' : 'Login',
                            style: TextStyle(
                              color: tabColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
