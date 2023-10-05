import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interview_task/screens/add_post_screen.dart';
import 'package:interview_task/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // final TextEditingController nameController = TextEditingController();
  // final TextEditingController descriptionController = TextEditingController();
  // final TextEditingController profilePicUrlController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  List<DocumentSnapshot<Map<String, dynamic>>> listOfPosts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Call the method to fetch posts data from Firestore.
    fetchPostsData();
  }

  void _getCurrentUser() async {
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      // Fetch and display the user's existing profile data (if any)
      DocumentSnapshot userProfileSnapshot =
          await _firestore.collection('users').doc(_currentUser!.uid).get();
      if (userProfileSnapshot.exists) {
        // final data = userProfileSnapshot.data() as Map<String, dynamic>;
        // nameController.text = data['username'];
        //descriptionController.text = data['description'];
        // profilePicUrlController.text = data['profilePicUrl'];
      }
    }
  }

  // Method to fetch posts data from Firestore.
  Future<void> fetchPostsData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('posts').get();

      setState(() {
        listOfPosts = snapshot.docs;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching posts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Interview Task'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AddPostScreen();
              })).then((value) {
                if (value) {
                  fetchPostsData();
                }
              });
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: listOfPosts.length,
              itemBuilder: (context, index) => PostCard(
                snap: listOfPosts[index].data(),
              ),
            ),
    );
  }
}
