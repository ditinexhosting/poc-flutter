import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/services.dart';

class Share extends StatefulWidget {
  const Share({Key? key}) : super(key: key);

  @override
  _ShareState createState() => _ShareState();
}

class _ShareState extends State<Share> {
  static const platform = const MethodChannel('samples.flutter.dev/fbshare');
  TextEditingController linkController = TextEditingController();
  TextEditingController quoteController = TextEditingController();
  TextEditingController hashtagController = TextEditingController();

  String shareStatus = "";

  @override
  void dispose() {
    linkController.dispose();
    quoteController.dispose();
    hashtagController.dispose();
    super.dispose();
  }
      
  Future<void> _getShareStatus(String link,{String quote='',String hashtag=''}) async {
    String _shareStatus;
    try {
      final String? result = await platform.invokeMethod('getShareStatus',{'link':link,'quote':quote,'hashtag':hashtag});
      _shareStatus = result!;
    } on PlatformException catch (e) {
      _shareStatus = "Failed to get battery level: '${e.message}'.";
    }
    print(_shareStatus);
    /*setState(() {
      shareStatus = _shareStatus;
    });*/
  }

  void submitPup(BuildContext context) {
    _getShareStatus(linkController.text.isEmpty?'https://www.facebook.com':linkController.text,quote: quoteController.text,hashtag:hashtagController.text);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.teal,
         title: Text('Share'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                      controller: linkController,
                      //onChanged: (v) => linkController.text = v,
                      decoration: InputDecoration(
                        labelText: 'Link',
                    ))
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                      controller: quoteController,
                      //onChanged: (v) => quoteController.text = v,
                      decoration: InputDecoration(
                        labelText: 'Quote',
                    ))
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                      controller: hashtagController,
                      //onChanged: (v) => hashtagController.text = v,
                      decoration: InputDecoration(
                        labelText: 'Hashtag',
                    ))
                ),
                FlatButton(
                  color: Colors.teal,
                  child: const Text(
                    'Share on facebook',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  onPressed: () { submitPup(context); }
                ),
                Text("Test"),
              ]
            )
        )
      )
    );
    /*return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('Get Battery Level'),
              onPressed: _getBatteryLevel,
            ),
            Text(_batteryLevel),
          ],
        ),
      ),
    );*/
  }
}