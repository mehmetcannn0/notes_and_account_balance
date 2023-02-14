class Turler {
  int tur;
  String turTitle;
  // int color;
  String color;
  //kategory eklerken
  Turler(this.tur, this.turTitle, this.color);

  Turler.fromMap(Map<String, dynamic> map) {
    print("from map içi");
    this.turTitle = map["turTitle"];
    this.tur = map["tur"];
    this.color = map["turColor"];
    // this.color = int.parse(map["turColor"]);
  }

  ///kategorı guncellenırken
  Turler.withID(this.tur, this.turTitle, this.color);

  Map<String, dynamic> toMap() {
    print("to map içi");
    Map<String, dynamic> map = {}; //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    map["tur"] = tur;
    map["turTitle"] = turTitle;
    map["turColor"] = color.toString();

    return map;
  }
}
