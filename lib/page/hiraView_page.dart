
import 'package:add_fihirana/database/dbhelper.dart';
import 'package:add_fihirana/model/favoris.dart';
import 'package:add_fihirana/model/history.dart';
import 'package:add_fihirana/page/setting_page.dart';
import 'package:add_fihirana/utils/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
  int carouselIndex;
  bool inputIsValid = true;
  String errorText;


  AnimationController _animController;
  Animation<double> animation1, animation2;
  _AnimationStatus animationStatus = _AnimationStatus.end;

  String message = "";
  ScrollController _controller;
  dynamic _offset = 80.0;
  dynamic _offsetExtend = 0.0;
  bool isHidden = false;

  int favoris;

  var history;

  _HiraViewPageState(this.title, this.hiraList); 


  int _btnSelectedVal;

  static const menuItems = <int>[
    0,
    1,
  ];

  static const icon = <Icon>[
    Icon(Icons.stars,),
    Icon(Icons.settings,),
  ];

  static const titleM = <String>[
    'Favoris',
    'Paramètres'
  ];




  final List<PopupMenuItem<int>> _popUpMenuItems = menuItems
  .map(
    (int val) => PopupMenuItem<int>(
          value: val,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: icon[val],
              ),
              
              Text(titleM[val]),
            ],
          ),
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

  _scrollListener() {
    setState(() {
      this._offsetExtend = _controller.position.maxScrollExtent.roundToDouble();
      this._offset = _controller.offset.roundToDouble();
      this._offset = (_offsetExtend-_offset);
    });
    
  }

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();

    _controller.addListener(_scrollListener);


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
        this.carouselIndex = f.id;
      }
    });

    db.setHistory(History(null, this.title, this.id, dateNow, 0));
    
  }

  @override
	void dispose(){
	  _animController.dispose();
    _controller.removeListener(_scrollListener);
    _controller.dispose();
	  super.dispose();
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

    final mediaQueryData = MediaQuery.of(context);
    final double height = mediaQueryData.size.height;
    // double height;
    // if (mediaQueryData.orientation == Orientation.landscape) {
    //   height = mediaQueryData.size.height;
    // } else {
    //   height = mediaQueryData.size.height;
    // }

    var carouselSlider = CarouselSlider(
        onPageChanged: (i) {
        setState(() {
          carouselIndex = i+1;
        });
        },
        enableInfiniteScroll: false,
        autoPlay: false,
        height: height,
        enlargeCenterPage: true,
        realPage: hiraList.length,
        viewportFraction: 1.0,
        initialPage: this.id-1,
        items: hiraList.map((e) {
          return SingleChildScrollView(
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: modeSombre == 1 ? Theme.of(context).primaryColor : Theme.of(context).primaryColorLight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10, top: 10),
                      color: modeSombre == 1 ? Theme.of(context).primaryColor : Theme.of(context).primaryColorLight,
                      child: ListTile(
                        dense: true,
                        title: Text(e.title, 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          )
                        ),
                        subtitle: Text('${e.namelist}'),
                        trailing: Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Icon(Icons.star_border, size: animation1.value, color: Theme.of(context).primaryTextTheme.title.backgroundColor),

                            IconButton(
                              iconSize: animation2.value,
                              icon: e.favoris == 1 
                                ? 
                                  Icon(Icons.star, color: Theme.of(context).accentColor)
                                : 
                                  Icon(Icons.star_border, color: Theme.of(context).accentColor,),
                              tooltip: 'Mettre aux favoris',
                              onPressed: () {
                                _handleStarIcon();
                                
                                int i = e.id;
                                setState(() {

                                  if(hiraList[i-1].favoris == 1) {

                                    HomePageState.hiraList[e.id-1].favoris = null;
                                    
                                    HomePageState.hiraSokajyhafa.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraFiankohofana .forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraPaska  .forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraFideranasyfankalazana.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraFanahyMasina.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraTeninAndriamanitra  .forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraFitorianafilazantsara .forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraFanatitra  .forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });


                                    HomePageState.hiraFanasannyTompo .forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraKrismasy .forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraFanosoranampiasa .forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraMariazy .forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraFanolorantena  .forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraFahafatesana  .forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraFiravana.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    HomePageState.hiraFanoloranjaza .forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = null;
                                      }
                                    });

                                    
                                    db.deleteFavoris2(e.id);
                                    db.setFavorisToTableHira(e.id, null);
                                    
                                  } else {
                                    HomePageState.hiraList[e.id-1].favoris = 1;

                                    HomePageState.hiraSokajyhafa.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraFiankohofana .forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraPaska.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraFideranasyfankalazana.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraFanahyMasina.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraTeninAndriamanitra.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraFitorianafilazantsara.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraFanatitra.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });


                                    HomePageState.hiraFanasannyTompo.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraKrismasy.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraFanosoranampiasa.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraMariazy.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraFanolorantena.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraFahafatesana.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraFiravana.forEach((f) {
                                      if(f.id == e.id) {
                                        f.favoris = 1;
                                      }
                                    });

                                    HomePageState.hiraFanoloranjaza.forEach((f) {
                                      if(f.id == e.id) {
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
                                    db.setFavoris2(Favoris(null, e.title, e.id, dateNow, 0));
                                    db.setFavorisToTableHira(e.id, 1);
                                  }

                                  // e.favoris == 1  ? db.setFavoris(e.id, null) : db.setFavoris(e.id, 1);
                                  // e.favoris == 1 ? HomePageState.e.favoris = null : HomePageState.e.favoris = 1;
                                });
                              },

                            ),

                          ],
                        )
                      )
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20) ),
                    child: Html(
                      backgroundColor: modeSombre == 1 ? Colors.black : Colors.white,
                      data: e.content,
                      defaultTextStyle: TextStyle(
                        fontSize: this.fontSize,
                      ),
                      padding: EdgeInsets.only(left: 15, right: 15),
                      linkStyle: const TextStyle(
                        color: Colors.redAccent,
                        decorationColor: Colors.redAccent,
                        decoration: TextDecoration.underline,
                      )
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      );

    var nestedScrollView = NestedScrollView(
      dragStartBehavior: DragStartBehavior.down,
      controller: _controller,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget> [
          SliverAppBar(
            pinned: true,
            title: Text('ADD Fihirana'),
            actions: <Widget>[
              PopupMenuButton<int>(
                onSelected: (int newValue) {
                  _btnSelectedVal = newValue;
                  if(_btnSelectedVal == 1) {
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
          ),

        ];
      },
      body: carouselSlider,
      
    );
    return Scaffold(
      body: nestedScrollView,
      backgroundColor: modeSombre == 1
              ? Colors.black
              : Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: Container(
        height: this._offset*0.88,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: IconButton(
                    iconSize: (this._offset/2)*0.88,
                      icon: Icon(Icons.arrow_left),
                      onPressed: () { 
                      carouselSlider.previousPage(duration: Duration(microseconds: 1), curve: Curves.linear);
                      }
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: CircleAvatar(
                      radius: this._offset/3,
                      backgroundColor: Theme.of(context).primaryColorDark,
                      child: Text('$carouselIndex', style: TextStyle(fontSize: this._offset/4),)
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: IconButton(
                    iconSize: (this._offset/2)*0.88,
                      icon: Icon(Icons.arrow_right),
                      onPressed: () { 
                      carouselSlider.nextPage(duration: Duration(microseconds: 1), curve: Curves.linear);
                      }
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
}

///
/// Menu animation status
///
enum _AnimationStatus { start, end, animating }