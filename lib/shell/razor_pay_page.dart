import 'package:flutter/material.dart';

class RazorpayPage extends StatefulWidget {
  const RazorpayPage({Key? key}) : super(key: key);

  @override
  State<RazorpayPage> createState() => _RazorpayPageState();
}

class _RazorpayPageState extends State<RazorpayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Center(
          child: TextField(
            decoration: InputDecoration(
              filled: true,
            ),
            style: TextStyle(
              color: Colors.deepOrange
            ),
          ),
        ),
      ),
    );
  }
}
