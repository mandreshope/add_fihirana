import 'package:add_fihirana/database/dbhelper.dart';
import 'package:add_fihirana/page/about_page.dart';
import 'package:add_fihirana/page/favoris_page.dart';
import 'package:add_fihirana/page/history_page.dart';
import 'package:add_fihirana/page/home_page.dart';
import 'package:add_fihirana/page/setting_page.dart';
import 'package:add_fihirana/page/themeColor.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  static restartApp(BuildContext context) {
    final _MyAppState state = context.ancestorStateOfType(const TypeMatcher<_MyAppState>());
    state.restartApp();
  }


  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  int modeSombre;
  String _theme;
  var db = DBHelper();

  void restartApp() {
    db.getSettings().then((onValue) {
      onValue.forEach((f) {
        setState(() {
          modeSombre = f.modeSombre;
          _theme = f.theme;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();

    db.getSettings().then((onValue) {
      onValue.forEach((f) {
        setState(() {
          _theme = f.theme;
          if(f.wakelock == 0) {
            Wakelock.toggle(on: false);
          }else {
            Wakelock.toggle(on: true);
          }
        });
      });
    }); 
  }

  @override
  Widget build(BuildContext context) {

    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
            primarySwatch: ThemeColor.themeColor(_theme),
            brightness: brightness,
          ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ADD Fihirana',
          theme: theme,
          home: HomePage(),
          // route for home is '/' implicitly
          routes: <String, WidgetBuilder>{
            // define the routes
            AboutPage.routeName: (BuildContext context) => new AboutPage(),
            SettingPage.routeName: (BuildContext context) => new SettingPage(),
            HistoryPage.routeName: (BuildContext context) => new HistoryPage(),
            FavorisPage.routeName: (BuildContext context) => new FavorisPage(),
          },
        );
      });
  }
  
}

