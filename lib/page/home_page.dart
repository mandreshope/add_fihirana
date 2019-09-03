import 'package:add_fihirana/database/dbhelper.dart';
import 'package:add_fihirana/model/favoris.dart';
import 'package:add_fihirana/model/hira.dart';
import 'package:add_fihirana/page/about_page.dart';
import 'package:add_fihirana/page/favoris_page.dart';
import 'package:add_fihirana/page/hiraView_page.dart';
import 'package:add_fihirana/page/history_page.dart';
import 'package:add_fihirana/page/setting_page.dart';
import 'package:add_fihirana/utils/diagonal_path_clipper_1.dart';
import 'package:add_fihirana/utils/share.dart';
import 'package:add_fihirana/utils/shimmer.dart';
import 'package:add_fihirana/utils/wave_clipper_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:material_search/material_search.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  static const String routeName = "/home";

  // receive data from the FirstScreen as a parameter
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {

  static List<Hira> hiraList = [];
  String skHiraList = 'No one';
  static List<Hira> hiraSokajyhafa = [];
  static List<Hira> hiraFiankohofana = [];
  static List<Hira> hiraPaska  = [];
  static List<Hira> hiraFideranasyfankalazana = [];
  static List<Hira> hiraFanahyMasina = [];
  static List<Hira> hiraTeninAndriamanitra  = [];
  static List<Hira> hiraFitorianafilazantsara = [];
  static List<Hira> hiraFanatitra  = [];
  static List<Hira> hiraFanasannyTompo = [];
  static List<Hira> hiraKrismasy = [];
  static List<Hira> hiraFanosoranampiasa = [];
  static List<Hira> hiraMariazy = [];
  static List<Hira> hiraFanolorantena = [];
  static List<Hira> hiraFahafatesana = [];
  static List<Hira> hiraFiravana = [];
  static List<Hira> hiraFanoloranjaza = [];
  static const int lengthOfTab = 16;

  ScrollController _scrollcontroller;
  dynamic _offset = 0.0;

  bool _sortAlfabet = false;
  bool _searchIsHidden = false;

  int modeSombre;
  var db = DBHelper();

  Future<void> launched;
  // String _phone = '0330297426';
  String _linkToShareAddFihirana = 'https://add-fihirana.fr.aptoide.com/';
  // https://web.facebook.com/pg/addfihirana/about/

  AnimationController _animController;
  AnimationController _animController2;
  Animation<double> animation1, animation2, animation3, animation4, animationTitleBar;
  _AnimationStatus animationStatus = _AnimationStatus.end;

  bool inputIsValid = true;
  var valueText;
  int menuSelected = 0;

  bool randomBool = false;

  static const menuItems = <String>[
    'Rechercher par titre',
    'Rechercher par numéro',
  ];


  void reloadHiraList() {
    hiraList.clear();
    db.getSongs().then((onValue) {
      setState(() {
        hiraList.addAll(onValue);
      });
    });
  }

  void reloadSettings() {
    db.getSettings().then((onValue) {
      onValue.forEach((f) {
        setState(() {
          modeSombre = f.modeSombre;
        });
      });
    });
  }

  // Future<void> _launchInBrowser(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url, forceSafariVC: false, forceWebView: false);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  _scrollListener() {
    setState(() {
      this._offset = _scrollcontroller.offset.roundToDouble();
      if(this._offset >= 174.0) {
        _searchIsHidden = true;
        _animController.reverse();
        randomBool = Random().nextBool();
        _animController2.forward();
      }else  {
        _searchIsHidden = false;
        _animController.forward();
        _animController2.reset();
      }
    });
    
  }

  @override
  void initState() {
    super.initState();

    _scrollcontroller = ScrollController();

    _scrollcontroller.addListener(_scrollListener);

    db.getSettings().then((onValue) {
      onValue.forEach((f) {
        setState(() {
          modeSombre = f.modeSombre;
        });
      });
    });

    db.getSongs().then((onValue) {
      hiraList.addAll(onValue);
      setState(() {});
      _animController.forward();
    });

    db.getCategorySongs('Sokajy hafa').then((onValue) {
      hiraSokajyhafa.addAll(onValue);
      setState(() {

      });
    });

    db.getCategorySongs('Fiankohofana').then((onValue) {
      hiraFiankohofana.addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('Paska').then((onValue) {
      hiraPaska.addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('Fiderana sy fankalazana').then((onValue) {
      hiraFideranasyfankalazana.addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('Fanahy Masina').then((onValue) {
      hiraFanahyMasina.addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs("Tenin'Andriamanitra").then((onValue) {
      hiraTeninAndriamanitra.addAll(onValue);
      setState(() {});
    });


    db.getCategorySongs('Fitoriana filazantsara').then((onValue) {
      hiraFitorianafilazantsara.addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('Fanatitra').then((onValue) {
      hiraFanatitra.addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs("Fanasan'ny Tompo").then((onValue) {
      hiraFanasannyTompo.addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('Krismasy').then((onValue) {
      hiraKrismasy.addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('Fanosorana mpiasa').then((onValue) {
      hiraFanosoranampiasa  .addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('Mariazy').then((onValue) {
      hiraMariazy  .addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('Fanoloran-tena').then((onValue) {
      hiraFanolorantena  .addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('Fahafatesana').then((onValue) {
      hiraFahafatesana  .addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('Firavana').then((onValue) {
      hiraFiravana  .addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('Fanoloran-jaza').then((onValue) {
      hiraFanoloranjaza.addAll(onValue);
      setState(() {});
    });

    _animController = new AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
	  );

    _animController2 = new AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
	  );

    animationTitleBar = Tween(begin: 1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController2,
          curve:  Curves.linear,
      ),
    );

    animation1 = Tween(begin: 1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve:  Curves.fastOutSlowIn,
      ),
    );

    animation2 = Tween(begin: -1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn), 
      ),
    );

    animation3 = Tween(begin: 1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve: Interval(0.7, 1.0, curve: Curves.fastOutSlowIn), 
      ),
    );

    animation4 = Tween(begin: 1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve: Interval(0.9, 1.0, curve: Curves.fastOutSlowIn), 
      ),
    );

  }

  @override
	void dispose(){
	  _animController.dispose();
    _scrollcontroller.removeListener(_scrollListener);
    _scrollcontroller.dispose();
	  super.dispose();
	}

  ListView hiraListWidget(List<Hira> hiraList2) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 5.0),
      itemCount: hiraList2.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 0,
          child: ListTile(
            onTap: () {
              _goToHiraViewPage(context, hiraList2[index].id);
            },
            dense: true,
            leading: CircleAvatar(
                child: Text(hiraList2[index].title.substring(0, 1),)
            ),
            title: Text(
              hiraList2[index].title,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                    hiraList2[index].id.toString() +
                    ' • ' +
                    hiraList2[index].namelist,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            trailing: IconButton(
              icon: hiraList2[index].favoris == 1
                ? 
                  Icon(Icons.star, color: Theme.of(context).accentColor,)
                : 
                  Icon(Icons.star_border, color: Theme.of(context).primaryColorLight,),
              onPressed: () {
                setState(() {
                  if(hiraList2[index].favoris == 1 ) {

                    hiraList[hiraList2[index].id-1].favoris = null;

                    hiraList2[index].favoris = null;

                    db.deleteFavoris2(hiraList2[index].id).then((onValue){});
                    db.setFavorisToTableHira(hiraList2[index].id, null);
                    
                  } else {
                    hiraList[hiraList2[index].id-1].favoris = 1;

                    hiraList2[index].favoris = 1;

                    var d = DateTime.now().day;
                    var m = DateTime.now().month;
                    var y = DateTime.now().year;
                    var h = DateTime.now().hour;
                    var mn = DateTime.now().minute;
                    // var s = DateTime.now().second;
                    var dateNow = '${d < 10 ? '0$d': d}-${m < 10 ? '0$m': m}-$y $h:$mn';
                    // mandeha
                    db.setFavoris2(Favoris(null, hiraList2[index].title, hiraList2[index].id, dateNow, 0));
                    db.setFavorisToTableHira(hiraList2[index].id, 1);
                  }
                });
              },

            ), 
          ),
        );
      }
    );
  }

  _buildMaterialSearchPage(BuildContext context) {
    return new MaterialPageRoute<String>(
        settings: new RouteSettings(
            name: 'material_search',
            isInitialRoute: true,
        ),
        builder: (BuildContext context) {
          return new Material(
            child: new MaterialSearch<String>(
              barBackgroundColor: modeSombre == 1
                  ? ThemeData.dark().backgroundColor
                  : Colors.white,
              iconColor: modeSombre == 1 ? Colors.white : Colors.black,
              placeholder: 'Tapez le titre ou le numéro...',
              results: hiraList
                  .map((Hira v) => new MaterialSearchResult<String>(
                        icon: Icons.queue_music,
                        value: '${v.id}${v.title}',
                        text: "${v.id}. ${v.title}",
                      ))
                  .toList(),
              filter: (dynamic value, String criteria) {
                return value.toLowerCase().trim().contains(
                    new RegExp(r'' + criteria.toLowerCase().trim() + ''));
              },
              onSelect: (dynamic value) {
                _searchgoToHiraViewPage(context, value);
              },
            ),
          );
        });
  }

  _showMaterialSearch(BuildContext context) {
    Navigator.of(context)
        .push(_buildMaterialSearchPage(context))
        .then((dynamic value) {
      setState(() => skHiraList = value as String);
    });
  }
  

  void _searchgoToHiraViewPage(BuildContext context, value) async {
    // start the SecondScreen and wait for it to finish with a result
    pigLatin(String value) => value.replaceAllMapped(
        RegExp(r"[0-9]*", multiLine: true),
        (Match m) => "${''}");
    print(pigLatin(value));
    
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HiraViewPage(
                  title: pigLatin(value),
                  hiraList: hiraList,
                )));
    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      reloadSettings();
    });
  }

  void _goToHiraViewPage(BuildContext context, index) async {
    // start the SecondScreen and wait for it to finish with a result
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HiraViewPage(
                  title: hiraList[index - 1].title,
                  hiraList: hiraList,
                )));
    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      reloadSettings();
    });
  }

  void _goToFavorisPage(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => FavorisPage()));
    // after the SecondScreen result comes back update the Text widget with it
    // setState(() {
    //   reloadHiraList();
    // });
  }

  void _goToSettingsPage(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingPage()));
    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      reloadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final drawerHeader = Center(
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: DiagonalPathClipperOne(),
            child: Container(
              height: 220.0,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: modeSombre == 1
                    ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/music_clip.png'),
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/logoaddf.png',
                            fit: BoxFit.fill,
                            width: 50.0,
                            height: 50.0,
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 5,
                          ),
                          Text('ADD FIHIRANA', style: TextStyle(
                              color: Theme.of(context).primaryTextTheme.title.color,
                              fontSize: 18,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold
                            ),),
                          Divider(
                            color: Colors.transparent,
                          ),
                          Text('FIHIRANA ASSEMBLEE DE DIEU MADAGASCAR', style: TextStyle(
                              color: Theme.of(context).primaryTextTheme.title.color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                            ),),
                        
                        ],
                      ),
                    )
                    : Container(
                      width: width,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/music_clip.png'),
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/logoaddf.png',
                            fit: BoxFit.fill,
                            width: 50.0,
                            height: 50.0,
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 5,
                          ),
                          
                          Text('ADD FIHIRANA', style: TextStyle(
                              color: Theme.of(context).primaryTextTheme.title.color,
                              fontSize: 18,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold
                            ),),
                          Divider(
                            color: Colors.transparent,
                          ),
                          Text('FIHIRANA ASSEMBLEE DE DIEU MADAGASCAR', style: TextStyle(
                              color: Theme.of(context).primaryTextTheme.title.color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                            ),),
                        
                        ],
                      ),
                    )
              ),
            ),
          ),
          
        ],
      )
    );

    final drawerItems = SingleChildScrollView(
      child: Column(
      children: <Widget>[
        drawerHeader,
        ListTile(
          leading: Icon(
            Icons.stars,
            color: modeSombre == 1
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).primaryColor,
          ),
          title: Text('Favoris'),
          onTap: () {
            Navigator.pop(context); // close the drawer
            _goToFavorisPage(context);
            // Navigator.of(context).pushNamed(FavorisPage.routeName);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.history,
            color: modeSombre == 1
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).primaryColor,
          ),
          title: Text('Historiques'),
          onTap: () {
            Navigator.pop(context); // close the drawer
            Navigator.of(context).pushNamed(HistoryPage.routeName);
            // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AboutPage()));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.settings,
            color: modeSombre == 1
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).primaryColor,
          ),
          title: Text('Paramètres'),
          onTap: () {
            Navigator.pop(context); // close the drawer
            _goToSettingsPage(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.share,
            color: modeSombre == 1
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).primaryColor,
          ),
          title: Text('Partager l\'application'),
          onTap: () {
            Navigator.pop(context);
            // Navigator.pop(context); // close the drawer
            // setState(() {
            //   this.launched = _launchInBrowser(_addFihiranaUrl);
            //   // this._launched = _makePhoneCall('tel:$_phone');
            // });
            final RenderBox box = context.findRenderObject();
            Share.plainText(
              text: 'Tiako be ity application ity 😍😃: $_linkToShareAddFihirana'
            ).share(sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.info,
            color: modeSombre == 1
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).primaryColor,
          ),
          title: Text('A propos de l\'application'),
          onTap: () {
            Navigator.pop(context); // close the drawer
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AboutPage()));
          },
        )
      ],
    ),
    );

    var noData = ListView(
      padding:
          EdgeInsets.only(top: 5.0, left: 5.0),
      children: <Widget>[
        Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            children: [0, 1, 2, 4, 5, 6]
                .map((_) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                      ),
                      title: Container(
                        height: 8.0,
                        color: Colors.white,
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Container(
                            height: 7.0,
                            width: width/4,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.star_border),
                        onPressed: (){},
                      ),
                          
                    ))
                .toList(),
          ),
        ),
      ],
    );

    var hiraListSokajyhafa = hiraListWidget(hiraSokajyhafa );
    var hiraListFiankohofana = hiraListWidget(hiraFiankohofana );
    var hiraListPaska = hiraListWidget(hiraPaska  );
    var hiraListFideranasyfankalazana = hiraListWidget(hiraFideranasyfankalazana );
    var hiraListFanahyMasina = hiraListWidget(hiraFanahyMasina );
    var hiraListTeninAndriamanitra = hiraListWidget(hiraTeninAndriamanitra  );
    var hiraListFitorianafilazantsara = hiraListWidget(hiraFitorianafilazantsara );
    var hiraListFanatitra = hiraListWidget(hiraFanatitra  );
    var hiraListFanasannyTompo = hiraListWidget(hiraFanasannyTompo );

    var hiraListKrismasy  = hiraListWidget(hiraKrismasy );
    var hiraListFanosoranampiasa  = hiraListWidget(hiraFanosoranampiasa );
    var hiraListMariazy  = hiraListWidget(hiraMariazy );
    var hiraListFanolorantena  = hiraListWidget(hiraFanolorantena );
    var hiraListFahafatesana  = hiraListWidget(hiraFahafatesana );
    var hiraListFiravana  = hiraListWidget(hiraFiravana );

    var hiraListFanoloranjaza = hiraListWidget(hiraFanoloranjaza );
    

    final _kTabPages = <Widget>[
      hiraList.isEmpty ? noData : hiraListSokajyhafa,
      hiraList.isEmpty ? noData : hiraListFiankohofana,
      hiraList.isEmpty ? noData : hiraListPaska,
      hiraList.isEmpty ? noData : hiraListFideranasyfankalazana,
      hiraList.isEmpty ? noData : hiraListFanahyMasina,
      hiraList.isEmpty ? noData : hiraListTeninAndriamanitra,
      hiraList.isEmpty ? noData : hiraListFitorianafilazantsara,
      hiraList.isEmpty ? noData : hiraListFanatitra,
      hiraList.isEmpty ? noData : hiraListFanasannyTompo,

      hiraList.isEmpty ? noData : hiraListKrismasy,
      hiraList.isEmpty ? noData : hiraListFanosoranampiasa,
      hiraList.isEmpty ? noData : hiraListMariazy,
      hiraList.isEmpty ? noData : hiraListFanolorantena,
      hiraList.isEmpty ? noData : hiraListFahafatesana,
      hiraList.isEmpty ? noData : hiraListFiravana,

      hiraList.isEmpty ? noData : hiraListFanoloranjaza,
    ];  

    return AnimatedBuilder(
      animation: _animController, 
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          backgroundColor: modeSombre == 1
              ? Colors.black
              : Theme.of(context).scaffoldBackgroundColor,
          body: DefaultTabController(
            length: lengthOfTab,
            child: NestedScrollView(
              controller: _scrollcontroller,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      icon: Icon(Icons.menu),
                      tooltip: 'Menu',
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    pinned: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.sort_by_alpha),
                        tooltip: this._sortAlfabet == false 
                          ? 
                            "Trier par alphabet"
                          :
                            "Trier par numero",
                        onPressed: () {
                          if(this._sortAlfabet == false) {
                            setState(() {
                              this._sortAlfabet = true;
                              hiraSokajyhafa ..sort((a, b) => a.title.compareTo(b.title));
                              hiraFiankohofana .sort((a, b) => a.title.compareTo(b.title));
                              hiraPaska  .sort((a, b) => a.title.compareTo(b.title));
                              hiraFideranasyfankalazana .sort((a, b) => a.title.compareTo(b.title));
                              hiraFanahyMasina .sort((a, b) => a.title.compareTo(b.title));
                              hiraTeninAndriamanitra  .sort((a, b) => a.title.compareTo(b.title));
                              hiraFitorianafilazantsara .sort((a, b) => a.title.compareTo(b.title));
                              hiraFanatitra  .sort((a, b) => a.title.compareTo(b.title));
                              hiraFanasannyTompo .sort((a, b) => a.title.compareTo(b.title));

                              hiraKrismasy  .sort((a, b) => a.title.compareTo(b.title));
                              hiraFanosoranampiasa  .sort((a, b) => a.title.compareTo(b.title));
                              hiraMariazy  .sort((a, b) => a.title.compareTo(b.title));
                              hiraFanolorantena .sort((a, b) => a.title.compareTo(b.title));
                              hiraFahafatesana   .sort((a, b) => a.title.compareTo(b.title));
                              hiraFiravana  .sort((a, b) => a.title.compareTo(b.title));

                              hiraFanoloranjaza .sort((a, b) => a.title.compareTo(b.title));
                            });
                          }else {
                            setState(() {
                              this._sortAlfabet = false;
                              hiraSokajyhafa..sort((a, b) => a.id.compareTo(b.id));
                              hiraFiankohofana..sort((a, b) => a.id.compareTo(b.id));
                              hiraPaska.sort((a, b) => a.id.compareTo(b.id));
                              hiraFideranasyfankalazana..sort((a, b) => a.id.compareTo(b.id));
                              hiraFanahyMasina..sort((a, b) => a.id.compareTo(b.id));
                              hiraTeninAndriamanitra.sort((a, b) => a.id.compareTo(b.id));
                              hiraFitorianafilazantsara.sort((a, b) => a.id.compareTo(b.id));
                              hiraFanatitra.sort((a, b) => a.id.compareTo(b.id));
                              hiraFanasannyTompo.sort((a, b) => a.id.compareTo(b.id));

                              hiraKrismasy  .sort((a, b) => a.id.compareTo(b.id));
                              hiraFanosoranampiasa  .sort((a, b) => a.id.compareTo(b.id));
                              hiraMariazy  .sort((a, b) => a.id.compareTo(b.id));
                              hiraFanolorantena .sort((a, b) => a.id.compareTo(b.id));
                              hiraFahafatesana   .sort((a, b) => a.id.compareTo(b.id));
                              hiraFiravana  .sort((a, b) => a.id.compareTo(b.id));

                              hiraFanoloranjaza.sort((a, b) => a.id.compareTo(b.id));
                              
                            });
                          }
                        },
                      ),
                      _searchIsHidden == true 
                      ? IconButton(
                        tooltip: 'Rechercher',
                        icon: Icon(Icons.search,),
                        onPressed: () {
                          _showMaterialSearch(context);
                          reloadSettings();
                        },
                      )
                      : Container(),
                      
                    ],
                    expandedHeight: 230.0,
                    flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsetsDirectional.only(start: 72, bottom: 14),
                        collapseMode: CollapseMode.none,
                        title: AnimatedBuilder(
                          animation: _animController2, 
                          builder: (BuildContext context, Widget child) {
                            return Transform(
                              transform: Matrix4.translationValues(0.0, animationTitleBar.value*(height*0.2), 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 30,
                                    margin: EdgeInsets.only(right: 5.0, top: 0.0, left: 0.0, bottom: 0.0),
                                    child: Image.asset('assets/images/logoaddf.png'),
                                  ),
                                  Container(
                                      width: width*0.45,
                                      child: Text('ADD Fihirana', 
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        
                        background: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            ClipPath(
                              clipper: WaveClipperOne(),
                              child: Stack(
                                alignment: AlignmentDirectional.topCenter,
                                children: <Widget>[
                                  Container(
                                    color: Theme.of(context).primaryColorDark,
                                    padding: EdgeInsets.only(top: 50, right: 20, left: 20),
                                  ),
                                ],
                              ),
                                  
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 70, bottom: 45, right: 12, left: 12),
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                                child: Container(
                                  margin: EdgeInsets.only(top: 45, bottom: 10, right: 10, left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Align(
                                            heightFactor: 0,
                                            alignment: Alignment.center,
                                            child: Text('“', 
                                              style: TextStyle(
                                                fontSize: 35,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: modeSombre == 1 ? Colors.white : Theme.of(context).primaryColor
                                              )
                                            ),
                                          ),
                                          Align(
                                            heightFactor: 1.5,
                                            alignment: Alignment.center,
                                            child: Text('Hihira ho an’i Jehovah aho raha mbola velona koa', 
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15,
                                                fontFamily: 'Montserrat',
                                                color: modeSombre == 1 ? Colors.white : Theme.of(context).primaryColor
                                              )
                                            ),
                                          ),
                                          Align(
                                            heightFactor: 0.5,
                                            alignment: Alignment.centerRight,
                                            child: Text('Sal. 105:2a', 
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontFamily: 'Montserrat',
                                                color: modeSombre == 1 ? Colors.white : Theme.of(context).primaryColor
                                              ),
                                            )
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ), 
                            Padding(
                              padding: EdgeInsets.only(top: 0, bottom: 10, right: 10, left: 10),
                              child: Card(
                                color: Theme.of(context).primaryColorDark,
                                elevation: 8,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    color: modeSombre == 1 ? Theme.of(context).primaryColor: Colors.white,
                                  ),
                                  child: TextField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      prefixIcon: Icon(Icons.search, color: Colors.grey[600],),
                                      border: InputBorder.none,
                                      hintText: 'Rechercher',
                                    ),
                                    onTap: () {
                                      _showMaterialSearch(context);
                                      reloadSettings();
                                    },
                                  ),
                                ),
                              )
                              
                            ),
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              margin: EdgeInsets.only(top: 0,bottom: 158, right: 12, left: 12),
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset('assets/images/logoaddf.png', width: 45),
                              ),
                            ),
                          ],
                        )
                        
                      ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        isScrollable: true,
                        labelStyle: TextStyle(fontSize: 20.0),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 20.0,
                        ),
                        indicatorColor: Theme.of(context).primaryTextTheme.title.color,
                        indicatorPadding: EdgeInsets.all(8.0),
                        labelColor: Theme.of(context).primaryTextTheme.title.color,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Tab(text: "Sokajy hafa"),
                          Tab(text: "Fiankohofana"),
                          Tab(text: "Paska"),
                          Tab(text: "Fiderana sy fankalazana"),
                          Tab(text: "Fanahy Masina"),
                          Tab(text: "Tenin'Andriamanitra"),
                          Tab(text: "Fitoriana filazantsara"),
                          Tab(text: "Fanatitra"),
                          Tab(text: "Fanasan'ny Tompo"),
                          Tab(text: "Krismasy"),
                          Tab(text: "Fanosorana mpiasa"),
                          Tab(text: "Mariazy"),
                          Tab(text: "Fanoloran-tena"),
                          Tab(text: "Fahafatesana"),
                          Tab(text: "Firavana"),
                          Tab(text: "Fanoloran-jaza"),
                        ],
                      )
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: _kTabPages,
              ),
            ),
          ),
          drawer: Drawer(
            child: drawerItems,
          ),
        );
      },

    );
    
  }

}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: <Widget>[
            _tabBar
          ],
        ));
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

enum _AnimationStatus { start, end, animating }
