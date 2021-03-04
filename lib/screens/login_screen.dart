import 'package:flutter/material.dart';
import 'package:edc_cal/data/constants.dart';
import 'package:edc_cal/shared/widgets.dart';
import 'package:edc_cal/data/api.dart';
import 'package:edc_cal/data/user.dart';
import 'package:edc_cal/screens/home_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = "";
  String password = "";

  bool isProcessing = false;
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
              "EDC - Login",
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value){
                        setState(() {
                          username = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Username",
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      onChanged: (value){
                        setState(() {
                          password = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Password",
                      ),
                    ),
                    SizedBox(height: 20.0),
                    !isProcessing ? UnlockableButton(
                      isClickable: !stringEmpty(username) && !stringEmpty(password),
                      onPressed: (){
                        Api().loginUser(username, password).then(
                            (json){
                              if(json["status"] == "200"){
                                // save user data
                                User user = User.getInstance();
                                user.role = json["data"]["role"];
                                user.name = username;
                                user.password = password;
                                user.save();
                                // go to homescreen
                                Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ));
                              }else if(json["status"] == "404"){
                                setState(() {
                                  isProcessing = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                     content: myText(json["message"]), 
                                    );
                                  }
                                );
                              }else{
                                setState(() {
                                  isProcessing = false;
                                });
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        content: myText("Something went wrong! Try Again"),
                                      );
                                    }
                                );
                              }
                            }
                        );
                        setState(() {
                          isProcessing = true;
                        });
                      },
                      child: myText("LOGIN", color: Colors.white),
                    ) : CircularProgressIndicator(
                      backgroundColor: ApplicationConstants.orange,
                    ),
                  ],
                ),
              ),
            ),
          ),
      )
    );
  }
}
