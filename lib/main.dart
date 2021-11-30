import 'package:fitness_mobile_app/screens/cards_screen.dart';
import 'package:fitness_mobile_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_mobile_app/routes/routes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

const storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Future<String> get jwtOrEmpty async {
    // print("test");
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    // print(jwt);
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fitness App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.red,
            foregroundColor: Colors.black,
          ),
        ),
        routes: Routes.getroutes,
        home: Scaffold(
          // appBar: AppBar(
          //   title: const Text('Fitness App'),
          // ),
          body: FutureBuilder(
              future: jwtOrEmpty,

              // This builder sees if there's a token, and renders the appropriate page
              builder: (context, snapshot) {
                // print(snapshot.data);
                if (!snapshot.hasData) return CircularProgressIndicator();
                if (snapshot.data != "") {
                  var str = snapshot.data.toString();
                  var jwt = str.split(".");

                  if (jwt.length != 3) {
                    return LoginScreen();
                  } else {
                    var payload = json.decode(
                        ascii.decode(base64.decode(base64.normalize(jwt[1]))));

                    // Check if the token is expired
                    if (DateTime.fromMillisecondsSinceEpoch(
                            payload["exp"] * 1000)
                        .isAfter(DateTime.now())) {
                      return CardsScreen();
                    } else {
                      return LoginScreen();
                    }
                  }
                } else {
                  return LoginScreen();
                }
              }),
        ) // home:
        );
  }
}
