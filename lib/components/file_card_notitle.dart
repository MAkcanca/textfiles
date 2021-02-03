import 'package:flutter/material.dart';
import 'package:textfiles/models/category.dart';
import 'package:textfiles/models/textfile.dart';
import 'package:textfiles/pages/filelist/filelist_page.dart';
import 'package:textfiles/pages/fileview/fileview_page.dart';

class FileCardNoTitle extends StatefulWidget {
  final Textfile textfile;

  FileCardNoTitle({Key key, this.textfile}) : super(key: key);

  @override
  _FileCardNoTitleState createState() => _FileCardNoTitleState();
}

class _FileCardNoTitleState extends State<FileCardNoTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Color(0xFFeb3c29)),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FileviewPage(
                    textfile: widget.textfile,
                  ))),
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /*Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Icon(Icons.cloud, color: Colors.white70,),
                  ),*/
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.textfile.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        widget.textfile.filename,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white54,

                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
