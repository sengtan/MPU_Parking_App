import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'floor_1.dart';
import 'floor_2.dart';

class floors extends StatefulWidget {
  String current_floor = "Level_2";
  bool isAdmin;
  int lots = 0, total = 0;

  floors(this.isAdmin);

  @override
  _floors_state createState() => _floors_state();
}

class _floors_state extends State<floors>{
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Query _floorRef;

  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    count();
  }

  void count(){
    int available = 0;
    _floorRef = _database.reference().child(widget.current_floor);
    _floorRef.keepSynced(true);
    _floorRef.onValue.listen((Event event) {
      List data = List.from(event.snapshot.value);
      data.remove(null);
      data.forEach((set){
        if(set["status"] == "Available")
          available++;
      });
      setState(() {
        widget.lots = available;
        widget.total = data.length;
      });
    });
  }
  Widget number(bool isAdmin){
    count();
    return Container(
      height:25.0,
      width:70.0,
      child: Text("${widget.lots}/${widget.total} Available",style: TextStyle(fontSize: 24.0),)
    );
  }
  Widget decide_floor(floor, update){
    switch(floor){
      case "Level_1": return floor_1(update,widget.isAdmin);break;
      case "Level_2": return floor_2(update,widget.isAdmin);break;
      default: return floor_1(update,widget.isAdmin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 30.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(50.0,0,0,0),
                  child: Container(
                    color: Colors.grey,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.grey,
                      ),
                      child: DropdownButton(
                        value: widget.current_floor,
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 24,
                        onChanged: (String newValue) {
                          setState(() {
                            widget.current_floor = newValue;
                          });
                          count();
                        },
                        items: <String>['Level_2', 'Level_1']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5.0,0,0,0),
                              child: Text(value, style: TextStyle(fontSize: 24.0,color: Colors.white))
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,0,20.0,0),
                  child: number(widget.isAdmin),
                )
              ],
            ),
          ),
          decide_floor(widget.current_floor,count),
          legend(),
        ],
      ),
    );
  }
}

class legend extends StatelessWidget{
  Widget block(Color color, String text){
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(80.0,0.0,5.0,0.0),
          child:Container(
            width: 25.0,
            height: 25.0,
            decoration: new BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5.0,0.0,5.0,0.0),
          child: Text(text, style: TextStyle(fontSize: 20.0),),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
          child: Row(
            children: <Widget>[
              block(Color(0xffff0000),"Occupied"),
              block(Color(0xff00ffff),"Available"),
              block(Color(0xff00ff00),"Reserved")
            ],
          ),
        )
    );
  }
}