import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final   VoidCallback  onPressed;
  final Color  colour;
    const RoundedButton(
      {Key? key, required this.title,
      required this.onPressed,
      required this.colour,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
