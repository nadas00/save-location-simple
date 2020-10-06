import 'package:floor/floor.dart';
import 'package:save_location/model/location.dart';

@dao
abstract class LocationDao {
  @Query('SELECT * FROM location WHERE id = :id')
  Future<Location> findLocationById(int id);

  @Query('SELECT * FROM location WHERE categoryColour = :color')
  Future<Location> findLocationByColor(String color);

  @Query('SELECT * FROM location')
  Future<List<Location>> findAllLocations();

  @Query('SELECT * FROM location')
  Stream<List<Location>> findAllLocationsAsStream();

  @insert
  Future<void> insertLocation(Location location);

  @update
  Future<void> updateLocation(Location location);

  @delete
  Future<void> deleteLocation(Location location);

  @delete
  Future<void> deleteLocations(Location location);
}
