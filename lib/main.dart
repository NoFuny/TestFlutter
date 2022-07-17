import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'post.dart';
import 'commets.dart';

int _indexComments = 0;

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.indigoAccent),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Посты'),
        '/commets': (context) => CommentsPage(
              title: 'Комментарии',
              post: _indexComments,
            ),
      },
    ));

// страница для отображении постов
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchPosts(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return PostsList(posts: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

// перечень всех постов
class PostsList extends StatelessWidget {
  PostsList({super.key, required this.posts});

  int _selectedIndex = 0;
  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            _indexComments = posts[index].id;
            Navigator.pushNamed(context, '/commets');
            //print("Container clicked $index");
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      posts[index].title,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      posts[index].body,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}

//Страница для отображения коментариев к определенному посту
class CommentsPage extends StatelessWidget {
  CommentsPage({super.key, required this.title, required this.post});

  final String title;
  final int post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Comments>>(
        future: fetchComments(http.Client(), post),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return CommentsList(comments: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

//перечень всех комментариев к посту.
class CommentsList extends StatelessWidget {
  CommentsList({super.key, required this.comments});

  final List<Comments> comments;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Icon(
                      Icons.account_circle_rounded,
                      size: 45,
                    ),
                    padding: EdgeInsets.only(right: 16),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comments[index].name,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            comments[index].body,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.normal),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
