import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_task/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../model/post.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  // final TextEditingController profilePicUrlController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String imageUrl = '';

  User? _currentUser;
  Uint8List? file;
  bool isLoading = false;

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List pickedFile = await pickImage(ImageSource.camera);
                imageUrl =
                    await uploadImageToStorage('posts', pickedFile, true);
                setState(() {
                  file = pickedFile;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List pickedFile = await pickImage(ImageSource.gallery);
                imageUrl =
                    await uploadImageToStorage('posts', pickedFile, true);

                setState(() {
                  file = pickedFile;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void _getCurrentUser() async {
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      // Fetch and display the user's existing profile data (if any)
      DocumentSnapshot userProfileSnapshot =
          await _firestore.collection('users').doc(_currentUser!.uid).get();
      if (userProfileSnapshot.exists) {
        final data = userProfileSnapshot.data() as Map<String, dynamic>;
        nameController.text = data['username'];
        // profilePicUrlController.text = data['profilePicUrl'];
        setState(() {});
      }
    }
  }

  // adding image to firebase storage
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    // creating location to our firebase storage

    Reference ref = FirebaseStorage.instance
        .ref()
        .child(childName)
        .child(_auth.currentUser!.uid);

    // putting in uint8list format -> Upload task like a future but not future
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String username,
    String imageurl,
  ) async {
    setState(() {
      isLoading = true;
    });
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String postId = const Uuid().v1();
      // String photoUrl = await uploadImageToStorage('posts', file, true);
      // creates unique id based on time
      Post post = Post(
        description: descriptionController.text,
        username: nameController.text,
        postUrl: imageUrl,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop(true);
    } catch (err) {
      res = err.toString();
      setState(() {
        isLoading = false;
      });
    }
    return res;
  }

  void _updateProfile() async {
    final String name = nameController.text;
    final String description = descriptionController.text;
    // final String profilePicUrl = profilePicUrlController.text;

    try {
      if (_currentUser != null) {
        // Update the user's profile in Firestore
        await _firestore.collection('users').doc(_currentUser!.uid).set({
          'name': name,
          'description': description,
          // 'profilePicUrl': profilePicUrl,
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile updated successfully'),
        ));
      }
    } catch (e) {
      // Handle errors
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update profile'),
      ));
    }
  }

  @override
  void initState() {
    _getCurrentUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Text('Upload Image'),
              actions: [
                TextButton(
                  onPressed: () {
                    uploadPost(descriptionController.text, file!,
                        nameController.text, imageUrl);
                  },
                  child: const Text('Post'),
                ),
              ],
            ),
            body: file == null
                ? Center(
                    child: IconButton(
                      onPressed: () =>
                          _selectImage(context), // Use 'context' here
                      icon: Icon(Icons.upload),
                    ),
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: TextField(
                              // controller: ,
                              decoration: InputDecoration(
                                  hintText: 'Enter description here',
                                  labelText: 'Description'),
                              maxLines: 8,
                            ),
                          ),
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    imageUrl,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
          );
  }
}
