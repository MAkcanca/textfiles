import 'package:flutter/material.dart';
import 'package:textfiles/components/file_card.dart';
import 'package:textfiles/components/file_card_notitle.dart';
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
    futureProduct = getTextfileList(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [],
          centerTitle: true,
          title:  Text(
              widget.category.name,
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
                        if(snapshot.data[index].title.isNotEmpty){
                          return FileCard(
                            textfile: snapshot.data[index],
                            // product: snapshot.data[index],
                            //index: null
                          );
                        } else {
                          return FileCardNoTitle(
                            textfile: snapshot.data[index],
                            // product: snapshot.data[index],
                            //index: null
                          );
                        }

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
