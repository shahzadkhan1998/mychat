// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_chat/component/rounded_button.dart';
import 'package:my_chat/constant/constant.dart';

class Login extends StatefulWidget {
  static const String id = 'login';
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // ignore: prefer_typing_uninitialized_variables
  var email;
  // ignore: prefer_typing_uninitialized_variables

  final auth = FirebaseAuth.instance;

  // ignore: prefer_typing_uninitialized_variables
  var password;

  bool showSpinner = false;

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
        title: "Login",
        onPressed: () {
          Navigator.pushNamed(context, '/chat');
        },
        colour: Colors.lightBlueAccent,
      );
    } else {
      return RoundedButton(
        title: "Login",
        onPressed: () async {
          setState(() {
            showSpinner = true;
          });
          try {
            final newUser = userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password);
                // ignore: unnecessary_null_comparison
                if (newUser != null) {
                  Navigator.pushNamed(context, '/chat'); 
                }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              // ignore: avoid_print
              print('No user found for that email.');
            } else if (e.code == 'wrong-password') {
              // ignore: avoid_print
              print('Wrong password provided for that user.');
            }
          }
        },
        colour: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                      'Login here',
                      textStyle: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                      
                    ),
                  ],
                  isRepeatingAnimation: true,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "Enter your Email"),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter your password"),
              ),
              checkSize(MediaQuery.of(context).size),
            ],
          ),
        ),
      ),
    );
  }
}
