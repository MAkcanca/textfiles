import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;

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

Future<String> getJson() {
  return rootBundle.loadString('assets/data/100.json');
}


Future<List<Textfile>> getTextfileList(category) async{
  var data = await getJson();
  final parsed = jsonDecode(data).cast<Map<String, dynamic>>();

  return parsed.map<Textfile>((json) => Textfile.fromJson(json)).toList();
}