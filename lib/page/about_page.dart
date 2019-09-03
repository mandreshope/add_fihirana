import 'package:add_fihirana/database/dbhelper.dart';
import 'package:add_fihirana/utils/points_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  static const String routeName = "/about";

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>  with SingleTickerProviderStateMixin  {

  int modeSombre;
  var _db = DBHelper();
  static DateTime _copyrightDate = new DateTime.now();

  Future<void> launched;
  // String _phone = '0330297426';
  String _lienFbMandresy = 'https://mobile.facebook.com/mandresyrandrianarinjaka';
  // String _lienFbAddFihirana = 'https://mobile.facebook.com/addfihirana/';
  String _textAboutAddFihirana = """
    🔹Ny hira rehetra ato amin'ity application ity dia hira rehetra nadika avy tao amin'ilay boky fihirana an'ny Assembl&eacute;e De Dieu de Madagascar.<br><br>
🔹Nadika tanana ny hira rehetra ka noho izany mety hisy diso na dia efa niezaka nandinika sy nijery aza izahay.<br><br>
🔹Ka noho izany, dia manasa anao izahay mba handefa hafatra miafina izay tononkira hitanao fa misy diso ato amin'ity pejy facebook ity, tsindrio eto : <strong>👉<a href="https://mobile.facebook.com/addfihirana/">ADD Fihirana</a></strong>👈. <br>Aza adino manondro ny laharan'ilay hira hitanao fa misy diso.<br><br>
🔸Misaotra an' 👑 Andriamanitra 👑 izahay tamin'ny fahafahanay nanatontosa ity fitaovana ity, fitaovana fotsiny ihany izahay fa ny saina nahafahanay nanao azy dia avy Taminy irery ihany.<br><br>
🔸Isaorana manokana ny filohan'ny fiangonana Assembl&eacute;e de Dieu Madagascar Pasteur <strong>Rijamamy Be Arthur Lala </strong>nanome alalana nahafahanay nanatontosa ity fitaovana ity.<br><br>
🔸Isaorana manokana ireo olona rehetra izay nanaiky ho fitaovana tsara nanampy sy nifanolo-tanana.<br>
  """;

  AnimationController _animController;
  Animation<double> animation1, animation2, animation3, animation4, animation5, animation6;

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

    animation1 = Tween(begin: 1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve:  Curves.bounceOut,
      ),
    );

    animation2 = Tween(begin: 1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve: Interval(0.3, 1.0, curve: Curves.bounceOut), 
      ),
    );

    animation3 = Tween(begin: 1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve: Interval(0.5, 1.0, curve: Curves.bounceOut), 
      ),
    );

    animation4 = Tween(begin: 1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve: Interval(0.7, 1.0, curve: Curves.bounceOut), 
      ),
    );

    animation5 = Tween(begin: 1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve: Interval(0.8, 1.0, curve: Curves.bounceOut), 
      ),
    );

    animation6 = Tween(begin: 1.0, end: 0.0).animate(
      new CurvedAnimation(
          parent: _animController,
          curve: Interval(0.9, 1.0, curve: Curves.bounceOut), 
      ),
    );
    

  }

  @override
	void dispose(){
	  _animController.dispose();
	  super.dispose();
	}

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime copyrightDate = _copyrightDate;
    int copyrightMonth = copyrightDate.year;
    final double width = MediaQuery.of(context).size.width;
    _animController.forward();
    return AnimatedBuilder(
      animation: _animController, 
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          backgroundColor: modeSombre == 1 ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'Retour',
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text("A propos"),
          ),
          body: 
          ListView(
            children: <Widget>[
              Transform(
                transform: Matrix4.translationValues(animation1.value * width, 0.0, 0.0),
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: ListTile(
                    leading: Image.asset(
                      'assets/images/logoaddf.png',
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
                    trailing: Text('v1.4.0(4)',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    // onTap: () => this.launched = _launchInBrowser(_lienFbAddFihirana),
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
                      subtitle: Text("ADD Fihirana dia application mobile Android izay ahitana ireo hira rehetra izay voarakitra ao anatin'ny boky fihirana Assemblée de Dieu Madagascar.",
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
                transform: Matrix4.translationValues(animation3.value * width, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Divider(),
                    Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20.0),
                          color: Colors.grey[400],
                          width: MediaQuery.of(context).size.width/100,
                          height: MediaQuery.of(context).size.height/10,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20.0),
                          width: MediaQuery.of(context).size.width,
                          child: ListTile(
                            title: Text(
                              'Marihina fa ity fihirana ity dia azon\'ny fiangonana rehetra ampiasaina.',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600]
                              ),
                            ),   
                          ),
                        )
                      ],
                    ),
                    Divider()
                  ],
                )

              ),

              Transform(
                transform: Matrix4.translationValues(animation4.value * width, 0.0, 0.0),
                child: ExpansionTile(
                  leading: Icon(Icons.label_important,size: 30.0,
                        color: modeSombre == 1 ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,),
                  title: Text("Hafatra sy Fisaorana"),
                  children: <Widget>[
                    Html(
                      data: _textAboutAddFihirana,
                      padding: EdgeInsets.only(left:20.0, right: 20.0),
                      linkStyle: const TextStyle(
                        color: Colors.redAccent,
                        decorationColor: Colors.redAccent,
                        decoration: TextDecoration.underline,
                      ),
                      onLinkTap: (link) {
                        this.launched = _launchInBrowser(link);
                      },
                    ),
                  ],
                ),
                
              ),

              Transform(
                transform: Matrix4.translationValues(animation5.value * width, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Divider(),
                    ListTile(
                        leading: Icon(
                          Icons.supervised_user_circle, 
                          size: 30.0,
                          color: modeSombre == 1 ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                        ),
                        title: Text(
                            'Assemblée de Dieu Madagascar $copyrightMonth'),
                    ),
                    Divider(),
                  ],
                )
                

              ),

              Transform(
                transform: Matrix4.translationValues(animation6.value * width, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.code,
                        size: 30.0,
                        color: modeSombre == 1 ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                      ),
                      title: Text('Développé par Randrianarinjaka Mandresy'),
                      subtitle: Text('Contact: mandreshope@gmail.com'),
                      onTap: () {
                        this.launched = _launchInBrowser(_lienFbMandresy);
                      },
                    ),
                    Divider()
                  ],
                )
              ),

            ],
          ),
        );

      },
    );
  }
}


