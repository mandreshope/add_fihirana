import 'package:add_fihirana/database/dbhelper.dart';
import 'package:add_fihirana/main.dart';
import 'package:add_fihirana/page/themeColor.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  static const String routeName = "/setting";

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double _fontSize = 14.0;
  int _modeSombre;
  bool _val = false;
  String _theme;
  var _db = DBHelper();

  _SettingPageState();

  void reloadSettings() {
    _db.getSettings().then((onValue) {
      onValue.forEach((f) {
        _modeSombre = f.modeSombre;
        _theme = f.theme;
        _fontSize = f.fontSize;
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
        setState(() {
          
        });
      });
    }); 
    
    
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: ListView(
        children: <Widget>[
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
                  }else {
                    _db.updateModeSombre(0).then((onValue) {
                      MyApp.restartApp(context);
                      changeBrightness();
                      reloadSettings();
                    });
                  }
                  // _val = value;
                  // _val == true ? _db.updateModeSombre(1) : _db.updateModeSombre(0);
                  // _val == true ? MyApp.restartApp(context) : MyApp.restartApp(context);
                  // _val == true ? reloadSettings() : reloadSettings();
                  // _val == true ? changeBrightness() : changeBrightness();
                  
                });
              }, 
              value: _val,
            )
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.text_format),
            title: Text('Font Size'),
            subtitle: Slider(
              value: this._fontSize,
              activeColor: _modeSombre == 0 ? null : Colors.white,
              min: 10.0,
              max: 40.0,
              divisions: 40,
              label: '${_fontSize.round()}',
              onChanged: (double value) {
                setState(() {
                  this._fontSize = value;
                  this._db.updateFontSize(this._fontSize);
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
      )
    );
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

}
