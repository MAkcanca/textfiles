import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:textfiles/blocs/ipfs/ipfs_bloc.dart';
import 'package:textfiles/blocs/theme/theme_bloc.dart';
import 'package:textfiles/models/textfile.dart';

class FileviewPage extends StatefulWidget {
  final Textfile textfile;

  FileviewPage({Key key, this.textfile}) : super(key: key);

  @override
  _FileviewPageState createState() => _FileviewPageState();
}

class _FileviewPageState extends State<FileviewPage> {
  double _fontSize = 10;
  final double _baseFontSize = 10;
  double _fontScale = 1;
  double _baseFontScale = 1;
  static const platform = const MethodChannel('cambaz.textfiles/ipfs');
  String filedata;
  IpfsBloc _ipfsBloc;
  ThemeBloc _themeBloc;
  Timer timer;

  Future<void> getDatafromNetwork() async {
    String returnedData;
    try {
      final String result = await platform.invokeMethod('getData', {"cid": widget.textfile.networkCid});
      returnedData = result;
    } on PlatformException catch (e) {
      returnedData = "Failed to get data: '${e.message}'.";
    }
    setState(() {
      filedata = returnedData;
    });
  }

  void retrieveData(t){
    _ipfsBloc.add(RetrieveData());
    if (filedata != null) {
      t.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    _ipfsBloc = BlocProvider.of<IpfsBloc>(context);
    _themeBloc = BlocProvider.of<ThemeBloc>(context);
    BlocProvider.of<IpfsBloc>(context)
        .add(FetchData(widget.textfile.networkCid));
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => retrieveData(t));
    _ipfsBloc.listen((state) {
      if(state is Fetched) {
        if (this.mounted) {
          setState(() {
            filedata = state.data;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IpfsBloc, IpfsState>(
      builder: (context, state) {
        if (state is Fetched){
          return NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(

                  title: new Text(widget.textfile.filename,),
                  pinned: false,
                  floating: true,
                  //snap: true,
                  forceElevated: innerBoxIsScrolled,
                    actions: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: DayNightSwitcherIcon(
                            isDarkModeEnabled:
                            _themeBloc.state.themeMode == ThemeMode.dark ? true : false,
                            onStateChanged: (state) => BlocProvider.of<ThemeBloc>(context)
                                .add(ThemeChanged(state)),
                          )),
                    ]
                ),
              ];
            },
            body: GestureDetector(
              onScaleStart: (ScaleStartDetails scaleStartDetails) {
                _baseFontScale = _fontScale;
              },
              onScaleUpdate: (ScaleUpdateDetails scaleUpdateDetails) {
                // don't update the UI if the scale didn't change
                if (scaleUpdateDetails.scale == 1.0) {
                  return;
                }
                setState(() {
                  _fontScale = (_baseFontScale * scaleUpdateDetails.scale).clamp(0.5, 5.0);
                  _fontSize = _fontScale * _baseFontSize;
                });
              },
              child: Scaffold(
              body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        filedata != null ? filedata : "Failed",
                        style: TextStyle(
                            fontFamily: Platform.isIOS ? "Courier" : "monospace",
                            fontSize: _fontSize,
                            color: _themeBloc.state.themeMode == ThemeMode.dark ? Color(0xFF00ff00) : Theme.of(context).textTheme.bodyText1.color
                        ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          )
        );
      },
    );
  }
}