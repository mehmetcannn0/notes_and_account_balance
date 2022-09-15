import 'package:flutter/material.dart';
import 'package:notes/const.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.widht - 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget.kalan > 0
              ? Container(
                  padding: EdgeInsets.all(8),
                  width: (widget.gelir * widget.katsayi),
                  color: Colors.green,
                  child: Text(
                    "gelir: " + widget.gelir.toString(),
                    style: headerStyle22,
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(8),
                  width: widget.widht - 2,
                  color: Colors.grey,
                  child: Text(
                    "gelir: " + widget.gelir.toString(),
                    style: headerStyle22,
                  ),
                ),
          Row(
            children: [
              widget.gelir == 0
                  ? Container(
                      padding: EdgeInsets.all(8),
                      width: widget.widht - 1,
                      color: Colors.red,
                      child: Text(
                        "gider: " + widget.gider.toString(),
                        style: headerStyle22,
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(8),
                      width: (widget.gider * widget.katsayi),
                      color: Colors.red,
                      child: Text(
                        "gider: " + widget.gider.toString(),
                        style: headerStyle22,
                      ),
                    ),
              Container(
                padding: EdgeInsets.all(8),
                width: (widget.kalan * widget.katsayi),
                color: Colors.blueAccent,
                child: Text(
                  "kalan: " + widget.kalan.toString(),
                  style: headerStyle22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
