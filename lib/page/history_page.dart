import 'package:add_fihirana/database/dbhelper.dart';
import 'package:add_fihirana/model/hira.dart';
import 'package:add_fihirana/model/history.dart';
import 'package:add_fihirana/page/hiraView_page.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  static const String routeName = "/history";

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var db = DBHelper();
  List<History> history = <History>[];
  List<Hira> hiraList = <Hira>[];


  int modeSombre;

  void reloadHistoryList() {
    history.clear();
    db.getHistory().then((onValue) {
      history.addAll(onValue);
      setState(() {
        history = history;
      });
    }); 
  }

  @override
  void initState() {
    super.initState();
    db.getHistory().then((onValue) {
      history.addAll(onValue);
      setState(() {
        history = history;
      });
    }); 

    db.getSettings().then((onValue) {
      onValue.forEach((f) {
        setState(() {
          modeSombre = f.modeSombre;
        });
      });
    });

    db.getSongs().then((onValue) {
      hiraList.addAll(onValue);
      setState(() {
        hiraList = hiraList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var noData = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only( top: MediaQuery.of(context).size.height*0.5/2),
      child: Column(
        children: <Widget>[
          Icon(Icons.history, size: 100.0, color: Colors.grey[300]),
          Text("Aucun historique", style: TextStyle(color: Colors.grey),)
        ],
      )
    );
    var list = ListView.builder(
      itemCount: history.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(history[index].title.substring(0, 1))
            ),
            title: Text(history[index].title),
            subtitle: Text(history[index].date),
            trailing: IconButton(
              icon: Icon(Icons.delete_forever, color: Colors.redAccent,), 
              onPressed: () {
                db.deleteHistory(history[index].id).then((onValue) {
                  reloadHistoryList();
                });
              },
            ), 
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => 
                    HiraViewPage(
                      title: history[index].title,
                      hiraList: hiraList, 
                    )
                )
              );
            }, 
          ),
        );
      },
    );
    return new Scaffold(
      backgroundColor: modeSombre == 1 ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
      appBar: new AppBar(
        title: new Text("Historiques"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Supprimer',
            onPressed: () {
              db.deleteAllHistory();
              setState(() {
                history.clear();
              });
            },
          ),
        ],
      ),
      body: history.isEmpty ? noData : list
      
    );
  }
}
