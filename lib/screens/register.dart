import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/homepage.dart';

import 'package:social_media_app/screens/login.dart';
import 'package:social_media_app/widgets/my_button.dart';
import 'package:social_media_app/widgets/text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pwController = TextEditingController();

  final TextEditingController _confirmpwController = TextEditingController();

  void signUp() async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));

    if (_emailController.toString().contains('@') != true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid email'),
        duration: Duration(milliseconds: 2000),
        backgroundColor: Colors.red,
      ));
    } else if (_pwController.toString().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password must be atleat 6 digits'),
        duration: Duration(milliseconds: 2000),
        backgroundColor: Colors.red,
      ));
    } else if (_pwController.text != _confirmpwController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Confirm password Shall match with the password'),
        duration: Duration(milliseconds: 2000),
        backgroundColor: Colors.red,
      ));
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _pwController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      if (context.mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Registered Sucessfully',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ));
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          maxLines: 1,
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              //logo
              Icon(
                Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(
                height: 50,
              ),

              //welcome message
              Text(
                "Lets get you an account first",
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).colorScheme.primary),
              ),

              const SizedBox(height: 50),

              //email txt field
              MyTextField(
                hintText: "Email",
                controller: _emailController,
                obsecureText: false,
              ),

              const SizedBox(height: 10),

              //pswrd field
              MyTextField(
                hintText: "Password",
                controller: _pwController,
                obsecureText: true,
              ),

              const SizedBox(height: 10),

              MyTextField(
                hintText: "Confirm Password",
                controller: _confirmpwController,
                obsecureText: true,
              ),

              SizedBox(height: 25),

              // login btn
              MyButton(
                text: "Sign Up",
                onTap: signUp,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  SizedBox(
                    width: 7,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      'Click here',
                      style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
