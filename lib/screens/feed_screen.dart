import 'package:flutter/material.dart';
import 'package:interview_task/screens/add_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
      title: Text('Welcome to Interview Task'),
      actions: [
        IconButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AddPostScreen();
              }));
        }, icon: Icon(Icons.add))
      ],
      ),
      body:Column()
    );
  }
}