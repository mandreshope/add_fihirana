class Settings{

  int id;
  int modeSombre;
  double fontSize;
  String theme;
  int wakelock;
  
  Settings(this.id, this.modeSombre, this.fontSize, this.theme, this.wakelock);

  Map<dynamic, dynamic> toMap() {
    var map = Map<dynamic, dynamic>();
    map["_id"] = id;
    map["modeSombre"] = modeSombre;
    map["fontSize"] = fontSize;
    map["theme"] = theme;
    map["wakelock"] = wakelock;
    
    return map;
  }
  
}