import 'package:floor/floor.dart';

@entity
class Location {
  @PrimaryKey(autoGenerate: true)
  int id;

  String name;
  String description;
  String latitude;
  String longitude;
  String lastVisit;
  String categoryColour;
  String photo;

  Location(
      {this.id,
      this.name,
      this.description,
      this.latitude,
      this.longitude,
      this.lastVisit,
      this.categoryColour,
      this.photo});

  @override
  String toString() {
    return 'Location{latitude: $latitude, longitude: $longitude, name: $name}';
  }
}
