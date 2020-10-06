import 'package:flutter/material.dart';
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
                  TextFormField(
                    decoration: InputDecoration(
                      hoverColor: Colors.blueAccent,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      labelText: 'Enter input (lat)',
                      fillColor: Colors.blueAccent,
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: 'Lat',
                    ),
                    onSaved: (input) => _lat = input,
                  ),
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
                      labelText: 'Enter input (long)',
                      fillColor: Colors.blueAccent,
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: 'Long',
                    ),
                    onSaved: (input) => _long = input,
                  ),
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
                      labelText: 'Enter input (name)',
                      fillColor: Colors.blueAccent,
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: 'Name',
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
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                formKey.currentState.save();
                String lat = _lat;
                String long = _long;
                String name = _name;
                print(listLocation);

                var newLocation =
                    Location(latitude: lat, longitude: long, name: name);
                locationDao.insertLocation(newLocation);
                formKey.currentState.reset();
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
