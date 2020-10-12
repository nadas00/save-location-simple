import 'package:flutter/material.dart';

class MyCustomAlert extends StatelessWidget {
  final titleText;
  final bodyText;
  final Function onPressApply;

  const MyCustomAlert(
      {@required this.titleText,
        @required this.bodyText,
        @required this.onPressApply});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: Text(bodyText),
      actions: <Widget>[
        FlatButton(
          child: Text('Kapat'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Ayarlar'),
          onPressed: onPressApply,
        ),
      ],
    );
  }
}
