import 'package:flutter/material.dart';

import '../services/app_localizations-service.dart';

class MyCustomAlert extends StatelessWidget {
  final titleText;
  final bodyText;
  final Function onPressApply;
  final applyText;

  const MyCustomAlert(
      {@required this.titleText,
      @required this.bodyText,
      @required this.onPressApply,
      this.applyText});

  @override
  Widget build(BuildContext context) {
    translate(String text) {
      return Localizations.of<AppLocalizationsService>(
                  context, AppLocalizationsService)
              .getTranslation(text) ??
          '<translate error: $text>';
    }

    return AlertDialog(
      title: Text(titleText),
      content: Text(bodyText),
      actions: <Widget>[
        FlatButton(
          child: Text(translate('close')),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(applyText ?? translate('settings')),
          onPressed: onPressApply,
        ),
      ],
    );
  }
}
