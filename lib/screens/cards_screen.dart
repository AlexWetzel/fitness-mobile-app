import 'package:flutter/material.dart';
import 'package:fitness_mobile_app/main.dart';
import 'package:fitness_mobile_app/utils/get_api.dart';
import 'package:fitness_mobile_app/screens/login_screen.dart';
import 'dart:convert';

class Exercise {
  String name = "";

  Exercise(this.name);

  factory Exercise.fromJson(dynamic json) {
    return Exercise(json["ExerciseName"] as String);
  }

  @override
  String toString() {
    return '{ $name }';
  }
}

class StrengthExercise {
  String name = "";
  int lowerRep = 0, upperRep = 0, weight = 0;

  StrengthExercise(this.name, this.lowerRep, this.upperRep, this.weight);

  factory StrengthExercise.fromJson(dynamic json) {
    return StrengthExercise(
        json["ExerciseName"] as String,
        json["LowerRepRange"] as int,
        json["UpperRepRange"] as int,
        json["StrengthWeight"] as int);
  }

  @override
  String toString() {
    return 'Strength exercise: $name\n Lower Rep Range: $lowerRep\n Upper Rep Range: $upperRep\n Weight: $weight lb';
  }
}

class CardioExercise {
  String name = "";
  int cardioTime = 0;

  CardioExercise(this.name, this.cardioTime);

  factory CardioExercise.fromJson(dynamic json) {
    return CardioExercise(
        json["ExerciseName"] as String, json["CardioTime"] as int);
  }

  @override
  String toString() {
    return 'Cardio exercise: $name\n Cardio Time: $cardioTime min';
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
  var strengthList = <StrengthExercise>[],
      newStrengthList = <StrengthExercise>[];
  var cardioList = <CardioExercise>[], newCardioList = <CardioExercise>[];
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
      cardioList = newCardioList;
      strengthList = newStrengthList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    storage.write(key: "jwt", value: "");
                    Navigator.pushNamed(context, '/login');
                  },
                  icon: const Icon(Icons.logout_rounded),
                ),
              ],
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    text: 'Search',
                  ),
                  Tab(
                    text: 'Strength',
                  ),
                  Tab(
                    text: 'Cardio',
                  )
                ],
              ),
              title: const Text('Exercise List'),
            ),
            body: TabBarView(
              children: <Widget>[
                Column(children: [
                  TextField(
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                        hintText: 'Search for a Card'),
                    onChanged: (text) {
                      search = text;
                    },
                  ),
                  RaisedButton(
                      child: const Text('Search',
                          style: TextStyle(fontSize: 14, color: Colors.black)),
                      onPressed: () async {
                        newSearchMessage = "";
                        newExerciseList = [];
                        newStrengthList = [];
                        newCardioList = [];
                        changeSearchText();

                        var str = await storage.read(key: 'jwt');
                        var jwt = str.toString().split(".");
                        var jsonObject = json.decode(ascii
                            .decode(base64.decode(base64.normalize(jwt[1]))));
                        var res;
                        String payload = '{"userId":"' +
                            jsonObject["userId"].toString() +
                            '","search":"' +
                            search.trim() +
                            '","jwtToken":"' +
                            str.toString() +
                            '"}';

                        try {
                          // String url = 'https://cop4331-7.herokuapp.com/api/searchcards';
                          String url = 'http://10.0.2.2:5000/api/searchcards';
                          String ret = await CardsData.getJson(url, payload);
                          print(ret);
                          // jsonObject = json.decode(ret);
                          res = jsonDecode(ret)["results"] as List;
                          print(res);
                        } catch (e) {
                          newSearchMessage = e.toString();
                          // newSearchMessage = "Search went wrong";
                          changeSearchText();
                          return;
                        }
                        // var results= jsonObject["results"];
                        // List<String> exercises = List.from(res);

                        int i = 0;

                        for (var ex in res) {
                          // String testString = '{"ExerciseName": "' + ex + '"}';
                          // print(testString);
                          print(ex);

                          if (ex["CardioTime"] == null) {
                            // Strength
                            for (int i = 0; i < 5; i++) {
                              newStrengthList
                                  .add(StrengthExercise.fromJson(ex));
                            }
                          } else {
                            // Cardio
                            for (int i = 0; i < 5; i++) {
                              newCardioList.add(CardioExercise.fromJson(ex));
                            }
                          }
                          Exercise e = Exercise.fromJson(ex);
                          // print(e);
                          newExerciseList.add(e);
                        }
                        changeExerciseList();
                      },
                      color: Colors.grey[20],
                      textColor: Colors.black,
                      padding: EdgeInsets.all(2.0),
                      splashColor: Colors.grey[100]
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        // shrinkWrap: true,
                        itemCount: exerciseList.length,
                        itemBuilder: (context, i) {
                          return Card(
                              child: ListTile(
                            title: Text(exerciseList[i].name),
                          ));
                        }),
                  ),
                ]),
                Column(children: [
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        // shrinkWrap: true,
                        itemCount: strengthList.length,
                        itemBuilder: (context, i) {
                          return Card(
                              child: ListTile(
                            title: Text(strengthList[i].name),
                            subtitle: Text(
                                "Rep Range: ${strengthList[i].lowerRep}-${strengthList[i].upperRep}\nWeight: ${strengthList[i].weight} "),
                          ));
                        }),
                  )
                ]),
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          // shrinkWrap: true,
                          itemCount: cardioList.length,
                          itemBuilder: (context, i) {
                            return Card(
                                child: ListTile(
                              title: Text(cardioList[i].name),
                              subtitle: Text(
                                  "Cardio time: ${cardioList[i].cardioTime}"),
                            ));
                          }),
                    ),
                  ],
                ),
              ],
            )));
  }
}
