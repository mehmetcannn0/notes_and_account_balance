// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'platform_duyarli_alert_dialog_widget.dart';

class PlatformDuyarliAlertDialog extends PlatformDuyarliAlertDialogWidget {
  final String baslik, icerik, anaButonYazisi, iptalButonYazisi;
  final icon;

  PlatformDuyarliAlertDialog(
      {@required this.baslik,
      @required this.icerik,
      @required this.anaButonYazisi,
      this.iptalButonYazisi,
      this.icon});
  Future<bool> goster(BuildContext context) async {
    /*7/11:58 */
    return //Platform.isIOS
        //     ? await showCupertinoDialog(
        //         context: context, builder: (context) => this)
        //     : await
        showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false

            ///////////barrierDismissible dısarı tıklayınca dıalog kapanmasın dıye
            );
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(baslik),
      content: Text(
        icerik,
        style: TextStyle(fontSize: 20),
      ),
      actions: _dialogButonlariAyarla(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(baslik),
      content: Text(
        icerik,
        style: TextStyle(fontSize: 20),
      ),
      actions: _dialogButonlariAyarla(context),
    );
  }

  List<Widget> _dialogButonlariAyarla(BuildContext context) {
    final tumButonlar = <Widget>[];
    /*if (Platform.isIOS) {
      if (iptalButonYazisi != null) {
        tumButonlar.add(
          CupertinoDialogAction(
            child: Text(
              iptalButonYazisi,
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }
      tumButonlar.add(CupertinoDialogAction(
        child: Text(
          anaButonYazisi,
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ));
      //ios degil ise
    } else {
      */
    if (iptalButonYazisi != null) {
      tumButonlar.add(
        TextButton(
          child: Text(
            iptalButonYazisi,
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      );
    }
    if (icon != null) {
      tumButonlar.add(TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              anaButonYazisi,
              style: TextStyle(fontSize: 20),
            ),
            icon
          ],
        ),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ));
      // yukardakı if else in }

    } else {
      tumButonlar.add(TextButton(
        child: Text(
          anaButonYazisi,
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ));
      // yukardakı if else in }

    }

    return tumButonlar;
  }
}
