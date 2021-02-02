import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textfiles/blocs/ipfs/ipfs_bloc.dart';
import 'package:textfiles/blocs/theme/theme_bloc.dart';
import 'package:textfiles/components/category_card.dart';
import 'package:textfiles/models/category.dart';
import 'package:textfiles/pages/filesearch/filesearch_page.dart';
import 'package:textfiles/utils/constants.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Category>> futureProduct;
  IpfsBloc _ipfsBloc;
  ThemeBloc _themeBloc;

  @override
  void initState() {
    super.initState();
    _ipfsBloc = BlocProvider.of<IpfsBloc>(context);
    _themeBloc = BlocProvider.of<ThemeBloc>(context);

    futureProduct = getCategoriesList("100");
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IpfsBloc, IpfsState>(builder: (context, state) {
      print(state);
      if (state is PeerNotStarted) {
        _ipfsBloc.add(StartPeer());
      }
      return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              title: Text(
                "Textfiles",
                style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 36,
                    fontWeight: FontWeight.w800),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: DayNightSwitcherIcon(
                      isDarkModeEnabled:
                          _themeBloc.state.themeMode == ThemeMode.dark
                              ? true
                              : false,
                      onStateChanged: (state) =>
                          BlocProvider.of<ThemeBloc>(context)
                              .add(ThemeChanged(state)),
                    )),
              ]),
          body: SafeArea(
            child: Column(
              children: [
                Center(
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
                          autofocus: false,
                          readOnly: true,
                          enableInteractiveSelection: false,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FilesearchPage()));
                          },
                          onChanged: (value) {},
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    child: FutureBuilder<List<Category>>(
                      future: futureProduct,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return CategoryCard(
                                category: snapshot.data[index],
                                gradientcolors: Constants.grad_array[index],
                                // product: snapshot.data[index],
                                //index: null
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                )
              ],
            ),
          ) // This trailing comma makes auto-formatting nicer for build methods.
          );
    });
  }
}
