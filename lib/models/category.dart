import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;

class Category {
  final String name;
  final String description;
  final String filename;


  Category({this.name, this.description, this.filename});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      description: json['description'],
      filename: json['filename']
    );
  }
}

Future<String> getCategories() {
  return rootBundle.loadString('assets/data/categories.json');
}

Future<List<Category>> getCategoriesList(category) async{
  var data = await getCategories();
  final parsed = jsonDecode(data).cast<Map<String, dynamic>>();

  return parsed.map<Category>((json) => Category.fromJson(json)).toList();
}