class Settings{

  int id;
  int modeSombre;
  double fontSize;
  String theme;
  
  Settings(this.id, this.modeSombre, this.fontSize, this.theme);

  Map<dynamic, dynamic> toMap() {
    var map = Map<dynamic, dynamic>();
    map["_id"] = id;
    map["modeSombre"] = modeSombre;
    map["fontSize"] = fontSize;
    map["theme"] = theme;
    
    return map;
  }
  
}