class History{

  int id;
  String title;
  int idHira;
  String date;
  
  History(this.id, this.title, this.idHira, this.date);

  History.map(dynamic obj) {
    this.id = obj["id"];
    this.title = obj["title"];
    this.idHira = obj["idHira"];
    this.date = obj["date"];
  }
  
  History.fromMap(Map map) {
    id = map[id];
    title = map[title];
    idHira = map[idHira];
    date = map[date];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["_id"] = id;
    map["title"] = title;
    map["id_table_hira"] = idHira;
    map["date"] = date;

    if (id != null) {
      map["_id"] = id;
    }
    
    return map;
  }
  
}