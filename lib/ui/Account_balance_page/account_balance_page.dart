import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:notes/common_widget/Account_balance_widgets/kalem_listesi.dart';
// import 'package:notes/common_widget/Account_balance_widgets/tur_listesi.dart';
import 'package:notes/common_widget/Account_balance_widgets/yeni_kalem.dart';
import 'package:notes/models/kalem.dart';
import 'package:notes/models/settings.dart';
// import 'package:notes/models/turler.dart';
import 'package:notes/services/database_helper.dart';
import 'package:notes/common_widget/Account_balance_widgets/gelir_gider_kalan.dart';
// import 'package:notes/ui/Date_range_picker/my_date_range_picker.dart';

import '../../common_widget/Platform_Duyarli_Alert_Dialog/platform_duyarli_alert_dialog.dart';
import '../../const.dart';

class AccountBalancePage extends StatefulWidget {
  @override
  State<AccountBalancePage> createState() => _AccountBalancePageState();
}

class _AccountBalancePageState extends State<AccountBalancePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Settings settings = Settings();
  final baslikKontrolcusu = TextEditingController();
  final miktarKontrolcusu = TextEditingController();
  final baslangicYearKontrolcusu = TextEditingController();
  final bitisYearKontrolcusu = TextEditingController();
  double gelir = 0, gider = 0, kalan = 0, katsayi = 1;
  // List<Turler> _kullaniciTurleri = [
  //   // Turler(1, "gelir fake", "4294550692"),
  //   // Turler(2, "gider fake", "4288865453"),
  //   // Turler(3, "c", "4294550692"),
  //   // Turler(4, "d", "4288865453")
  // ];

  List<Kalem> _kullaniciKalemleri = [
    // Kalem(
    //   id: 1,
    //   baslik: "yeeni kitap1",
    //   miktar: "33",
    //   tarih: "2022-11-11",
    // ),
    // Kalem(
    //   id: 0,
    //   baslik: "yeeni kitap 2",
    //   miktar: "333",
    //   tarih: "2022-12-12",
    // ),
    // Kalem(
    //   id: 1,
    //   baslik: "yeeni kitap1",
    //   miktar: "33",
    //   tarih: "2022-11-11",
    // ),
    // Kalem(
    //   id: 0,
    //   baslik: "yeeni kitap 2",
    //   miktar: "333",
    //   tarih: "2022-12-12",
    // ),
  ];

  //?
//!
  bool isSorted = true;
  int sortBy = 3;
  int orderBy = 1;
  int lenght;
  bool readed = false;
  bool deneme = true;
  DateTimeRange selectedDateTime;
  DateTimeRange picked;
  bool secim = false;
//!
  //?

  //?

  double baslangicDay = 5;
  double baslangicmonth = 1;
  double baslangicYear = 2022;
  double bitisDay = 15;
  double bitismonth = 2;
  double bitisYear = 2022;

  //?
  //?
  int seciliTarihFiltre = 9;

  @override
  void initState() {
    // buAyOnPressed();
    gelirGiderHesapla();
    super.initState();
  }

  Future<void> _yeniKalemEkle(int tur, String kalemBaslik, int kalemMiktar,
      String selectedDateTime) async {
    int result;

    final yeniKlm = Kalem(tur, kalemBaslik, kalemMiktar, selectedDateTime);

    result = await databaseHelper.addKalem(yeniKlm);

    print(
        "kalemin data base e yazılma ıslemı future tamamlandıktan sonra donen \ndeger : " +
            result.toString());
    if (result != 0) {
      _kullaniciKalemleri.add(yeniKlm);
      setState(() {
        print("setstate içi");

        // gelirGiderHesapla();
      });
      Navigator.pop(context, result.toString());
    }
    // fillAllkalem();
    gelirGiderHesapla();
  }

  void _yeniKalemEklemeyeBasla(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (bcontext) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: YeniKalem(_yeniKalemEkle));
        });
  }

  Future<void> gelirGiderHesapla() async {
    var result = await fillAllkalem();

    print("deneme result : $result");
    if (_kullaniciKalemleri == null) {
      gelir = 0;
      gider = 0;
      kalan = 0;
      print("gelir/gider yok db boş");
    } else {
      gelir = 0;
      gider = 0;
      print("Gelir");
      for (var kalem in _kullaniciKalemleri) {
        print("${kalem.id}  ${kalem.baslik} ${kalem.tarih}");
        if (kalem.tur == 1) {
          gelir += kalem.miktar;
        }
      }
      print("toplam gelir : + " + gelir.toString());
      print("Gider");
      for (var kalem in _kullaniciKalemleri) {
        if (kalem.tur == 2) {
          gider += kalem.miktar;
        }
      }
      print("toplam gider : + " + gider.toString());
    }
    if (gelir == 0) {
      kalan = 0;
    } else {
      kalan = gelir - gider;
    }

    setState(() {
      print("gelirGiderHesapla fonksiyonunun sonundakı setstate içi");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double widht = size.width;
    double height = size.height;
    if (gelir == 0) {
      katsayi = 1;
    } else if (kalan < 0) {
      kalan = 0;
      katsayi = widht / gider;
    } else {
      katsayi = widht / gelir;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: settings.currentColor,
        title: Text("Hesap Özet"),
        actions: [
          // IconButton(
          //     iconSize: 38,
          //     // onPressed: () => _yeniKalemEklemeyeBasla(context),
          //     icon: Icon(
          //         Icons.category_outlined)), ////// tur ekleme ekranı yapılacak
          IconButton(
              iconSize: 38,
              onPressed: () => _yeniKalemEklemeyeBasla(context),
              icon: Icon(Icons.monetization_on_outlined)),
        ],
      ),
      body: secim == false
          ? SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Container(
                  //   color: settings.currentColor,
                  //   width: double.infinity,
                  //   child: Text("grafik"),
                  // ),
                  SizedBox(
                    height: height * 0.0001,
                  ),
                  GelirGiderKalan(gelir, gider, kalan, katsayi, widht),

                  KalemListesiWidget(),

                  // : KalemListesi(_kullaniciKalemleri),
                ],
              ),
            )
          : showMyDateRangePicker(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: settings.currentColor,
        onPressed: () => secim == false
            ? _yeniKalemEklemeyeBasla(context)
            : {
                /*kaydet fonksıyonu buraya gelebılır */
                dateRangePickerSaver()
              },
        //todo:
        child: Icon(
          secim == false ? Icons.add : Icons.save,
        ),
      ),
    );
  }

  //?
//!
  Widget KalemListesiWidget() {
    return Column(
      children: [
        //filtre satırı
        Container(
          color: settings.currentColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   width: 10,
                  // ),
                  seciliTarihFiltre != 9
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              seciliTarihFiltre = 9;
                              isSorted = null;
                              picked = null;
                              selectedDateTime = null;
                              fillAllkalem();
                              gelirGiderHesapla();
                            });
                          },
                          icon: Icon(Icons.clear))
                      : SizedBox(
                          width: 0,
                        ),
                  GestureDetector(
                      onTap: buAyOnPressed,
                      child: Card(
                        color: seciliTarihFiltre == 0
                            ? Colors.green
                            : Colors.grey[600],
                        child: Text(
                          "bu ay",
                          style: headerStyle22,
                        ),
                      )),
                  GestureDetector(
                      onTap: gecenAyOnPressed,
                      child: Card(
                        color: seciliTarihFiltre == 1
                            ? Colors.green
                            : Colors.grey[600],
                        child: Text(
                          "gecen ay",
                          style: headerStyle22,
                        ),
                      )),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        secim = true;
                      });
                    },
                    child: Card(
                      color: seciliTarihFiltre > 1
                          ? Colors.green
                          : Colors.grey[600],
                      child: Text(
                        picked == null
                            ? "Şuan tüm kalemler\nsıarlanıyor tarih aralığı seç"
                            // : "okeyy"
                            : DateFormat("dd/MM/yyyy")
                                    .format(selectedDateTime.start) +
                                "\n" +
                                DateFormat("dd/MM/yyyy")
                                    .format(selectedDateTime.end),
                        style: headerStyle23,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.sort),
                onPressed: () {
                  sortKalemDialog(context);
                },
              ),
            ],
          ),
        ),
        _kullaniciKalemleri.length == 0
            ? Container()
            : FutureBuilder(
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
                            "Hoşgeldiniz 🥳\n" +
                                "Hiçbir gelir/gider eklemediniz 😊",
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey.shade800),
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
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey.shade800),
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
                            key: Key(_kullaniciKalemleri[index].id.toString()),
                            background: Container(
                              child: Center(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Text(
                                  //   "🗑",
                                  //   style: TextStyle(fontSize: 30),
                                  // ),
                                  Icon(Icons.delete_outline),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 70),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Text(
                                  //   "🗑",
                                  //   style: TextStyle(fontSize: 30),
                                  // ),
                                  Icon(Icons.delete_outline),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 70),
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
                              int kalemID = _kullaniciKalemleri[index].id;

                              setState(() {
                                _kullaniciKalemleri.removeAt(index);
                                _areYouSureforDelete(kalemID);
                              });
                            },
                            child: GestureDetector(
                              child: Card(
                                color: _kullaniciKalemleri[index].tur == 1
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
                                              _kullaniciKalemleri[index]
                                                  .miktar
                                                  .toString(),
                                          style: headerStyle21),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_kullaniciKalemleri[index].baslik,
                                            style: headerStyle22),
                                        Text(
                                          _kullaniciKalemleri[index].tarih !=
                                                  null
                                              ? databaseHelper.dateFormat(
                                                  DateTime.parse(
                                                      _kullaniciKalemleri[index]
                                                          .tarih))
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
                                    _kullaniciKalemleri[index].id.toString());
                              },
                            ),
                          );
                        },
                        itemCount: _kullaniciKalemleri.length,
                      ),
                    );
                  }
                },
              ),
      ],
    );
  }

  void gecenAyOnPressed() {
    setState(() {
      secim = false;

      seciliTarihFiltre = 1;

      picked = DateTimeRange(
        start: DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
        end: DateTime(DateTime.now().year, DateTime.now().month - 1, 31),
      );
      selectedDateTime = picked;
      baslangicYearKontrolcusu.text = DateTime.now().year.toString();
      bitisYearKontrolcusu.text = DateTime.now().year.toString();
      baslangicDay = 1;
      baslangicmonth = double.parse(DateTime.now().month.toString()) - 1;
      ;
      baslangicYear = double.parse(DateTime.now().year.toString());
      bitisDay = 31;
      bitismonth = double.parse(DateTime.now().month.toString()) - 1;
      bitisYear = double.parse(DateTime.now().year.toString());

      fillAllkalem();
      gelirGiderHesapla();
      isSorted = true;
    });
  }

  void buAyOnPressed() {
    setState(() {
      secim = false;
      seciliTarihFiltre = 0;

      picked = DateTimeRange(
        start: DateTime(DateTime.now().year, DateTime.now().month, 1),
        end: DateTime(DateTime.now().year, DateTime.now().month, 31),
      );
      selectedDateTime = picked;
      baslangicYearKontrolcusu.text = DateTime.now().year.toString();
      bitisYearKontrolcusu.text = DateTime.now().year.toString();
      baslangicDay = 1;
      baslangicmonth = double.parse(DateTime.now().month.toString());
      ;
      baslangicYear = double.parse(DateTime.now().year.toString());
      bitisDay = double.parse(DateTime.now().day.toString());
      bitismonth = double.parse(DateTime.now().month.toString());
      bitisYear = double.parse(DateTime.now().year.toString());
      fillAllkalem();
      gelirGiderHesapla();

      isSorted = true;
    });
  }

//!
  //?

  //?
//!

  Future fillAllkalem() async {
    if (isSorted == null) {
      int lenghtLocal;
      _kullaniciKalemleri = await databaseHelper.getKalemList();
      setState(() {
        lenghtLocal = _kullaniciKalemleri.length;
        lenght = lenghtLocal;
        readed = true;
      });
      print("fillAllkalem issorted null ");
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
      _kullaniciKalemleri = await databaseHelper.getSortKalemList(
          selectedDayStart, selectedDayEnd, sortBy, orderBy);
      int lenghtLocal;

      setState(() {
        lenghtLocal = _kullaniciKalemleri.length;

        lenght = lenghtLocal;
        readed = true;
      });
      print("fillAllkalem issorted null degil");
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
      setState(() {
        gelirGiderHesapla();
      });
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

  Widget dropDownDayStart() {
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
            value: baslangicDay - 1,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 20,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(height: 2, color: Colors.transparent),
            onChanged: (selectedDay) => dropDownState(() {
                  switch (selectedDay) {
                    case 0:
                      baslangicDay = 1;
                      break;
                    case 1:
                      baslangicDay = 2;
                      break;
                    case 2:
                      baslangicDay = 3;
                      break;
                    case 3:
                      baslangicDay = 4;
                      break;
                    case 4:
                      baslangicDay = 5;
                      break;
                    case 5:
                      baslangicDay = 6;
                      break;
                    case 6:
                      baslangicDay = 7;
                      break;
                    case 7:
                      baslangicDay = 8;
                      break;
                    case 8:
                      baslangicDay = 9;
                      break;
                    case 9:
                      baslangicDay = 10;
                      break;
                    case 10:
                      baslangicDay = 11;
                      break;
                    case 11:
                      baslangicDay = 12;
                      break;
                    case 12:
                      baslangicDay = 13;
                      break;
                    case 13:
                      baslangicDay = 14;
                      break;
                    case 14:
                      baslangicDay = 15;
                      break;
                    case 15:
                      baslangicDay = 16;
                      break;
                    case 16:
                      baslangicDay = 17;
                      break;
                    case 17:
                      baslangicDay = 18;
                      break;
                    case 18:
                      baslangicDay = 19;
                      break;
                    case 19:
                      baslangicDay = 20;
                      break;
                    case 20:
                      baslangicDay = 21;
                      break;
                    case 21:
                      baslangicDay = 22;
                      break;
                    case 22:
                      baslangicDay = 23;
                      break;
                    case 23:
                      baslangicDay = 24;
                      break;
                    case 24:
                      baslangicDay = 25;
                      break;
                    case 25:
                      baslangicDay = 26;
                      break;
                    case 26:
                      baslangicDay = 27;
                      break;
                    case 27:
                      baslangicDay = 28;
                      break;
                    case 28:
                      baslangicDay = 29;
                      break;
                    case 29:
                      baslangicDay = 30;
                      break;
                    case 30:
                      baslangicDay = 31;
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

  Widget dropDownmonthStart() {
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
            value: baslangicmonth.toInt() - 1,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 20,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(height: 2, color: Colors.transparent),
            onChanged: (selectedmonth) => dropDownOrderState(() {
                  switch (selectedmonth) {
                    case 0:
                      baslangicmonth = 1;
                      break;
                    case 1:
                      baslangicmonth = 2;
                      break;
                    case 2:
                      baslangicmonth = 3;
                      break;
                    case 3:
                      baslangicmonth = 4;
                      break;
                    case 4:
                      baslangicmonth = 5;
                      break;
                    case 5:
                      baslangicmonth = 6;
                      break;
                    case 6:
                      baslangicmonth = 7;
                      break;
                    case 7:
                      baslangicmonth = 8;
                      break;
                    case 8:
                      baslangicmonth = 9;
                      break;
                    case 9:
                      baslangicmonth = 10;
                      break;
                    case 10:
                      baslangicmonth = 11;
                      break;
                    case 11:
                      baslangicmonth = 12;
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

  Widget dropDownDayEnd() {
    List<double> sortList = [
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
            value: bitisDay - 1,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 20,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(height: 2, color: Colors.transparent),
            onChanged: (selectedDay) => dropDownState(() {
                  switch (selectedDay) {
                    case 0:
                      bitisDay = 1;
                      break;
                    case 1:
                      bitisDay = 2;
                      break;
                    case 2:
                      bitisDay = 3;
                      break;
                    case 3:
                      bitisDay = 4;
                      break;
                    case 4:
                      bitisDay = 5;
                      break;
                    case 5:
                      bitisDay = 6;
                      break;
                    case 6:
                      bitisDay = 7;
                      break;
                    case 7:
                      bitisDay = 8;
                      break;
                    case 8:
                      bitisDay = 9;
                      break;
                    case 9:
                      bitisDay = 10;
                      break;
                    case 10:
                      bitisDay = 11;
                      break;
                    case 11:
                      bitisDay = 12;
                      break;
                    case 12:
                      bitisDay = 13;
                      break;
                    case 13:
                      bitisDay = 14;
                      break;
                    case 14:
                      bitisDay = 15;
                      break;
                    case 15:
                      bitisDay = 16;
                      break;
                    case 16:
                      bitisDay = 17;
                      break;
                    case 17:
                      bitisDay = 18;
                      break;
                    case 18:
                      bitisDay = 19;
                      break;
                    case 19:
                      bitisDay = 20;
                      break;
                    case 20:
                      bitisDay = 21;
                      break;
                    case 21:
                      bitisDay = 22;
                      break;
                    case 22:
                      bitisDay = 23;
                      break;
                    case 23:
                      bitisDay = 24;
                      break;
                    case 24:
                      bitisDay = 25;
                      break;
                    case 25:
                      bitisDay = 26;
                      break;
                    case 26:
                      bitisDay = 27;
                      break;
                    case 27:
                      bitisDay = 28;
                      break;
                    case 28:
                      bitisDay = 29;
                      break;
                    case 29:
                      bitisDay = 30;
                      break;
                    case 30:
                      bitisDay = 31;
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

  Widget dropDownmonthEnd() {
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
            value: bitismonth.toInt() - 1,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 20,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(height: 2, color: Colors.transparent),
            onChanged: (selectedmonth) => dropDownOrderState(() {
                  switch (selectedmonth) {
                    case 0:
                      bitismonth = 1;
                      break;
                    case 1:
                      bitismonth = 2;
                      break;
                    case 2:
                      bitismonth = 3;
                      break;
                    case 3:
                      bitismonth = 4;
                      break;
                    case 4:
                      bitismonth = 5;
                      break;
                    case 5:
                      bitismonth = 6;
                      break;
                    case 6:
                      bitismonth = 7;
                      break;
                    case 7:
                      bitismonth = 8;
                      break;
                    case 8:
                      bitismonth = 9;
                      break;
                    case 9:
                      bitismonth = 10;
                      break;
                    case 10:
                      bitismonth = 11;
                      break;
                    case 11:
                      bitismonth = 12;
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

//!
  //?
//todo: benım date pickerim

  Widget showMyDateRangePicker() {
    //todo yıl degıskenı eklenmelı
    return Center(
      child: Container(
        child: ListView(
          children: [
            //todo

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(23.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "baslangicYear"),
                      controller: baslangicYearKontrolcusu,
                      // onSubmitted: (_) => veriTeslim(context),
                      onChanged: (value) {
                        baslangicYear = double.parse(value);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(23.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "bitisYear"),
                      controller: bitisYearKontrolcusu,
                      // onSubmitted: (_) => veriTeslim(context),
                      onChanged: (value) {
                        bitisYear = double.parse(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(23.0),
              child: Row(
                children: [
                  dropDownDayStart(),
                  dropDownmonthStart(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(23.0),
              child: Row(
                children: [
                  dropDownDayEnd(),
                  dropDownmonthEnd(),
                ],
              ),
            ),

            /*
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
                      max: 31,
                      divisions: 31,
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
                  Text("baslangicmonth",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(baslangicmonth.round().toString(),
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      )),
                  Slider(
                      min: 1,
                      max: 12,
                      divisions: 12,
                      value: baslangicmonth,
                      onChanged: (double newValue) {
                        setState(() {
                          baslangicmonth = newValue;
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
                      divisions: 31,
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
                  Text("bitismonth",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(bitismonth.round().toString(),
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      )),
                  Slider(
                      min: 1,
                      max: 12,
                      divisions: 12,
                      value: bitismonth,
                      onChanged: (double newValue) {
                        setState(() {
                          bitismonth = newValue;
                        });
                      }),
                  /*null oursa slider disable olur*/
                ],
              ),
            ),*/
            // FlatButton(onPressed: dateRangePickerSaver, child: Text("kaydet")),
          ],
        ),
      ),
    );
  }

  void dateRangePickerSaver() {
    if (baslangicYearKontrolcusu.text == null ||
        baslangicYearKontrolcusu.text == "") {
      baslangicYearKontrolcusu.text = "2022";
      baslangicYear = 2022;
    }
    if (bitisYearKontrolcusu.text == null || bitisYearKontrolcusu.text == "") {
      bitisYearKontrolcusu.text = "2022";
      bitisYear = 2022;
    }
    int sd = baslangicDay.toInt();
    int sm = baslangicmonth.toInt();
    int ed = bitisDay.toInt();

    int em = bitismonth.toInt();
    int sy = baslangicYear.toInt();
    int ey = bitisYear.toInt();

    if ((sy < ey) || (sy == ey && (sm < em || (sm == em && sd < ed)))) {
      picked = DateTimeRange(
        //todo yıl degıskenı eklenmelı
        start: DateTime(sy, sm, sd),
        // start: DateTime(
        //   int.parse(baslangicYear.round().toString()),
        //   int.parse(baslangicmonth.round().toString()),
        //   int.parse(baslangicDay.round().toString()),
        // ),
        //todo yıl degıskenı eklenmelı

        end: DateTime(ey, em, ed),
      );
      print("date rane deneme print i ");
      print(picked);

      if (picked != null) {
        setState(() {
          secim = false;
          seciliTarihFiltre = 2;
          selectedDateTime = picked;

          print(" deneme range");
          print(picked);
          //!
          //?
          isSorted = true;
          fillAllkalem();
          gelirGiderHesapla();
        });
        print('Daterange  Selected:${selectedDateTime.toString()}');
        print('Daterange start Selected:${selectedDateTime.start.toString()}');
        print('Daterange end Selected:${selectedDateTime.end.toString()}');
      } else {
        print("null dondu");
        print(picked);
      }
    }
  }

  /*
    void addCategoryDialog(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Kategori Ekle",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Kategori Adı",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value.length < 3) {
                        return "Lütfen en az 3 karakter giriniz";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) => newCategoryTitle = value,
                  ),
                ),
              ),
              changeColorWidget(context),
              ButtonBar(
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.orangeAccent),
                    child: Text(
                      "İptal ❌",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                    child: Text(
                      "Kaydet 💾",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        int value = await databaseHelper.addCategory(
                            Category(newCategoryTitle, currentColor.value));

                        if (value > 0) {
                          //0 ise hata var
                          //0 dan buyuk ıse hatasız calıstı
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Kategori başarıyla eklendi 👌"),
                            duration: Duration(seconds: 2),
                          ));
                          Navigator.pop(context);
                          setState(() {
                            updateCategoryList();
                          });
                        }
                      }
                    },
                  ),
                ],
              )
            ],
          );
        });
  }


  Widget changeColorWidget(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter blockPickerState) {
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 26),
              child: Text(
                "Bir Renk Seç",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 80),
              child: GestureDetector(
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: currentColor),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Bir Renk Seç"),
                          content:
                              //////////////////////////////flutter_colorpicker bu kutuphane ıle renk secenegı yapıldı
                              MaterialPicker(
                                  pickerColor: currentColor,
                                  onColorChanged: (Color color) {
                                    Navigator.pop(context);
                                    blockPickerState(
                                        () => currentColor = color);
                                  }),
                        );
                      });
                },
              ),
            )
          ],
        );
      },
    );
  }
*/
}
