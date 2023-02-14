import 'package:flutter/material.dart';
import 'package:notes/common_widget/flat_button_yeni.dart';
// import 'package:intl/intl.dart';

import '../../const.dart';

class YeniKalem extends StatefulWidget {
  final Function klmEkle;
  YeniKalem(this.klmEkle);

  @override
  State<YeniKalem> createState() => _YeniKalemState();
}

class _YeniKalemState extends State<YeniKalem> {
  final baslikKontrolcusu = TextEditingController();
  final miktarKontrolcusu = TextEditingController();
  DateTime selectedDateTime = DateTime.now();
  DateTime picked;
  int tur = null;

  void veriTeslim(BuildContext context) {
    final girilenBaslik = baslikKontrolcusu.text;
    if (miktarKontrolcusu.text == null || miktarKontrolcusu.text == "") {
      miktarKontrolcusu.text = "0";
    }
    final girilenMiktar = int.parse(miktarKontrolcusu.text);
    if (girilenBaslik.isEmpty || girilenMiktar <= 0) {
      return;
    } else {
      widget.klmEkle(
          tur, girilenBaslik, girilenMiktar, selectedDateTime.toString());
      // Navigator.pop(context);
    }
  }

  final yearKontrolcusu = TextEditingController();
  double day = DateTime.now().day.toDouble();
  double month = DateTime.now().month.toDouble();
  double year = DateTime.now().year.toDouble();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        // height: 100,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                dropDownDay(),
                dropDownMonth(),
                inputYear(),
              ],
            ),
            TextField(
              decoration: InputDecoration(labelText: "Başlık"),
              controller: baslikKontrolcusu,
              // onSubmitted: (_) => veriTeslim(context),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Miktar"),
              controller: miktarKontrolcusu,
              // onSubmitted: (_) => veriTeslim(context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Form(
                      child: FlatButtonYeni(
                        backGroundColor: tur == null
                            ? Colors.green
                            : tur == 1
                                ? Colors.green
                                : Colors.grey[600],
                        textColor: Colors.deepPurpleAccent,
                        onPressed: () {
                          setState(() {
                            tur = 1;
                            print("tur 1: " + tur.toString());
                          });
                        },
                        child: Text("gelir"),
                      ),
                    ),
                    Form(
                      child: FlatButtonYeni(
                        backGroundColor: tur == null
                            ? Colors.red
                            : tur == 2
                                ? Colors.red
                                : Colors.grey[600],
                        textColor: Colors.deepPurpleAccent,
                        onPressed: () {
                          setState(() {
                            tur = 2;
                            print("tur 2 : " + tur.toString());
                          });
                        },
                        child: Text("gider"),
                      ),
                    ),
                  ],
                ),

                // Form(
                //   child: FlatButton(
                //     color: Theme.of(context).primaryColorLight,
                //     textColor: Colors.deepPurpleAccent,
                //     onPressed: () async {
                //       // picked = await showDatePicker(
                //       //     context: context,
                //       //     initialDate: selectedDateTime,
                //       //     currentDate: picked,
                //       //     firstDate: new DateTime(2000),
                //       //     lastDate: new DateTime(3000));
                //       dropDownDay();
                //       dropDownMonth();
                //       inputYear();

                //       if (picked != null) {
                //         print('Date Selected:${selectedDateTime.toString()}');
                //         setState(() {
                //           selectedDateTime = picked;
                //         });
                //       }

                //       // print(baslikKontrolcusu.text);
                //       print("selected date time tarih : " +
                //           selectedDateTime.toString());
                //       print("selected date ptime tarih : " + picked.toString());
                //     },
                //     child:
                //         Text(DateFormat("dd/MM/yyyy").format(selectedDateTime)),
                //   ),
                // ),
              ],
            ),
            FlatButtonYeni(
              backGroundColor: Theme.of(context).primaryColorLight,
              textColor: Colors.deepPurpleAccent,
              onPressed: () {
                print("tur : " + tur.toString());
                if (tur == null) {
                  tur = 2;
                }
                dateRangePickerSaver();
                veriTeslim(context);
                // print(baslikKontrolcusu.text);
              },
              child: Text("Kalem Ekle"),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropDownDay() {
    List<int> sortList = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      31
    ];
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter dropDownState) {
        return DropdownButton(
            value: day - 1,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 20,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(height: 2, color: Colors.transparent),
            onChanged: (selectedDay) => dropDownState(() {
                  switch (selectedDay) {
                    case 0:
                      day = 1;
                      break;
                    case 1:
                      day = 2;
                      break;
                    case 2:
                      day = 3;
                      break;
                    case 3:
                      day = 4;
                      break;
                    case 4:
                      day = 5;
                      break;
                    case 5:
                      day = 6;
                      break;
                    case 6:
                      day = 7;
                      break;
                    case 7:
                      day = 8;
                      break;
                    case 8:
                      day = 9;
                      break;
                    case 9:
                      day = 10;
                      break;
                    case 10:
                      day = 11;
                      break;
                    case 11:
                      day = 12;
                      break;
                    case 12:
                      day = 13;
                      break;
                    case 13:
                      day = 14;
                      break;
                    case 14:
                      day = 15;
                      break;
                    case 15:
                      day = 16;
                      break;
                    case 16:
                      day = 17;
                      break;
                    case 17:
                      day = 18;
                      break;
                    case 18:
                      day = 19;
                      break;
                    case 19:
                      day = 20;
                      break;
                    case 20:
                      day = 21;
                      break;
                    case 21:
                      day = 22;
                      break;
                    case 22:
                      day = 23;
                      break;
                    case 23:
                      day = 24;
                      break;
                    case 24:
                      day = 25;
                      break;
                    case 25:
                      day = 26;
                      break;
                    case 26:
                      day = 27;
                      break;
                    case 27:
                      day = 28;
                      break;
                    case 28:
                      day = 29;
                      break;
                    case 29:
                      day = 30;
                      break;
                    case 30:
                      day = 31;
                      break;
                  }
                }),
            items: sortList
                .map(
                  (e) => DropdownMenuItem<int>(
                    child: Text(
                      e.toInt().toString(),
                      style: headerStyle3_1,
                    ),
                    value: sortList.indexOf(e),
                  ),
                )
                .toList());
      },
    );
  }

  Widget dropDownMonth() {
    List<String> orderList = [
      "Ocak",
      "Şubat",
      "Mart",
      "Nisan",
      "Mayıs",
      "Haziran",
      "Temmuz",
      "Ağustos",
      "Eylül",
      "Ekim",
      "Kasım",
      "Aralık"
    ];

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter dropDownOrderState) {
        return DropdownButton<int>(
            value: month.toInt() - 1,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 20,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(height: 2, color: Colors.transparent),
            onChanged: (selectedmonth) => dropDownOrderState(() {
                  switch (selectedmonth) {
                    case 0:
                      month = 1;
                      break;
                    case 1:
                      month = 2;
                      break;
                    case 2:
                      month = 3;
                      break;
                    case 3:
                      month = 4;
                      break;
                    case 4:
                      month = 5;
                      break;
                    case 5:
                      month = 6;
                      break;
                    case 6:
                      month = 7;
                      break;
                    case 7:
                      month = 8;
                      break;
                    case 8:
                      month = 9;
                      break;
                    case 9:
                      month = 10;
                      break;
                    case 10:
                      month = 11;
                      break;
                    case 11:
                      month = 12;
                      break;
                  }
                }),
            items: orderList
                .map((e) => DropdownMenuItem<int>(
                    value: orderList.indexOf(e),
                    child: Text(
                      e,
                      style: headerStyle3,
                    )))
                .toList());
      },
    );
  }

  Widget inputYear() {
    return Padding(
      padding: const EdgeInsets.all(23.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.33,
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: "Yıl"),
          controller: yearKontrolcusu,
          // onSubmitted: (_) => veriTeslim(context),
          onChanged: (value) {
            year = double.parse(value);
          },
        ),
      ),
    );
  }

  void dateRangePickerSaver() {
    if (yearKontrolcusu.text == null || yearKontrolcusu.text == "") {
      yearKontrolcusu.text = "2022";
      year = 2022;
    }

    picked = DateTime(year.toInt(), month.toInt(), day.toInt());
    print("datetime deneme print i *****************///////////////");
    print(picked);

    if (picked != null) {
      setState(() {
        selectedDateTime = picked;

        print(" deneme range");
        print(picked);
      });
      print('Datetime Selected:${selectedDateTime.toString()}');
    } else {
      print("null dondu");
      print(picked);
    }
  }
}
