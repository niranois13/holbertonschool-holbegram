import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/models/posts.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:holbegram/methods/auth_methods.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<List<DocumentSnapshot>> getPosts(List<dynamic> postIds) async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('posts');
    if (postIds.isNotEmpty) {
      final query = collection.where(FieldPath.documentId, whereIn: postIds);
      final querySnapshot = await query.get();
      return querySnapshot.docs;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final postsIds = userProvider.user!.posts;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 40,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthMethode().logOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen(
                    emailController: TextEditingController(),
                    passwordController: TextEditingController(),
                  )),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: userProvider.user!.photoUrl.isNotEmpty
                        ? NetworkImage(userProvider.user!.photoUrl)
                        : const AssetImage("assets/images/img.png")
                            as ImageProvider,
                  ),
                  FollwItem(
                      text: "Posts",
                      count: userProvider.user!.posts.length.toString()),
                  FollwItem(
                      text: "Followers",
                      count: userProvider.user!.followers.length.toString()),
                  FollwItem(
                      text: "Following",
                      count: userProvider.user!.following.length.toString()),
                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                child: Text(
                  userProvider.user!.username,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 600,
                child: FutureBuilder<List<DocumentSnapshot>>(
                  future: getPosts(postsIds),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final posts = snapshot.data;

                    if (posts == null || posts.isEmpty) {
                      return const Center(child: Text('No posts available.'));
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                      ),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final Post post = Post.fromSnap(posts[index]);
                        return Image.network(
                          post.postUrl,
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FollwItem extends StatelessWidget {
  final String text;
  final String count;
  const FollwItem({super.key, required this.text, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          text,
          style: const TextStyle(
              color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
