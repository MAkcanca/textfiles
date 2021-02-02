import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textfiles/blocs/ipfs/ipfs_bloc.dart';
import 'package:textfiles/components/category_card.dart';
import 'package:textfiles/models/category.dart';
import 'package:textfiles/utils/constants.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = const MethodChannel('cambaz.textfiles/ipfs');
  Future<List<Category>> futureProduct;
  IpfsBloc _ipfsBloc;

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('startPeer');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

  }

  @override
  void initState() {
    super.initState();
    _ipfsBloc = BlocProvider.of<IpfsBloc>(context);
    futureProduct = getCategoriesList("100");
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IpfsBloc, IpfsState>(
        builder: (context, state) {
          print(state);
          if (state is PeerNotStarted){
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
                  style: TextStyle(color: Colors.black),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              body: Column(
                children: [
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 14),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 55,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                          color: Colors.white,
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
                        onChanged: (value) {},
                        textInputAction: TextInputAction.search,
                        cursorHeight: 18,
                        onSubmitted: (value) {

                        },
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
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0),
                      child: FutureBuilder<List<Category>>(
                        future: futureProduct,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          }
                          else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  )
                ],
              ) // This trailing comma makes auto-formatting nicer for build methods.
          );
        }
    );
  }
}