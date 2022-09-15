import 'package:flutter/material.dart';
import 'package:notes/models/turler.dart';
import 'package:notes/services/database_helper.dart';

class TurListesi extends StatefulWidget {
  List<Turler> turler;

  TurListesi(this.turler);

  @override
  State<TurListesi> createState() => _TurListesiState();
}

class _TurListesiState extends State<TurListesi> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  int lenght;
  bool readed = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Hoşgeldiniz 🥳\n" + "Hiçbir gelir/gider eklemediniz 😊",
                style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
              ),
            ),
          );
        } else {
          return Container(
            height: MediaQuery.of(context).size.height * 0.73,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  child: Card(
                    color: widget.turler[index].tur == 1
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
                                  color: Colors.deepPurpleAccent, width: 1)),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "₺" + widget.turler[index].tur.toString(),
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
                              widget.turler[index].turTitle,
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
                    print("basilan turun id si : " +
                        widget.turler[index].tur.toString());
                  },
                );
              },
              itemCount: widget.turler.length,
            ),
          );
        }
      },
    );
  }

  Future fillAllkalem() async {
    int lenghtLocal;
    print("fill all kalem içi tur list len ");
    widget.turler = await databaseHelper.getTurList();
    lenghtLocal = widget.turler.length;
    setState(() {
      lenght = lenghtLocal;
      print("fill all kalem içi tur list lenght: " + lenght.toString());
      readed = true;
    });
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
