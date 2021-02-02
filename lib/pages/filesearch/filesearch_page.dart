import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textfiles/blocs/theme/theme_bloc.dart';

class FilesearchPage extends StatefulWidget {
  FilesearchPage({Key key}) : super(key: key);

  @override
  _FilesearchPageState createState() => _FilesearchPageState();
}

class _FilesearchPageState extends State<FilesearchPage> {
  ThemeBloc _themeBloc;

  @override
  void initState() {
    super.initState();
    _themeBloc = BlocProvider.of<ThemeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:[
          Center(
            child: Hero(
              tag: "search",
              child: Material(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: _themeBloc.state.themeMode == ThemeMode.light ? Colors.white : Colors.white70,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          offset: Offset(0, 5),
                          color: Colors.grey.withOpacity(0.25),
                        )
                      ]),
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) {},
                    textInputAction: TextInputAction.search,
                    cursorHeight: 18,
                    onSubmitted: (value) {},
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      hintText: "Search a Textfile2",
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
        ]
      ),
    );
  }
}