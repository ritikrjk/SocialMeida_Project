import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/login.dart';
import 'package:social_media_app/widgets/post_card.dart';
import 'package:social_media_app/widgets/text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text(
          'HomePage',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Alert"),
                      content: Text('Are you sure you want to Log Out?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("cancel")),
                        TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: Text('yes, I am sure'))
                      ],
                    )),
            icon: Icon(Icons.logout),
            color: Colors.white,
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('User Posts')
                  .orderBy('TimeStamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return PostCard(
                            userMsg: post['Message'], email: post['UserEmail']);
                        // time: post['TimeStamp']);
                      });
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Eror: ${snapshot.error.toString()}'),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        hintText: 'Write your thoughts',
                        obsecureText: false,
                        controller: textController),
                  ),
                  IconButton(
                    onPressed: () {
                      if (textController.text.isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection('User Posts')
                            .add({
                          'UserEmail': user.email,
                          'Message': textController.text,
                          'TimeStamp': Timestamp.now()
                        });

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'New Post Created Succesfully',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.green[400],
                          duration: Duration(milliseconds: 1000),
                        ));
                        FocusScope.of(context).unfocus();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Empty Posts are Invalid',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          duration: Duration(milliseconds: 1000),
                        ));
                      }
                      setState(() {
                        textController.clear();
                      });
                    },
                    icon: Icon(Icons.arrow_circle_up),
                    iconSize: 33,
                  )
                ],
              ),
            ),
            Text("Logged in as " + user.email!)
          ],
        ),
      ),
    );
  }
}
