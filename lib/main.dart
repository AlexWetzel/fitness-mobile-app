import 'package:fitness_mobile_app/screens/cards_screen.dart';
import 'package:fitness_mobile_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_mobile_app/routes/routes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

// const SERVER_IP = 'http://192.168.1.167:5000';
final storage = FlutterSecureStorage();

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Future<String> get jwtOrEmpty async {
    // print("test");
    var jwt = await storage.read(key:"jwt");
    if(jwt == null) return "";
    // print(jwt);
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      routes: Routes.getroutes,
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return CircularProgressIndicator();
            if(snapshot.data != "") {
              var str = snapshot.data.toString();
              var jwt = str.split(".");

              if(jwt.length != 3) {
                return LoginScreen();
              } else {

                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                print(payload);
                // if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {

                //   return CardsScreen();
                // } else {

                //   return LoginScreen();
                // }
                return CardsScreen();
              }
            } else {
              return LoginScreen();
            }
          }
      ),
    );
  }
}
