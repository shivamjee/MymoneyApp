import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';


//SET limit button in overviewScreen.dart

class SetLimit extends StatefulWidget {

  int limit;
  int upperLimit;
  SetLimit(this.limit,[this.upperLimit]);
  @override
  _SetLimitState createState() => _SetLimitState();
}

class _SetLimitState extends State<SetLimit> {


  final limitValueController = TextEditingController();
  bool error = false;

  void initState()
  {
    limitValueController.text = widget.limit==null?'':widget.limit.toString();
    limitValueController.addListener(() {
      setState(() {
        //print(limitValueController.text);
        if(limitValueController.text.length!=0)
        {
          //print(limitValueController.text);
          widget.limit = int.parse(limitValueController.text);
        }

      });
    });
    super.initState();
  }
  void dispose()
  {
    limitValueController.removeListener(() {setState(() {}); });
    super.dispose();
  }


  void reset(int value) {
    setState(() {
      widget.limit = value;
      limitValueController.text = value.toString();
      //print(limitValueController.text);

    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width/2,
        height:  MediaQuery.of(context).size.height/2.5,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(error)
                  Text('Please set a value:', style: TextStyle(color: Colors.red,fontSize: 14),),
                Text('Set Value:', style: Theme.of(context).textTheme.bodyText2,),
                SizedBox(width: 10,),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: TextFormField(
                    //initialValue: widget.limit.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black,),
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    )),
                    controller: limitValueController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    //focusNode: amountFocusNode,
                    //onChanged: (value)=>reset(int.parse(value))
                  ),
                ),
              ],
            ),
            NumberPicker.integer(
                initialValue: widget.limit == null?0:widget.limit,
                minValue: 0,
                maxValue: widget.upperLimit == null?4294967296:widget.upperLimit,
                step: 100,
                onChanged: (newValue) => reset(newValue)
            ),
            //new Text("Current number: ${widget.limit} "),

            FlatButton(
                onPressed: () {
                  if(widget.limit == null)
                    setState(() {
                      error = true;
                    });
                  else
                    error = false;
                  if(!error)
                    Navigator.of(context).pop(widget.limit);
                },
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.lightBlue,),
                  textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      );
  }
}
