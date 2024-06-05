import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MyButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
