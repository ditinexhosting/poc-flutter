import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Share extends StatefulWidget {
  const Share({Key? key}) : super(key: key);

  @override
  _ShareState createState() => _ShareState();
}

class _ShareState extends State<Share> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    //initPlatformState();
  }



  ScreenshotController screenshotController = ScreenshotController();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Screenshot(
          controller: screenshotController,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Running on: $_platformVersion\n',
                  textAlign: TextAlign.center,
                ),
                /*RaisedButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker().getImage(
                        source: ImageSource.gallery,
                        maxWidth: 1800,
                        maxHeight: 1800,
                    );
                    PickedFile? test = pickedFile;
                    print("DEBUG:");
                    print(pickedFile?.path);
                    String? path = pickedFile?.path;
                    if(path != null){
                    SocialShare.shareInstagramStory(
                      path,
                      backgroundTopColor: "#ffffff",
                      backgroundBottomColor: "#000000",
                      attributionURL: "https://ditinex.com",
                    ).then((data) {
                      print(data);
                    });
                    }
                  },
                  child: Text("Share On Instagram Story"),
                ),*/
                /*RaisedButton(
                  onPressed: () async {
                    await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((image) async {
                        if (image != null) {
                            final directory = await getApplicationDocumentsDirectory();
                            final imagePath = await File('${directory.path}/image.png').create();
                            await imagePath.writeAsBytes(image);

                            print(imagePath.path);

                      SocialShare.shareInstagramStory(
                        imagePath.path,
                        backgroundTopColor: "#ffffff",
                        backgroundBottomColor: "#000000",
                        attributionURL: "https://deep-link-url",
                        //backgroundImagePath: image.path,
                      ).then((data) {
                        print("WTF");
                        print(data);
                      })
                      .catchError((e) => print("[insta error]: " + e.toString()));
                        }
                    });
                  },
                  child: Text("Share On Instagram Story with background"),
                ),*/
                /*RaisedButton(
                  onPressed: () async {
                    await screenshotController.capture().then((image) async {
                      //facebook appId is mandatory for andorid or else share won't work
                      Platform.isAndroid
                          ? SocialShare.shareFacebookStory(
                              image.path,
                              "#ffffff",
                              "#000000",
                              "https://google.com",
                              appId: "xxxxxxxxxxxxx",
                            ).then((data) {
                              print(data);
                            })
                          : SocialShare.shareFacebookStory(
                              image.path,
                              "#ffffff",
                              "#000000",
                              "https://google.com",
                            ).then((data) {
                              print(data);
                            });
                    });
                  },
                  child: Text("Share On Facebook Story"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.copyToClipboard(
                      "This is Social Share plugin",
                    ).then((data) {
                      print(data);
                    });
                  },
                  child: Text("Copy to clipboard"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareTwitter(
                      "This is Social Share twitter example",
                      hashtags: ["hello", "world", "foo", "bar"],
                      url: "https://google.com/#/hello",
                      trailingText: "\nhello",
                    ).then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on twitter"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareSms(
                      "This is Social Share Sms example",
                      url: "\nhttps://google.com/",
                      trailingText: "\nhello",
                    ).then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on Sms"),
                ),
                RaisedButton(
                  onPressed: () async {
                    await screenshotController.capture().then((image) async {
                      SocialShare.shareOptions("Hello world").then((data) {
                        print(data);
                      });
                    });
                  },
                  child: Text("Share Options"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareWhatsapp(
                      "Hello World \n https://google.com",
                    ).then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on Whatsapp"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareTelegram(
                      "Hello World \n https://google.com",
                    ).then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on Telegram"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.checkInstalledAppsForShare().then((data) {
                      print(data.toString());
                    });
                  },
                  child: Text("Get all Apps"),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
