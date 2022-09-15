// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:notes/common_widget/Platform_Duyarli_Alert_Dialog/platform_duyarli_alert_dialog.dart';
import 'package:notes/const.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/settings.dart';
import 'package:notes/services/database_helper.dart';
import 'package:notes/ui/Note_Detail/note_detail.dart';

class BuildNoteListAtArchive extends StatefulWidget {
  final bool isSorted;
  final int categoryID;
  BuildNoteListAtArchive({this.isSorted, this.categoryID});
  @override
  State<BuildNoteListAtArchive> createState() => _BuildNoteListAtArchiveState();
}

class _BuildNoteListAtArchiveState extends State<BuildNoteListAtArchive> {
  List<Note> allNotes = [];

  Settings settings = Settings();
  DatabaseHelper databaseHelper = DatabaseHelper();

  bool isSorted;
  int categoryID;
  @override
  void initState() {
    super.initState();
    isSorted = widget.isSorted;
    categoryID = widget.categoryID;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: fillAllNotesAtArchive(),
      builder: (BuildContext context, _) {
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: allNotes.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Dismissible(
                  key: Key(allNotes[index].id.toString()),
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
                          padding: const EdgeInsets.symmetric(horizontal: 70),
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
                        //   "📦",
                        //   style: TextStyle(fontSize: 30),
                        // ),
                        Icon(Icons.outbox_sharp),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70),
                          child: Text(
                            "Arşivden \nÇıkar",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),

                        // Text(
                        //   "📦",
                        //   style: TextStyle(fontSize: 30),
                        // ),
                        Icon(Icons.outbox_sharp),
                      ],
                    )),
                    color: Colors.blue,
                  ),
                  onDismissed: (direction) {
                    int noteID = allNotes[index].id;
                    print("directioon: " + direction.toString());

                    setState(() {
                      if (direction == DismissDirection.startToEnd) {
                        print("soldan saga ..."); //sil
                        allNotes.removeAt(index);
                        _areYouSureforDelete(noteID);
                      } else {
                        print("sagdan  sola...");

                        allNotes.removeAt(index);
                        // //////////////////////////////////////////////////////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////////// ////////////////////////////////////////////////////////////////////////////////////////
                        _areYouSureforDeleteArchive(noteID);
                      }
                    });
                  },
                  child: GestureDetector(
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                          color: settings.switchBackgroundColor(),
                          borderRadius: borderRadius1),
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 110,
                            width: size.width * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      allNotes[index].title.length > 10
                                          ? allNotes[index]
                                                  .title
                                                  .substring(0, 10) +
                                              "..."
                                          : allNotes[index].title,
                                      style: headerStyle5,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      databaseHelper.dateFormat(
                                          DateTime.parse(allNotes[index].time)),
                                      style: headerStyle3_2,
                                    )
                                  ],
                                ),
                                SizedBox(height: 3),
                                Text(
                                  allNotes[index].content.length > 50
                                      ? allNotes[index]
                                              .content
                                              .replaceAll("\n", "  ")
                                              .substring(0, 50) +
                                          "..."
                                      : allNotes[index].content,
                                  style: headerStyle4,
                                )
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _setPriorityIcon(allNotes[index].priority),
                              Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(allNotes[index].categoryColor),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetail(
                            updateNote: allNotes[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            );
          },
        );
      },
    );
  }

  Future fillAllNotesAtArchive() async {
    allNotes = await databaseHelper.getNoteList(1);

    allNotes.sort();
  }

  _setPriorityIcon(int priority) {
    switch (priority) {
      case 0:
        return CircleAvatar(
          child: Text(
            "Düşük",
            style: TextStyle(color: Colors.black, fontSize: 13),
          ),
          backgroundColor: Colors.green,
        );
        break;
      case 1:
        return CircleAvatar(
          child: Text(
            "Orta",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          backgroundColor: Colors.yellow,
        );
        break;
      case 2:
        return CircleAvatar(
          child: Text(
            "Yüksek",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: Colors.red,
        );
        break;
    }
  }

  Future<void> _areYouSureforDelete(int noteID) async {
    bool sonuc = await PlatformDuyarliAlertDialog(
            baslik: "Emin misiniz ?",
            icerik: "Bir note silinecek",
            anaButonYazisi: "SİL ",
            icon: Icon(Icons.delete_outline),
            iptalButonYazisi: "İPTAL")
        .goster(context);
    if (sonuc) {
      _delNote(noteID);
    }
  }

  Future _delNote(int noteID) async {
    int sonuc = await databaseHelper.deleteNote(noteID);
    if (sonuc != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Note başarıyla silindi! 👌"),
          duration: Duration(seconds: 3),
        ),
      );
      setState(() {});
    }
  }

  Future<void> _areYouSureforDeleteArchive(int noteID) async {
    bool sonuc = await PlatformDuyarliAlertDialog(
            baslik: "Emin misiniz ?",
            icerik: "Bir note arşivden çıkarılacak",
            anaButonYazisi: "Çıkar ",
            icon: Icon(Icons.outbox_sharp),
            iptalButonYazisi: "İPTAL")
        .goster(context);
    if (sonuc) {
      _delArchiveNote(noteID);
      // _delNote(noteID);
    }
  }

  // Future _delNoteAtArchive(int noteID) async {
  //   int sonuc = 1;
  //   ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //   await databaseHelper.deleteNoteAtArchive(noteID);
  //   if (sonuc != 0) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Note başarıyla silindi! 👌"),
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //     setState(() {});
  //   }
  // }

  Future _delArchiveNote(int noteID) async {
    await databaseHelper.deleteNoteAtArchive(noteID).then((value) => {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Note başarıyla arşivden çıkarıldı! 👌"),
              duration: Duration(seconds: 3),
            ),
          ),
          setState(() {})
        });

    // //////////////////////////////////////////////////////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////////// ////////////////////////////////////////////////////////////////////////////////////////
    // int sonuc = await databaseHelper.addNoteAtArchive(archiveNote);
    // if (sonuc != 0) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text("Note başarıyla arşivlendi! 👌"),
    //       duration: Duration(seconds: 3),
    //     ),
    //   );
    //   setState(() {});
    // }
  }
}
