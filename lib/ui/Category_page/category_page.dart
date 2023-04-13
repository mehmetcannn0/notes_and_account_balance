// import 'dart:html';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes/common_widget/Platform_Duyarli_Alert_Dialog/platform_duyarli_alert_dialog.dart';
import 'package:notes/common_widget/build_note_list.dart';
import 'package:notes/const.dart';
import 'package:notes/models/category.dart';
import 'package:notes/models/settings.dart';
import 'package:notes/services/database_helper.dart';
import 'package:notes/ui/Home_Page/home_page.dart';
import 'package:notes/ui/Note_Detail/note_detail.dart';

class CategoryPage extends StatefulWidget {
  final Category category;
  CategoryPage({@required this.category});
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Category category;
  int lenght = 0;
  String newCategoryTitle;
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    category = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Settings();
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        //true donerse kapanır
        //false donerse kapanmaz
        return _areYouSureforExit();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: settings.currentColor,
            actions: [
              IconButton(
                  onPressed: () {
                    if (category.id != 0) {
                      editCategoryDialog(context, category);
                    }
                  },
                  icon: Icon(
                    Icons.edit_square,
                    size: 35,
                    color:
                        category.id != 0 ? Colors.white : Color(category.color),
                  )),
            ],
          ),
          backgroundColor: scaffoldColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                buildHeader(size),
                SizedBox(height: 20),
                FutureBuilder(
                  future: lenghtNote(),
                  builder: (context, _) {
                    if (lenght == 0) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Text(
                                "Bu kategoride not bulunmuyor",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 15,
                              ),
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
                                openBuilder:
                                    (BuildContext context, VoidCallback _) =>
                                        NoteDetail(
                                  gelenColor: Color(category.color),
                                  gelenCategoryID: category.id,
                                  gelenArchive: 0,
                                ),
                                closedElevation: 6,
                                closedColor: Color(category.color),
                                closedBuilder: (BuildContext context,
                                        VoidCallback openContainer) =>
                                    Icon(
                                  Icons.add_circle_outline_outlined,
                                  size: 55,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        height: 150.0 * lenght,
                        child: BuildNoteList(categoryID: category.id),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader(Size size) {
    return Container(
        height: 220,
        color: Color(category.color),
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.categoryTitle,
                style: category.categoryTitle.length < 20
                    ? headerStyle6 //50
                    : category.categoryTitle.length < 35
                        ? headerStyle6.copyWith(fontSize: 37)
                        : category.categoryTitle.length < 50
                            ? headerStyle6.copyWith(fontSize: 31)
                            : headerStyle6.copyWith(fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "$lenght notlar",
                  style: headerStyle7,
                ),
              ),
            ],
          ),
        ));
  }

  Future lenghtNote() async {
    int lenghtLocal, categoryID = category.id;
    if (categoryID == 0) {
      //tum notlar
      lenghtLocal = await databaseHelper.lenghtAllNotes();
    } else {
      lenghtLocal = await databaseHelper.lenghtCategoryNotes(categoryID);
    }
    if (mounted)
      setState(() {
        lenght = lenghtLocal;
      });
    // setState(() {
    //   lenght = lenghtLocal != null ? lenghtLocal : 0;
    // });
  }

  Future<bool> _areYouSureforExit() async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin Misiniz?",
      icerik:
          "Bulunduğunuz kategori sayfasından çıkmak istediğinize emin misiniz?",
      anaButonYazisi: "ÇIK",
      iptalButonYazisi: "İPTAL",
    ).goster(context);
    return Future.value(sonuc);
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
                        setState(() {
                          category.categoryTitle = newCategoryTitle;
                          category.color = category.color;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Kategori başarıyla düzenlendi 👌"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        newCategoryTitle = null;
                        Navigator.pop(context);
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

// ????
// !!!!!
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

    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => HomePage(),
    ));
  }
}
