import 'package:flutter/material.dart';
import 'package:save_location/app_localizations.dart';
import 'package:save_location/db/dao/LocationDao.dart';
import 'package:save_location/db/database.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      supportedLocales: [Locale('en', ''), Locale('tr', '')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocaleList) {
        for(var deviceLanguage in supportedLocaleList){
          if(deviceLanguage.languageCode == locale.languageCode){
            return locale;
          }
        }
        return supportedLocaleList.first;
      },
      debugShowCheckedModeBanner: false,
      home: HomeScreen(locationDao),
    );
  }
}
