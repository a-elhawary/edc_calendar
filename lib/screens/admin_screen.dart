import 'package:edc_cal/screens/create_user.dart';
import 'package:flutter/material.dart';
import 'package:edc_cal/shared/widgets.dart';
import 'package:edc_cal/data/constants.dart';
import 'package:edc_cal/data/api.dart';
import 'package:edc_cal/data/user.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List data = null;

  @override
  void initState(){
    super.initState();
    refresh();
  }

  void refresh(){
    Api().getUsers(User.getInstance().name, User.getInstance().password).then(
            (json){
          setState(() {
            data = json["data"];
          });
        }
    );
  }

  // TODO - refresh on save user

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        User.getInstance().isAdmin() ? GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => CreateUser(),
            )).then((value){
              setState(() {
                data = null;
                refresh();
              });
            });
          },
          child: myContainer(
            child: Row(
              children: [
                myText(
                  "Create User",
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
        ) : SizedBox(),
        SizedBox(height: 15.0,),
        Expanded(
          child: myContainer(
            child: Column(
              children: [
                myText(
                  "USERS",
                  size: 18.0,
                  color: ApplicationConstants.darkBlue,
                ),
                SizedBox(height: 10.0,),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: ApplicationConstants.darkGrey,
                ),
                Expanded(
                  child: data == null ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: ApplicationConstants.orange,
                    ),
                  ):ListView.separated(
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: myText(
                              data[index][0],
                              textAlign: TextAlign.center,
                              size: 16.0,
                              color: ApplicationConstants.darkBlue,
                            ),
                          ),
                          Expanded(
                            child: myText(
                              "logged out",
                              size: 16.0,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: DropDownWidget(
                              initialText: data[index][1],
                              items: [
                                myText(
                                  "User",
                                ),
                                myText("Editor"),
                                myText("Admin"),
                              ],
                              selections: [
                                "User",
                                "Editor",
                                "Admin",
                              ],
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        myText("Are you sure you want to delete the user ${data[index][0]}"),
                                        SizedBox(height: 10.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                           RaisedButton(
                                             onPressed: (){
                                               Api().removeUser(data[index][0]).then(
                                                   (value){
                                                     refresh();
                                                   }
                                               );
                                               Navigator.pop(context);
                                               setState((){
                                                 data = null;
                                               });
                                             },
                                             color: Colors.red[700],
                                             child: myText("YES", color: Colors.white),
                                           ),
                                            SizedBox(width: 10.0,),
                                            RaisedButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                                color: Colors.green,
                                                child: myText("NO", color: Colors.white)
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red[700],
                              ),
                            ),
                          ),
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

              ],
            ),
          ),
        ),
      ],
    );
  }
}
