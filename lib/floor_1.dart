import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'parking_lot.dart';
import 'utils.dart';

class floor_1 extends StatefulWidget {
  Function update;
  bool isAdmin;
  floor_1(this.update,this.isAdmin);
  @override
  _floor_1_state createState() => _floor_1_state();
}

class _floor_1_state extends State<floor_1>{
  @override
  void initState(){
    super.initState();
  }

  List position = [
    //Top Row
    {"top":20.0,"left":10.0}, {"top":20.0,"left":45.0}, {"top":20.0,"left":80.0}, {"top":20.0,"left":115.0},
    {"top":20.0,"left":150.0}, {"top":20.0,"left":185.0}, {"top":20.0,"left":220.0}, {"top":20.0,"left":255.0},
    {"top":20.0,"left":290.0}, {"top":20.0,"left":325.0}, {"top":20.0,"left":360.0}, {"top":20.0,"left":395.0},
    {"top":20.0,"left":430.0}, {"top":20.0,"left":465.0}, {"top":20.0,"left":500.0}, {"top":20.0,"left":535.0},
    {"top":20.0,"left":570.0}, {"top":20.0,"left":605.0}, {"top":20.0,"left":640.0},
    //Left Column
    {"top":90.0,"left":10.0},{"top":140.0,"left":10.0},{"top":190.0,"left":10.0},
    //Right Column
    {"top":90.0,"left":640.0},{"top":140.0,"left":640.0},{"top":190.0,"left":640.0},
    //Middle Top Row 1
    {"top":90.0,"left":80.0,"type":"Staircase","H":50.0,"L":30.0,"C":Colors.deepPurpleAccent,"T":Colors.white},
    {"top":90.0,"left":115.0}, {"top":90.0,"left":150.0}, {"top":90.0,"left":185.0}, {"top":90.0,"left":220.0},
    {"top":90.0,"left":255.0}, {"top":90.0,"left":290.0}, {"top":90.0,"left":325.0}, {"top":90.0,"left":360.0},
    {"top":90.0,"left":395.0}, {"top":90.0,"left":430.0}, {"top":90.0,"left":465.0}, {"top":90.0,"left":500.0},
    {"top":90.0,"left":535.0,"type":"Staircase","H":50.0,"L":30.0,"C":Colors.deepPurpleAccent,"T":Colors.white},
    {"top":90.0,"left":570.0},
    //Middle Top Row 2
    {"top":140.0,"left":80.0}, {"top":140.0,"left":115.0}, {"top":140.0,"left":150.0}, {"top":140.0,"left":185.0},
    {"top":140.0,"left":220.0}, {"top":140.0,"left":255.0}, {"top":140.0,"left":290.0}, {"top":140.0,"left":325.0},
    {"top":140.0,"left":360.0}, {"top":140.0,"left":395.0},
    {"top":140.0,"left":430.0,"type":"Lift Area","H":50.0,"L":65.0,"C":Colors.deepPurpleAccent,"T":Colors.white},
    {"top":140.0,"left":500.0}, {"top":140.0,"left":535.0}, {"top":140.0,"left":570.0},
    //Middle Bottom Row
    {"top":210.0,"left":80.0,"type":"Motorcycle Parking","H":50.0,"L":100.0,"C":Colors.deepPurpleAccent,"T":Colors.white},
    {"top":210.0,"left":185.0}, {"top":210.0,"left":220.0}, {"top":210.0,"left":255.0}, {"top":210.0,"left":290.0},
    {"top":210.0,"left":325.0}, {"top":210.0,"left":360.0}, {"top":210.0,"left":395.0}, {"top":210.0,"left":430.0},
    {"top":210.0,"left":465.0}, {"top":210.0,"left":500.0}, {"top":210.0,"left":535.0}, {"top":210.0,"left":570.0},
    //Bottom Row
    {"top":250.0,"left":10.0,"type":"Exit to Level 2","H":80.0,"L":50.0,"C":Colors.yellowAccent,"T":Colors.black},
    {"top":280.0,"left":80.0}, {"top":280.0,"left":115.0}, {"top":280.0,"left":150.0}, {"top":280.0,"left":185.0},
    {"top":280.0,"left":220.0}, {"top":280.0,"left":255.0}, {"top":280.0,"left":290.0}, {"top":280.0,"left":325.0},
    {"top":280.0,"left":360.0}, {"top":280.0,"left":395.0}, {"top":280.0,"left":430.0}, {"top":280.0,"left":465.0},
    {"top":280.0,"left":500.0}, {"top":280.0,"left":535.0}, {"top":280.0,"left":570.0},
    {"top":250.0,"left":620.0,"type":"Entr. from Level 2","H":80.0,"L":50.0,"C":Colors.yellowAccent,"T":Colors.black},
  ];

  List<Widget> generatePosition(List position){
    List<Widget> data = [];
    int num = 1;
    position.forEach((location){
      if(location.containsKey("type")){
        data.add(
          Positioned(
            top:location["top"],
            left: location["left"],
            child: Container(
              decoration: myBoxDecoration(location["C"]),
              height:location["H"],
              width:location["L"],
              child: Center(
                child: Text(location["type"],textAlign:TextAlign.center,style:TextStyle(color:location["T"]))
              )
            )
          )
        );
      }
      else{
        data.add(
          Positioned(
            top:location["top"],
            left: location["left"],
            child: Parking_Lot("Level_1",num,widget.update,widget.isAdmin),
          ),
        );
        num++;
      }
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          width: MediaQuery. of(context). size. width,
          height:MediaQuery. of(context). size. height - 30.0 - 50,
          child: Stack(
            children: generatePosition(position),
          ),
        ),
      ],
    );
  }
}
