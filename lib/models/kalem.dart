// import 'package:flutter/cupertino.dart';

class Kalem {
  int id;
  int tur;
  String baslik;
  int miktar;
  String tarih;

  Kalem(this.tur, this.baslik, this.miktar, this.tarih);
  Kalem.withID(this.id, this.tur, this.baslik, this.miktar, this.tarih);
  Kalem.fromMap(Map map) {
    this.id = map["id"];
    this.tur = map["tur"];
    this.baslik = map["baslik"];
    this.miktar = map["miktar"];
    this.tarih = map["tarih"];
    // print("from map içi ${this.id} ${this.baslik} ${this.tarih}");
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "tur": tur,
        "baslik": baslik,
        "miktar": miktar,
        "tarih ": tarih,
      };
}
