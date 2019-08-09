class Hira{

  int id;
  String namelist;
  int page;
  String title;
  String content;
  int favoris;
  
  Hira(this.id, this.namelist, this.page, this.title, this.content, this.favoris);

  Map<dynamic, dynamic> toMap() {
    var map = Map<dynamic, dynamic>();
    map["_id"] = id;
    map["namelist"] = namelist;
    map["page"] = page;
    map["title"] = title;
    map["content"] = content;
    map["favoris"] = favoris;
    
    return map;
  }
  
}