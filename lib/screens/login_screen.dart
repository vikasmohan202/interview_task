import 'package:flutter/material.dart';
import 'package:interview_task/resources/auth_methods.dart';
import 'package:interview_task/screens/feed_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  void loginUser() async {
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passController.text
        );

        if (res == "success"){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const FeedScreen();
              }));
        } else {
          //
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
              obscureText: true, // Hide password text
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: loginUser,
              // () {
              //   // TODO: Add your login logic here
              //   String email = _emailController.text;
              //   String password = _passController.text;
              //   print('Email: $email, Password: $password');
              // },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
