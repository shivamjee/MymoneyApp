
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Transaction_Provider.dart';
import '../Widgets/MonthTransTile.dart';

class MonthlyScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    final mp = Provider.of<Transaction>(context);

    return Container(
        color: Theme.of(context).backgroundColor,
        child:
        /*mp.doFilter
        ?mp.filterList.length==0
          ?Center(child: Text("no transactions yet"),)
          :ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx,i)=> MonthlyTransTile(mp.filterList[i]),
            itemCount: mp.filterList.length)
        :*/
        mp.monthList.length==0
        ?Center(child: Text(
            "No Transactions Today",
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)
        ),)
        :ListView.builder(
          shrinkWrap: true,
          itemBuilder: (ctx,i)=> MonthlyTransTile(mp.monthList[i]),
          itemCount: mp.monthList.length,
        ),
    );
  }
}