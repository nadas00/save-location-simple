import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizationsService {
  Locale locale;

  static const LocalizationsDelegate<AppLocalizationsService> delegate = _AppLocalizationsDelegate();

  AppLocalizationsService(this.locale);

  Map<String, String> languageMap = Map();
  Future load() async {
    final fileString =
        await rootBundle.loadString('langs/${locale.languageCode}.json');
    final Map<String, dynamic> mapData = json.decode(fileString);
    languageMap = mapData.map((key, value) => MapEntry(key, value.toString()));
  }

  getTranslation(key) {
    return languageMap[key];
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizationsService>{
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en','tr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizationsService> load(Locale locale) async {
    AppLocalizationsService localizations = AppLocalizationsService(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizationsService> old) {
    return false;
  }

}