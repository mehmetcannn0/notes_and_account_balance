// class Note implements Comparable<Note> {
class Note implements Comparable<Note> {
  int id; //db deki
  int noteID;
  int categoryID;
  String categoryTitle;
  int categoryColor;
  String title;
  String content;
  String time;
  int priority;
  int archive;
  Note(
    this.categoryID,
    this.title,
    this.content,
    this.time,
    this.priority,
    this.archive,
  );
  Note.withID(
    this.id,
    this.categoryID,
    this.title,
    this.content,
    this.time,
    this.priority,
    this.archive,
  );
  Note.all(
    this.id,
    this.categoryID,
    this.categoryTitle,
    this.categoryColor,
    this.title,
    this.content,
    this.time,
    this.priority,
    this.archive,
  );

  Note.fromMap(Map map) {
    this.id = map["id"];
    this.categoryID = map["categoryID"];
    this.categoryTitle = map["categoryTitle"];
    this.categoryColor = int.parse(map["categoryColor"]);
    this.title = map["noteTitle"];
    this.content = map["content"];
    this.time = map["time"];
    this.priority = map["priority"];
    this.archive = map["archive"];
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "categoryID": categoryID,
        "noteTitle": title,
        "content": content,
        "time": time,
        "priority": priority,
        "archive": archive
      };
  @override
  int compareTo(Note other) {
    if (this.priority > other.priority) {
      return -1;
    } else if (this.priority < other.priority) {
      return 1;
    } else {
      return 0;
    }
  }
}
