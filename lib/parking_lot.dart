import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'utils.dart';

enum status{
  Available,
  Reserved,
  Occupied,
}

class Parking_Lot extends StatefulWidget{
  status state = status.Available;
  String reserver = "";
  DateTime reserve_time;
  String occupy_time = "";
  String floor;
  int number;
  Function update;
  bool isAdmin;
  Parking_Lot(this.floor, this.number,this.update,this.isAdmin);

  @override
  _Parking_Lot_State createState() => _Parking_Lot_State();
}

class _Parking_Lot_State extends State<Parking_Lot>{
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Query _stateRef;

  @override
  void initState(){
    super.initState();
    _stateRef = _database.reference().child(widget.floor).child(widget.number.toString());
    _stateRef.keepSynced(true);
    _stateRef.onValue.listen((Event event) {
      switch(event.snapshot.value["status"]){
        case "Available": setState((){widget.state = status.Available;});break;
        case "Reserved": setState((){widget.state = status.Reserved;});break;
        case "Occupied": setState((){widget.state = status.Occupied;});break;
        default: setState((){widget.state = status.Available;});
      }
    });
  }

  void Reserve(StateSetter setState){
    _database.reference().child(widget.floor).child(widget.number.toString()).set({"status":"Reserved"});
    widget.update();
    setState(() {
      widget.state = status.Reserved;
    });
  }

  void Available(StateSetter setState){
    _database.reference().child(widget.floor).child(widget.number.toString()).set({"status":"Available"});
    widget.update();
    setState(() {
      widget.state = status.Available;
    });
  }

  void Occupy(StateSetter setState){
    _database.reference().child(widget.floor).child(widget.number.toString()).set({"status":"Occupied"});
    widget.update();
    setState(() {
      widget.state = status.Occupied;
    });
  }

  Color decide_color(status state){
    switch(state){
      case status.Available:
        return Color(0xff00ffff);break;
      case status.Reserved:
        return Color(0xff00ff00);break;
      case status.Occupied:
        return Color(0xffff0000);break;
    }
  }
  String display_msg(status state, int num){
    String msg = "";
    switch(state){
      case status.Available:
        msg = "Lot No. $num\n(Available)";break;
      case status.Reserved:
        msg = "Lot No. $num\n(Reserved)";break;
      case status.Occupied:
        msg = "Lot No. $num\n(Occupied)";break;
    }
    return msg;
  }

  Widget occupy_button(StateSetter setState) {
    return RaisedButton(
      color: Color(0xffff0000),
      onPressed: () => Occupy(setState),
      child: Text("Occupy"),
    );
  }

  Widget decide(status state, int num, String name, StateSetter setState){
    Widget widgets;
    Text msg;
    Widget button;
    switch(state){
      case status.Available:
        msg = Text("Lot No. $num\n(Available)");
        button = RaisedButton(
          color: Color(0xff00ff00),
//          onPressed: () => setState(() {
//            widget.state = status.Reserved;
//            widget.reserve_time = convertDateTime(getDateTime());
//            widget.reserver = name;
//          }),
          onPressed: () => Reserve(setState),
          child: Text("Reserve"),
        );
        if(widget.isAdmin){
          widgets = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              msg, button, occupy_button(setState)
            ],
          );
        }
        else{
          widgets = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              msg, button
            ],
          );
        }
        break;
      case status.Reserved:
        msg = Text("Lot No. $num\n(Reserved)");
        button = RaisedButton(
          color: Color(0xff00ffff),
//          onPressed: () => setState(() {
//            widget.state = status.Available;
//            widget.reserve_time = null;
//            widget.reserver = null;
//          }),
          onPressed: () => Available(setState),
          child: Text("Cancel"),
        );
        if(widget.isAdmin){
          widgets = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              msg, button, occupy_button(setState)
            ],
          );
        }
        else{
          widgets = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              msg, button
            ],
          );
        }
        break;
      case status.Occupied:
        msg = Text("Lot No. $num\n(Occupied)");
        button = RaisedButton(
          color: Color(0xff00ffff),
//          onPressed: () => setState(() {
//            widget.state = status.Available;
//            widget.reserve_time = null;
//            widget.reserver = null;
//          }),
          onPressed: () => Available(setState),
          child: Text("Cancel"),
        );
        if(widget.isAdmin){
          widgets = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              msg, button
            ],
          );
        }
        break;
    }
    return widgets;
  }
  Future<void> popup(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return StatefulBuilder(
              builder: (context, setState){
                return AlertDialog(
                  backgroundColor: decide_color(widget.state),
                  content: SizedBox(
                    width: 50.0,
                    height: 150.0,
                    child: Center(
                        child: decide(widget.state, widget.number, "LOL",setState)
                    )
                  )
                );
              }
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stateRef.onValue,
      builder: (context, AsyncSnapshot<Event> snapshot){
        if(snapshot.hasData){
          switch(snapshot.data.snapshot.value["status"]){
            case "Available": widget.state = status.Available;break;
            case "Reserved": widget.state = status.Reserved;break;
            case "Occupied": widget.state = status.Occupied;break;
            default: widget.state = status.Available;
          }
        }
        return ButtonTheme(
            minWidth: 10.0,
            height: 50.0,
            child: Container(
              decoration: myBoxDecoration(null),
              width: 30.0,
              child: RaisedButton(
                onPressed: () => popup(context),
                child: Text(widget.number.toString(), style: TextStyle(fontSize: 15.0), textAlign: TextAlign.center,),
                color: decide_color(widget.state),
              ),
            )
        );
      },
    );
  }
}
