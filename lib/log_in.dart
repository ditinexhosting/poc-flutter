import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fshare/home_screen.dart';
import 'package:fshare/share_screen.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  static final FacebookLogin facebookSignIn = new FacebookLogin();
   late String  name = '', image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.teal,
      //   title: Text('title'),
      //
      // ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bannerBg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Share()),
            );
          },
        ),
                FlatButton(
                  color: Colors.teal,
                  child: const Text(
                    'Login with facebook',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    final FacebookLoginResult result =
                    await facebookSignIn.logIn(permissions: [
                      FacebookPermission.publicProfile,
                      FacebookPermission.userPosts,
                    ]);

                    switch (result.status) {
                      case FacebookLoginStatus.success:
                        final FacebookAccessToken ? accessToken = result.accessToken;
                        /*final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=first_name,picture&access_token=${accessToken!.token}')
                        );
                        final profile = jsonDecode(graphResponse.body);
                        print(profile);
                        setState(() {
                          name = profile['first_name'];
                          image = profile['picture']['data']['url'];
                        });*/
                        print('''
           Logged in!
           
           Token: ${accessToken!.token}
           User id: ${accessToken.userId}
           Expires: ${accessToken.expires}
           Permissions: ${accessToken.permissions}
           Declined permissions: ${accessToken.declinedPermissions}
           ''');

                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                   Home(
                                    name: name,
                                    pic: image,
                                  )
                          ),
                        );*/

                        break;
                      case FacebookLoginStatus.cancel:
                        Fluttertoast.showToast(
                            msg: "Failed to login. Please try again.",
                            fontSize: 16,
                            backgroundColor: Colors.orange[100],
                            textColor: Colors.white,
                            toastLength: Toast.LENGTH_LONG);
                        break;
                      case FacebookLoginStatus.error:
                        print('Something went wrong with the login process.\n'
                            'Here\'s the error Facebook gave us: ${result.error}');
                        Fluttertoast.showToast(
                            msg: "Failed to login. Please try again.",
                            fontSize: 16,
                            backgroundColor: Colors.orange[100],
                            textColor: Colors.white,
                            toastLength: Toast.LENGTH_LONG);
                        break;
                    }
                  },
                )
              ],
            )),
      ),
    );
  }
}
