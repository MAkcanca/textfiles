import 'package:flutter/material.dart';
import 'package:textfiles/components/file_card.dart';
import 'package:textfiles/models/category.dart';
import 'package:textfiles/models/textfile.dart';

class FilelistPage extends StatefulWidget {
  final Category category;

  FilelistPage({Key key, this.category}) : super(key: key);

  @override
  _FilelistPageState createState() => _FilelistPageState();
}

class _FilelistPageState extends State<FilelistPage> {
  Future<List<Textfile>> futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = getTextfileList(widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [],
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          title:  Text(
              widget.category.name,
              style: TextStyle(color: Colors.black),
            ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              child: FutureBuilder<List<Textfile>>(
                future: futureProduct,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 2.8,
                          crossAxisCount: 1),
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return FileCard(
                          textfile: snapshot.data[index],
                          // product: snapshot.data[index],
                          //index: null
                        );
                      },
                    );
                  }
                  else if(snapshot.hasError){
                    return Text("${snapshot.error}");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          )
        ]
        )
    );
  }
}
