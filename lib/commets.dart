import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<Comments>> fetchComments(http.Client client, int post) async {
  String _url = 'https://jsonplaceholder.typicode.com/posts/'+post.toString() +'/comments';
  final response =
  await client.get(Uri.parse(_url));

  // Use the compute function to run parseComments in a separate isolate.
  return compute(parseComments, response.body);
}

// A function that converts a response body into a List<Comments>.
List<Comments> parseComments(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Comments>((json) => Comments.fromJson(json)).toList();
}

class Comments {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  const Comments({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      postId: json['userId'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      body: json['body'] as String,
    );
  }
}


