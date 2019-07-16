import 'package:add_fihirana/database/dbhelper.dart';
import 'package:add_fihirana/utils/points_clipper.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  static const String routeName = "/about";
  static DateTime _copyrightDate = new DateTime.now();

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>  with SingleTickerProviderStateMixin  {

  int modeSombre;
  var _db = DBHelper();

  AnimationController _animController;
  Animation<double> animation1, animation2, animation3, animation4;

  @override
  void initState() {
    super.initState(); 

    _db.getSettings().then((onValue) {
      onValue.forEach((f) {
        setState(() {
          modeSombre = f.modeSombre;
        });
      });
    });

    _animController = new AnimationController(
      duration: const Duration(seconds: 2), 
      vsync: this,
	  );

    animation1 = Tween(begin: -1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve:  Curves.fastOutSlowIn,
      ),
    );

    animation2 = Tween(begin: -1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn), 
      ),
    );

    animation3 = Tween(begin: -1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn), 
      ),
    );

    animation4 = Tween(begin: -1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve: Interval(0.9, 1.0, curve: Curves.fastOutSlowIn), 
      ),
    );
    

  }

  @override
	void dispose(){
	  _animController.dispose();
	  super.dispose();
	}

  @override
  Widget build(BuildContext context) {
    DateTime copyrightDate = AboutPage._copyrightDate;
    int copyrightMonth = copyrightDate.year;
    final double width = MediaQuery.of(context).size.width;
    _animController.forward();
    return AnimatedBuilder(
      animation: _animController, 
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          backgroundColor: modeSombre == 1 ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text("A propos"),
          ),
          body: ListView(
            children: <Widget>[
              Transform(
                transform: Matrix4.translationValues(animation1.value * width, 0.0, 0.0),
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: ListTile(
                    leading: Image.asset(
                      'assets/images/logoaddfihirana.png',
                    ),
                    title: Text('ADD Fihirana',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    subtitle: Text('ADD Fihirana amin\'ny Android',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                        ),
                    ),
                    trailing: Text('v1.0.4',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                  ),
                ),
              ),

              Transform(
                transform: Matrix4.translationValues(animation2.value * width, 0.0, 0.0),
                child: ClipPath(
                  clipper: PointsClipper(20),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 20),
                    color: Theme.of(context).primaryColor,
                    child: ListTile(
                      subtitle: Text(
                        'Add fihirana dia application Android ahitana ireo hira rehetra ao amin\'ny fiangonana Assemblée de Dieu de Madagascar sy hira fiderana maro samihafa koa.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.title.color,
                        ),
                      ),
                    ),
                  ),
                ),

              ),
              
              
              Transform(
                transform: Matrix4.translationValues(animation2.value * width, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Divider(),
                    ListTile(
                        leading: Icon(
                          Icons.mail, 
                          size: 30.0,
                          color: modeSombre == 1 ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                        ),
                        title: Text(
                            'Assemblée de Dieu de Madagascar'),
                        // subtitle: Text(
                        //     'assembleededieudemadagascar@gmail.com')
                    ),
                    Divider(),
                  ],
                )
                

              ),
              Transform(
                transform: Matrix4.translationValues(animation3.value * width, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.supervised_user_circle,
                        size: 30.0,
                        color: modeSombre == 1 ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                      ),
                      title: Text('Développé par Tanora Modely ADD Ivandry'),
                      subtitle: Text('Contact: mandreshope@gmail.com')
                    ),
                    Divider(),
                  ],
                )
              ),
              
              Transform(
                transform: Matrix4.translationValues(animation4.value * width, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.developer_mode,
                        size: 30.0,
                        color: modeSombre == 1 ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        'ADD MG $copyrightMonth'
                      ),   
                    ),
                    Divider()
                  ],
                )

              ),
              

            ],
          ),
          // body: CustomScrollView(
          //   slivers: <Widget>[
          //     SliverAppBar(
          //       pinned: true,
          //       expandedHeight: 160.0,
          //       flexibleSpace: FlexibleSpaceBar(
          //         title: Text("A propos"),
          //         background: modeSombre == 1 
          //         ? 
          //         Image.asset('assets/images/backgroundAboutNightMode.jpg',fit: BoxFit.fill)
          //         : 
          //         Image.asset('assets/images/backgroundAbout.jpg',fit: BoxFit.fill),
          //         collapseMode: CollapseMode.parallax,
          //       ),
          //     ),
          //     SliverFillRemaining(
          //       child: Container(
          //         child: ListView(
          //           controller: ScrollController(keepScrollOffset: false),
          //           physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          //           children: <Widget>[
          //             ListTile(
          //               leading: Image.asset(
          //                 'assets/images/logoadd.png',
          //               ),
          //               title: Text('ADD Fihirana'),
          //               subtitle: Text('ADD Fihirana amin\'ny Android'),
          //               trailing: Text('v1.0.1'),
          //             ),
          //             ListTile(
          //               subtitle: Text(
          //                 'Add fihirana dia application Android ahitana ireo hira rehetra ao amin\'ny fiangonana Assemblée de Dieu de Madagascar sy hira fiderana maro samihafa koa.',
          //                 textAlign: TextAlign.center,
          //               ),
          //             ),
          //             Divider(),
          //             ListTile(
          //                 leading: Icon(
          //                   Icons.mail, 
          //                   size: 30.0,
          //                   color: ThemeColor.themeColor(_theme),
          //                 ),
          //                 title: Text(
          //                     'Assemblée de Dieu de Madagascar'),
          //                 subtitle: Text(
          //                     'assembleededieudemadagascar@gmail.com')),
          //             Divider(),
          //             ListTile(
          //               leading: Icon(
          //                 Icons.supervised_user_circle,
          //                 size: 30.0,
          //                 color: ThemeColor.themeColor(_theme),
          //               ),
          //               title: Text('Développé par Tanora Modely Add Ivandry'),
          //               subtitle: Text('Contact: mandreshope@gmail.com')
          //             ),
          //             Divider(),
          //             ListTile(
          //               leading: Icon(
          //                 Icons.copyright,
          //                 size: 30.0,
          //                 color: ThemeColor.themeColor(_theme)
          //               ),
          //               title: Text(
          //                 'Copyright $copyrightMonth Assemblée de Dieu de Madagascar'
          //               ),   
          //             ),
          //             Divider()
          //           ],
          //         ),
          //       )
          //     )
          //   ],
          // ),
        );

      },
    );
  }
}


