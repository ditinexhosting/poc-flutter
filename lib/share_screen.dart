import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fshare/constants.dart' as Constants;

class Share extends StatefulWidget {
  final String userId;
  final String? extendedAccessToken;
  const Share({Key? key, required this.userId, required this.extendedAccessToken}) : super(key: key);

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
    try {
      final String? result = await platform.invokeMethod('getShareStatus',{'link':link,'quote':quote,'hashtag':hashtag});
      setState(() {
        shareStatus = "Please wait while fetching ...";
      });
      _verifyPostPublishStatus();
    } on PlatformException catch (e) {
                          Fluttertoast.showToast(
                            msg: "Sharing dialog dismissed.",
                            fontSize: 16,
                            toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> _verifyPostPublishStatus() async {
      final response = await http
      .get(Uri.parse("https://graph.facebook.com/me/posts?fields=id,permalink_url,created_time,application&limit=1&access_token=${widget.extendedAccessToken}"));
      final body = jsonDecode(response.body);
      final post_id = body['data'][0]['id'];
      final created_time = body['data'][0]['created_time'];
      final application_id = body['data'][0].containsKey('application')?body['data'][0]['application']['id']:null;
      var now = new DateTime.now();
      var date = DateTime.parse(created_time);
      var diff = now.difference(date);
      // If Posted Successfully and Not Cancelled
      if(application_id!=null && diff.inMinutes<2){

        final response = await http
        .get(Uri.parse("${Constants.API_URL}verify-new-post-status/${widget.userId}"));
        final body = jsonDecode(response.body);
        String _sharestatus = "Failed to update in backend api.";
        if(body==true){
          _sharestatus = "Shared successfully.";
          Navigator.pop(context);
        }
        setState(() {
          shareStatus = _sharestatus;
        });

      }
      else{
        setState(() {
          shareStatus = "";
        });
                            Fluttertoast.showToast(
                            msg: "Sharing failed or not accessible.",
                            fontSize: 16,
                            toastLength: Toast.LENGTH_LONG);
      }
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
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
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
                Text(shareStatus),
              ]
            )
        )
      )
    );
  }
}