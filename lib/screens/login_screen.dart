import 'package:fitness_mobile_app/main.dart';
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
                    // String url = 'https://cop4331-10.herokuapp.com/api/login';
                    String url = 'http://10.0.2.2:5000/api/login';
                    // String url = 'https://cop4331-7.herokuapp.com/api/login';
                    String? ret = await CardsData.getJson(url, payload);
                    jsonObject = json.decode(ret);
                    // userId = jsonObject["id"];
                    // print(jsonObject["accessToken"]);
                    var jwt = jsonObject["accessToken"];
                    storage.write(key: "jwt", value: jwt);

                    if(jwt == null)
                    {
                      newMessageText = "Incorrect Login/Password";
                      changeText();
                    }
                    else
                    {
                      jwt = jwt.split(".");
                      var userInfo = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                      print(userInfo);



                      Navigator.pushNamed(context, '/cards');
                      // GlobalData.userId = userId;
                      // GlobalData.firstName = jsonObject["firstName"];
                      // GlobalData.lastName = jsonObject["lastName"];
                      // GlobalData.loginName = loginName;
                      // GlobalData.password = password;
                      // Navigator.pushNamed(context, '/cards');
                    }
                  }
                  catch(e)
                  {
                    // newMessageText = "Something went wrong...";
                    newMessageText = e.toString();
                    changeText();
                    return;
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