import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/models/turler.dart';
import 'package:notes/services/database_helper.dart';

class YeniKalem extends StatefulWidget {
  final Function klmEkle;
  YeniKalem(this.klmEkle);

  @override
  State<YeniKalem> createState() => _YeniKalemState();
}

class _YeniKalemState extends State<YeniKalem> {
  final baslikKontrolcusu = TextEditingController();
  final miktarKontrolcusu = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Turler> allTur;
  DateTime selectedDateTime = DateTime.now();
  DateTime picked;
  int tur = 1, counter = 0;
  bool isChanged = false;
  @override
  void initState() {
    readTur();
    print("init state içi");
    print(allTur.length);
    super.initState();
  }

  void veriTeslim(BuildContext context) {
    final girilenBaslik = baslikKontrolcusu.text;
    if (miktarKontrolcusu.text == null || miktarKontrolcusu.text == "") {
      miktarKontrolcusu.text = "0";
    }
    final girilenMiktar = double.parse(miktarKontrolcusu.text);
    if (girilenBaslik.isEmpty || girilenMiktar <= 0) {
      return;
    } else {
      widget.klmEkle(tur, girilenBaslik, girilenMiktar.toString(),
          selectedDateTime.toString());
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readTur(),
        builder: (BuildContext context, _) {
          return Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.53,
                        child: ListView.builder(
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                              child: Card(
                                color: allTur[index].tur == 1
                                    ? Colors.green[300]
                                    : Colors.red[300],
                                elevation: 5,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.deepPurpleAccent,
                                              width: 1)),
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        "₺" + allTur[index].tur.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.deepPurpleAccent),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          allTur[index].turTitle,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                          ),
                                        ),
                                        // Text(
                                        //   widget.kalemler[index].tarih,
                                        //   style: TextStyle(color: Colors.blueGrey),
                                        // ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                print("basilan tur id si : " +
                                    allTur[index].tur.toString());
                              },
                            );
                          },
                          itemCount: allTur.length,
                        ),
                      ),
                      // dropDown(tur),
                      // // gider
                      Form(
                        child: FlatButton(
                          color: tur == 1 ? Colors.green : Colors.grey[600],
                          textColor: Colors.deepPurpleAccent,
                          onPressed: () {
                            setState(() {
                              tur = 1;
                              print("tur 1 : " + tur.toString());
                            });
                          },
                          child: Text("gelir"),
                        ),
                      ),
                      //gelir
                      Form(
                        child: FlatButton(
                          color: tur == 2 ? Colors.red : Colors.grey[600],
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
                      //tarih
                      Form(
                        child: FlatButton(
                          color: Theme.of(context).primaryColorLight,
                          textColor: Colors.deepPurpleAccent,
                          onPressed: () async {
                            picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDateTime,
                                currentDate: picked,
                                firstDate: new DateTime(2000),
                                lastDate: new DateTime(3000));

                            if (picked != null && picked != selectedDateTime) {
                              print(
                                  'Date Selected:${selectedDateTime.toString()}');
                              setState(() {
                                selectedDateTime = picked;
                              });
                            }

                            // print(baslikKontrolcusu.text);
                            print("selected date time tarih : " +
                                selectedDateTime.toString());
                            print("selected date ptime tarih : " +
                                picked.toString());
                          },
                          child: Text(DateFormat("dd/MM/yyyy")
                              .format(selectedDateTime)),
                        ),
                      ),
                    ],
                  ),
                  FlatButton(
                    color: Theme.of(context).primaryColorLight,
                    textColor: Colors.deepPurpleAccent,
                    onPressed: () {
                      print("tur : " + tur.toString());
                      if (tur == null) {
                        tur = 2;
                      }
                      veriTeslim(context);
                      // print(baslikKontrolcusu.text);
                    },
                    child: Text("Kalem Ekle"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> readTur() async {
    // if (counter == 0) {
    print("read tur içi ");
    // allTur = await databaseHelper.getTurList();
    // print("all tur uzunluk " + allTur.length.toString());
    print("read tur içi  get tur list sonrası");

    // print(allTur[1].turTitle);
    allTur = [
      Turler(1, "gelir fake", "4294550692"),
      Turler(2, "gider fake", "4288865453"),
      Turler(3, "c", "4294550692"),
      Turler(4, "d", "4288865453")
    ];
    print(allTur[0].turTitle);
    print(allTur[1].turTitle);
    print(allTur);

    counter++;
    // }
  }

  Widget dropDown(int id) {
    return DropdownButton(
      value: tur = id != null ? id : tur,
      // value: tur,
      icon: Icon(Icons.keyboard_arrow_down),
      iconSize: 20,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.transparent,
      ),
      onChanged: (selecteTurID) {
        isChanged = true;
        setState(() {
          tur = selecteTurID;
        });
      },
      items: createturItem(),
    );
  }

  List<DropdownMenuItem> createturItem() {
    return allTur
        .map((turler) => DropdownMenuItem<int>(
            value: turler.tur,
            child: Text(
              turler.turTitle,
            )))
        .toList();
  }
}
