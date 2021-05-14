import 'package:intl/intl.dart';
import 'package:mymoney/Widgets/detailScreen.dart';
import '../providers/Transaction_Provider.dart';
import 'package:flutter/material.dart';


class MonthlyTransTile extends StatefulWidget
{
  final MonthTransaction monthTransaction;
  MonthlyTransTile(this.monthTransaction);

  @override
  _MonthlyTransTileState createState() => _MonthlyTransTileState();
}

class _MonthlyTransTileState extends State<MonthlyTransTile> {
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
      child: Column(
        children:[
          Row(
            children: <Widget>[

              Text(
                DateFormat.yMMM().format(widget.monthTransaction.title),
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
              ),
              Spacer(),
              widget.monthTransaction.getMonthTotal()<0?Icon(Icons.arrow_downward,color: Colors.red,):Icon(Icons.arrow_upward,color: Colors.green,),
              Text("₹"+widget.monthTransaction.getMonthTotal().abs().toString(),style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
              IconButton(
                icon: isDetailed?Icon(Icons.arrow_drop_up):Icon(Icons.arrow_drop_down),
                onPressed: showDetail,
                color: Theme.of(context).buttonColor,
              ),
            ],
          ),
          isDetailed?DetailScreen(widget.monthTransaction,rebuildPage):SizedBox(height: 0,),
        ],
      ),
    );
  }
}