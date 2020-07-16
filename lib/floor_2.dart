import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'parking_lot.dart';
import 'utils.dart';

class floor_2 extends StatefulWidget {
  Function update;
  bool isAdmin;
  floor_2(this.update,this.isAdmin);
  @override
  _floor_2_state createState() => _floor_2_state();
}

class _floor_2_state extends State<floor_2>{
  @override
  void initState(){
    super.initState();
  }

  List position = [
    //Top Left Corner parking
    {"top":20.0,"left":115.0},{"top":70.0,"left":115.0},
    {"top":20.0,"left":170.0},{"top":20.0,"left":205.0},{"top":20.0,"left":240.0},{"top":20.0,"left":275.0},
    {"top":20.0,"left":310.0},{"top":20.0,"left":345.0},{"top":20.0,"left":380.0},{"top":20.0,"left":415.0},
    {"top":15.0,"left":450.0,"type":"Exit","H":60.0,"L":70.0,"C":Colors.yellowAccent,"T":Colors.black},
    {"top":10.0,"left":530.0,"type":"Guard House","H":70.0,"L":70.0,"C":Colors.deepPurpleAccent,"T":Colors.white},
    {"top":15.0,"left":610.0,"type":"Entrance","H":60.0,"L":70.0,"C":Colors.yellowAccent,"T":Colors.black},
    //Basement block
    {"top":120.0,"left":10.0,"type":"Basement Entrance & Exit","H":50.0,"L":145.0,"C":Colors.yellowAccent,"T":Colors.black},
    {"top":170.0,"left":10.0,"type":"","H":160.0,"L":85.0,"C":Colors.black12,"T":Colors.black},
    {"top":171.0,"left":11.0}, {"top":221.0,"left":11.0}, {"top":271.0,"left":11.0},
    {"top":171.0,"left":63.0},{"top":221.0,"left":63.0}, {"top":271.0,"left":63.0},
    //Level 1 Exit block
    {"top":170.0,"left":95.0,"type":"Exit from Level 1","H":50.0,"L":60.0,"C":Colors.yellowAccent,"T":Colors.black},
    {"top":220.0,"left":95.0,"type":"","H":110.0,"L":55.0,"C":Colors.black12,"T":Colors.black},
    {"top":221.0,"left":116.0}, {"top":271.0,"left":116.0},
    //Level 1 Entrance block
    {"top":170.0,"left":620.0,"type":"Entr. to Level 1","H":50.0,"L":60.0,"C":Colors.yellowAccent,"T":Colors.black},
    {"top":220.0,"left":625.0,"type":"","H":110.0,"L":55.0,"C":Colors.black12,"T":Colors.black},
    {"top":221.0,"left":626.0}, {"top":271.0,"left":626.0},
    //Bottom parking
    {"top":210.0,"left":232.0}, {"top":210.0,"left":267.0}, {"top":210.0,"left":302.0}, //upper
    {"top":210.0,"left":337.0}, {"top":210.0,"left":372.0}, {"top":210.0,"left":407.0}, {"top":210.0,"left":442.0},
    {"top":210.0,"left":477.0}, {"top":210.0,"left":512.0},

    {"top":230.0,"left":152.0}, {"top":280.0,"left":152.0}, //left side
    {"top":280.0,"left":197.0}, {"top":280.0,"left":232.0}, {"top":280.0,"left":267.0}, {"top":280.0,"left":302.0}, //Bottom
    {"top":280.0,"left":337.0}, {"top":280.0,"left":372.0}, {"top":280.0,"left":407.0}, {"top":280.0,"left":442.0},
    {"top":280.0,"left":477.0}, {"top":280.0,"left":512.0}, {"top":280.0,"left":547.0},
    {"top":230.0,"left":590.0}, {"top":280.0,"left":590.0}, //right side
    //Middle block
    {"top":90.0,"left":232.0}, {"top":90.0,"left":267.0}, {"top":90.0,"left":302.0},
    {"top":90.0,"left":442.0,"type":"Shuttle Parking","H":50.0,"L":100.0,"C":Colors.deepPurpleAccent,"T":Colors.white},
    {"top":140.0,"left":232.0,"type":"Motorcycle","H":70.0,"L":30.0,"C":Colors.deepPurpleAccent,"T":Colors.white},
    {"top":140.0,"left":267.0,"type":"","H":35.0,"L":240.0,"C":Colors.deepPurpleAccent,"T":Colors.white},
    {"top":140.0,"left":337.0,"type":"Pick up/Drop off Area","H":35.0,"L":100.0,"C":Color(0xFFFF00FF),"T":Colors.white},
    {"top":175.0,"left":267.0,"type":"INTI Building","H":35.0,"L":240.0,"C":Colors.deepPurpleAccent,"T":Colors.white},
    {"top":140.0,"left":512.0,"type":"Motorcycle","H":70.0,"L":30.0,"C":Colors.deepPurpleAccent,"T":Colors.white},
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
            child: Parking_Lot("Level_2",num,widget.update,widget.isAdmin),
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
