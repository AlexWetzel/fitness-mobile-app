import 'package:fitness_mobile_app/main.dart';
import 'package:flutter/material.dart';
import 'package:fitness_mobile_app/utils/get_api.dart';
import 'dart:convert';

class GlobalData {
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
      backgroundColor: Colors.green,
      body: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String message = '', newMessageText = '';
  String loginName = '', password = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/SantaApp.png'),
              TextField(
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Login Name',
                    hintText: 'Enter Your Login Name'),
                onChanged: (text) {
                  loginName = text;
                },
              ),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter Your Password'),
                onChanged: (text) {
                  password = text;
                },
              ),
              RaisedButton(
                  child: const Text('Do Login',
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  onPressed: () async {
                    newMessageText = "";
                    changeText();
                    String payload = '{"login":"' +
                        loginName.trim() +
                        '","password":"' +
                        password.trim() +
                        '"}';
                    // var userId = -1;
                    var jsonObject;
                    try {
                      // String url = 'https://cop4331-10.herokuapp.com/api/login';
                      String url =
                          'http://10.0.2.2:5000/api/login'; // localhost
                      // String url = 'https://cop4331-7.herokuapp.com/api/login';
                      String? ret = await CardsData.getJson(url, payload);
                      jsonObject = json.decode(ret);
                      // userId = jsonObject["id"];
                      // print(jsonObject["accessToken"]);
                      var jwt = jsonObject["jwtToken"]["accessToken"];
                      storage.write(key: "jwt", value: jwt);

                      if (jwt == null) {
                        newMessageText = "Authorization failed";
                        changeText();
                      } else {
                        jwt = jwt.split(".");
                        var userInfo = json.decode(ascii
                            .decode(base64.decode(base64.normalize(jwt[1]))));
                        // print(userInfo);

                        Navigator.pushNamed(
                          context,
                          '/cards',
                          // arguments: <String, String>{
                          //   'userId': userInfo["userId"],
                          // }
                        );
                        // GlobalData.userId = userId;
                        // GlobalData.firstName = jsonObject["firstName"];
                        // GlobalData.lastName = jsonObject["lastName"];
                        // GlobalData.loginName = loginName;
                        // GlobalData.password = password;
                        // Navigator.pushNamed(context, '/cards');
                      }
                    } catch (e) {
                      // newMessageText = "Something went wrong...";
                      newMessageText = e.toString();
                      changeText();
                      return;
                    }
                  },
                  color: Colors.brown[50],
                  textColor: Colors.black,
                  padding: const EdgeInsets.all(2.0),
                  splashColor: Colors.grey[100]),
              Text(message,
                  style: const TextStyle(fontSize: 14, color: Colors.white)),
              Image.asset('assets/images/Cookies.png', height: 200, width: 200),
            ],
          ),
        ));
  }

  changeText() {
    setState(() {
      message = newMessageText;
    });
  }
}
