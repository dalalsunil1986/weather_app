import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/ui/util/utils.dart' as util;

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
      drawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: sideNav()),
      body: Stack(
        children: <Widget>[
          backgroundpic(_time),
          AppBar(
            backgroundColor: Colors.transparent,
          ),
          Container(
            child: updateTempWidget(util.defaultCity),
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(95.0, 31.0, 0, 0),
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

  Drawer sideNav() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Settings',
              style: TextStyle(
                  color: Colors.white, fontFamily: "Armadillo", fontSize: 50.0),
            ),
          ),
          TextField(
            controller: _WeatherController,
            keyboardType: TextInputType.text,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: new InputDecoration(

                labelText: 'enter City Name',
                fillColor: Colors.white,
                icon: new Icon(Icons.location_city)),
          ),
          IconButton(
            icon: Icon(Icons.subdirectory_arrow_right),
            iconSize: 70.0,
            color: Colors.white,
            onPressed: () => handelpress(),
          )
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
