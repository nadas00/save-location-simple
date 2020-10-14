import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as pH;
import 'package:save_location/services/advert-service.dart';
import 'package:save_location/services/app_localizations-service.dart';
import 'package:save_location/db/dao/LocationDao.dart';
import 'package:save_location/db/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:convert';

import '../components/reusable_alert_dialog.dart';
import '../model/location.dart';

class HomeScreen extends StatefulWidget {
  final LocationDao locationDao;

  HomeScreen(this.locationDao);

  @override
  _HomeScreenState createState() => _HomeScreenState(locationDao);
}

class _HomeScreenState extends State<HomeScreen> {
  final AdvertService _advertService = AdvertService();
  String _lat;
  String _long;
  String _name;
  Location location;
  List<Location> listLocation;

  final formKey = GlobalKey<FormState>();

  LocationDatabase locationDatabase;
  LocationDao locationDao;

  _HomeScreenState(this.locationDao);

  var encodedPhoto;

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

  getPhotoFromSource(ImageSource imageSource) async {
    var picture = await picker.getImage(source: imageSource);
    if (picture != null) {
      imageFile = File(picture.path);
      final bytes = await File(imageFile.path).readAsBytes();
      String base64Photo = base64.encode(bytes);
      this.setState(() {
        encodedPhoto = base64Photo;
      });
    }
    Navigator.of(context).pop();
  }

  savingOperations() async {
    if (await pH.Permission.locationWhenInUse.serviceStatus.isEnabled) {
      if (await pH.Permission.location.request().isGranted) {
        await getPosition();
        formKey.currentState.save();
        String lat = _lat ?? translate('location undefined');
        String long = _long ?? translate('location undefined');
        if (_name.isEmpty) {
          _name = translate('undefined location');
        }
        String name = _name;

        if (imageFile != null) {
          var newLocation = Location(
              latitude: lat, longitude: long, name: name, photo: encodedPhoto);
          locationDao.insertLocation(newLocation);
          formKey.currentState.reset();
        } else {
          var newLocation =
              Location(latitude: lat, longitude: long, name: name);
          locationDao.insertLocation(newLocation);
          formKey.currentState.reset();
        }
      } else {
        final titleText = translate("location permission titleText");
        final bodyText = translate("location permission bodyText");
        askLocationPermission() {
          AppSettings.openAppSettings();
          Navigator.of(context).pop();
        }

        var locationPermissionDisabledError = MyCustomAlert(
          onPressApply: askLocationPermission,
          titleText: titleText,
          bodyText: bodyText,
        );
        showDialog(
            context: context,
            builder: (BuildContext context) => locationPermissionDisabledError);
      }
    } else {
      final titleText = translate('location service titleText');
      final bodyText = translate('location service bodyText');
      askLocationService() {
        AppSettings.openLocationSettings();
        Navigator.of(context).pop();
      }

      var locationServiceDisabledError = MyCustomAlert(
          titleText: titleText,
          bodyText: bodyText,
          onPressApply: askLocationService);
      showDialog(
          context: context,
          builder: (BuildContext context) => locationServiceDisabledError);
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              translate('selection'),
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: RaisedButton.icon(
                      disabledColor: Colors.blue,
                      label: Text(translate('from gallery')),
                      icon: Icon(Icons.add_photo_alternate_outlined),
                    ),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: RaisedButton.icon(
                      disabledColor: Colors.blue,
                      label: Text(translate('take a photo')),
                      icon: Icon(Icons.camera_alt_outlined),
                    ),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  File imageFile;
  final picker = ImagePicker();


  _openGallery(BuildContext context) async {
    pH.Permission _permission;

    if (Platform.isIOS) {
      _permission = pH.Permission.photos;
    } else if (Platform.isAndroid) {
      _permission = pH.Permission.accessMediaLocation;
    }
    if (await _permission.request().isGranted) {
      await getPhotoFromSource(ImageSource.gallery);
    } else {
      final titleText = translate('media permission titleText');
      final bodyText = translate('media permission bodyText');
      askMediaLocationPermission() {
        AppSettings.openAppSettings();
        Navigator.of(context).pop();
      }

      var mediaLocationPermissionDisabledError = MyCustomAlert(
          titleText: titleText,
          bodyText: bodyText,
          onPressApply: askMediaLocationPermission);
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              mediaLocationPermissionDisabledError);
    }
  }

  _openCamera(BuildContext context) async {
    if (await pH.Permission.camera.request().isGranted) {
      getPhotoFromSource(ImageSource.camera);
    } else {
      final titleText = translate('media permission titleText');
      final bodyText = translate('media permission bodyText');
      askMediaLocationPermission() {
        AppSettings.openAppSettings();
        Navigator.of(context).pop();
      }

      var mediaLocationPermissionDisabledError = MyCustomAlert(
          titleText: titleText,
          bodyText: bodyText,
          onPressApply: askMediaLocationPermission);
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              mediaLocationPermissionDisabledError);
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  translate(String text){
    return Localizations.of<AppLocalizationsService>(context, AppLocalizationsService).getTranslation(text) ?? '<translate error: $text>';
  }

  Widget _imagePlaceholder() {
    if (imageFile == null) {
      return Text(translate('no image'));
    } else {
      return Column(
        children: [
          Image.file(imageFile,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 5),
          Text(
            translate('double tap to delete image'),
            style: TextStyle(color: Colors.blueGrey),
          )
        ],
      );
    }
  }

  Widget _leadingImage(List<Location> locations, int index) {
    if (locations[index].photo != null) {
      return FractionallySizedBox(
          widthFactor: 0.2,
          heightFactor: 0.9,
          child: Image.memory(
            base64Decode(locations[index].photo),
          ));
    } else
      return FractionallySizedBox(
          widthFactor: 0.2, heightFactor: 0.9, child: Icon(Icons.map_outlined));
  }

  @override
  void initState() {
    super.initState();
    builder();
    _advertService.showIntersitial();
    _advertService.showBanner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(translate('save location simple')),
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
                      labelText: translate('location name'),
                      fillColor: Colors.blueAccent,
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: translate('enter location name'),
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
              setState(() {
                imageFile = null;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _imagePlaceholder(),
                  RaisedButton(
                      child: Text(translate('add picture'),
                          style: TextStyle(color: Colors.white)),
                      color: Colors.blue,
                      onPressed: () {
                        _showChoiceDialog(context);
                      }),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    child: Text(
                      translate('save'),
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      await savingOperations();
                      setState(() {
                        imageFile = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<Location>>(
              stream: locationDao.findAllLocationsAsStream(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) return Container();
                final locations = snapshot.data;
                return ListView.builder(
                  itemCount: locations.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      leading: _leadingImage(locations, index),
                      title: Text(locations[index].name),
                      subtitle: Text(locations[index].latitude +
                          ' ' +
                          locations[index].longitude),
                      onLongPress: () {
                        int id = locations[index].id;
                        var selectedLocation = Location(id: id);
                        locationDao.deleteLocation(selectedLocation);
                      },
                      onTap: () {
                        _advertService.showIntersitial();
                        var url =
                            'https://www.google.com/maps/dir/?api=1&destination=${locations[index].latitude},${locations[index].longitude}&travelmode=walking&dir_action=navigate';
                        _launchURL(url);
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Divider(color: Colors.blueAccent)),
          Padding(padding: EdgeInsets.only(bottom: 55.0))

        ],
      ),
    );
  }
}
