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
  double _lat;
  double _long;
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
    return Container();
  }
}
