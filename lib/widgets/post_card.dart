import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String userMsg;
  final String email;
  // final String time;

  const PostCard({
    super.key,
    required this.userMsg,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration:
                BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle),
            child: Icon(Icons.person),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text(userMsg),
              Text(
                email,
                style: TextStyle(color: Colors.grey[500]),
              )
            ],
          )
        ],
      ),
    );
  }
}
