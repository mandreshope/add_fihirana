class Hira{

  int id;
  String namelist;
  int page;
  String title;
  String content;
  int favoris;
  String dateUpdate;
  
  Hira(this.id, this.namelist, this.page, this.title, this.content, this.favoris, this.dateUpdate,);

  Hira.map(dynamic obj) {
    this.id = obj["id"];
    this.namelist = obj["namelist"];
    this.page = obj["page"];
    this.title = obj["title"];
    this.content = obj["content"];
    this.favoris = obj["favoris"];
    this.dateUpdate = obj["dateUpdate"];
  }
  
  Hira.fromMap(Map map) {
    id = map[id];
    namelist = map[namelist];
    page = map[page];
    title = map[title];
    content = map[content];
    favoris = map[favoris];
    dateUpdate = map[dateUpdate];
  }

  Map<dynamic, dynamic> toMap() {
    var map = Map<dynamic, dynamic>();
    map["_id"] = id;
    map["namelist"] = namelist;
    map["page"] = page;
    map["title"] = title;
    map["content"] = content;
    map["favoris"] = favoris;
    map["dateUpdate"] = dateUpdate;
    
    return map;
  }
  
}