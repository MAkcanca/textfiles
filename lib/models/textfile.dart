import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'dart:async' show Future;

import 'category.dart';

class Textfile {
  final String title;
  final String description;
  final String filename;
  final String category;
  final String networkCid;


  Textfile({this.title, this.description, this.filename, this.category, this.networkCid});

  factory Textfile.fromJson(Map<String, dynamic> json) {
    return Textfile(
        title: json['title'],
        description: json['description'],
        filename: json['filename'],
        category: "100",
        networkCid: json['networkCid'],
    );
  }
}

Future<String> getJson(Category category) {
  return rootBundle.loadString('assets/data/${category.filename}');
}

Future<List<Textfile>> searchTextfile(keyword) async {
  var cat1 = Category(filename: "100.json");
  var data = await getJson(cat1);
  final filesList = (jsonDecode(data) as List)
      .map((p) => Textfile.fromJson(p));
 /* return (json.decode(utf8.decode(response.bodyBytes)) as List)
      .map((p) => Product.fromJson(p))
      .toList();*/
  return filesList.where((item) => item.title.contains(keyword) || item.filename.contains(keyword)).toList();
}

Future<String> getFromgateway(networkCid) async{
  final response = await http.get("https://ipfs.io/ipfs/" + networkCid);
  if (response.statusCode == 200) {
    print(response.body);
    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}


Future<List<Textfile>> getTextfileList(Category category) async{
  var data = await getJson(category);
  final parsed = jsonDecode(data).cast<Map<String, dynamic>>();

  return parsed.map<Textfile>((json) => Textfile.fromJson(json)).toList();
}