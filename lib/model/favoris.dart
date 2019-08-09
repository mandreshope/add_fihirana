class Favoris{

  int id;
  String title;
  int idHira;
  String date;
  bool check = false;
  int checked;
  
  Favoris(this.id, this.title, this.idHira, this.date, this.checked);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["_id"] = id;
    map["title"] = title;
    map["id_table_hira"] = idHira;
    map["date"] = date;
    map["checked"] = checked;

    if (id != null) {
      map["_id"] = id;
    }
    
    return map;
  }
  
}