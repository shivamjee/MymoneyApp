import 'package:flutter/material.dart';
import 'package:mymoney/providers/Transaction_Provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

//gadbad with weekly screen and delete

class DetailScreen extends StatelessWidget
{
  final  monthTransaction;
  final rebuildPage;
  DetailScreen(this.monthTransaction,this.rebuildPage);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (ctx,i)=>Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
            //color: monthTransaction.transList[i].isCredited?Colors.green:Colors.red,
          ),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset(
                  monthTransaction.transList[i].category==cat.Transport? 'assets/images/car1.png'
                      :monthTransaction.transList[i].category==cat.Food?'assets/images/food1.png'
                      :monthTransaction.transList[i].category==cat.Health?'assets/images/health1.png'
                      :monthTransaction.transList[i].category==cat.Shopping?'assets/images/shop1.png':
                  'assets/images/food1.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10,),
              Text(monthTransaction.transList[i].title),
              Text("("+ DateFormat.yMMMd().format(monthTransaction.transList[i].date )+")",style: TextStyle(color: Colors.grey)),
              Spacer(),
              Text("₹"+monthTransaction.transList[i].amount.toString()),
              monthTransaction.transList[i].isCredited
                ? Icon(
                Icons.arrow_upward, color: Colors.green,size: 20,) :Icon(
                Icons.arrow_downward, color: Colors.red,size: 20,),
              IconButton(
                icon: Icon(Icons.delete,color: Colors.red,),
                onPressed: (){
                  Provider.of<Transaction>(context,listen: false).removeTransaction(monthTransaction.transList[i].id).then((_)
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
                  rebuildPage();
                },
              ),
            ],
          ),
        ),
        itemCount: monthTransaction.transList.length,
      ),
    );
  }
}
