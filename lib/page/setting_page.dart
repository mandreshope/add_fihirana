import 'package:add_fihirana/database/dbhelper.dart';
import 'package:add_fihirana/main.dart';
import 'package:add_fihirana/page/themeColor.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wakelock/wakelock.dart';

class SettingPage extends StatefulWidget {
  static const String routeName = "/setting";

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double _fontSize = 14.0;
  int _modeSombre;
  bool _val = false;
  bool _checkBoxVal = false;
  int _wakelock;
  String _theme;
  var _db = DBHelper();
  final String _textPriview = """
  <br>Iza no toa Anao Tompo ô ! 
<br>Noharinao ‘zahay hitovy Aminao 
<br>Iza no toa Anao Tompo ô !
<br>‘Ndreto izahay hanandratra Anao
<br>
<br><i>&nbsp;&nbsp;&nbsp;Asandratray ny tananay 
<br>&nbsp;&nbsp;&nbsp;Mba ho an’Ilay ho avy indray 
<br>&nbsp;&nbsp;&nbsp;Asandratray ny tananay 
<br>&nbsp;&nbsp;&nbsp;Iza no toa Anao (2)
<br>&nbsp;&nbsp;&nbsp;Iza no toa Anao (tsara ianao)</i>
<br>
<br>Iza no toa Anao Tompo ô ! 
<br>Noharinao ‘zahay arak’izay tianao 
<br>Iza no toa Anao Tompo ô !
<br>Efa voahosotrao ho Anao ‘zahay
<br>
<br><i>Asandratray ...</i>
<br>
<i><br>&nbsp;&nbsp;&nbsp;Fa Tompo lanao, Mpanjakanay 
<br>&nbsp;&nbsp;&nbsp;Ireo fahagagana nataonao 
<br>&nbsp;&nbsp;&nbsp;Mahafaly anay
<br>&nbsp;&nbsp;&nbsp;Ny famonjena nahatonga anay 
<br>&nbsp;&nbsp;&nbsp;Hanam-pitsaharana
<br>&nbsp;&nbsp;&nbsp;Ray ô ! Lazanay fa tianay Ianao 
<br>&nbsp;&nbsp;&nbsp;Holazaina ny fitiavanay Anao 
<br>&nbsp;&nbsp;&nbsp;Ray ô ! Lazainay fa tianay Ianao 
<br>&nbsp;&nbsp;&nbsp;Ny fitiavanay Anao mandrakizay</i>
""";

  _SettingPageState();

  void reloadSettings() {
    _db.getSettings().then((onValue) {
      onValue.forEach((f) {
        _modeSombre = f.modeSombre;
        _theme = f.theme;
        _fontSize = f.fontSize;
        _wakelock = f.wakelock;
      });
    }); 
  }

  @override
  void initState() {
    super.initState();

    _db.getSettings().then((onValue) {
      onValue.forEach((f) {
        _modeSombre = f.modeSombre;
        _theme = f.theme;
        _modeSombre == 0 ? _val = false : _val = true;
        _fontSize = f.fontSize;
        _wakelock = f.wakelock;
        _wakelock == 0 ? _checkBoxVal = false : _checkBoxVal = true;
        setState(() {
        });
      });
    }); 
    
  }
  
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    var responsive;
    var previewC = Container(
      child: Html(
        data: _textPriview,
        defaultTextStyle: TextStyle(
          fontSize: this._fontSize,
        ),
        padding: EdgeInsets.all(10.0),
      ),
    );
    ListView listParams = ListView(
      children: <Widget>[
        Divider(),
        ListTile(
          leading: _modeSombre == 0 ? Icon(Icons.brightness_5) : Icon(Icons.brightness_4),
          title: Text('Mode sombre'),
          trailing: Switch(
            activeColor: _modeSombre == 0 ? null : Colors.white,
            onChanged: (bool value) {
              setState(() {
                _val = value;
                if(_val == true) {
                  _db.updateModeSombre(1).then((onValue) {
                    MyApp.restartApp(context);
                    changeBrightness();
                    reloadSettings();
                  });
                }
                if(_val == false) {
                  _db.updateModeSombre(0).then((onValue) {
                    MyApp.restartApp(context);
                    changeBrightness();
                    reloadSettings();
                  });
                }
                
              });
            }, 
            value: _val,
          )
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.text_format),
          title: Text('Taille de police'),
          subtitle: Slider(
            value: this._fontSize,
            inactiveColor: _modeSombre == 0 ? null : Theme.of(context).primaryColorLight,
            activeColor: _modeSombre == 0 ? null : Colors.white,
            min: 10.0,
            max: 40.0,
            onChanged: (double value) {
              setState(() {
                this._fontSize = value;
                this._db.updateFontSize(this._fontSize);
              });
            },
          ),
          trailing: CircleAvatar(child: Text('${_fontSize.round()}', style: TextStyle(color: _modeSombre == 1 ? Colors.white : Colors.black,),), radius: 20, backgroundColor: Colors.transparent,)
        ),

        Divider(),

        ListTile(
          leading: Icon(Icons.phone_android),
          title: Text('Rester activé'),
          subtitle: Text("L'écran ne se met jamais en veille"),
          trailing: Checkbox(
            value: _checkBoxVal,
            checkColor: _modeSombre == 0 ? null : Colors.black,
            activeColor: _modeSombre == 0 ? null : Colors.white,
            onChanged: (bool value) {
              setState(() {
                this._checkBoxVal = value;
                this._checkBoxVal == false ? this._db.updateWakelock(0) : this._db.updateWakelock(1) ;
                Wakelock.toggle(on: value);
              });
            }, 

          )
        ),

        Divider(),

        ListTile(
          leading: Icon(Icons.color_lens), 
          title: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('Thème')
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(5.0),
                    width: 20.0,
                    height: 20.0,
                    color: ThemeColor.themeColor(_theme)
                  )
                ],
              )
            ],
          ),
          onTap: () {
            // Or: showModalBottomSheet(), with model bottom sheet, clicking
            // anywhere will dismiss the bottom sheet.
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black12)),
                ),
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: RaisedButton(
                              color: Colors.purple,
                              onPressed: () {
                                this._db.updateTheme('purple').then((val) {
                                  MyApp.restartApp(context);
                                  reloadSettings();
                                });
                              },
                            ),
                            margin: EdgeInsets.all(5.0),
                            width: 40.0,
                            height: 40.0,
                            color: Colors.purple,
                          ),
                          Container(
                            child: RaisedButton(
                              color: Colors.green,
                              onPressed: () {
                                this._db.updateTheme('green').then((val) {
                                  MyApp.restartApp(context);
                                  reloadSettings();
                                });
                              },
                            ),
                            margin: EdgeInsets.all(5.0),
                            width: 40.0,
                            height: 40.0,
                            color: Colors.green,
                          ),
                          Container(
                            child: RaisedButton(
                              color: Colors.pink,
                              onPressed: () {
                                this._db.updateTheme('pink').then((val) {
                                  MyApp.restartApp(context);
                                  reloadSettings();
                                });
                              },
                            ),
                            margin: EdgeInsets.all(5.0),
                            width: 40.0,
                            height: 40.0,
                            color: Colors.pink,
                          ),
                          Container(
                            child: RaisedButton(
                              color: Colors.blueGrey,
                              onPressed: () {
                                this._db.updateTheme('blueGrey').then((val) {
                                  MyApp.restartApp(context);
                                  reloadSettings();
                                });
                              },
                            ),
                            margin: EdgeInsets.all(5.0),
                            width: 40.0,
                            height: 40.0,
                            color: Colors.blueGrey,
                          ),
                          Container(
                            child: RaisedButton(
                              color: Colors.indigo,
                              onPressed: () {
                                this._db.updateTheme('indigo').then((val) {
                                  MyApp.restartApp(context);
                                  reloadSettings();
                                });
                              },
                            ),
                            margin: EdgeInsets.all(5.0),
                            width: 40.0,
                            height: 40.0,
                            color: Colors.blueGrey,
                          ),
                        ],
                      )
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: RaisedButton(
                              color: Colors.red,
                              onPressed: () {
                                this._db.updateTheme('red').then((val) {
                                  MyApp.restartApp(context);
                                  reloadSettings();
                                });
                              },
                            ),
                            margin: EdgeInsets.all(5.0),
                            width: 40.0,
                            height: 40.0,
                            color: Colors.red,
                          ),
                          Container(
                            child: RaisedButton(
                              color: Colors.blue,
                              onPressed: () {
                                this._db.updateTheme('blue').then((val) {
                                  MyApp.restartApp(context);
                                  reloadSettings();
                                });
                              },
                            ),
                            margin: EdgeInsets.all(5.0),
                            width: 40.0,
                            height: 40.0,
                            color: Colors.blue,
                          ),
                          Container(
                            child: RaisedButton(
                              color: Colors.deepOrange,
                              onPressed: () {
                                this._db.updateTheme('deepOrange').then((val) {
                                  MyApp.restartApp(context);
                                  reloadSettings();
                                });
                              },
                            ),
                            margin: EdgeInsets.all(5.0),
                            width: 40.0,
                            height: 40.0,
                            color: Colors.deepOrange,
                          ),
                          Container(
                            child: RaisedButton(
                              color: Colors.teal,
                              onPressed: () {
                                this._db.updateTheme('teal').then((val) {
                                  MyApp.restartApp(context);
                                  reloadSettings();
                                });
                              },
                            ),
                            margin: EdgeInsets.all(5.0),
                            width: 40.0,
                            height: 40.0,
                            color: Colors.teal,
                          ),
                          Container(
                            child: RaisedButton(
                              color: Colors.cyan,
                              onPressed: () {
                                this._db.updateTheme('cyan').then((val) {
                                  MyApp.restartApp(context);
                                  reloadSettings();
                                });
                              },
                            ),
                            margin: EdgeInsets.all(5.0),
                            width: 40.0,
                            height: 40.0,
                            color: Colors.blueGrey,
                          ),
                        ],
                      )
                    )
                  ],
                ),
              ),
            );
          },
        ),
        Divider(),
      ],
    );
    if (mediaQueryData.orientation == Orientation.landscape) {
      responsive = Row(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width*0.5,
            child: SingleChildScrollView(
              child: previewC,
            ),
          ),
          SizedBox.fromSize(
            size: Size(MediaQuery.of(context).size.width*0.5, MediaQuery.of(context).size.height),
            child: listParams,
          ),
        ],
      );
    } else {
      responsive = Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height*0.4,
            child: SingleChildScrollView(
              child: previewC,
            )
          ),
          SizedBox.fromSize(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height*0.43),
            child: listParams,
          )
        ],
      );
    }
    return new Scaffold(
      backgroundColor: _modeSombre == 1 ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: responsive,
      
    );
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

}
