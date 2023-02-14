import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes/common_widget/Platform_Duyarli_Alert_Dialog/platform_duyarli_alert_dialog.dart';
import 'package:notes/common_widget/build_note_list.dart';
import 'package:notes/common_widget/merkez_widget.dart';
import 'package:notes/const.dart';
import 'package:notes/models/category.dart';
import 'package:notes/models/settings.dart';
import 'package:notes/services/database_helper.dart';
import 'package:notes/ui/Account_balance_page/account_balance_page.dart';
import 'package:notes/ui/Category_page/category_page.dart';
import 'package:notes/ui/Note_Detail/note_detail.dart';
import 'package:notes/ui/Search_Page/search_page.dart';
import 'package:notes/ui/Settings/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Settings settings = Settings();

  List<Category> allCategories = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  String newCategoryTitle;
  Color currentColor = Colors.red;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("allcategories.isempty : ${allCategories.isEmpty}");
    if (allCategories.isEmpty) updateCategoryList();
    return WillPopScope(
        //bulundugun sayfadan ayrılırken ekrana uyarı yazdırma
        onWillPop: () {
          //true donerse kapanır
          //false donerse kapanmaz
          return _areYouSureforExit();
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: settings.currentColor,
            body: ListView(
              children: [
                SizedBox(
                  height: 25,
                ),
                header(),
                categoriesAndNew(),
                buildCategories(size),
                Notes()
              ],
            ),
          ),
        ));
  }

  void updateCategoryList() {
    databaseHelper.getCategoryList().then((categoryList) {
      categoryList.insert(
          0, Category.withID(0, "Tüm Notlar", settings.currentColor.value));
      setState(() {
        allCategories = categoryList;
      });
    });
  }

  Widget buildCategories(Size size) {
    return Container(
      height: 130,
      width: size.width,
      child: ListView.builder(
        itemCount: allCategories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: borderRadius1,
                  color: settings.switchBackgroundColor(),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(allCategories[index].color),
                        ),
                      ),
                      Text(
                        allCategories[index].categoryTitle.length > 35
                            ? allCategories[index]
                                    .categoryTitle
                                    .replaceAll("\n", "  ")
                                    .substring(0, 34) +
                                "..."
                            : allCategories[index].categoryTitle,
                        style: switchCategoriesTitleStyle(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      CategoryPage(category: allCategories[index])));
            },
            onLongPress: () {
              if (index != 0) {
                editCategoryDialog(context, allCategories[index]);
              }
            },
          );
        },
      ),
    );
  }

  Future<bool> _areYouSureforExit() async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin Misiniz?",
      icerik: "Note dan çıkmak istediğinize emin misiniz?",
      anaButonYazisi: "ÇIK",
      iptalButonYazisi: "İPTAL",
    ).goster(context);
    return Future.value(sonuc);
  }

  Widget header() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Ana Sayfa",
            style: headerStyle,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: settings.currentColor),
            child: Text(
              "Ara",
              style: headerStyle3,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SearchPage()));
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.grey.shade800,
              size: 30,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AccountBalancePage()));
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.settings,
              color: Colors.grey.shade800,
              size: 30,
            ),
            onTap: () async {
              String result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
              if (result != null)
                updateCategoryList();
              else
                setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget categoriesAndNew() {
    return Container(
        height: 80,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 30, top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Kategoriler",
                style: headerStyle2,
              ),
              GestureDetector(
                child: Text(
                  "+Yeni",
                  style: headerStyle3,
                ),
                onTap: () {
                  addCategoryDialog(context);
                },
              )
            ],
          ),
        ));
  }

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

  TextStyle switchCategoriesTitleStyle() {
    switch (settings.currentColor.hashCode) {
      //siyah
      case 4078190080:
        return headerStyle4.copyWith(color: Colors.white);
      default:
        return headerStyle4;
    }
  }

  void editCategoryDialog(BuildContext context, Category category) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Kategori Düzenle", 
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: category.categoryTitle,
                  decoration: InputDecoration(
                      labelText: "Kategori Adı", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value.length < 3)
                      return "Lütfen en az 3 karakter giriniz";
                    return null;
                  },
                  onSaved: (value) => newCategoryTitle = value,
                ),
              ),
            ),
            editColorWidget(context, category),
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Row(
                    children: [
                      Text(
                        "Kaldır",
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(Icons.delete_outline)
                    ],
                  ),
                  onPressed: () async {
                    await _sureForDelCategory(context, category.id);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.orangeAccent),
                  child: Text(
                    "İptal ❌",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: Text(
                    "Kaydet 💾",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      int value = await databaseHelper.updateCategory(
                          Category.withID(
                              category.id, newCategoryTitle, category.color));
                      if (value > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Kategori başarıyla düzenlendi 👌"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        newCategoryTitle = null;
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
      },
    );
  }

  Widget editColorWidget(BuildContext context, Category category) {
    Color categoryColor = Color(category.color);
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter blockPickerState) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 26.0),
              child: Text(
                "Bir Renk Seç",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80.0),
              child: GestureDetector(
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: categoryColor),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Bir Renk Seç"),
                        content: SingleChildScrollView(
                          child: MaterialPicker(
                            pickerColor: categoryColor,
                            onColorChanged: (Color color) {
                              Navigator.pop(context);
                              blockPickerState(
                                () {
                                  category.color = color.value;
                                  categoryColor = color;
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sureForDelCategory(BuildContext context, int CategoryID) async {
    final result = await PlatformDuyarliAlertDialog(
      baslik: "Emin misiniz? ",
      icerik: "Kategoriyi silmek istediğinizden emin misiniz?\n" +
          "Bu işlem, bu kategoriye ait arşivdekilerde dahil olmak üzere \ntüm notları silecek!!",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Hayır",
    ).goster(context);
    if (result) await _delCategory(context, CategoryID);
  }

  Future<void> _delCategory(BuildContext context, int categoryID) async {
    int deletedCategory = await databaseHelper.deleteCategory(categoryID);
    if (deletedCategory != 0) {
      setState(
        () {
          updateCategoryList();
        },
      );
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }
}

class Notes extends StatefulWidget {
  //!!! kesme noktası koyulmus ????
  //??
  const Notes({Key key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  int lenght, sortBy, orderBy, visibility;
  bool isSorted = false, readed = false;
  DatabaseHelper databaseHelper = DatabaseHelper();
  Settings settings = Settings();
  @override
  void initState() {
    super.initState();
    readSort();
    readVisibility();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: [
          buildRecentOnesAndFilterHeader(),
          SizedBox(
            height: 10,
          ),
          FutureBuilder(
              future: todayNotesLenght(),
              builder: (context, _) {
                if (!readed)
                  return MerkezWidget(children: [CircularProgressIndicator()]);

                if (lenght == 0) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Tekrar Hoşgeldiniz 🥳\n" +
                            "Bugün hiçbir not düzenlemediniz 😊",
                        style: TextStyle(
                            fontSize: 20, color: Colors.grey.shade800),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 150.0 * lenght,
                    width: size.width,
                    child: BuildNoteList(isSorted: isSorted),
                  );
                }
              }),
        ],
      ),
    );
  }

  void readSort() {
    String sort = settings.sort;
    //3/1
    List<String> sortList = sort.split("/");
    //["3","1"]
    setState(() {
      sortBy = int.parse(sortList[0]);
      //sortBy=3
      orderBy = int.parse(sortList[1]);
      //orderBy =1
    });
  }

  void readVisibility() {
    int visibilityread = settings.visibility;

    setState(() {
      visibility = visibilityread;
    });
  }

  Future<void> todayNotesLenght() async {
    int lenghtLocal;
    // 2021-12-24 12:23:47.216546
    if (settings.visibility == 1) {
      String suan = DateTime.now().toString().substring(0, 10);
      lenghtLocal = await databaseHelper.isThereAnyTodayNotes(suan);
    } else {
      lenghtLocal = 0;
    }

    setState(() {
      lenght = lenghtLocal;
      readed = true;
    });
  }

  Widget buildRecentOnesAndFilterHeader() {
    return Container(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 30,
          top: 30,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Son Notlar",
              style: headerStyle2,
            ),
            Row(
              children: [
                OpenContainer(
                  onClosed: (result) {
                    if (result != null) {
                      setState(() {
                        //widgetların yenılenmesı ıcın
                        //son notlar kısmındakı
                      });
                    }
                  },
                  transitionType: ContainerTransitionType.fade,
                  openBuilder: (BuildContext context, VoidCallback _) =>
                      NoteDetail(
                    gelenArchive: 0,
                  ),
                  closedElevation: 6,
                  closedColor: settings.currentColor,
                  closedBuilder:
                      (BuildContext context, VoidCallback openContainer) =>
                          Text(
                    "+Yeni",
                    style: headerStyle2,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  child: Icon(Icons.sort),
                  onTap: () {
                    sortNotesDialog(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void sortNotesDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Notları sırala",
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
                        isSorted = false;
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
                      String sort =
                          sortBy.toString() + "/" + orderBy.toString();
                      int result = await databaseHelper.updateSort(sort);
                      if (result == 1) {
                        settings.sort = sort;
                        setState(() {
                          isSorted = true;
                        });
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Sıralama Db e kaydedilemedi :("),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
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
      "Kategori",
      "Başlık",
      "İçerik",
      "Zaman",
      "Öncelik"
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
            items: createOrderByItem());
      },
    );
  }

  List<DropdownMenuItem<int>> createOrderByItem() {
    List<String> orderList = ["Artan", "Azalan"];
    return orderList
        .map((e) => DropdownMenuItem<int>(
            value: orderList.indexOf(e),
            child: Text(
              e,
              style: headerStyle3,
            )))
        .toList();
  }
}
