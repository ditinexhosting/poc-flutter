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
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  String _batteryLevel =
      'Battery Level';

  _ShareState(){
    
  }
      
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final String? result = await platform.invokeMethod('getBatteryLevel',{'link':'https://www.google.com','quote':'Hello Google','hashtag':'#google'});
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch(call.method) {
      case "message":
        debugPrint(call.arguments);
        return new Future.value("");
    }
  }

  @override
  Widget build(BuildContext context) {
    platform.setMethodCallHandler(_handleMethod);
    return Material(
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
    );
  }
}