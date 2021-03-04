import 'package:edc_cal/data/api.dart';
import 'package:edc_cal/data/constants.dart';
import 'package:edc_cal/data/user.dart';
import 'package:flutter/material.dart';
import 'package:edc_cal/shared/widgets.dart';
import 'package:intl/intl.dart';

class WeekScreen extends StatefulWidget {
  @override
  _WeekScreenState createState() => _WeekScreenState();
}
/*
  TODO -> if 5,5 rather than the add button show a green FULL
 */
class _WeekScreenState extends State<WeekScreen> {
  List data;
  @override
  void initState() {
    super.initState();
    DateTime currentDate= DateTime.now();
    DateTime date = currentDate.subtract(Duration(hours: currentDate.hour, minutes: currentDate.minute, seconds: currentDate.second));
    String firstHalf = DateFormat.yMMMMd('en_US').format(date);
    String secondHalf = new DateFormat.Hm().format(date);
    String today = "$firstHalf $secondHalf:00 +0200";
    Api().getWeek(today).then(
        (value){
          setState(() {
            data = value["data"];
          });
        }
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Spacer(flex: 1,),
                    myText(
                      "DAY",
                      color: ApplicationConstants.darkBlue,
                      size: 17.0,
                    ),
                    Spacer(flex: 1,),
                    myText(
                      "Room #1",
                      color: ApplicationConstants.darkBlue,
                        size: 17.0
                    ),
                    Spacer(flex: 1,),
                    myText(
                      "Room #2",
                      color: ApplicationConstants.orange,
                        size: 17.0
                    ),
                    Spacer(flex: 1,),
                  ],
                ),
                SizedBox(height: 5.0,),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: ApplicationConstants.darkGrey,
                ),
                 Expanded(
                  child: data == null ? Center(child: CircularProgressIndicator(backgroundColor: ApplicationConstants.orange,),): ListView.separated(
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: myText(
                                data[index]["day"],
                                textAlign: TextAlign.center,
                                size: 16.0,
                                color: ApplicationConstants.darkBlue,
                              ),
                            ),
                            Expanded(
                              child: myText(
                                "${data[index]["roomOne"]}",
                                size: 16.0,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: myText(
                                "${data[index]["roomTwo"]}",
                                size: 16.0,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            User.getInstance().isAdminOrEditor() ? CircleAvatar(
                              radius: 13.0,
                              backgroundColor: ApplicationConstants.orange,
                              child: Icon(Icons.add, color: Colors.white,size: 15.0),
                            ) : SizedBox(),
                          ],
                        ),
                      ),
                      separatorBuilder: (context, index) => Container(
                        width: double.infinity,
                        height: 0.5,
                        color: ApplicationConstants.darkGrey,
                      ),
                      itemCount: data.length,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: ApplicationConstants.darkGrey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

