import 'package:edc_cal/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:edc_cal/data/constants.dart';


class DropDownWidget extends StatefulWidget {
  final List<Widget> items;
  final List<String> selections;
  final Function onChange;
  final String initialText;
  DropDownWidget({@required this.items, this.selections, this.onChange, this.initialText});
  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  bool controller = false;
  int selectionIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap:(){
            setState((){
              controller = !controller;
            });
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                selectionIndex == -1 ? SizedBox() : Text(widget.selections[selectionIndex]),
                selectionIndex == -1 ? Text(widget.initialText) : SizedBox(),
                Spacer(flex: 1),
                Icon(controller ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        controller ? Container(
          padding: EdgeInsets.all(8.0),
          width:double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.5),
              right: BorderSide(width: 0.5),
              left: BorderSide(width: 0.5),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder:(context, index){
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectionIndex = index;
                    controller = false;
                  });
                  widget.onChange(index);
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: widget.items[index],
                ),
              );
            },
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 0.5,
              color: Colors.grey,
            ),
            itemCount: widget.items.length,
          ),
        ) : SizedBox(),
      ],
    );
  }
}

// usually used with unlockable button
bool stringEmpty(String input){
  if(input.length == 0) return true;
  for(int i = 0; i < input.length; i++){
    if(input[i] != ' ') return false;
  }
  return true;
}

class UnlockableButton extends StatefulWidget {
  final bool isClickable;
  final Function onPressed;
  final Widget child;
  UnlockableButton({this.isClickable, this.onPressed, this.child});

  @override
  _UnlockableButtonState createState() => _UnlockableButtonState();
}

class _UnlockableButtonState extends State<UnlockableButton> {
  @override
  Widget build(BuildContext context) {
    if(widget.isClickable){
      return InkWell(
        onTap: widget.onPressed,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          color: ApplicationConstants.orange,
          child: widget.child,
        ),
      );
    }else{
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        color: Colors.grey,
        child: widget.child,
      );
    }
  }
}

Widget myText(String text, {Color color, double size, TextAlign textAlign}){
  if(text == null){
    return SizedBox();
  }else {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        color: color,
        fontSize: size,
        letterSpacing: 0.6,
      ),
    );
  }
}
Widget myContainer({Widget child}) => Container(
  width: double.infinity,
  padding: EdgeInsets.all(15.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
  ),
  child: child,
);
