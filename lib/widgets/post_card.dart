import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  void initState() {
    super.initState();
  }

  void deletePost(String postId) async {
   
    postId = postId.replaceAll('//', '/');

    try {
      // Reference the Firestore collection and document for the post
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      // Delete the post document
      await postRef.delete();

      // Close the dialog or navigate to another screen as needed
      Navigator.of(context).pop();
    } catch (e) {
      print("Error deleting post: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //Header section
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                // CircleAvatar(
                //   radius: 16,
                //   backgroundImage: NetworkImage(
                //     widget.snap['profImage'],
                //   ),
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: [
                                  'Delete',
                                ]
                                    .map((e) => InkWell(
                                          onTap: () async {
                                            deletePost(widget.snap['postUrl']);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(e),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ));
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),

          //image section
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postUrl'].toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),

          //like comment section
          Row(
            children: [
              IconButton(
                onPressed: () {},
                // => Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => CommentsScreen(
                //       snap: widget.snap,
                //     ),
                //   ),
                // ),
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
              ))
            ],
          ),

          //description and no. of comments
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DefaultTextStyle(
                //   style: Theme.of(context)
                //       .textTheme
                //       .subtitle2!
                //       .copyWith(fontWeight: FontWeight.w800),
                //   child: Text(
                //     '${widget.snap['likes'].length} likes',
                //     style: Theme.of(context).textTheme.bodyText2,
                //   ),
                // ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ' ${widget.snap['description']}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(vertical: 4),
                //   child: Text(
                //     '26/11',
                //     style: const TextStyle(
                //       fontSize: 16,
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
