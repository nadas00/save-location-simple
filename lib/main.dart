import 'package:flutter/material.dart';
import 'package:save_location/db/dao/LocationDao.dart';
import 'package:save_location/db/database.dart';

import 'homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final locationDatabase =
      await $FloorLocationDatabase.databaseBuilder('location.db').build();

  final locationDao = locationDatabase.locationDao;
  runApp(SaveLocationSimple(locationDao));
}

class SaveLocationSimple extends StatelessWidget {
  final LocationDao locationDao;
  const SaveLocationSimple(this.locationDao);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(locationDao),
    );
  }
}
