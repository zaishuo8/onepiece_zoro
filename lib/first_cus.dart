import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class FirstCus extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FirstCusState();
}

class _FirstCusState extends State<FirstCus> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Route')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: const Text('Present second route'),
              onPressed: () {

                String url = 'second';
                Map<String, dynamic> urlParams = {};

                FlutterBoost.singleton.open(
                  url,
                  urlParams: urlParams
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}