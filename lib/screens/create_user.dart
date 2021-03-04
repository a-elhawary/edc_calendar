import 'package:edc_cal/data/api.dart';
import 'package:edc_cal/data/constants.dart';
import 'package:edc_cal/shared/widgets.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  String role = "user";
  String username = "";
  String password = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          backgroundColor: ApplicationConstants.orange,
          elevation: 0.0,
          title: Row(
            children: [
              Image.asset("assets/images/edc.jpg", width: 30,),
              SizedBox(width: 10.0,),
              myText(
                "EDC - Create User",
              ),
            ],
          ),),
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
                            decoration: InputDecoration(
                              hintText: "Username",
                            ),
                            onChanged: (value) {
                              setState(() {
                                username = value;
                              });
                            },
                          ),
                          Container(
                            width: double.infinity,
                            child: DropdownButton(
                              onChanged: (value) {
                                setState(() {
                                  role = value;
                                });
                              },
                              value: role,
                              items: [
                                DropdownMenuItem(
                                  value: "admin",
                                  child: myText("Admin"),
                                ),
                                DropdownMenuItem(
                                  value: "editor",
                                  child: myText("Editor"),
                                ),
                                DropdownMenuItem(
                                  value: "user",
                                  child: myText("User"),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "password",
                            ),
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          loading ? Center(child: CircularProgressIndicator(backgroundColor: ApplicationConstants.orange,),) : UnlockableButton(
                            isClickable: !stringEmpty(password) &&
                                !stringEmpty(username),
                            onPressed: () {
                              Api().addUser(username, role, password).then(
                                  (value){
                                    Navigator.pop(context);
                                  }
                              );
                              setState(() {
                                loading = true;
                              });
                            },
                            child: myText("CREATE USER", color: Colors.white),
                          ),
                        ],
                      ))))),
    );
  }
}
