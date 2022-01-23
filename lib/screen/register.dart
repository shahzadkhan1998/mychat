// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_chat/component/rounded_button.dart';
import 'package:my_chat/constant/constant.dart';
import 'package:my_chat/screen/login.dart';

import 'Login.dart';

class Register extends StatefulWidget {
  static const String id = 'register';
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // ignore: prefer_typing_uninitialized_variables
  var email;
  // ignore: prefer_typing_uninitialized_variables
  var password;

  bool showSpinner = false;

  final auth = FirebaseAuth.instance;
  UserCredential? userCredential;
  @override
  void initState() {
    super.initState();

    // ignore: avoid_print

    // ignore: avoid_print
  }

  checkSize(Size size) {
    if (size.width >= 700) {
      return RoundedButton(
        title: "Register",
        onPressed: () {
          Navigator.pushNamed(context, "/login");
        },
        colour: Colors.lightBlueAccent,
      );
    } else {
      return RoundedButton(
        title: "Register",
        onPressed: () async {
          setState(() {
            showSpinner = true;
          });
          try {
            final newUser = userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email, password: password);
            // ignore: unnecessary_null_comparison
            if (newUser != null) {
              Navigator.pushNamed(context, "/chat");
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              print('The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
              print('The account already exists for that email.');
            }
          } catch (e) {
            print(e);
          }
          setState(() {
            showSpinner = false;
          });
        },
        colour: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          // Center Column
          children: [
            Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Register Here',
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    
                  ),
                ],
               isRepeatingAnimation: true,
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "Enter your Email"),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "Enter your Email"),
              ),
            ),
            checkSize(MediaQuery.of(context).size),
          ],
        ),
      ),
    );
  }
}
