import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textfiles/blocs/ipfs/ipfs_bloc.dart';
import 'package:textfiles/models/textfile.dart';

class FileviewPage extends StatefulWidget {
  final Textfile textfile;

  FileviewPage({Key key, this.textfile}) : super(key: key);

  @override
  _FileviewPageState createState() => _FileviewPageState();
}

class _FileviewPageState extends State<FileviewPage> {
  static const platform = const MethodChannel('cambaz.textfiles/ipfs');
  String filedata;
  IpfsBloc _ipfsBloc;
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
    if (filedata.isNotEmpty) {
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
          return Scaffold(
            body: SingleChildScrollView(
              child: Text(
                  filedata
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