import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textfiles/blocs/ipfs/ipfs_bloc.dart';

import 'pages/home/home_page.dart';

void main() {
  runApp(MultiBlocProvider(
      providers: [BlocProvider<IpfsBloc>(
        create: (context) => IpfsBloc(null)..add(AppLaunched()),
      )],
        child: MyApp()
  )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Textfiles',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
