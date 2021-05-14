import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/Transaction_Provider.dart';


/* DEPENDANT ON MONTHLY AND WEEKLY PROVIDER... SHOULD NOT BE*/


class SettingsButton extends StatefulWidget
{
  final resetPage;
  SettingsButton(this.resetPage);

  @override
  _SettingsButtonState createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  bool isGpay= false;

  bool isCash = false;

  bool isCard = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings,color: Colors.black),
      onPressed: (){showDialog(
          context: context,
          builder:(ctx)=> AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
              title: Center(child: Text('Filter',style: Theme.of(context).textTheme.body1),),
              content: Container(
                height: MediaQuery.of(context).size.height/3.3,
                child: Column(
                  children:[
                    Center(child: Text("Not Selecting any will show all transactions",style: TextStyle(color: Colors.grey,fontSize: 16),)),
                    SwitchListTile(
                      title: Text("CASH",style: Theme.of(context).textTheme.body1),
                      inactiveTrackColor: Theme.of(context).buttonColor,
                      inactiveThumbColor: Colors.grey,
                      activeColor: Colors.amberAccent,
                      value: isCash,
                      onChanged: (val)=> setState((){isCash = val;}),
                    ),
                    SwitchListTile(
                      title: Text("GPAY",style: Theme.of(context).textTheme.body1),
                      inactiveTrackColor: Theme.of(context).buttonColor,
                      inactiveThumbColor: Colors.grey,
                      activeColor: Colors.amberAccent,
                      value: isGpay,
                      onChanged: (val)=> setState((){isGpay = val;}),
                    ),
                    SwitchListTile(
                      title: Text("CARDS",style: Theme.of(context).textTheme.body1),
                      inactiveTrackColor: Theme.of(context).buttonColor,
                      inactiveThumbColor: Colors.grey,
                      activeColor: Colors.amberAccent,
                      value: isCard,
                      onChanged: (val)=> setState((){isCard = val;}),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[

                FlatButton(
                    child: Text("Apply Filters"),
                    onPressed: () {
                      if (isGpay == false && isCash == false && isCard == false) {
                        Provider.of<Transaction>(context, listen: false).doFilter = false;
                        //Provider.of<Weekly_Provider>(context, listen: false).doFilter = false;
                        //Provider.of<Monthly_Provider>(context, listen: false).doFilter = false;
                      }
                      else {
                        Provider.of<Transaction>(context, listen: false).doFilter = true;
                        //Provider.of<Weekly_Provider>(context, listen: false).doFilter = true;
                        //Provider.of<Monthly_Provider>(context, listen: false).doFilter = true;
                        Provider.of<Transaction>(context, listen: false).filterTransList(isCash, isGpay, isCard);
                        //Future.delayed(Duration(seconds: 1),()=>Provider.of<Weekly_Provider>(context, listen: false).filterTransList1(isCash, isGpay, isCard));
                        //Future.delayed(Duration(seconds: 1),()=>Provider.of<Monthly_Provider>(context, listen: false).filterTransList1(isCash, isGpay, isCard));

                      }
                      widget.resetPage();
                      Navigator.of(ctx).pop();
                    }
                ),
              ],
            ),
        );
      },
    );
  }
}