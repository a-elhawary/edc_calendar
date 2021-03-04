import 'package:edc_cal/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:edc_cal/shared/widgets.dart';
import 'package:edc_cal/data/api.dart';
import 'package:edc_cal/data/user.dart';
import 'package:edc_cal/screens/login_screen.dart';
import 'day_screen.dart';
import 'week_screen.dart';
import 'admin_screen.dart';

/*
  TODO -> Login, Secure Admin
 */

DayScreen dayScreen = DayScreen();
WeekScreen weekScreen = WeekScreen();
AdminScreen adminScreen = AdminScreen();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Widget> screens = [dayScreen, weekScreen, adminScreen];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApplicationConstants.lightGrey,
      appBar: AppBar(
        backgroundColor: ApplicationConstants.orange,
        elevation: 0.0,
        title: Row(
          children: [
            Image.asset("assets/images/edc.jpg", width: 30,),
            SizedBox(width: 10.0,),
            myText(
              "EDC - Calendar",
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: (){
              User.getInstance().forget();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(Icons.exit_to_app),),
        ],
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: screens[selectedIndex],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        onTap: (newIndex){
          setState(() {
            selectedIndex = newIndex;
          });
        },
        currentIndex: selectedIndex,
      ),
    );
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  final Function onTap;
  final int currentIndex;

  MyBottomNavigationBar({@required this.onTap, @required this.currentIndex});
  @override
  Widget build(BuildContext context) {
    if(User.getInstance().isAdmin()){
      return BottomNavigationBar(
        unselectedItemColor: ApplicationConstants.darkGrey,
        selectedItemColor: ApplicationConstants.darkBlue,
        selectedFontSize: 18.0,
        unselectedFontSize: 13.0,
        onTap: onTap,
        currentIndex: currentIndex,
        unselectedIconTheme: IconThemeData(
          size: 18.0,
        ),
        iconSize: 25.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            title: myText("DAY"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: myText("WEEK"),
          ),
          User.getInstance().isAdmin() ? BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            title: myText("ADMIN"),
          ) : SizedBox(),
        ],
      );
    }else{
      return BottomNavigationBar(
        unselectedItemColor: ApplicationConstants.darkGrey,
        selectedItemColor: ApplicationConstants.darkBlue,
        selectedFontSize: 18.0,
        unselectedFontSize: 13.0,
        onTap: onTap,
        currentIndex: currentIndex,
        unselectedIconTheme: IconThemeData(
          size: 18.0,
        ),
        iconSize: 25.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            title: myText("DAY"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: myText("WEEK"),
          )
        ],
      );
    }
    return Container();
  }
}

