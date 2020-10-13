import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  AppLocalizations(this.locale);

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

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations>{
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en','tr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }

}