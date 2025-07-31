import 'package:flutter/material.dart';
import 'package:holbegram/models/posts.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/screens/Pages/methods/PostStorage.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final List<dynamic> postsIds = userProvider.user!.saved;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(
            fontSize: 40,
            fontFamily: 'Billabong',
          ),
        ),
      ),
      body: FutureBuilder(
        future: PostStorage().getPosts(postsIds),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final posts = snapshot.data;
          if (posts!.isEmpty) {
            return Center(child: Text('No posts available.'));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 7);
              },
              itemBuilder: (context, index) {
                final Post post = Post.fromSnap(posts[index]);
                return Image.network(
                  post.postUrl,
                  height: 350,
                  fit: BoxFit.cover,
                );
              },
            ),
          );
        }
      ),
    );    
  }
}