import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fshare/home_screen.dart';
import 'package:fshare/share_screen.dart';
import 'package:fshare/insight_screen.dart';
import 'package:http/http.dart' as http;
import 'package:fshare/constants.dart' as Constants;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  static final FacebookLogin facebookSignIn = new FacebookLogin();
  late String  name = "", image = "";
  late String userId = "";
  late String? extendedAccessToken = "";

  @override
  void initState() {
    super.initState();
    checkIfLoggedIn();
  }

  Future<void> _storeUserData(data) async {
    data['expiry'] = (data['expiry'].millisecondsSinceEpoch/1000).toInt();
      final response = await http
      .post(Uri.parse("${Constants.API_URL}add-or-update-user"),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': data['name'],
        'user_id': data['user_id'],
        'access_token': data['access_token'],
        'expiry': data['expiry'].toString()
      })
      );
      final body = jsonDecode(response.body);
      print(body);
  }

  void checkIfLoggedIn() async {
    final profile = await facebookSignIn.getUserProfile();
    final imgUrl = await facebookSignIn.getProfileImageUrl(width: 200);
    final access_token = await facebookSignIn.accessToken;
    if(profile != null && imgUrl != null){
      setState(() {
        name = profile.name!;
        userId = profile.userId;
        image = imgUrl;
        extendedAccessToken = access_token?.token;
      });
      _storeUserData({'name': profile.name!, 'user_id': profile.userId, 'access_token': access_token?.token, 'expiry': access_token?.expires});
    }
  }

  void logOut() async {
    await facebookSignIn.logOut();
    setState(() {
        name = "";
        userId = "";
        image = "";
    });
  }

  void login() async {
    final FacebookLoginResult result =
      await facebookSignIn.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.userPosts,
      ]);

      switch (result.status) {
          case FacebookLoginStatus.success:
              final FacebookAccessToken ? accessToken = result.accessToken;
              //extendedAccessToken = accessToken!.token;
              checkIfLoggedIn();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.teal,
         title: Text('POC'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: image!="" ? Image.network(
                        image,
                        height: 100.0,
                        width: 100.0,
                    ) : null,
                ),
                name != "" ? Text(
                    "Hello ${name},\nFB User Id : ${userId}",
                    textAlign: TextAlign.center,
                  ) : Container(),
                name != "" ? FlatButton(
                  color: Colors.teal,
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  onPressed: logOut
                ) : Container(),
                name != "" ? FlatButton(
                  color: Colors.teal,
                  child: const Text(
                    'Share On Facebook',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                Share(
                                  userId: userId,
                                  extendedAccessToken: extendedAccessToken
                                )
                          ),
                        );
                  }
                ) : Container(),
                name != "" ? FlatButton(
                  color: Colors.teal,
                  child: const Text(
                    'Show Insight',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                Insight(
                                  userId: userId,
                                  extendedAccessToken: extendedAccessToken
                                )
                          ),
                        );
                  }
                ) : Container(),
                name == "" ? FlatButton(
                  color: Colors.teal,
                  child: const Text(
                    'Login with facebook',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  onPressed: login,
                ) : Container()
              ],
            )),
      ),
    );
  }
}
