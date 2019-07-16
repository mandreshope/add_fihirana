import 'dart:math' as math;

import 'package:add_fihirana/database/dbhelper.dart';
import 'package:add_fihirana/model/hira.dart';
import 'package:add_fihirana/page/about_page.dart';
import 'package:add_fihirana/page/favoris_page.dart';
import 'package:add_fihirana/page/hiraView_page.dart';
import 'package:add_fihirana/page/history_page.dart';
import 'package:add_fihirana/page/setting_page.dart';
import 'package:add_fihirana/utils/diagonal_path_clipper_1.dart';
import 'package:add_fihirana/utils/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:material_search/material_search.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:animated_background/animated_background.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/home";

  // receive data from the FirstScreen as a parameter
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static const numBehaviours = 5;

  ParticleOptions particleOptions = ParticleOptions(
    baseColor: Colors.white,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.1,
    maxOpacity: 0.7,
    spawnMinSpeed: 20.0,
    spawnMaxSpeed: 40.0,
    spawnMinRadius: 3.0,
    spawnMaxRadius: 10.0,
    particleCount: 10,
  );

  var particlePaint = Paint()
    ..style = PaintingStyle.fill
    ..strokeWidth = 0.5;

  // Lines

  var _lineDirection = LineDirection.Ltr;
  int _lineCount = 50;

  // Bubbles
  BubbleOptions _bubbleOptions = BubbleOptions(
      bubbleCount: 5,
      minTargetRadius: 10,
      maxTargetRadius: 29,
      popRate: 50,
      growthRate: 5.0);

  // General Variables
  int _behaviourIndex = 1;
  Behaviour behaviour;

  bool _showSettings = false;

  static List<Hira> hiraList = [];
  List<String> kHiraList = [];
  String skHiraList = 'No one';
  static List<Hira> hiraTaloha = [];
  static List<Hira> hira2016 = [];
  static List<Hira> hira2017 = [];
  static List<Hira> hira2018 = [];

  bool _sortAlfabet = false;

  int modeSombre;
  var db = DBHelper();

  Future<void> launched;
  // String _phone = '0330297426';
  String _addFihiranaUrl =
      'https://web.facebook.com/Add-fihirana-2215721572022794/';

  HomePageState();

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

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();

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
    });

    db.getCategorySongs('Taloha').then((onValue) {
      hiraTaloha.addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('2016').then((onValue) {
      hira2016.addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('2017').then((onValue) {
      hira2017.addAll(onValue);
      setState(() {});
    });

    db.getCategorySongs('2018').then((onValue) {
      hira2018.addAll(onValue);
      setState(() {});
    });

    db.getTitleSongs().then((onValue) {
      kHiraList.addAll(onValue);
      setState(() {});
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   reloadHiraList();
  // }

  ListView hiraListWidget(List<Hira> hiraList2) {
    return ListView.builder(
      itemCount: hiraList2.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            onTap: () {
              _goToHiraViewPage(context, hiraList2[index].id);
            },
            dense: true,
            leading: CircleAvatar(
                child: Text(hiraList2[index].title.substring(0, 1))),
            title: Text(
              hiraList2[index].title,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                'N° ' +
                    hiraList2[index].id.toString() +
                    ' / Categorie : ' +
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

                    db.setFavoris(hiraList2[index].id, null, null).then((onValue) {
                      
                    });
                    
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
                    db.setFavoris(hiraList2[index].id, 1, dateNow);
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
            isInitialRoute: false,
            arguments: modeSombre),
        builder: (BuildContext context) {
          return new Material(
            child: new MaterialSearch<String>(
              barBackgroundColor: modeSombre == 1
                  ? ThemeData.dark().backgroundColor
                  : Colors.white,
              iconColor: modeSombre == 1 ? Colors.white : Colors.black,
              placeholder: 'Tapez le titre...',
              results: kHiraList
                  .map((String v) => new MaterialSearchResult<String>(
                        icon: Icons.queue_music,
                        value: v,
                        text: "$v",
                      ))
                  .toList(),
              filter: (dynamic value, String criteria) {
                return value.toLowerCase().trim().contains(
                    new RegExp(r'' + criteria.toLowerCase().trim() + ''));
              },
              onSelect: (dynamic value) {
                _searchgoToHiraViewPage(context, value);
              },
              // onSubmit: (String value) => Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (BuildContext context) =>
              //       HiraViewPage(
              //         title: value
              //       )
              //   )
              // )
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
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HiraViewPage(
                  title: value,
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
    final drawerHeader = Center(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          ClipPath(
            clipper: DiagonalPathClipperOne(),
            child: Container(
              height: 200.0,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: modeSombre == 1
                    ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/logoaddfihirana.png',
                            fit: BoxFit.fill,
                            width: 50.0,
                            height: 50.0,
                          ),
                          Divider(
                            color: Theme.of(context).primaryColor,
                            height: 5,
                          ),
                          Text('ADD FIHIRANA', style: TextStyle(
                              color: Theme.of(context).primaryTextTheme.title.color,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),),
                          Divider(
                            color: Theme.of(context).primaryColor,
                          ),
                          Text('FIHIRANA ASSEMBLEE DE DIEU DE MADAGASCAR', style: TextStyle(
                              color: Theme.of(context).primaryTextTheme.title.color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                            ),),
                        
                        ],
                      ),
                    )
                    : Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/logoaddfihirana.png',
                            fit: BoxFit.fill,
                            width: 50.0,
                            height: 50.0,
                          ),
                          Divider(
                            color: Theme.of(context).primaryColor,
                            height: 5,
                          ),
                          
                          Text('ADD FIHIRANA', style: TextStyle(
                              color: Theme.of(context).primaryTextTheme.title.color,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),),
                          Divider(
                            color: Theme.of(context).primaryColor,
                          ),
                          Text('FIHIRANA ASSEMBLEE DE DIEU DE MADAGASCAR', style: TextStyle(
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

    final drawerItems = ListView(
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
            Navigator.pop(context); // close the drawer
            setState(() {
              this.launched = _launchInBrowser(_addFihiranaUrl);
              // this._launched = _makePhoneCall('tel:$_phone');
            });
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
    );

    var noData = ListView(
      padding:
          EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0, bottom: 16.0),
      children: <Widget>[
        Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            children: [0, 1, 2, 4, 5, 6, 7, 8]
                .map((_) => Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Container(
                                  width: 40.0,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );

    var hiraListTaloha = hiraListWidget(hiraTaloha);
    var hiraList2016 = hiraListWidget(hira2016);
    var hiraList2017 = hiraListWidget(hira2017);
    var hiraList2018 = hiraListWidget(hira2018);

    final _kTabPages = <Widget>[
      hiraList.isEmpty ? noData : hiraListTaloha,
      hiraList.isEmpty ? noData : hiraList2016,
      hiraList.isEmpty ? noData : hiraList2017,
      hiraList.isEmpty ? noData : hiraList2018,
    ];

    return Scaffold(
      backgroundColor: modeSombre == 1
          ? Colors.black
          : Theme.of(context).scaffoldBackgroundColor,
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                actions: <Widget>[
                  IconButton(
                    icon: this._sortAlfabet == false 
                      ? 
                        Icon(Icons.sort_by_alpha)
                      :
                        Icon(Icons.format_list_numbered),
                    tooltip: this._sortAlfabet == false 
                      ? 
                        "Trier par alphabet"
                      :
                        "Trier par numero",
                    onPressed: () {
                      if(this._sortAlfabet == false) {
                        setState(() {
                          this._sortAlfabet = true;
                          hiraTaloha..sort((a, b) => a.title.compareTo(b.title));
                          hira2016.sort((a, b) => a.title.compareTo(b.title));
                          hira2017.sort((a, b) => a.title.compareTo(b.title));
                          hira2018.sort((a, b) => a.title.compareTo(b.title));
                        });
                      }else {
                        setState(() {
                          this._sortAlfabet = false;
                          hiraTaloha..sort((a, b) => a.id.compareTo(b.id));
                          hira2016..sort((a, b) => a.id.compareTo(b.id));
                          hira2017..sort((a, b) => a.id.compareTo(b.id));
                          hira2018..sort((a, b) => a.id.compareTo(b.id));
                        });
                      }
                    },
                  ),
                  IconButton(
                    tooltip: 'Rechercher',
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      _showMaterialSearch(context);
                      reloadSettings();
                    },
                  ),
                ],
                pinned: true,
                expandedHeight: 160.0,
                flexibleSpace: FlexibleSpaceBar(
                    title: Text("ADD Fihirana"),
                    background: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: modeSombre == 1
                              ? Image.asset(
                                  'assets/images/backgroundAddNightMode.jpg',
                                  fit: BoxFit.fill)
                              : Image.asset('assets/images/backgroundAd.jpg',
                                  fit: BoxFit.fill),
                        ),
                        AnimatedBackground(
                          behaviour: behaviour = _buildBehaviour(),
                          vsync: this,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                            ),
                          ),
                        ),
                      ],
                    )
                    // background: Image.asset(
                    //   'assets/images/material2.jpg',
                    //   fit: BoxFit.fill,
                    // ),
                    ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(TabBar(
                  labelStyle: TextStyle(fontSize: 20.0),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white70,
                  ),
                  indicatorColor: Colors.white,
                  indicatorPadding: EdgeInsets.all(8.0),
                  labelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(text: "Taloha"),
                    Tab(text: "2016"),
                    Tab(text: "2017"),
                    Tab(text: "2018"),
                  ],
                )),
                pinned: true,
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
  }

  Behaviour _buildBehaviour() {
    switch (_behaviourIndex) {
      case 0:
        return RandomParticleBehaviour(
          options: particleOptions,
          paint: particlePaint,
        );
      case 1:
        return RainParticleBehaviour(
          options: particleOptions,
          paint: particlePaint,
          enabled: !_showSettings,
        );
      case 2:
        return RectanglesBehaviour();
      case 3:
        return RacingLinesBehaviour(
          direction: _lineDirection,
          numLines: _lineCount,
        );
      case 4:
        return BubblesBehaviour(
          options: _bubbleOptions,
        );
      case 5:
        return SpaceBehaviour();
    }

    return RandomParticleBehaviour(
      options: particleOptions,
      paint: particlePaint,
    );
  }
}

enum ParticleType {
  Shape,
  Image,
}

class RainParticleBehaviour extends RandomParticleBehaviour {
  static math.Random random = math.Random();

  bool enabled;

  RainParticleBehaviour({
    ParticleOptions options = const ParticleOptions(),
    Paint paint,
    this.enabled = true,
  })  : assert(options != null),
        super(options: options, paint: paint);

  @override
  void initPosition(Particle p) {
    p.cx = random.nextDouble() * size.width;
    if (p.cy == 0.0)
      p.cy = random.nextDouble() * size.height;
    else
      p.cy = random.nextDouble() * size.width * 0.2;
  }

  @override
  void initDirection(Particle p, double speed) {
    double dirX = (random.nextDouble() - 0.5);
    double dirY = random.nextDouble() * 0.5 + 0.5;
    double magSq = dirX * dirX + dirY * dirY;
    double mag = magSq <= 0 ? 1 : math.sqrt(magSq);

    p.dx = dirX / mag * speed;
    p.dy = dirY / mag * speed;
  }

  @override
  Widget builder(
      BuildContext context, BoxConstraints constraints, Widget child) {
    return GestureDetector(
      onPanUpdate: enabled
          ? (details) => _updateParticles(context, details.globalPosition)
          : null,
      onTapDown: enabled
          ? (details) => _updateParticles(context, details.globalPosition)
          : null,
      child: ConstrainedBox(
        // necessary to force gesture detector to cover screen
        constraints: BoxConstraints(
            minHeight: double.infinity, minWidth: double.infinity),
        child: super.builder(context, constraints, child),
      ),
    );
  }

  void _updateParticles(BuildContext context, Offset offsetGlobal) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.globalToLocal(offsetGlobal);
    particles.forEach((particle) {
      var delta = (Offset(particle.cx, particle.cy) - offset);
      if (delta.distanceSquared < 70 * 70) {
        var speed = particle.speed;
        var mag = delta.distance;
        speed *= (70 - mag) / 70.0 * 2.0 + 0.5;
        speed = math.max(
            options.spawnMinSpeed, math.min(options.spawnMaxSpeed, speed));
        particle.dx = delta.dx / mag * speed;
        particle.dy = delta.dy / mag * speed;
      }
    });
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
        color: Colors.black87,
        child: Stack(
          children: <Widget>[_tabBar],
        ));
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
