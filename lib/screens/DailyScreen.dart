import 'package:flutter/material.dart';
import 'package:mymoney/Widgets/DailyTransTile.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/Transaction_Provider.dart';

class DailyScreen extends StatefulWidget
{
  @override
  _DailyScreenState createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {


 DateTime date = DateTime.now();
 void addDate(BuildContext ctx1)
 {
   showDatePicker(
       context: ctx1,
       initialDate: DateTime.now(),
       firstDate: DateTime(2019),
       lastDate: DateTime.now()).then((pickedDate){
     if (pickedDate == null)
     { return;}
     setState(() {
       date = pickedDate;
     });
   });

 }
  @override
  Widget build(BuildContext context) {
    final trans = Provider.of<Transaction>(context,listen: true);
    //trans.createTransMonthWeekList();
    final List<TransactionItem> transactionList = trans.doFilter
        ?trans.filterList.where((item)=>item.date.weekday == date.weekday).toList()
        :trans.tranList.where((item){
          //print(item.date.day.toString()+" "+ date.day.toString());
          return item.date.day == date.day;}).toList();

    List<Color> randomColors = [
      Color.fromRGBO(94, 151, 202, 1),
      Color.fromRGBO(81,116,164,1),
      Color.fromRGBO(89,84,132,1),
      Color.fromRGBO(80,69,98,1),
      Color.fromRGBO(80,69,98,1),
      Color.fromRGBO(89,84,132,1),
      Color.fromRGBO(81,116,164,1),
      Color.fromRGBO(94, 151, 202, 1),
    ];
    int j =0;//length is 6
    //height: MediaQuery.of(context).size.height- AppBar().preferredSize.height-MediaQuery.of(context).padding.top,
    return SingleChildScrollView(
        child: Container(
        color: Theme.of(context).backgroundColor,
          height: MediaQuery.of(context).size.height- AppBar().preferredSize.height-MediaQuery.of(context).padding.top,
          child: Column(
        children: [
          //SizedBox(height: 3,),
          Container(
            color: Theme.of(context).primaryColor,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                      Icons.chevron_left,
                    color:transactionList.length==0?Colors.black:Colors.white,
                  ),
                  onPressed: (){
                    setState(() {
                      date = date.subtract(Duration(days: 1));
                    });
                  },
                  iconSize: 20,
                ),
                GestureDetector(
                    child: Text(
                      DateFormat.yMMMd().format(date),
                      style: TextStyle(
                        fontSize: 20,
                        color:transactionList.length==0?Colors.black:Colors.white,
                      ),
                    ),
                    onTap: ()=> addDate(context),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right,color: transactionList.length==0?Colors.black:Colors.white,),
                  onPressed: () {
                    date.isAfter(DateTime.now().subtract(Duration(days: 1)))
                        ? null :
                    setState(() {
                      date = date.add(Duration(days: 1));
                    });
                  },
                  iconSize: 20,
                ),
              ],
            ),
          ),
          //SizedBox(height: 2,),
          transactionList.length==0
          ?Container(
            color: Theme.of(context).backgroundColor,
            height: MediaQuery.of(context).size.height-203,
              child: Center(
                child: Text(
                  "No Transactions Today",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)
                ),
              )
          )
          :ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (ctx, i) => DailyTransTile(transactionList[i],randomColors[j==8?j=0:j++]),//randomColors[random.nextInt(6)]),
            itemCount: transactionList.length,
          )
        ],
    ),),
    );
  }
}
//tx.date.isAfter(DateTime.now())