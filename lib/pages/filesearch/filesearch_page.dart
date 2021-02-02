import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textfiles/blocs/theme/theme_bloc.dart';
import 'package:textfiles/components/file_card.dart';
import 'package:textfiles/models/textfile.dart';

class FilesearchPage extends StatefulWidget {
  FilesearchPage({Key key}) : super(key: key);

  @override
  _FilesearchPageState createState() => _FilesearchPageState();
}

class _FilesearchPageState extends State<FilesearchPage> {
  ThemeBloc _themeBloc;
  String searchText = "";
  Future<List<Textfile>> futureFiles;
  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    _themeBloc = BlocProvider.of<ThemeBloc>(context);
    myFocusNode = FocusNode();

    Future.delayed(
        const Duration(milliseconds: 350), () => myFocusNode.requestFocus());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  _searchResults(String text) {
    futureFiles = searchTextfile(text);
    setState(() {
      /*return new FutureBuilder<List<Textfile>>(
          future: search(text),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MemberList(snapshot.data);
            }
            return Container(
                alignment: AlignmentDirectional.center,
                child: new CircularProgressIndicator(
                  strokeWidth: 7,
                ));
          });*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Hero(
                    tag: "search",
                    child: Material(
                      child: Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: _themeBloc.state.themeMode == ThemeMode.light
                                ? Colors.white
                                : Colors.white70,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                offset: Offset(0, 5),
                                color: Colors.grey.withOpacity(0.25),
                              )
                            ]),
                        child: TextField(
                          onChanged: (text) async {
                            _searchResults(text);
                            searchText = text;
                          },
                          focusNode: myFocusNode,
                          textInputAction: TextInputAction.search,
                          cursorHeight: 18,
                          onSubmitted: (value) {},
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            hintText: "Search a Textfile",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF818181),
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            suffixIcon: Icon(Icons.search,
                                color: Color(0x818181).withOpacity(1)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      width: 50,
                      height: 55,
                      child: Text("Cancel")),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Textfile>>(
              future: futureFiles,
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
                if(searchText.isNotEmpty){
                  return Center(child: CircularProgressIndicator());
                }
                return SizedBox();
              },
            ),
          )
        ]),
      ),
    );
  }
}
