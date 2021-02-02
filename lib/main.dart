import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textfiles/blocs/ipfs/ipfs_bloc.dart';
import 'package:textfiles/blocs/theme/theme_bloc.dart';

import 'pages/home/home_page.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<IpfsBloc>(
        create: (context) => IpfsBloc()..add(AppLaunched())),
    BlocProvider<ThemeBloc>(
        create: (context) => ThemeBloc()..add(ThemeLoadStarted()))
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        print(state);
        return MaterialApp(
          themeMode: state.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
            primaryIconTheme: IconThemeData.fallback().copyWith(
              color: Colors.black,
            ),
            primaryTextTheme: TextTheme(
                headline6: TextStyle(
                    color: Colors.black
                )
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          title: 'Textfiles',
          /*theme: ThemeData(
            primarySwatch: Colors.blue,
          ),*/
          home: HomePage(),
        );
      },
    );
  }
}
