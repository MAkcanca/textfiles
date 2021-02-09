import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                  "assets/images/ic_launcher.png",
                  width: 60,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: new TextSpan(
                  children: [
                    new TextSpan(
                      text: 'Textfiles are archived by Jason Scott / ',
                      style: new TextStyle(color: Colors.black),
                    ),
                    new TextSpan(
                      text: 'textfiles.com',
                      style: new TextStyle(color: Colors.blue),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () { launch('http://textfiles.com');
                        },
                    ),
                  ],
                ),
              ),
              Text(
                  "All of the files are stored in IPFS P2P network."
              ),
              RichText(
                textAlign: TextAlign.center,
                text: new TextSpan(
                  children: [
                    new TextSpan(
                      text: 'This app runs and uses IPFS client protocol,\nmore about it can be found in ',
                      style: new TextStyle(color: Colors.black),
                    ),
                    new TextSpan(
                      text: 'ipfs.io',
                      style: new TextStyle(color: Colors.blue),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () { launch('https://ipfs.io');
                        },
                    ),
                  ],
                ),
              ),
              Text(
                  "Source code can be found in : COMING SOON"
              ),
              Text(
                "Developed by Cambaz"
              ),
            ],
          ),
        ),
      ),
    );
  }
}
