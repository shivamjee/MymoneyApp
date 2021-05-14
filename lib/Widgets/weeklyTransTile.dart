import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mymoney/Widgets/detailScreen.dart';
import '../providers/Transaction_Provider.dart';
import 'package:flutter/material.dart';


class WeeklyTransTile extends StatefulWidget
{
  final WeekTransaction weekTransaction;
  WeeklyTransTile(this.weekTransaction);

  @override
  _WeeklyTransTileState createState() => _WeeklyTransTileState();
}

class _WeeklyTransTileState extends State<WeeklyTransTile> {
  @override
  var isDetailed = false;

  void showDetail()
  {
    setState((){
      isDetailed = !isDetailed;
    });
  }
  void rebuildPage()
  {
    setState(() {

    });
  }
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
      ),
      /*padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),*/
      child: GestureDetector(
        onTap: showDetail,
        child: Column(
          children:[
            Row(
              children: <Widget>[

                Text(
                  DateFormat.MMMd().format(widget.weekTransaction.title)+"-"+DateFormat.yMMMd().format(widget.weekTransaction.title.add(Duration(days: 6))),
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),
                Spacer(),
                widget.weekTransaction.getWeekTotal()<0?Icon(Icons.arrow_downward,color: Colors.red,):Icon(Icons.arrow_upward,color: Colors.green,),
                Text("₹"+widget.weekTransaction.getWeekTotal().abs().toString(),style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
                IconButton(
                  icon: isDetailed
                      ?Icon(Icons.arrow_drop_up)
                      :Icon(Icons.arrow_drop_down),
                  color: Theme.of(context).buttonColor,
                  //onPressed: showDetail,
                ),
              ],
            ),
            isDetailed?DetailScreen(widget.weekTransaction,rebuildPage):SizedBox(height: 0,),
          ],
        ),
      ),
    );
  }
}