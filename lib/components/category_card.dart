import 'package:flutter/material.dart';
import 'package:textfiles/models/category.dart';
import 'package:textfiles/pages/filelist/filelist_page.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  final List<Color> gradientcolors;

  CategoryCard({Key key, this.category, this.gradientcolors}) : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          height: 100.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              gradient: LinearGradient(
                  colors: widget.gradientcolors,
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft)),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            onTap: () => {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FilelistPage(
            category: widget.category,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.category.name,
                        style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        widget.category.description,
                        style: TextStyle(fontSize: 14.0, color: Colors.white70),
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
