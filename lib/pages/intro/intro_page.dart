import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textfiles/blocs/theme/theme_bloc.dart';
import 'package:textfiles/services/shared_pref_service.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  PageController _pageController;
  SharedPreferencesService sharedPrefService;
  ThemeBloc _themeBloc;


  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _themeBloc = BlocProvider.of<ThemeBloc>(context);
    initSharedPrefs();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> initSharedPrefs() async {
    sharedPrefService = await SharedPreferencesService.instance;
  }

  void setIsFirstLaunch() {
    _themeBloc.add(FirstLaunchChanged(false));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          buildPage1(),
          buildPage2(),
        ],
      ),
    );
  }

  Widget buildPage1() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Stack(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "What are",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
              ),
              Text(
                "Textfiles?",
                style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 36,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                "A wonderful thing happened in the 1980s:\nLife started to go online. From computers, internet magazines, BBS's and provocative ideas to ASCII arts, Textfiles are the text-based files written in that period of time.",
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ]),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () {
                    if (_pageController.hasClients) {
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                        fontFamily: 'Courier',
                        color: Colors.black,
                        fontSize: 25,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildPage2() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Stack(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Why does this",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
              ),
              Text(
                "matter?",
                style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 36,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                "There are around 60.000~ Textfiles archived by Jason Scott at textfiles.com\nWe believe these files are some spectrum of humanity and it should be preserved.\nThis app uses P2P protocols to retrieve files so the files can exist, forever.",
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ]),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () {
                    if (_pageController.hasClients) {
                      setIsFirstLaunch();
                    }
                  },
                  child: Text(
                    "Bring it on",
                    style: TextStyle(
                        fontFamily: 'Courier',
                        color: Colors.black,
                        fontSize: 25,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
