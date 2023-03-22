import 'package:flutter/material.dart';
import 'package:notes/common_widget/Platform_Duyarli_Alert_Dialog/platform_duyarli_alert_dialog.dart';
import 'package:notes/common_widget/merkez_widget.dart';
import 'package:notes/const.dart';
import 'package:notes/models/category.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/settings.dart';
import 'package:notes/services/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final Note updateNote;
  final Color gelenColor;
  final int gelenCategoryID;
  final int gelenArchive;
  NoteDetail(
      {this.updateNote,
      this.gelenColor,
      this.gelenCategoryID,
      this.gelenArchive});
  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  List<Category> allCategories;
  DatabaseHelper databaseHelper = DatabaseHelper();

  Note updateNote;
  int categoryID, selectedPriority, counter = 0, archive = 0;
  Color backgroundColor;
  Settings settings = Settings();

  bool isChanged = false, readed = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Size size;
  String noteTitle, noteContent;
  PlatformDuyarliAlertDialog exitDialog = PlatformDuyarliAlertDialog(
    baslik: "Emin misiniz ?",
    icerik:
        "Değişikliklerinizi kaydetmek mi yoksa iptal etmek mi istiyorsunuz ?",
    anaButonYazisi: "KAYDET 💾",
    iptalButonYazisi: "İPTAL ❌",
  );
  @override
  Widget build(BuildContext context) {
    archive = widget.gelenArchive;
    if (widget.updateNote != null) {
      setState(() {
        backgroundColor = Color(widget.updateNote.categoryColor);
      });
    }
    if (widget.gelenColor != null) {
      setState(() {
        backgroundColor = Color(widget.gelenColor.value);
      });
    }

    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (isChanged) {
          final sonuc = await exitDialog.goster(context);
          if (sonuc) {
            save(context);
            return false;
          }
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: Visibility(
            /*buradakı amac klavye acıldıgı zaman butonun
             klavyenın ustune cıkmasını engellemek yanı 
             yapmak ıstedıgımız sey butonu gorunmez yapmak */
            // visible: MediaQuery.of(context).viewInsets.bottom == 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                elevation: 5,
                child: Icon(
                  Icons.save,
                  color: Colors.grey.shade700,
                ),
                onPressed: () {
                  save(context);
                },
              ),
            ),
          ),
          backgroundColor: backgroundColor,
          body: FutureBuilder(
            future: readCategories(),
            builder: (BuildContext context, _) {
              if (!readed) {
                return MerkezWidget(children: [CircularProgressIndicator()]);
              } else {
                if (allCategories.isEmpty) {
                  return Center(
                    child: Text(
                      "Lütfen önce bir kategori oluşturun!",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
              }
              return SingleChildScrollView(
                child: Container(
                  child: Form(
                      key: formKey,
                      child: Column(children: [
                        buildAppBar(widget.gelenCategoryID),
                        buildTitleFormField(),
                        buildFormField(),
                      ])),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> readCategories() async {
    if (counter == 0) {
      allCategories = await databaseHelper.getCategoryList();
      if (allCategories.isNotEmpty) {
        if (widget.updateNote != null) {
          updateNote = widget.updateNote;
          categoryID = updateNote.categoryID;
          selectedPriority = updateNote.priority;
          backgroundColor = Color(updateNote.categoryColor);
        } else {
          backgroundColor = settings.currentColor;
          categoryID = allCategories[0].id;
          selectedPriority = 0;
        }
      }

      readed = true;
      counter++;
    }
  }

  Widget buildAppBar(int id) {
    return Container(
      height: 50,
      width: size.width,
      color: Colors.grey.shade100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                iconSize: 40,
                color: Colors.grey.shade500,
                onPressed: (() async {
                  if (isChanged) {
                    final sonuc = await exitDialog.goster(context);
                    if (sonuc) {
                      save(context);
                    } else {
                      Navigator.pop(context);
                    }
                  } else {
                    Navigator.pop(context);
                  }
                }),
              ),
            ),
            SizedBox(
              width: size.width * 0.25,
            ),
            dropDownPriority(),
            SizedBox(width: size.width * 0.05),
            dropDown(id),
          ],
        ),
      ),
    );
  }

  Widget dropDown(int id) {
    return DropdownButton(
      value: categoryID = id != null ? id : categoryID,
      icon: Icon(Icons.keyboard_arrow_down),
      iconSize: 20,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.transparent,
      ),
      onChanged: (selectedCategoryID) {
        isChanged = true;
        setState(() {
          categoryID = selectedCategoryID;
        });
      },
      items: createCategoryItem(),
    );
  }

  List<DropdownMenuItem> createCategoryItem() {
    return allCategories
        .map((category) => DropdownMenuItem<int>(
            value: category.id,
            child: Text(
              category.categoryTitle,
              style: headerStyle3,
            )))
        .toList();
  }

  Widget dropDownPriority() {
    List<String> priority = ["Düşük", "Orta", "Yüksek"];
    return DropdownButton<int>(
      value: selectedPriority,
      icon: Icon(Icons.keyboard_arrow_down),
      iconSize: 20,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.transparent,
      ),
      onChanged: (selectedPriorityID) {
        isChanged = true;
        setState(() {
          selectedPriority = selectedPriorityID;
        });
      },
      items: priority
          .map((e) => DropdownMenuItem<int>(
              child: Text(
                e,
                style: headerStyle3_1,
              ),
              value: priority.indexOf(e)))
          .toList(),
    );
  }

  Widget buildTitleFormField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
      child: TextFormField(
        initialValue: updateNote != null ? updateNote.title : "",
        /*yazılan yazılar ekrana sıgmadıgı zaman sag tarafa tasmasında alt satıra gecsın dıye kullanıyoruz bu ozellıgı */
        maxLines: null,
        style: headerStyle5,
        cursorColor: Colors.grey.shade700,
        decoration: InputDecoration(
            hintText: "Note Başlığını giriniz ",
            hintStyle: headerStyle5,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none),
        onSaved: (text) => noteTitle = text,
        onChanged: (String value) => isChanged = true,
      ),
    );
  }

  Widget buildFormField() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          initialValue: updateNote != null ? updateNote.content : "",
          maxLines: null,
          style: headerStyle10,
          cursorColor: Colors.grey.shade700,
          decoration: InputDecoration(
              hintText: "Note İçeriğini Giriniz ",
              hintStyle: headerStyle10,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none),
          onSaved: (text) => noteContent = text,
          onChanged: (String value) => isChanged = true,
        ),
      )
    ]);
  }

  Future<void> save(BuildContext context) async {
    //tumm form lardakı onsaved arı calıstırıyor
    formKey.currentState.save();
    DateTime suan = DateTime.now();
    int result;
    String returnStr;
    if (updateNote == null) {
      print(
          " categoryID,          noteTitle,          noteContent,          suan.toString(),          selectedPriority,          archive");
      print(categoryID);
      print(noteTitle);
      print(noteContent);
      print(suan);
      print(selectedPriority);
      print(archive);
      result = await databaseHelper.addNote(
        Note(
          categoryID,
          noteTitle,
          noteContent,
          suan.toString(),
          selectedPriority,
          archive,
        ),
      );
      if (result != 0) {
        returnStr = "saved";
      }
    } else {
      result = await databaseHelper.updateNote(Note.withID(
        updateNote.id,
        categoryID,
        noteTitle,
        noteContent,
        suan.toString(),
        selectedPriority,
        updateNote.archive,
      ));
      if (result != 0) {
        returnStr = "updated";
      }
    }
    if (result != 0) {
      Navigator.pop(context, returnStr);
    }
  }
}
