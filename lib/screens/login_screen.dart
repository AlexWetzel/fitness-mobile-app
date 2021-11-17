import 'package:flutter/material.dart';
import 'package:fitness_mobile_app/utils/get_api.dart';
import 'dart:convert';

class GlobalData
{
  static int? userId;
  static String? firstName;
  static String? lastName;
  static String? loginName;
  static String? password;
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: MainPage(),
    );
  }
}
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  String message = "This is a message", newMessageText = '';
  String loginName = '', password = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
          crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontal
          children: <Widget>[
            Row(
                children: <Widget>[
                  Container(
                    width: 200,
                    child:
                    TextField (
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Login Name',
                          hintText: 'Enter Your Login Name'
                      ),
                      onChanged: (text) {
                        loginName = text;
                      },
                    ),
                  ),
                ]
            ),
            Row(
                children: <Widget>[
                  Container(
                    width: 200,
                    child:
                    TextField (
                      obscureText: true,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter Your Password'
                      ),
                      onChanged: (text) {
                        password = text;
                      },
                    ),
                  ),
                ]
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                    child: Text('Do Login',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                    onPressed: () async
                {
                  newMessageText = "";
                  changeText();
                  String payload = '{"login":"' + loginName.trim() + '","password":"' +
                      password.trim() + '"}';
                  var userId = -1;
                  var jsonObject;
                  try
                  {
                    String url = 'https://cop4331-10.herokuapp.com/api/login';
                    String ret = await CardsData.getJson(url, payload);
                    jsonObject = json.decode(ret);
                    userId = jsonObject["id"];
                  }
                  catch(e)
                  {
                    newMessageText = "Something went wrong...";
                    // newMessageText = e.message;
                    changeText();
                    return;
                  }
                  if( userId <= 0 )
                  {
                    newMessageText = "Incorrect Login/Password";
                    changeText();
                  }
                  else
                  {
                    GlobalData.userId = userId;
                    GlobalData.firstName = jsonObject["firstName"];
                    GlobalData.lastName = jsonObject["lastName"];
                    GlobalData.loginName = loginName;
                    GlobalData.password = password;
                    Navigator.pushNamed(context, '/cards');
                  }
                },
                    color:Colors.brown[50],
                    textColor: Colors.black,
                    padding: EdgeInsets.all(2.0),
                    splashColor: Colors.grey[100]
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('$message',style: TextStyle(fontSize: 14 ,color:Colors.black)),
              ],
            ),
          ],
        )
    );
  }

  changeText() {
    setState(() {
      message = newMessageText;
    });
  }
}