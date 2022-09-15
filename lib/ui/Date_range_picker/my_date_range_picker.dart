import 'package:flutter/material.dart';

class MyDateRangePicker extends StatefulWidget {
  DateTimeRange picked;
  MyDateRangePicker(this.picked);
  @override
  State<MyDateRangePicker> createState() => _MyDateRangePickerState();
}

class _MyDateRangePickerState extends State<MyDateRangePicker> {
  // final baslangicYearKontrolcusu = TextEditingController();
  // final bitisYearKontrolcusu = TextEditingController();
  double baslangicDay = 5;
  double baslangicMounth = 1;
  double baslangicYear = 2022;
  double bitisDay = 15;
  double bitisMounth = 2;
  double bitisYear = 2022;

  //todo yıl degıskenı eklenmelı
//todo
/*
  // void veriTeslim(BuildContext context) {
  //   if (baslangicYearKontrolcusu.text == null ||
  //       baslangicYearKontrolcusu.text == "") {
  //     baslangicYearKontrolcusu.text = "2022";
  //   }
  //   if (bitisYearKontrolcusu.text == null ||
  //       bitisYearKontrolcusu.text == "") {
  //     bitisYearKontrolcusu.text = "2022";
  //   }

  //   if (girilenBaslik.isEmpty || girilenMiktar <= 0) {
  //     return;
  //   } else {
  //     widget.klmEkle(
  //         tur, girilenBaslik, girilenMiktar, selectedDateTime.toString());
  //     // Navigator.pop(context);
  //   }
  // }
  */

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              //todo
              // TextField(
              //   keyboardType: TextInputType.number,
              //   decoration: InputDecoration(labelText: "baslangicYear"),
              //   controller: baslangicYearKontrolcusu,
              //   // onSubmitted: (_) => veriTeslim(context),
              // ),
              // TextField(
              //   keyboardType: TextInputType.number,
              //   decoration: InputDecoration(labelText: "bitisYear"),
              //   controller: bitisYearKontrolcusu,
              //   // onSubmitted: (_) => veriTeslim(context),
              // ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("baslangicDay",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(baslangicDay.round().toString(),
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        )),
                    Slider(
                        min: 1,
                        max: 30,
                        value: baslangicDay,
                        onChanged: (double newValue) {
                          setState(() {
                            baslangicDay = newValue;
                          });
                        }),
                    /*null oursa slider disable olur*/
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("baslangicMounth",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(baslangicMounth.round().toString(),
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        )),
                    Slider(
                        min: 1,
                        max: 30,
                        value: baslangicMounth,
                        onChanged: (double newValue) {
                          setState(() {
                            baslangicMounth = newValue;
                          });
                        }),
                    /*null oursa slider disable olur*/
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("bitisDay",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(bitisDay.round().toString(),
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        )),
                    Slider(
                        min: 1,
                        max: 31,
                        value: bitisDay,
                        onChanged: (double newValue) {
                          setState(() {
                            bitisDay = newValue;
                          });
                        }),
                    /*null oursa slider disable olur*/
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("bitisMounth",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(bitisMounth.round().toString(),
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        )),
                    Slider(
                        min: 1,
                        max: 30,
                        value: bitisMounth,
                        onChanged: (double newValue) {
                          setState(() {
                            bitisMounth = newValue;
                          });
                        }),
                    /*null oursa slider disable olur*/
                  ],
                ),
              ),
              FlatButton(
                  onPressed: () {
                    int sd = int.parse(baslangicDay.round().toString());
                    int sm = int.parse(baslangicMounth.round().toString());
                    int ed = int.parse(bitisDay.round().toString());
                    ;
                    int em = int.parse(bitisMounth.round().toString());
                    ;
                    widget.picked = DateTimeRange(
                      //todo yıl degıskenı eklenmelı
                      start: DateTime(2022, sm, sd),
                      // start: DateTime(
                      //   int.parse(baslangicYear.round().toString()),
                      //   int.parse(baslangicMounth.round().toString()),
                      //   int.parse(baslangicDay.round().toString()),
                      // ),
                      //todo yıl degıskenı eklenmelı

                      end: DateTime(2022, em, ed),
                    );
                    print("date rane deneme print i  my  date page");
                    print(widget.picked);
                    Navigator.pop(context);
                  },
                  child: Text("kaydet")),
            ],
          ),
        ),
      ),
    );
  }
}
