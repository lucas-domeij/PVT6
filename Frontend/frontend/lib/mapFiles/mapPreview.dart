import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/friendsAndContacts/addContactPage.dart';
import 'package:frontend/routePickerMap/Route.dart';
import 'package:geojson/geojson.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:user_location/user_location.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/userFiles/user.dart' as userlib;
import 'dart:convert';

import 'mapWithRoute.dart';

List<SavedRoute> savedRoutes = [];

class _MapPreviewPageState extends State<MapPreviewPage> {
  Location location;
  LatLng userLocation;

  static LatLng latLng = LatLng(59.338738, 18.064034);
  String kmString = "0";
  String routeTimeString = "0";
  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;
  UserLocationOptions userLocationOptions;
  List<Marker> markers = [];

  String routesData = "";

  var points = <LatLng>[];
  void loadData() async {}

  @override
  void initState() {
    location = new Location();

    getLocation();
    getSavedRoutes();

    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);
    statefulMapController.onReady.then((_) => loadData());

    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: markers,
      onLocationUpdate: (LatLng pos) => userLocation = pos,
      updateMapLocationOnPositionChange: false,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: Stack(children: <Widget>[
        FlutterMap(
          mapController: mapController,
          options: new MapOptions(
            center: LatLng(latLng.latitude, latLng.longitude),
            minZoom: 14,
            plugins: [
              // ADD THIS
              UserLocationPlugin(),
            ],
          ),
          layers: [
            new TileLayerOptions(
                urlTemplate: FlutterConfig.get('MAPBOXAPI_URL'),
                additionalOptions: {
                  'accessToken': FlutterConfig.get('MAPBOX_ID'),
                  'id': 'Streets-copy'
                }),
            MarkerLayerOptions(markers: markers),
            // ADD THIS

            new PolylineLayerOptions(polylines: [
              new Polyline(
                points: points,
                color: Colors.blue,
                strokeWidth: 4.0,
              )
            ]),

            userLocationOptions,
          ],
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      color: colorPeachPink,
                      onPressed: () {},
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.dice,
                            color: colorPurple,
                          ),
                          Text("Generate Route",
                              style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FlatButton(
                      color: colorPeachPink,
                      onPressed: () {},
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.save,
                            color: colorPurple,
                          ),
                          Text("Save", style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FlatButton(
                      color: colorPeachPink,
                      onPressed: () {},
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.play_arrow,
                            color: colorPurple,
                          ),
                          Text("Start route", style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
            child: Card(
               shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
                elevation: 20,
                child: Container(
                  width: 205,
                  height: 45,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text("Distance",
                                  style:
                                      TextStyle(color: Colors.grey.shade500)),
                              Text(" $kmString" + "km",
                                  style: new TextStyle(fontSize: 20)),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text("Estimated Time ",
                                  style:
                                      TextStyle(color: Colors.grey.shade500)),
                              Text("$routeTimeString",
                                  style: new TextStyle(fontSize: 20)),
                            ],
                          ),
                        ],
                      )),
                ))),
        // ...
      ])),
      appBar: AppBar(
        title: const Text('Route Preview'),
        backgroundColor: colorPurple,
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Text('Saved Routes'),
              onPressed: () {
                showSavedRoutes(context);
              },
            ),
            IconButton(
              icon: Text('Save Route'),
              onPressed: () {
                saveRoute(context, points);
              },
            ),
            IconButton(
              icon: Text('Generate Route'),
              onPressed: () async {
                //sätt error dialog här om inget har sätts in i route
                getKm(context);
                mapController.move(
                    LatLng(latLng.latitude, latLng.longitude), 1);
              },
            ),
            IconButton(
              icon: Text('Start Route'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapWithRoute(
                        points: points,
                        latLng: latLng,
                      ),
                    ));
              },
            ), //Skickar med rutt datan till en ny karta.
          ],
        ),
      ),
    );
  }

  getLocation() async {
    var location = new Location();
    location.onLocationChanged().listen((currentLocation) {
      print(currentLocation.latitude);
      print(currentLocation.longitude);
      setState(() {
        latLng = LatLng(currentLocation.latitude, currentLocation.longitude);
      });

      print("getLocation:$latLng");
    });
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Dialoger

  saveRoute(BuildContext context, var points) {
    var savePoints = points;
    String name = "";
    showDialog(
      context: context,
      builder: (context) {
        String contentText = "Content of Dialog";
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Save Route"),
              content: Row(
                children: <Widget>[
                  SizedBox(
                    width: 200.0,
                    height: 300.0,
                    child: TextField(
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                      decoration: new InputDecoration(
                        labelText: "Input a name",
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black)),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Cancel"),
                ),
                FlatButton(
                  onPressed: () async {
                    if (routesData != "") {
                      print(routesData);

                      final response = await http.post(
                          Uri.parse(
                              "https://group6-15.pvt.dsv.su.se/route/saveRoute"),
                          encoding: Encoding.getByName("utf-8"),
                          body: {
                            'name': name,
                            'route': routesData,
                            'uid': userlib.uid,
                            'distans': kmString.toString()
                          });
                      print(response.body);
                      if (response.statusCode == 200) {
                        showSaveAlertDialog(context);
                        //Navigator.pop(context);

                      }
                    } else {
                      showFailAlertDialog(context);
                    }
                  },
                  child: Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  getKm(BuildContext context) {
    TextEditingController kmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        String contentText = "Content of Dialog";
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Generate a route"),
              content: Row(
                children: <Widget>[
                  SizedBox(
                    width: 200.0,
                    height: 300.0,
                    child: TextField(
                      controller: kmController,
                      decoration: new InputDecoration(
                        labelText: "How long?",
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black)),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ], // Only numbers c
                    ),
                  ),
                  SizedBox(
                    width: 60.0,
                    height: 300.0,
                    child: Text('km'),
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context, "-1"),
                  child: Text("Cancel"),
                ),
                FlatButton(
                  onPressed: () {
                    kmString = kmController.text.toString();
                    Navigator.pop(context);
                    generateRoute(LatLng(latLng.latitude, latLng.longitude));
                  },
                  child: Text("Generate"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  showSavedRoutes(BuildContext context) {
    TextEditingController editingController = TextEditingController();
    print(savedRoutes[1].id);
    List<String> litems = [savedRoutes[0].name, "Fisken", "Be", "Lloo", "Adde"];
    List<int> km = [200, 20, 23, 12, 22];
    String selectedRoute = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Saved routes"),
              content: Row(
                children: <Widget>[
                  SizedBox(
                    height: 400,
                    width: 200,
                    child: new ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: litems.length,
                        itemBuilder: (BuildContext context, int index) {
                          String c = litems?.elementAt(index);
                          return GestureDetector(
                              onTap: () async {
                                setState() {
                                  selectedRoute = c;
                                }

                                return showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('${litems[index]}'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('Close'),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              litems.removeAt(index);
                                              print(litems.length);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              showSavedRoutes(context);
                                            },
                                            child: Text('Delete'),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Open'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                  height: 75,
                                  margin: EdgeInsets.all(2),
                                  color: Colors.blue,
                                  child: Center(
                                    child: Text(
                                        '${litems[index]} ${km[index]} Km'),
                                  )));
                        }),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  showFailAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("No Route"),
      content: Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showSaveAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Saved"),
      content: Text("Your Route was saved"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void generateRoute(LatLng pos) async {
    print("GENERATING ROUTE");
    var km = int.parse(kmString);
    points.clear();
    var Postion = latLng;
    final data = await http.get(
        "https://group6-15.pvt.dsv.su.se/route/new?posX=${pos.latitude}&posY=${pos.longitude}&distans=${km}");

    var jsonfile = json.decode(data.body);
    routesData = "";

    routesData += jsonfile["waypoints"][0]["location"].join(', ') + "/";
    routesData += jsonfile["waypoints"][1]["location"].join(', ') + "/";
    routesData += jsonfile["waypoints"][2]["location"].join(', ') + "";

    print(routesData);
    var routedata = jsonfile['routes'][0];
    var route = routedata["geometry"]["coordinates"];
    kmString = (routedata["distance"] / 1000).toStringAsFixed(2);
    var estimatedTime = (routedata["duration"] / 3600)
        .toStringAsFixed(2)
        .toString(); // MAN KAN ÄNDRA GÅNGHASTIGHET FÖR ATT FÅ MER ACCURATE
    routeTimeString = estimatedTime;
    for (var i = 0; i < route.length; i++) {
      points.add(new LatLng(route[i][1], route[i][0]));
    }
    print(points);
  }
}

void getSavedRoutes() async {
  final response = await http.get(
      "https://group6-15.pvt.dsv.su.se/route/getSavedRoutes?uid=${userlib.uid}");
  if (response.statusCode == 200) {
    savedRoutes = (json.decode(response.body) as List)
        .map((i) => SavedRoute.fromJson(i))
        .toList();
  } else {
    // ERROR HÄR
  }
}

class MapPreviewPage extends StatefulWidget {
  @override
  var km;
  MapPreviewPage({Key key, this.km}) : super(key: key);
  _MapPreviewPageState createState() => _MapPreviewPageState();
}