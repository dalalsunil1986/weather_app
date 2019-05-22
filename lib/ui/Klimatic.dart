import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:weather_app/ui/util/utils.dart' as util;
import 'package:http/http.dart' as http;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  void showApi() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  final TextEditingController _WeatherController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    TimeOfDay _time = TimeOfDay.now();

    return Scaffold(
      appBar: AppBar(
        title: Text("Weather zaki"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Settings'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            TextField(
              controller: _WeatherController,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                  labelText: 'enter City Name',
                  icon: new Icon(Icons.location_city)),
            ),
            IconButton(
              icon: Icon(Icons.subdirectory_arrow_right),
              iconSize: 70.0,
              color: Colors.blue,
              onPressed: () => handelpress(),
            )
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          backgroundpic(_time),
          Container(
            child: updateTempWidget(util.defaultCity),
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(110.0, 31.0, 0, 0),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(0, 95, 0, 0),
            child: UpdateIcon(util.defaultCity),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(0, 140, 0, 0),
            child: Text(
              util.defaultCity,
              style: TextStyle(
                  fontSize: 40.0, color: Colors.black, fontFamily: "Armadillo"),
            ),
          ),
        ],
      ),
    );
  }

  void handelpress() {
    setState(() {
      util.defaultCity = _WeatherController.text;
    });
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&APPID=${util.appId}&units=metric";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
        future: getWeather(util.appId, city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            if ((content["cod"] != 404)) {
              return Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                        title: Text(
                      "${content["main"]["temp"].toString()}°C",
                      style: TextStyle(
                          fontSize: 65,
                          color: Colors.black,
                          fontFamily: "Armadillo"),
                    ))
                  ],
                ),
              );
            }
          } else
            return Container(
                child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ));
        });
  }

  Widget UpdateIcon(String city) {
    return FutureBuilder(
        future: getWeather(util.appId, city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            if ((content["cod"] != 404)) {
              return Container(
                  child: Text(
                content["weather"][0]["main"].toString(),
                style: TextStyle(
                  fontFamily: "Armadillo",
                  fontSize: 45,
                  color: Colors.black,
                ),
              ));
            }
          } else {
            return Container(
                child:
                    CircularProgressIndicator(backgroundColor: Colors.black));
          }
        });
  }
}

Widget backgroundpic(TimeOfDay time) {
  TimeOfDay day = TimeOfDay(hour: 17, minute: 00);
  TimeOfDay sunset = TimeOfDay(hour: 20, minute: 00);

  if (time.hour < day.hour) {
    return Center(
      child: Image.asset(
        "assets/greenday.png",
        fit: BoxFit.fitHeight,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  } else if (time.hour < sunset.hour) {
    return Center(
      child: Image.asset(
        "assets/sunset.png",
        fit: BoxFit.fitHeight,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  } else {
    return Center(
      child: Image.asset(
        "assets/night.png",
        fit: BoxFit.fitHeight,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}

TextStyle cityStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 35.0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    shadows: [
      Shadow(
          // bottomLeft
          offset: Offset(-1.5, -1.5),
          color: Colors.black),
      Shadow(
          // bottomRight
          offset: Offset(1.5, -1.5),
          color: Colors.black),
      Shadow(
          // topRight
          offset: Offset(1.5, 1.5),
          color: Colors.black),
      Shadow(
          // topLeft
          offset: Offset(-1.5, 1.5),
          color: Colors.black),
    ],
  );
}

TextStyle weatherText() {
  return TextStyle(
    color: Colors.white,
    fontSize: 35.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    shadows: [
      Shadow(
          // bottomLeft
          offset: Offset(-1.5, -1.5),
          color: Colors.black),
      Shadow(
          // bottomRight
          offset: Offset(1.5, -1.5),
          color: Colors.black),
      Shadow(
          // topRight
          offset: Offset(1.5, 1.5),
          color: Colors.black),
      Shadow(
          // topLeft
          offset: Offset(-1.5, 1.5),
          color: Colors.black),
    ],
  );
}
