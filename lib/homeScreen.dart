import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:save_location/db/dao/LocationDao.dart';
import 'package:save_location/db/database.dart';

import 'model/location.dart';

class HomeScreen extends StatefulWidget {
  final LocationDao locationDao;
  HomeScreen(this.locationDao);
  @override
  _HomeScreenState createState() => _HomeScreenState(locationDao);
}

class _HomeScreenState extends State<HomeScreen> {
  String _lat;
  String _long;
  String _name;
  Location location;
  List<Location> listLocation;

  final formKey = GlobalKey<FormState>();

  LocationDatabase locationDatabase;
  LocationDao locationDao;
  _HomeScreenState(this.locationDao);

  builder() async {
    locationDatabase =
        await $FloorLocationDatabase.databaseBuilder('location.db').build();
    setState(() {
      locationDao = locationDatabase.locationDao;
    });
  }

  getPosition() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String pLat = position.latitude.toString();
    String pLong = position.longitude.toString();
    _lat = pLat;
    _long = pLong;
  }

  @override
  void initState() {
    super.initState();
    builder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Location Simple'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hoverColor: Colors.blueAccent,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      labelText: 'Konum İsmi',
                      fillColor: Colors.blueAccent,
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: 'Konum ismi giriniz',
                    ),
                    onSaved: (input) => _name = input,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onDoubleTap: () {
              listLocation.removeLast();
            },
            child: RaisedButton(
              color: Colors.blueAccent,
              child: Text(
                'Kaydet',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                ServiceStatus serviceStatus =
                    await LocationPermissions().checkServiceStatus();
                PermissionStatus permissionStatus =
                    await LocationPermissions().checkPermissionStatus();

                if (serviceStatus != ServiceStatus.disabled) {
                  if (permissionStatus != PermissionStatus.denied) {
                    await getPosition();
                    formKey.currentState.save();
                    String lat = _lat ?? 'Konum belirlenemedi';
                    String long = _long ?? 'Konum belirlenemedi';
                    if (_name.isEmpty) {
                      _name = 'Tanımsız Konum';
                    }
                    String name = _name;

                    var newLocation =
                        Location(latitude: lat, longitude: long, name: name);
                    locationDao.insertLocation(newLocation);
                    formKey.currentState.reset();
                  } else {
                    var locationPermissionDisabledError = AlertDialog(
                      title: Text('Uygulama izinlerini düzenlemen gerekiyor!'),
                      content: Text(
                          'Bu özelliği kullanabilmek için konum izni gereklidir.'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Kapat'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text('Ayarlar'),
                          onPressed: () {
                            AppSettings.openLocationSettings();
                          },
                        ),
                      ],
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            locationPermissionDisabledError);
                  }
                } else {
                  var locationServiceDisabledError = AlertDialog(
                    title: Text('Konum ayarlarını düzenlemen gerekiyor!'),
                    content: Text(
                        'Bu özelliği kullanabilmek için konum servislerini açmanız gerekir.'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Kapat'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Ayarlar'),
                        onPressed: () {
                          AppSettings.openLocationSettings();
                        },
                      ),
                    ],
                  );
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          locationServiceDisabledError);
                }
              },
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<Location>>(
              stream: locationDao.findAllLocationsAsStream(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) return Container();
                final locations = snapshot.data;
                print(snapshot.data);
                return ListView.builder(
                  itemCount: locations.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: Text(locations[index].name),
                      subtitle: Text(locations[index].latitude +
                          ' ' +
                          locations[index].longitude),
                      onLongPress: () {
                        int id = locations[index].id;
                        var selectedLocation = Location(id: id);
                        print(locations[index].name);
                        locationDao.deleteLocation(selectedLocation);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
