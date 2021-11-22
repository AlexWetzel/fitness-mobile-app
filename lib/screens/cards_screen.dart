import 'package:flutter/material.dart';
import 'package:fitness_mobile_app/main.dart';
import 'package:fitness_mobile_app/utils/get_api.dart';
import 'package:fitness_mobile_app/screens/login_screen.dart';
import 'dart:convert';

class Exercise {
  String name = "";

  Exercise (this.name);

  factory Exercise.fromJson(dynamic json) {
    return Exercise(json["ExerciseName"] as String);
  }

  @override
  String toString() {
    return '{ ${this.name} }';
  }
}

class CardsScreen extends StatefulWidget {
  @override
  _CardsScreenState createState() => _CardsScreenState();
}
class _CardsScreenState extends State<CardsScreen> {
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
  var exerciseList = <Exercise>[], newExerciseList = <Exercise>[];
  String message = '', newMessageText = '';
  String addMessage = '', newAddMessage = '';
  String searchMessage = '', newSearchMessage = '';
  String card = "";
  String search = "";
  @override
  void initState() {
    super.initState();
  }


  void changeText() {
    setState(() {
      message = newMessageText;
    });
  }
  void changeAddText() {
    setState(() {
      addMessage = newAddMessage;
    });
  }
  void changeSearchText() {
    setState(() {
      searchMessage = newSearchMessage;
    });
  }
  void changeExerciseList() {
    setState(() {
      exerciseList = newExerciseList;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
          crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontal
          children: <Widget>[
            Row(
                children: <Widget>[
                  Column(
                      children: <Widget>[
                        Container(
                          width: 200,
                          child:
                          TextField (
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                labelText: 'Search',
                                hintText: 'Search for a Card'
                            ),
                            onChanged: (text)
                            {
                              search = text;
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text('$searchMessage',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                          ],
                        ),
                        Column(
                          children: exerciseList.map((e) => Text(e.name)).toList()
                        ),
                      ]
                  ),
                  RaisedButton(
                      child: Text('Search',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                      onPressed: () async
                      {
                        newSearchMessage = "";
                        changeSearchText();

                        var str = await storage.read(key: 'jwt');
                        var jwt = str.toString().split(".");
                        var jsonObject = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                        var res;
                        String payload = '{"userId":"' + jsonObject["userId"].toString() + '","search":"' +
                            search.trim() + '","jwtToken":"' + str.toString() + '"}';

                        try
                        {

                          // String url = 'https://cop4331-7.herokuapp.com/api/searchcards';
                          String url = 'http://10.0.2.2:5000/api/searchcards';
                          String ret = await CardsData.getJson(url, payload);
                          print(ret);
                          // jsonObject = json.decode(ret);
                          res = jsonDecode(ret)["results"];
                          print(res);


                        }
                        catch(e)
                        {
                          newSearchMessage = e.toString();
                          // newSearchMessage = "Search went wrong";
                          changeSearchText();
                          return;
                        }
                        // var results= jsonObject["results"];
                        List<String> exercises = List.from(res);
                        int i = 0;

                        for(String ex in exercises) {
                          String testString = '{"ExerciseName": "' + ex+ '"}';
                          // print(testString);
                          Exercise e = Exercise.fromJson(jsonDecode(testString));
                          print(e);
                          newExerciseList.add(e);
                        }
                        // while( true )
                        // {
                        //   try
                        //   {
                        //     // newSearchMessage += results[i];
                        //     // newSearchMessage += "\n";
                        //     // i++;
                        //     // print(exercises[i]);
                        //
                        //     String testString = '{"ExerciseName": "' + exercises[i] + '"}';
                        //     // print(testString);
                        //     Exercise e = Exercise.fromJson(jsonDecode(testString));
                        //     print(e);
                        //     newExerciseList.add(e);
                        //     // print(res[i]);
                        //     i++;
                        //   }
                        //   catch(e)
                        //   {
                        //     print(e.toString());
                        //     break;
                        //   }
                        // }

                        changeExerciseList();
                      },
                      color:Colors.brown[50],
                      textColor: Colors.black,
                      padding: EdgeInsets.all(2.0),
                      splashColor: Colors.grey[100]
                  )
                ]
            ),
            // Row(
            //     children: <Widget>[
            //       Column(
            //         children: <Widget>[
            //           Container(
            //             width: 200,
            //             child:
            //             TextField (
            //               obscureText: true,
            //               decoration: InputDecoration(
            //                   filled: true,
            //                   fillColor: Colors.white,
            //                   border: OutlineInputBorder(),
            //                   labelText: 'Add',
            //                   hintText: 'Add a Card'
            //               ),
            //               onChanged: (text)
            //               {
            //                 card = text;
            //               },
            //             ),
            //           ),
            //           Row(
            //             children: <Widget>[
            //               Text('$addMessage',style: TextStyle(fontSize: 14 ,color:Colors.black)),
            //             ],
            //           ),
            //         ],
            //       ),
            //       RaisedButton(
            //           child: Text('Add',style: TextStyle(fontSize: 14 ,color:Colors.black)),
            //           onPressed: () {},
            //           // onPressed: () async
            //           // {
            //           //   newAddMessage = "";
            //           //   changeAddText();
            //           //   String payload = '{"userId":"' + GlobalData.userId.toString() + '","card":"' +
            //           //       card.trim() + '"}';
            //           //   var jsonObject;
            //           //   try
            //           //   {
            //           //     String url = 'https://cop4331-10.herokuapp.com/api/addcard';
            //           //     String ret = await CardsData.getJson(url, payload);
            //           //     jsonObject = json.decode(ret);
            //           //   }
            //           //   catch(e)
            //           //   {
            //           //     // newAddMessage = "Add went wrong";
            //           //     newAddMessage = e.toString();
            //           //     changeAddText();
            //           //     return;
            //           //   }
            //           //   newAddMessage = "Card has been added";
            //           //   changeAddText();
            //           // },
            //           color:Colors.brown[50],
            //           textColor: Colors.black,
            //           padding: EdgeInsets.all(2.0),
            //           splashColor: Colors.grey[100]
            //       )
            //     ]
            // ),
            Row(
              children: <Widget>[
                Text('$message',style: TextStyle(fontSize: 14 ,color:Colors.black)),
              ],
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                    child: Text('Logout',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                    onPressed: ()
                    {
                      storage.write(key: "jwt", value: "");
                      Navigator.pushNamed(context, '/login');
                    },
                    color:Colors.brown[50],
                    textColor: Colors.black,
                    padding: EdgeInsets.all(2.0),
                    splashColor: Colors.grey[100]
                )
              ],
            )
          ],
        )
    );
  }
}