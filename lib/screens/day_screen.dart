import 'package:edc_cal/data/api.dart';
import 'package:edc_cal/data/constants.dart';
import 'package:edc_cal/data/user.dart';
import 'package:flutter/material.dart';
import 'package:edc_cal/shared/widgets.dart';
import 'package:intl/intl.dart';

class DayScreen extends StatefulWidget {
  final DateTime date;
  DayScreen({this.date});
  @override
  _DayScreenState createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  int initialTime = 3;
  int finalTime = 9;
  DateTime date;
  List<Widget> roomOne;
  List<Widget> roomTwo;

  @override
  void initState() {
    super.initState();
    if(widget.date == null){
      DateTime currentDate= DateTime.now();
      date = currentDate.subtract(Duration(hours: currentDate.hour, minutes: currentDate.minute, seconds: currentDate.second));
    }else{
      date = widget.date;
    }
    String firstHalf = DateFormat.yMMMMd('en_US').format(date);
    String secondHalf = new DateFormat.Hm().format(date);
    String today = "$firstHalf $secondHalf:00 +0200";

    Api().getDay(today).then(
        (value){
          List data = value["data"];
          roomOne = [];
          roomTwo= [];
          if(data.length == 0){
            setState(() {});
            return;
          }
          int currentSlot = 0;
          int hour = int.parse(data[currentSlot][0].split(" ")[3].split(":")[0]);
          String startTime = "$hour:${data[currentSlot][0].split(" ")[3].split(":")[1]}";
          String endTime = data[currentSlot][4];

          int minute = int.parse(endTime.split(":")[1]);
          for(double i = 15; i < 21; i++){
            if(hour == i){
              // put in the correct room
              if(data[currentSlot][2] == 1 || data[currentSlot][2] == "1"){
                roomOne.add(Slot(
                 color: ApplicationConstants.darkBlue,
                 text: data[currentSlot][1],
                 subText: '$startTime - $endTime',
                 halfSize: minute > 0,
               ));
                if(minute > 0){
                  roomOne.add(Slot(blankSlot: true, halfSize: true));
                }
               roomTwo.add(Slot(blankSlot: true,));
              }else{
                roomTwo.add(Slot(
                  color: ApplicationConstants.orange,
                  text: data[currentSlot][1],
                  subText: '$startTime - $endTime',
                  halfSize: minute > 0,
                ));
                if(minute > 0){
                  roomTwo.add(Slot(blankSlot: true, halfSize: true));
                }
                roomOne.add(Slot(blankSlot: true,));
              }
              // increment current slot and calculate hour
              if(data.length -1 > currentSlot){
                currentSlot++;
                hour = int.parse(data[currentSlot][0].split(" ")[3].split(":")[0]);
                startTime = "$hour:${data[currentSlot][0].split(" ")[3].split(":")[1]}";
                endTime = data[currentSlot][4];
                minute = int.parse(endTime.split(":")[1]);
              }

            }else{
              roomOne.add(Slot(blankSlot: true));
              roomTwo.add(Slot(blankSlot: true));
            }
          }
          setState(() {});
        }
        // loop for each slot
    );
  }

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          !User.getInstance().isAdminOrEditor()? SizedBox() : myContainer(
            child: Row(
              children: [
                myText(
                  "Create Appointment",
                  color: ApplicationConstants.orange,
                  size: 17.0,
                ),
                Spacer(flex: 1,),
                CircleAvatar(
                  radius: 15.0,
                  backgroundColor: ApplicationConstants.orange,
                  child: Icon(Icons.add, color: Colors.white,),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.0),
          Expanded(
            child: myContainer(
              child: roomOne == null || roomTwo == null? Center(child: CircularProgressIndicator(backgroundColor: ApplicationConstants.orange,),): Column(
                children: [
                  Row(
                    children: [
                      Spacer(flex: 1,),
                      myText(
                        "Room #1",
                        color: ApplicationConstants.darkBlue,
                      ),
                      Spacer(flex: 1,),
                      myText(
                        "Room #2",
                        color: ApplicationConstants.orange,
                      ),
                      Spacer(flex: 1,),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  CalendarSlots(
                    slotsManager: SlotsManager(
                      roomOne: roomOne,
                      roomTwo: roomTwo,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }
}

class Slot extends StatelessWidget {
  final bool halfSize;
  final bool blankSlot;
  final Color color;
  final String text;
  final String subText;

  Slot({
    this.halfSize = false,
    this.blankSlot = false,
    this.color,
    this.text,
    this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // if editor or higher
        if(blankSlot){
         // create appointment
        }else{
         // show delete/edit screen
        }
      },
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: halfSize ? 55.0 : 113.0,
            decoration: BoxDecoration(
              color: blankSlot ? null : color,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: blankSlot ? SizedBox() : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                myText(
                  text,
                  color: Colors.white,
                  size: 17.0,
                ),
                myText(subText, color: Colors.white),
              ],
            ),
          ),
          SizedBox(height: 3),
        ],
      ),
    );
  }
}


class SlotsManager extends StatelessWidget {
  final List roomOne;
  final List roomTwo;

  SlotsManager({this.roomOne, this.roomTwo});

  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacer(flex: 2,),
        Flexible(
          flex: 4,
          child: Column(
            children: roomOne,
          ),
        ),
        Spacer(flex: 1),
        Flexible(
          flex: 4,
          child: Column(
            children: roomTwo,
          ),
        ),
        Spacer(flex: 1,),
      ],
    );
  }
}


class CalendarSlots extends StatelessWidget {
  final int initialTime = 3;
  final int finalTime = 9;
  final Widget slotsManager;
  CalendarSlots({this.slotsManager});
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for(int i = initialTime; i <= finalTime; i++){
     children.add(Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         myText("$i:00"),
         SizedBox(width: 5.0,),
         Expanded(
           child: Container(
             height: 0.5,
             color: ApplicationConstants.darkGrey,
           ),
         ),
       ],
     ));
     if(i != finalTime) children.add(SizedBox(height: 100.0,));
    }
    return Expanded(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: children,
            ),
            slotsManager,
          ],
      ),
    ));
  }
}



