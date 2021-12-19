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
import 'package:url_launcher/url_launcher.dart';

class Insight extends StatefulWidget {
  final String userId;
  final String? extendedAccessToken;
  const Insight({Key? key, required this.userId, required this.extendedAccessToken}) : super(key: key);

  @override
  _InsightState createState() => _InsightState();
}

class _InsightState extends State<Insight> {
  
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = _getDbInsight();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  Future<List<Data>> _getDbInsight() async {
    final response = await http
        .get(Uri.parse("${Constants.API_URL}show-latest-insights/${widget.userId}"));
    final body = jsonDecode(response.body);
    return List.from(body.reversed.toList().map((i) => Data.fromJson(i)));
    /*List<dynamic> parsedListJson = jsonDecode(response.body);
    List itemsList = List.from(parsedListJson.map((i) => Item.fromJson(i)));
      print(itemsList);*/
  }

  Future<void> _reFetch() async {
    final response = await http
        .get(Uri.parse("${Constants.API_URL}fetch-insight-data/${widget.userId}"));
    final body = jsonDecode(response.body);
    setState(() {
       futureData = _getDbInsight();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.teal,
         title: Text('Insight'),
      ),
      body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlatButton(
                  color: Colors.teal,
                  child: const Text(
                    'Re-Fetch',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  onPressed: _reFetch
                ),
                SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder <List<Data>>(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => Container(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Color(0xffDDDDDD),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Post ID : ${snapshot.data![index].post_id}",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text("Reactions : ${snapshot.data![index].reaction_count}"),
                        SizedBox(height: 5),
                        Text("Comments : ${snapshot.data![index].comment_count}"),
                        SizedBox(height: 5),
                        RaisedButton(
                          onPressed: (){_launchURL(snapshot.data![index].parmalink_url);},
                          child: new Text('Open Post'),
                        ),
                      ],
                    ),
                  ),
                ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
          ),
        ],
      ),
    );
  }
}



class Data {
  final String post_id;
  final String id;
  final String parmalink_url;
  final String reaction_count;
  final String comment_count;

  Data({required this.post_id, required this.id, required this.parmalink_url, required this.reaction_count, required this.comment_count});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      post_id: json['post_id'],
      id: json['_id'].toString(),
      parmalink_url: json['parmalink_url'],
      reaction_count: json['insight']['reactions'].toString(),
      comment_count: json['insight']['comments'].toString(),
    );
  }
}