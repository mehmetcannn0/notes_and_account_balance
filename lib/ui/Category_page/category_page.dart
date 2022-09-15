// import 'dart:html';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:notes/common_widget/Platform_Duyarli_Alert_Dialog/platform_duyarli_alert_dialog.dart';
// import 'package:notes/common_widget/Platform_Duyarli_Alert_Dialog/platform_duyarli_alert_dialog.dart';
import 'package:notes/common_widget/build_note_list.dart';
import 'package:notes/const.dart';
import 'package:notes/models/category.dart';
import 'package:notes/models/settings.dart';
import 'package:notes/services/database_helper.dart';
// import 'package:notes/ui/Home_Page/home_page.dart';
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
            title: category.id != 0
                ? OpenContainer(
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
                      gelenColor: Color(category.color),
                      gelenCategoryID: category.id,
                      gelenArchive: 0,
                    ),
                    closedElevation: 6,
                    closedColor: Color(category.color),
                    closedBuilder:
                        (BuildContext context, VoidCallback openContainer) =>
                            Text(
                      "Categoriye Yeni Not Ekle",
                      style: headerStyle2,
                    ),
                  )
                : Text(""),
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
                          child: Text(
                            "Bu kategoride not bulunmuyor",
                            style: TextStyle(fontSize: 20),
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
    // Settings settings = Settings();
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(left: 9, right: 9, top: 5),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           GestureDetector(
              //             child: Icon(
              //               Icons.arrow_back_ios,
              //               size: 20,
              //               color: Colors.white,
              //             ),
              //             onTap: () {
              //               //navigator pop yapılmalı ama framework hatası verıyor
              //               // try {
              //               // Navigator.of(context).pop();
              //               // } catch (e) {
              //               //   print("Bir hata meydana geldi : " + e.toString());
              //               //   PlatformDuyarliAlertDialog(
              //               //           baslik: "Bir hata meydana geldi",
              //               //           icerik: "Hata: " + e.toString(),
              //               //           anaButonYazisi: "Tamam")
              //               //       .goster(context);
              //               //   Navigator.pop(context);
              //               // }
              //               // // Navigator.of(context).pushAndRemoveUntil(
              //               // //     MaterialPageRoute(
              //               // //         builder: (context) => HomePage()),
              //               // //     (route) => false);
              //               // Navigator.of(context).push(MaterialPageRoute(
              //               //     builder: (context) => HomePage()));
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              // // OpenContainer(
              // //   onClosed: (result) {
              // //     if (result != null) {
              // //       setState(() {
              // //         //widgetların yenılenmesı ıcın
              // //         //son notlar kısmındakı
              // //       });
              // //     }
              // //   },
              // //   transitionType: ContainerTransitionType.fade,
              // //   openBuilder: (BuildContext context, VoidCallback _) =>
              // //       NoteDetail(
              // //           gelenColor: Color(category.color),
              // //           gelenCategoryID: id),
              // //   closedElevation: 6,
              // //   closedColor: Color(category.color),
              // //   closedBuilder:
              // //       (BuildContext context, VoidCallback openContainer) =>
              // //           Text(
              // //     "Categoriye Yeni Not Ekle",
              // //     style: headerStyle2,
              // //   ),
              // // ),
              //   ],
              // ),

              ////////////////////
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
}
