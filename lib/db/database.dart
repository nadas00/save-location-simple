import 'dart:async';

import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:save_location/db/dao/LocationDao.dart';
import 'package:save_location/model/location.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Location])
abstract class LocationDatabase extends FloorDatabase {
  LocationDao get locationDao;
}
