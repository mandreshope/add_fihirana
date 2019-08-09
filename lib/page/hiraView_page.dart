
import 'package:add_fihirana/database/dbhelper.dart';
import 'package:add_fihirana/model/favoris.dart';
import 'package:add_fihirana/model/history.dart';
import 'package:add_fihirana/page/setting_page.dart';
import 'package:add_fihirana/utils/points_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'favoris_page.dart';
import 'home_page.dart';
// import 'package:html/dom.dart' as dom;

class HiraViewPage extends StatefulWidget {
  static const String routeName = "/hiraView";
  final String title;
  final List hiraList;

  // receive data from the FirstScreen as a parameter
  HiraViewPage({Key key, @required this.title, this.hiraList}) : super(key: key);

  @override
  _HiraViewPageState createState() => _HiraViewPageState(title, hiraList);
}

class _HiraViewPageState extends State<HiraViewPage> with SingleTickerProviderStateMixin {
  int id;
  String title;
  String content = '';
  String namelist = '';
  List hiraList = [];
  IconData star;
  bool checkStar;
  int modeSombre;
  var db = DBHelper();
  double fontSize = 14.0;

  AnimationController _animController;
  Animation<double> animation1, animation2;
  _AnimationStatus animationStatus = _AnimationStatus.end;

  int favoris;

  var history;

  _HiraViewPageState(this.title, this.hiraList); 


  String _btnSelectedVal;

  static const menuItems = <String>[
    'Favoris',
    'Paramètres',
  ];

  final List<PopupMenuItem<String>> _popUpMenuItems = menuItems
  .map(
    (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
  )
  .toList();

  void reloadSettings() {
    db.getSettings().then((onValue) {
      onValue.forEach((f) {
        setState(() {
          modeSombre = f.modeSombre;
          fontSize = f.fontSize.toDouble();
        });
      });
    });
  }

  ///
	/// Star Icon, onPress() handling
	///
  _handleStarIcon(){
      if (animationStatus == _AnimationStatus.end){
        _animController.forward().orCancel.then((_) {
          _animController.reset();
        });
      }
  }

  @override
  void initState() {
    super.initState();

    _animController = new AnimationController(
      duration: const Duration(milliseconds: 300), 
      vsync: this,
	  )
    ..addListener((){
		  setState((){

      });
	  })..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        animationStatus = _AnimationStatus.start;
      } else if (status == AnimationStatus.dismissed) {
        animationStatus = _AnimationStatus.end;
      } else {
        animationStatus = _AnimationStatus.animating;
      }
    });


    animation1 = Tween(begin: 25.0, end: 36.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve:  Curves.elasticOut,
      ),
    );

    animation2 = Tween(begin: 25.0, end: 35.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve: Interval(0.3, 1.0, curve: Curves.elasticOut), 
      ),
    );


    db.getSettings().then((onValue) {
      onValue.forEach((f) {
        setState(() {
          modeSombre = f.modeSombre;
          fontSize = f.fontSize.toDouble();
        });
      });
    });

    var d = DateTime.now().day;
    var m = DateTime.now().month;
    var y = DateTime.now().year;
    var dateNow = '${d < 10 ? '0$d': d}-${m < 10 ? '0$m': m}-$y';
    
    hiraList.forEach((f) {
      if (f.title == this.title) {
        this.id = f.id;
        this.favoris = f.favoris;
        this.title = f.title;
        this.content = f.content;
        this.namelist = f.namelist;
      }
    });

    db.setHistory(History(null, this.title, this.id, dateNow, 0));
    
  }

  @override
	void dispose(){
	  _animController.dispose();
	  super.dispose();
	}

  Widget _buildCarousel(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    var height;
    if (mediaQueryData.orientation == Orientation.landscape) {
      height = MediaQuery.of(context).size.height * 0.75;
    } else {
      height = MediaQuery.of(context).size.height * 0.85;
    }
    
    return Column(
      children: <Widget>[
        SizedBox(
          // you may want to use an aspect ratio here for tablet support
          height: height,
          child: PageView.builder(
            itemCount: hiraList.length,
            // store this controller in a State to save the carousel scroll position
            controller: PageController(
              viewportFraction: 1.0,
              initialPage: this.id-1,
            ),
            itemBuilder: (BuildContext context, int itemIndex) {
              return _buildCarouselItem(context, itemIndex);
            },
          ),
        )
      ],
    );
    
  }

  Widget _buildCarouselItem(BuildContext context, int itemIndex) {
    return ListView(
      children: <Widget>[
        Card(
          color: modeSombre == 1 ? Colors.black : Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipPath(
                clipper: PointsClipper(40),
                child: Container(
                  padding: EdgeInsets.only(bottom: 20, top: 10),
                  color: modeSombre == 1 ? Theme.of(context).primaryColor : Theme.of(context).primaryColorLight,
                  child: ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: modeSombre == 1 ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorDark,
                      child: Text(
                        '${hiraList[itemIndex].id}',
                      )
                    ),
                    title: Text(hiraList[itemIndex].title, 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      )
                    ),
                    subtitle: Text('${hiraList[itemIndex].namelist}'),
                    trailing: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Icon(Icons.star_border, size: animation1.value, color: Theme.of(context).primaryTextTheme.title.backgroundColor),

                        IconButton(
                          iconSize: animation2.value,
                          icon: hiraList[itemIndex].favoris == 1 
                            ? 
                              Icon(Icons.star, color: Theme.of(context).accentColor)
                            : 
                              Icon(Icons.star_border, color: Theme.of(context).accentColor,),
                          tooltip: 'Mettre au favoris',
                          onPressed: () {
                            _handleStarIcon();
                            
                            int i = hiraList[itemIndex].id;
                            setState(() {

                              if(hiraList[i-1].favoris == 1) {

                                HomePageState.hiraList[itemIndex].favoris = null;
                                
                                HomePageState.hiraSokajyhafa.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraFiankohofana .forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraPaska  .forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraFideranasyfankalazana.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraFanahyMasina.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraTeninAndriamanitra  .forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraFitorianafilazantsara .forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraFanatitra  .forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });


                                HomePageState.hiraFanasannyTompo .forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraKrismasy .forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraFanosoranampiasa .forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraMariazy .forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraFanolorantena  .forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraFahafatesana  .forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraFiravana.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                HomePageState.hiraFanoloranjaza .forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = null;
                                  }
                                });

                                
                                db.deleteFavoris2(hiraList[itemIndex].id);
                                db.setFavorisToTableHira(hiraList[itemIndex].id, null);
                                
                              } else {
                                HomePageState.hiraList[itemIndex].favoris = 1;

                                HomePageState.hiraSokajyhafa.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraFiankohofana .forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraPaska.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraFideranasyfankalazana.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraFanahyMasina.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraTeninAndriamanitra.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraFitorianafilazantsara.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraFanatitra.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });


                                HomePageState.hiraFanasannyTompo.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraKrismasy.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraFanosoranampiasa.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraMariazy.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraFanolorantena.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraFahafatesana.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraFiravana.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                HomePageState.hiraFanoloranjaza.forEach((f) {
                                  if(f.id == hiraList[itemIndex].id) {
                                    f.favoris = 1;
                                  }
                                });

                                var d = DateTime.now().day;
                                var m = DateTime.now().month;
                                var y = DateTime.now().year;
                                var h = DateTime.now().hour;
                                var mn = DateTime.now().minute;
                                // var s = DateTime.now().second;
                                var dateNow = '${d < 10 ? '0$d': d}-${m < 10 ? '0$m': m}-$y $h:$mn';
                                db.setFavoris2(Favoris(null, hiraList[itemIndex].title, hiraList[itemIndex].id, dateNow, 0));
                                db.setFavorisToTableHira(hiraList[itemIndex].id, 1);
                              }

                              // hiraList[itemIndex].favoris == 1  ? db.setFavoris(hiraList[itemIndex].id, null) : db.setFavoris(hiraList[itemIndex].id, 1);
                              // hiraList[itemIndex].favoris == 1 ? HomePageState.hiraList[itemIndex].favoris = null : HomePageState.hiraList[itemIndex].favoris = 1;
                            });
                          },

                        ),

                      ],
                    )
                  )
                ),
              ),
              Html(
                data: hiraList[itemIndex].content,
                defaultTextStyle: TextStyle(
                  fontSize: this.fontSize,
                ),
                padding: EdgeInsets.all(10.0),
                linkStyle: const TextStyle(
                  color: Colors.redAccent,
                  decorationColor: Colors.redAccent,
                  decoration: TextDecoration.underline,
                )
              ),
            ],
          ),
        ),
      ]
    );
  }

  void _goToSettingsPage(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    await Navigator.push(context,
    MaterialPageRoute(
      builder: (context) => SettingPage()
    ));
    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      reloadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    return new Scaffold(
        backgroundColor: modeSombre == 1 ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('ADD Fihirana'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (String newValue) {
                _btnSelectedVal = newValue;
                if(_btnSelectedVal == 'Paramètres') {
                  _goToSettingsPage(context);
                }else {
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => FavorisPage()
                    )
                  );
                }
              },
              itemBuilder: (BuildContext context) => _popUpMenuItems,
            ),
          ],
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   tooltip: 'Retour', 
          //   onPressed: () {
          //     Navigator.pop(context, this.hiraList);
          //   },
          // )
        ),
        body: ListView(
          children: <Widget>[
            _buildCarousel(context)
          ],
        ),
    );
  }
  
}

///
/// Menu animation status
///
enum _AnimationStatus { start, end, animating }