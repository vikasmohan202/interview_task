import 'package:flutter/material.dart';
import 'package:interview_task/resources/auth_methods.dart';
import 'package:interview_task/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  void signUpUser() async {
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passController.text,
      username: _usernameController.text,
      bio: _bioController.text,
    );
    print(res);
    if (res == "success") {
      //
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
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'bio',
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'username',
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: signUpUser,
              // () async {
              //   // TODO: Add your signup logic here
              //   String res = await AuthMethods().signUpUser(
              //     email: _emailController.text,
              //     password: _passController.text,
              //     username: _usernameController.text,
              //     bio: _bioController.text,
              //   );
              //   print(res);
              // },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 16),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Dont have an accout?"),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LoginScreen();
              }));
                    },
                    child: Container(
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
