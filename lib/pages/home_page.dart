import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:mapty_app/data/app_class.dart';
import 'package:mapty_app/theme/custum_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppClass appClass = AppClass();
  MapController mapController = MapController();
  Location currLocation = Location();

  Map<String, double> locationCoords = {};
  LocationData? locationData;

  List markers = [];
  final myFormKey = GlobalKey();

  bool isClicked = false;

  void getPostion() async {
    // GETTING THE CURRENT LOCATION --------------------------
    // -------------------------------------------------------
    try {
      locationData = await currLocation.getLocation();
      setState(() {
        locationCoords['latitude'] = locationData!.latitude ?? 0;
        locationCoords['longitude'] = locationData!.longitude ?? 0;

        mapController.move(
          LatLng(locationCoords['latitude']!, locationCoords['longitude']!),
          14,
        );
      });
    } catch (e) {
      debugPrint('Error: Failed to load coords');
    }
  }

  void addMarker(double latitude, double longitude) {
    setState(() {
      markers.add(
        Marker(
          point: LatLng(latitude, longitude),
          child: Icon(Icons.location_on, color: brandSecondary),
        ),
      );
    });
  }

  void showForm() {
    setState(() {
      isClicked = true;

      if (isClicked) {
        debugPrint("clicked");
      } else {
        debugPrint("Uncliked");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // ----------------------------------------------------------------
    // ----------------------------------------------------------------
    appClass.setPermission();

    // ----------------------------------------------------------------
    // ----------------------------------------------------------------
    getPostion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            appClass.loadMap(
              mapController,
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      locationCoords['latitude'] ?? 0,
                      locationCoords['longitude'] ?? 0,
                    ),
                    width: 80,
                    height: 80,
                    child: Icon(
                      Icons.location_on,
                      size: 40,
                      color: brandSecondary,
                    ),
                  ),
                ],
              ),
              showForm,
            ),

            // MyForm --------------------------------------------
            // -------------------------------------------------
            if (isClicked) ...[MyForm(myKey: myFormKey)],

            Positioned(
              bottom: 100,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    mapController.move(
                      LatLng(
                        locationCoords['latitude'] ?? 0,
                        locationCoords['longitude'] ?? 0,
                      ),
                      18,
                    );
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: darkPrimary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Icon(Icons.location_searching, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key, required this.myKey});
  final GlobalKey myKey;

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String dropBtnValue = '';
  final List<String> dropBtnItems = ['Running', 'Cycling'];

  TextEditingController contDistance = TextEditingController();
  TextEditingController contDuration = TextEditingController();
  TextEditingController contCadence = TextEditingController();
  TextEditingController contElevation = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.myKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: darkSecondary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            'Type',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 25),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            width: 60,
                            child: DropdownButton<String>(
                              focusColor: Colors.redAccent,
                              dropdownColor: brandSecondary,

                              borderRadius: BorderRadius.circular(5),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              hint: Text(
                                dropBtnValue,
                                style: TextStyle(color: brandSecondary),
                                textAlign: TextAlign.center,
                              ),
                              items:
                                  dropBtnItems.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value.toUpperCase()),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropBtnValue = value!;
                                  print(dropBtnValue);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Duration",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(width: 10),
                        TextInputStyle(
                          hintText: "min",
                          controller: contDuration,

                          validator: (value) {
                            var el = int.parse(value);
                            if (el.isFinite) {
                              return "Entrer la cadence";
                            } else if (el < 0) {
                              return 'Entrez un nombre positif';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 11),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Distance",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(width: 15),
                        TextInputStyle(
                          hintText: "km",
                          controller: contDistance,
                          validator: (value) {
                            var el = int.parse(value);
                            if (el.isFinite) {
                              return "Entrer la cadence";
                            } else if (el < 0) {
                              return 'Entrez un nombre positif';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // CADENCE -------------------
                    if (dropBtnValue == "Running" || dropBtnValue == "") ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Cadence",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(width: 15),
                          TextInputStyle(
                            hintText: "step/min",
                            controller: contCadence,
                            validator: (value) {
                              var el = int.parse(value);
                              if (el.isFinite) {
                                return "Entrer la cadence";
                              } else if (el < 0) {
                                return 'Entrez un nombre positif';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Elv Gain",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(width: 20),
                          TextInputStyle(
                            hintText: "meters",
                            controller: contElevation,
                            validator: (value) {
                              var el = int.parse(value);
                              if (el.isFinite) {
                                return "Entrer la cadence";
                              } else if (el < 0) {
                                return 'Entrez un nombre positif';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ],

                    // VITESSE -------------------
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextInputStyle extends StatelessWidget {
  const TextInputStyle({
    super.key,
    required this.hintText,
    required this.validator,
    required this.controller,
  });
  final String hintText;
  final FormFieldValidator validator;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
      ),
      width: 84,
      height: 30,
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
          hintText: hintText,
          // label: Text('km'),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
