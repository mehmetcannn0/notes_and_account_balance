import 'package:flutter/material.dart';
import 'package:notes/const.dart';
import 'package:notes/models/settings.dart';

class GelirGiderKalan extends StatefulWidget {
  double gelir;
  double gider;
  double kalan;
  double katsayi;
  double widht;
  GelirGiderKalan(this.gelir, this.gider, this.kalan, this.katsayi, this.widht);
  @override
  State<GelirGiderKalan> createState() => _GelirGiderKalanState();
}

class _GelirGiderKalanState extends State<GelirGiderKalan> {
  Settings settings = Settings();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 9, bottom: 5),
      color: settings.currentColor,
      width: widget.widht - 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget.kalan > 0
              ? Card(
                  elevation: 5,
                  color: Colors.green,
                  child: Text(
                    "gelir: " + widget.gelir.toString(),
                    style: headerStyle22,
                  ),
                )
              : Card(
                  elevation: 5,
                  color: Colors.grey,
                  child: Text(
                    "gelir: " + widget.gelir.toString(),
                    style: headerStyle22,
                  ),
                ),
          widget.gelir == 0
              ? Card(
                  elevation: 5,
                  color: Colors.red,
                  child: Text(
                    "gider: " + widget.gider.toString(),
                    style: headerStyle22,
                  ),
                )
              : Card(
                  elevation: 5,
                  color: Colors.red,
                  child: Text(
                    "gider: " + widget.gider.toString(),
                    style: headerStyle22,
                  ),
                ),
          Card(
            elevation: 5,
            color: Colors.blueAccent,
            child: Text(
              "kalan: " + widget.kalan.toString(),
              style: headerStyle22,
            ),
          ),
        ],
      ),
    );
  }
}
