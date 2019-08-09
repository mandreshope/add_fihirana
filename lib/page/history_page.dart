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
  List<int> favorisId = [];
  List<int> hiraId = [];
  int increment = 0;

  bool selectAll = false;

  bool _sortAlfabet = false;

  int modeSombre;

  void reloadHistoryList() {
    history.clear();
    db.getHistory().then((onValue) {
      history.addAll(onValue);
      setState(() {
      });
    }); 
  }

  @override
  void initState() {
    super.initState();

    db.updateAllChechedHistory(0).then((onValue) {
      db.getHistory().then((onValue) {
        history.addAll(onValue);
        setState(() {
          history = history;
        });
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

  void _goToHiraViewPage(index) {

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => 
            HiraViewPage(
              title: hiraList[index-1].title,
              hiraList: hiraList, 
            )
        )
      );
    
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
          child: GestureDetector(
            child: ListTile(
              leading: history[index].check == false 
                ? CircleAvatar(
                  child: Text(history[index].title.substring(0, 1))
                )
                :CircleAvatar(
                  child: Icon(Icons.check)
                ),
              title: Text(history[index].title),
              subtitle: Text(history[index].date),
              onTap: () {
                if(increment <=0) {
                  _goToHiraViewPage(history[index].idHira);
                }else {
                  setState(() {
                    if(history[index].check == true) {
                      history[index].check = false;
                      increment--;
                      db.updateHistory(0, history[index].id).then((onValue) {
                        
                      });
                      history[index].checked = 0;
                    }else{
                      history[index].check = true;
                      increment++;
                      db.updateHistory(1, history[index].id).then((onValue) {
                        
                      });
                      history[index].checked = 1;
                    }
                    
                  });
                }
              }, 
            ),
            onLongPress: () {
              setState(() {
                if(history[index].check == true) {
                  history[index].check = false;
                  increment--;
                  db.updateHistory(0, history[index].id).then((_) {
                    
                  });
                  history[index].checked = 0;
                }else{
                  history[index].check = true;
                  increment++;
                  db.updateHistory(1, history[index].id).then((_) {
                    
                  });
                  history[index].checked = 1;
                }
                
              });
            },
          ),
        );
      },
    );
    return new Scaffold(
      backgroundColor: modeSombre == 1 ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
      appBar: new AppBar(
        title: new Text("Historiques"),
        actions: increment <=0 
          ? 
            <Widget>[
              IconButton(
                icon: Icon(Icons.sort_by_alpha),
                tooltip: this._sortAlfabet == false 
                  ? 
                    "Trier par alphabet"
                  :
                    "Trier par date",
                onPressed: () {
                  if(this._sortAlfabet == false) {
                    setState(() {
                      this._sortAlfabet = true;
                      history..sort((a, b) => a.title.compareTo(b.title));
                      
                    });
                  }else {
                    setState(() {
                      this._sortAlfabet = false;
                      history..sort((a, b) => b.id.compareTo(a.id));
                      
                    });
                  }
                },
              ),
            ]
          :
            <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                tooltip: 'Supprimer',
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Row(
                        children: <Widget>[
                          Container(
                            child: Icon(Icons.info_outline),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text('Supprimer'),
                          ),
                        ],
                      ),
                      content: increment == 1 
                      ? Text('$increment historique va être supprimé.',)
                      : increment == history.length 
                        ? Text('Tous les historiques vont être supprimés.',)
                        : Text('$increment historiques vont être supprimés.',), 
                      
                      actions: <Widget>[
                        FlatButton(
                          child: Text('ANNULER'),
                          onPressed: () {
                            Navigator.pop(context);
                          } 
                        ),
                        FlatButton(
                          child: Text('SUPPRIMER'),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              db.deleteHistoryChecked().then((_) {
                                reloadHistoryList();
                                increment = 0;
                              });
                            });
                          } 
                        ),
                      ],
                    ),
                  );
                  
                },
              ),
              increment == history.length 
              ?
                IconButton(
                  icon: Icon(Icons.undo),
                  tooltip: "Annuler",
                  onPressed: () {
                    if(selectAll == false) {
                      setState(() {
                        selectAll = true;
                      });
                    }else {
                      setState(() {
                        selectAll = false;
                      });
                    }
                    if(increment == history.length) {
                      setState(() {
                        setState(() {
                          selectAll = false;
                        });
                      });
                    }

                    if(selectAll == true) {
                      history.forEach((f) {
                        setState(() {
                          f.check = true;
                          increment = history.length;
                          db.updateHistory(1, f.id).then((onValue) {
                        
                          });
                          f.checked = 1;
                        });
                      });
                    }else{
                      history.forEach((f) {
                        setState(() {
                          f.check = false;
                          increment = 0;
                          db.updateHistory(0, f.id).then((onValue) {
                        
                          });
                          f.checked = 0;
                        });
                      });

                    }

                    
                  },
                )
              :
                IconButton(
                  icon: Icon(Icons.select_all),
                  tooltip: "Tout",
                  onPressed: () {
                    if(selectAll == false) {
                      setState(() {
                        selectAll = true;
                      });
                    }else {
                      setState(() {
                        selectAll = false;
                      });
                    }
                    if(increment == history.length) {
                      setState(() {
                        setState(() {
                          selectAll = false;
                        });
                      });
                    }

                    if(selectAll == true) {
                      history.forEach((f) {
                        setState(() {
                          f.check = true;
                          increment = history.length;
                          db.updateHistory(1, f.id).then((onValue) {
                        
                          });
                          f.checked = 1;
                        });
                      });
                    }else{
                      history.forEach((f) {
                        setState(() {
                          f.check = false;
                          increment = 0;
                          db.updateHistory(0, f.id).then((onValue) {
                        
                          });
                          f.checked = 0;
                        });
                      });

                    }

                    
                  },
                ),
            ]
      ),
      body: history.isEmpty ? noData : list
      
    );
  }
}
