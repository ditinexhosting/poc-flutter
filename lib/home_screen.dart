import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final String name;
  final String pic;
  const Home({Key? key, required this.name, required this.pic}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final imageurlp="https://res.cloudinary.com/practicaldev/image/fetch/s--_HBZhuhF--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/nweeqf97l2md3tlqkjyt.jpg";
  String text="If you have been self-teaching programming to yourself and wondering what are some of the most basic things every software developer or programmer should learn or know";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Welcome  ${widget.name}"),
        leading: widget.pic != null
            ? Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(widget.pic)),
              shape: BoxShape.circle),
        ):
        Container(),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: [
            SizedBox(height: 150,),

            //FadeInImage(image: Image.network(imageurlp),
                FadeInImage(
                  image: NetworkImage(
                      imageurlp),
                  // width: screenWidth*0.29,//120.0,
                  // height: screenHeight*0.123,
                  placeholder: const AssetImage("images/nweeqf97l2md3tlqkjyt.jpg"),
                  fit: BoxFit.fill,
                ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text),
            ),
            SizedBox(height: 50,),
            ElevatedButton(
              child: const Text('Share'),
              onPressed: () async {
                final imageurl = imageurlp;
                final uri = Uri.parse(imageurl);
                final response = await http.get(uri);
                final bytes = response.bodyBytes;

                final temp = await getTemporaryDirectory();
                final path = '${temp.path}/image.jpg';

                File(path).writeAsBytesSync(bytes);
                print("ijaj");

                //await Share.shareFiles([path], text: text);//[path] for shareing image
                await Share.share('$text $imageurlp');
              },
            ),

          ]

      ),
    );
  }
}
