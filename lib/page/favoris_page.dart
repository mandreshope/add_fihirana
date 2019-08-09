import 'package:add_fihirana/database/dbhelper.dart';
import 'package:add_fihirana/model/favoris.dart';
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
  List<Favoris> favoris2 = [];
  List<Hira> hiraList = <Hira>[];
  int modeSombre;
  List<int> favorisId = [];
  List<int> hiraId = [];
  int increment = 0;

  bool selectAll = false;

  bool _sortAlfabet = false;

  void reloadFavorisList() {
    favoris2.clear();
    db.getFavoris2().then((onValue) {
      favoris2.addAll(onValue);
      setState(() {
        favoris2 = favoris2;
      });
    }); 
  }

  @override
  void initState() {
    super.initState();
    
    db.updateAllChechedFavoris2(0).then((onValue) {
      db.getFavoris2().then((onValue) {
        favoris2.addAll(onValue);
        setState(() {
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

  @override
  Widget build(BuildContext context) {
    print('favoris: ${favoris2.length}');
    
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
      itemCount: favoris2.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: GestureDetector(
            child: ListTile(
              // key: Key(favoris2[index].id.toString()),
              // leading: CircleAvatar(
              //   child: Text(favoris2[index].title.substring(0, 1))
              // ),
              leading: favoris2[index].check == false 
              ? CircleAvatar(
                child: Text(favoris2[index].title.substring(0, 1))
              )
              :CircleAvatar(
                child: Icon(Icons.check)
              ),
              title: Text(favoris2[index].title),
              subtitle: Text(favoris2[index].date),
              onTap: () {
                if(increment <= 0) {
                  _goToHiraViewPage(context, favoris2[index].idHira);
                }else {
                  setState(() {
                    if(favoris2[index].check == true) {
                      favoris2[index].check = false;
                      increment--;
                      favorisId.remove(favoris2[index].id);
                      hiraId.remove(favoris2[index].idHira);
                      db.updateFavoris2(0, favoris2[index].id).then((onValue) {
                        
                      });
                      favoris2[index].checked = 0;
                    }else{
                      favoris2[index].check = true;
                      increment++;
                      favorisId.add(favoris2[index].id);
                      hiraId.add(favoris2[index].idHira);
                      db.updateFavoris2(1, favoris2[index].id).then((onValue) {
                        
                      });
                      favoris2[index].checked = 1;
                    }
                    
                  });
                }
    
              }, 
            ),
            onLongPress: () {
              setState(() {
                if(favoris2[index].check == true) {
                  favoris2[index].check = false;
                  increment--;
                  favorisId.remove(favoris2[index].id);
                  hiraId.remove(favoris2[index].idHira);
                  db.updateFavoris2(0, favoris2[index].id).then((onValue) {
                    
                  });
                  favoris2[index].checked = 0;
                }else{
                  favoris2[index].check = true;
                  increment++;
                  favorisId.add(favoris2[index].id);
                  hiraId.add(favoris2[index].idHira);
                  db.updateFavoris2(1, favoris2[index].id).then((onValue) {
                    
                  });
                  favoris2[index].checked = 1;
                }
                
              });
            },
          ),
        );
      },
    );

    print('favorisId: $favorisId');
    print('hiraId: $hiraId');
    return new Scaffold(
      backgroundColor: modeSombre == 1 ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
      appBar: new AppBar(
        title: new Text("Favoris"),
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
                      favoris2 ..sort((a, b) => a.title.compareTo(b.title));
                      
                    });
                  }else {
                    setState(() {
                      this._sortAlfabet = false;
                      favoris2..sort((a, b) => b.id.compareTo(a.id));
                      
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
                      ? Text('$increment favoris va être supprimé.',)
                      : increment == favoris2.length 
                        ? Text('Tous les favoris vont être supprimés.',)
                        : Text('$increment favoris vont être supprimés.',),
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
                            db.deleteFavorisChecked().then((_) {
                              setState(() {
                                if(increment == favoris2.length ) {
                                  db.updateAllFavorisFromTableHira(null);
                                  HomePageState.hiraList.forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });
                                  HomePageState.hiraSokajyhafa.forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });
                                  HomePageState.hiraFiankohofana.forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });
                                  HomePageState.hiraPaska.forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });
                                  HomePageState.hiraFideranasyfankalazana.forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });
                                  HomePageState.hiraFanahyMasina.forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });
                                  HomePageState.hiraTeninAndriamanitra.forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });
                                  HomePageState.hiraFitorianafilazantsara.forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });
                                  HomePageState.hiraFanatitra.forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });
                                  HomePageState.hiraFanasannyTompo.forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });

                                  HomePageState.hiraKrismasy .forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });

                                  HomePageState.hiraFanosoranampiasa .forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });

                                  HomePageState.hiraMariazy .forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });

                                  HomePageState.hiraFanolorantena .forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });

                                  HomePageState.hiraFahafatesana .forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });

                                  HomePageState.hiraFiravana .forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });

                                  HomePageState.hiraFanoloranjaza.forEach((f) {
                                    if(f.favoris == 1) {
                                      f.favoris = null;
                                    }
                                  });
                                }else {
                                  hiraId.forEach((f) {
                                    HomePageState.hiraList[(f)-1].favoris = null;
                                    db.setFavorisToTableHira(f, null);
                                    HomePageState.hiraSokajyhafa.forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });
                                    HomePageState.hiraFiankohofana.forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });
                                    HomePageState.hiraPaska.forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });
                                    HomePageState.hiraFideranasyfankalazana.forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });
                                    HomePageState.hiraFanahyMasina.forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });
                                    HomePageState.hiraTeninAndriamanitra.forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });
                                    HomePageState.hiraFitorianafilazantsara.forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });
                                    HomePageState.hiraFanatitra.forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });
                                    HomePageState.hiraFanasannyTompo.forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });

                                    HomePageState.hiraKrismasy  .forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });

                                    HomePageState.hiraFanosoranampiasa  .forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });

                                    HomePageState.hiraMariazy  .forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });

                                    HomePageState.hiraFanolorantena  .forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });

                                    HomePageState.hiraFahafatesana  .forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });

                                    HomePageState.hiraFiravana  .forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });


                                    HomePageState.hiraFanoloranjaza.forEach((ff) {
                                      if(ff.id == f) {
                                        ff.favoris = null;
                                        db.setFavorisToTableHira(ff.id, null);
                                      }
                                    });
                                    
                                  });
                                }
                              });
                              increment = 0;
                              reloadFavorisList();
                            });
                          } 
                        ),
                      ],
                    ),
                  );
                },
              ),
              increment == favoris2.length 
                ?
                  IconButton(
                    icon: Icon(Icons.undo),
                    tooltip: 'Annuler', 
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
                      if(increment == favoris2.length) {
                        setState(() {
                          setState(() {
                            selectAll = false;
                          });
                        });
                      }

                      if(selectAll == true) {
                        favoris2.forEach((f) {
                          setState(() {
                            f.check = true;
                            increment = favoris2.length;
                            db.updateFavoris2(1, f.id).then((onValue) {
                              
                            });
                            f.checked = 1;
                          });
                        });
                      }else {
                        favoris2.forEach((f) {
                          setState(() {
                            f.check = false;
                            increment = 0;
                            db.updateFavoris2(0, f.id).then((onValue) {
                              
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
                  tooltip: 'Tout', 
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
                    if(increment == favoris2.length) {
                      setState(() {
                        setState(() {
                          selectAll = false;
                        });
                      });
                    }

                    if(selectAll == true) {
                      favoris2.forEach((f) {
                        setState(() {
                          f.check = true;
                          increment = favoris2.length;
                          db.updateFavoris2(1, f.id).then((onValue) {
                            
                          });
                          f.checked = 1;
                        });
                      });
                    }else {
                      favoris2.forEach((f) {
                        setState(() {
                          f.check = false;
                          increment = 0;
                          db.updateFavoris2(0, f.id).then((onValue) {
                            
                          });
                          f.checked = 0;
                        });
                      });

                    }
                  },
                )
            ]

      ),
      body: favoris2.isEmpty ? noData : list
      
    );
  }
}
