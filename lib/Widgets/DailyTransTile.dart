import 'package:flutter/material.dart';
import 'package:mymoney/providers/Transaction_Provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class DailyTransTile extends StatefulWidget {
  final TransactionItem transaction;
  final Color bgColor;

  DailyTransTile(this.transaction,this.bgColor);

  @override
  _DailyTransTileState createState() => _DailyTransTileState();
}

class _DailyTransTileState extends State<DailyTransTile> {
  @override
  var isDetailed = false;
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.transaction.id),
      background: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  backgroundColor: Theme.of(context).backgroundColor,
                  title: Text('Are you Sure?',
                      style: Theme.of(context).textTheme.bodyText2),
                  content: Text('Do you want to remove the item?',
                      style: Theme.of(context).textTheme.bodyText2),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("NO"),
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                    FlatButton(
                      child: Text("YES"),
                      onPressed: () => Navigator.of(ctx).pop(true),
                    ),
                  ],
                ));
      },
      onDismissed: (dir) {
        Provider.of<Transaction>(context, listen: false).removeTransaction(widget.transaction.id).then((_)
        {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("product Deleted",
              textAlign: TextAlign.left,
              style:TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.black,
          ),);
        });
      },
      child:
      GestureDetector(
        onTap: () {
          setState(() {
            isDetailed = !isDetailed;
          });
        },
        child: Container(
          padding: EdgeInsets.all(17),
          //margin: const EdgeInsets.only(bottom:3,top: 0),
          //margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: Colors.black,
              //spreadRadius: 4,
              blurRadius: 10,
              offset: Offset(0,3)
              //offset: Offset(0,3),
            )
            ],
            color: widget.bgColor,
            //border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset(
                  widget.transaction.category == cat.Transport
                      ? 'assets/images/car1.png'
                      : widget.transaction.category == cat.Food
                          ? 'assets/images/food1.png'
                          : widget.transaction.category == cat.Health
                              ? 'assets/images/health1.png'
                              : widget.transaction.category == cat.Shopping
                                  ? 'assets/images/shop1.png'
                                  : 'assets/images/food1.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.transaction.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal,color: Colors.white70),
                  ),
                  isDetailed
                      ? Text(
                          "Mode of Payment: " +
                              widget.transaction.modeOfPayment,
                          style: TextStyle(color: Colors.green[500],fontWeight:FontWeight.bold,fontSize: 16),
                        )
                      : SizedBox(height: 0),
                  isDetailed
                      ? Text(
                      DateFormat(DateFormat.HOUR_MINUTE).format(widget.transaction.date),
                          /*widget.transaction.date.hour.toString() +
                              ":" +
                              widget.transaction.date.minute.toString(),*/
                          style: TextStyle(fontSize: 16, color: Colors.grey[900],fontWeight: FontWeight.bold),
                        )
                      : SizedBox(height: 0),
                  isDetailed
                      ? Text(widget.transaction.description)
                      : SizedBox(height: 0),
                ],
              ),
              Spacer(),
              Text(
                "₹" + widget.transaction.amount.toString(),
                style: TextStyle(fontSize: 28,fontWeight: FontWeight.normal,color: Colors.white70),
              ),
              widget.transaction.isCredited
                  ? Icon(
                      Icons.arrow_upward,
                      color: Colors.green,
                      size: 30,
                    )
                  : Icon(
                      Icons.arrow_downward,
                      color: Colors.red,
                      size: 30,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}