import 'package:add_fihirana/database/dbhelper.dart';
import 'package:add_fihirana/model/hira.dart';
import 'package:add_fihirana/page/hiraView_page.dart';
import 'package:add_fihirana/page/home_page.dart';
import 'package:flutter/material.dart';

class FavorisPage extends StatefulWidget {
  static const String routeName = "/favoris";

  @override
  _FavorisPageState createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  
  var db = DBHelper();
  List favoris = [];
  List<Hira> hiraList = <Hira>[];
  int modeSombre;

  void reloadFavorisList() {
    favoris.clear();
    db.getFavoris().then((onValue) {
      favoris.addAll(onValue);
      setState(() {
        favoris = favoris;
      });
    }); 
  }

  @override
  void initState() {
    super.initState();

    db.getFavoris().then((onValue) {
      favoris.addAll(onValue);
      setState(() {
        favoris = favoris;
      });
    });

    db.getSettings().then((onValue) {
      onValue.forEach((f) {
        setState(() {
          modeSombre = f.modeSombre;
        });
      });
    });

    setState(() {
      hiraList = HomePageState.hiraList;
    });
  }

  void _goToHiraViewPage(BuildContext context, index) async {
    // start the SecondScreen and wait for it to finish with a result
    await Navigator.push(context,
    MaterialPageRoute(
      builder: (context) => HiraViewPage(
        title: hiraList[index-1].title,
        hiraList: hiraList, 
      )
    ));
    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      reloadFavorisList();
    });
  }

  int hiraTaloha() {
    var index = 0;
    for (var i = 0; i <  HomePageState.hiraTaloha.length; i++) {
      if(HomePageState.hiraTaloha[i].favoris == 1) { 
        index = i;
      }
    }
    return index;
  }

  int hira2016() {
    var index = 0;
    for (var i = 0; i <  HomePageState.hira2016.length; i++) {
      if(HomePageState.hira2016[i].favoris == 1) { 
        index = i;
      }
    }
    return index;
  }

  int hira2017() {
    var index = 0;
    for (var i = 0; i <  HomePageState.hira2017.length; i++) {
      if(HomePageState.hira2017[i].favoris == 1) { 
        index = i;
      }
    }
    return index;
  }

  int hira2018() {
    var index = 0;
    for (var i = 0; i <  HomePageState.hira2018.length; i++) {
      if(HomePageState.hira2018[i].favoris == 1) { 
        index = i;
      }
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    var noData = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only( top: MediaQuery.of(context).size.height*0.5/2),
      child: Column(
        children: <Widget>[
          Icon(Icons.star_border, size: 100.0, color: Colors.grey[300]),
          Text("Aucun favoris", style: TextStyle(color: Colors.grey),)
        ],
      )
    );
    var list = ListView.builder(
      itemCount: favoris.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(favoris[index].title.substring(0, 1))
            ),
            title: Text(favoris[index].title),
            subtitle: Text(favoris[index].dateUpdate.toString()),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.redAccent,), 
              onPressed: () {

                db.setFavoris(favoris[index].id, null, null).then((onValue) {
                  HomePageState.hiraList[(favoris[index].id)-1].favoris = null;
                  HomePageState.hiraTaloha[hiraTaloha()].favoris = null;
                  HomePageState.hira2016[hira2016()].favoris = null;
                  HomePageState.hira2017[hira2017()].favoris = null;
                  HomePageState.hira2018[hira2018()].favoris = null;

                  reloadFavorisList();
                });

                // hira2016().then((onValue) {

                //   HomePageState.hiraList[(favoris[index].id)-1].favoris = null;
                //   reloadFavorisList();

                // });
              },
            ), 
            onTap: () {
              _goToHiraViewPage(context, favoris[index].id);
            }, 
          ),
        );
      },
    );
    return new Scaffold(
      backgroundColor: modeSombre == 1 ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
      appBar: new AppBar(
        title: new Text("Favoris"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Supprimer',
            onPressed: () {
              db.deleteAllFavoris().then((onValue) {
                setState(() {
                  this.favoris.clear();
                  HomePageState.hiraList.forEach((f) {
                    f.favoris = null;
                  });
                  HomePageState.hiraTaloha.forEach((f) {
                    f.favoris = null;
                  });
                  HomePageState.hira2016.forEach((f) {
                    f.favoris = null;
                  });
                  HomePageState.hira2017.forEach((f) {
                    f.favoris = null;
                  });
                  HomePageState.hira2018.forEach((f) {
                    f.favoris = null;
                  });
                }); 
              });
            },
          ),
        ],
      ),
      body: favoris.isEmpty ? noData : list
      
    );
  }
}
