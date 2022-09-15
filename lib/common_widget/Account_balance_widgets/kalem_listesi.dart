import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/common_widget/Platform_Duyarli_Alert_Dialog/platform_duyarli_alert_dialog.dart';
import 'package:notes/const.dart';
// import 'package:intl/intl.dart';
import 'package:notes/models/kalem.dart';
import 'package:notes/models/settings.dart';
import 'package:notes/services/database_helper.dart';

class KalemListesi extends StatefulWidget {
  List<Kalem> kalemler;

  KalemListesi(this.kalemler);

  @override
  State<KalemListesi> createState() => _KalemListesiState();
}

class _KalemListesiState extends State<KalemListesi> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Settings settings = Settings();
  // todo: desc asc   //  fiyata gore desc asc
  bool isSorted = null;
  int sortBy = 3;
  int orderBy = 1;
  int lenght;
  bool readed = false;
  bool deneme = true;
  DateTimeRange selectedDateTime;
  DateTimeRange picked;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: settings.currentColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              selectedDateTime != null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          selectedDateTime = null;
                          picked = null;
                        });
                      },
                      icon: Icon(Icons.clear))
                  : SizedBox(
                      width: 0,
                    ),
              Form(
                child: FlatButton(
                  color: Colors.grey,
                  textColor: settings.currentColor,
                  onPressed: () async {
                    picked = await showDateRangePicker(
                        context: context,
                        currentDate: DateTime.now(),
                        firstDate: new DateTime(2000),
                        lastDate: new DateTime(3000));

                    if (picked != null) {
                      setState(() {
                        selectedDateTime = picked;
                        fillAllkalem();
                      });
                      print(
                          'Daterange  Selected:${selectedDateTime.toString()}');
                      print(
                          'Daterange start Selected:${selectedDateTime.start.toString()}');
                      print(
                          'Daterange end Selected:${selectedDateTime.end.toString()}');
                    }

                    // // print(baslikKontrolcusu.text);
                    // print("selected date time tarih : " +
                    //     selectedDateTime.toString());
                    // print("selected date ptime tarih : " + picked.toString());
                  },
                  child: Text(
                    picked == null
                        ? "tarih aralığı"
                        : DateFormat("dd/MM/yyyy")
                                .format(selectedDateTime.start) +
                            " - " +
                            DateFormat("dd/MM/yyyy")
                                .format(selectedDateTime.end),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                child: Icon(Icons.sort),
                onTap: () {
                  sortKalemDialog(context);
                },
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: fillAllkalem(),
          // initialData: InitialData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!readed)
              return Container(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );

            if (lenght == 0) {
              if (selectedDateTime == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Hoşgeldiniz 🥳\n" + "Hiçbir gelir/gider eklemediniz 😊",
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade800),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Seçilen tarih aralığında\n" +
                          "Hiçbir gelir/gider bulunamadı",
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade800),
                    ),
                  ),
                );
              }
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * 0.45,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Dismissible(
                      key: Key(widget.kalemler[index].id.toString()),
                      background: Container(
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Text(
                            //   "🗑",
                            //   style: TextStyle(fontSize: 30),
                            // ),
                            Icon(Icons.delete_outline),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 70),
                              child: Text(
                                "Kaldır",
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            // Text(
                            //   "🗑",
                            //   style: TextStyle(fontSize: 30),
                            // ),
                            Icon(Icons.delete_outline),
                          ],
                        )),
                        color: Colors.red,
                      ),
                      secondaryBackground: Container(
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Text(
                            //   "🗑",
                            //   style: TextStyle(fontSize: 30),
                            // ),
                            Icon(Icons.delete_outline),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 70),
                              child: Text(
                                "Kaldır",
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            // Text(
                            //   "🗑",
                            //   style: TextStyle(fontSize: 30),
                            // ),
                            Icon(Icons.delete_outline),
                          ],
                        )),
                        color: Colors.red,
                      ),
                      onDismissed: (direction) {
                        int kalemID = widget.kalemler[index].id;

                        setState(() {
                          widget.kalemler.removeAt(index);
                          _areYouSureforDelete(kalemID);
                        });
                      },
                      child: GestureDetector(
                        child: Card(
                          color: widget.kalemler[index].tur == 1
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
                                    "₺" +
                                        widget.kalemler[index].miktar
                                            .toString(),
                                    style: headerStyle21),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.kalemler[index].baslik,
                                      style: headerStyle22),
                                  Text(
                                    widget.kalemler[index].tarih != null
                                        ? databaseHelper.dateFormat(
                                            DateTime.parse(
                                                widget.kalemler[index].tarih))
                                        : "---",
                                    style: headerStyle3_2,
                                  )
                                ],
                              ),
                              // Text(widget.kalemler[index].tarih)
                            ],
                          ),
                        ),
                        onTap: () {
                          print("basilan kalemin id si : " +
                              widget.kalemler[index].id.toString());
                        },
                      ),
                    );
                  },
                  itemCount: widget.kalemler.length,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Future fillAllkalem() async {
    if (isSorted == null) {
      int lenghtLocal;
      widget.kalemler = await databaseHelper.getKalemList();
      lenghtLocal = widget.kalemler.length;
      setState(() {
        lenght = lenghtLocal;
        readed = true;
      });
    } else {
      String selectedDayStart;

      String selectedDayEnd;
      if (selectedDateTime == null) {
        selectedDayStart = null;
        selectedDayEnd = null;
      } else {
        selectedDayStart = selectedDateTime.start.toString();
        selectedDayEnd = selectedDateTime.end.toString();
      }
      // yıl-ay-
      widget.kalemler = await databaseHelper.getSortKalemList(
          selectedDayStart, selectedDayEnd, sortBy, orderBy);
      int lenghtLocal;

      lenghtLocal = widget.kalemler.length;

      lenght = lenghtLocal;
      readed = true;
    }
  }

  Future<void> _areYouSureforDelete(int kalemID) async {
    bool sonuc = await PlatformDuyarliAlertDialog(
            baslik: "Emin misiniz ?",
            icerik: "Bir kalem silinecek",
            anaButonYazisi: "SİL 🗑",
            iptalButonYazisi: "İPTAL")
        .goster(context);
    if (sonuc) {
      _delKalem(kalemID);
    }
  }

  Future _delKalem(int kalemID) async {
    int sonuc = await databaseHelper.deleteKalem(kalemID);
    if (sonuc != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kalem başarıyla silindi! 👌"),
          duration: Duration(seconds: 3),
        ),
      );
      setState(() {});
    }
  }

  void sortKalemDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Kalemleri sırala",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            contentPadding: const EdgeInsets.only(left: 25),
            children: [
              dropDown(),
              dropDownOrder(),
              ButtonBar(
                children: [
                  ElevatedButton(
                    child: Text(
                      "İptal",
                      style: TextStyle(color: Colors.white),
                    ),
                    style:
                        ElevatedButton.styleFrom(primary: Colors.orangeAccent),
                    onPressed: () {
                      setState(() {
                        isSorted = null;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      "Sırala",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                    onPressed: () async {
                      String sort = sortBy.toString();
                      setState(() {
                        isSorted = true;
                        // fillAllkalem();
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget dropDown() {
    List<String> sortList = [
      "Tür",
      "Başlık",
      "Miktar",
      "Tarih",
    ];
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter dropDownState) {
        return DropdownButton(
            value: sortBy,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 20,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(height: 2, color: Colors.transparent),
            onChanged: (selectedSortBy) =>
                dropDownState(() => sortBy = selectedSortBy),
            items: sortList
                .map(
                  (e) => DropdownMenuItem<int>(
                    child: Text(
                      e,
                      style: headerStyle3_1,
                    ),
                    value: sortList.indexOf(e),
                  ),
                )
                .toList());
      },
    );
  }

  Widget dropDownOrder() {
    List<String> orderList = ["Artan", "Azalan"];

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter dropDownOrderState) {
        return DropdownButton<int>(
            value: orderBy,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 20,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(height: 2, color: Colors.transparent),
            onChanged: (selectedOrderBy) =>
                dropDownOrderState(() => orderBy = selectedOrderBy),
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
}
/**
 * 
  return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            color:
                kalemler[index].id == 0 ? Colors.green[300] : Colors.red[300],
            elevation: 5,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.deepPurpleAccent, width: 1)),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "₺" + kalemler[index].miktar,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.deepPurpleAccent),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kalemler[index].baslik,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    Text(
                      kalemler[index].tarih,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ],
                )
              ],
            ),
          );
        },
        itemCount: kalemler.length,
      ),
    );

 * 
 */
