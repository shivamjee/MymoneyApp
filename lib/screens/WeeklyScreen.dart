
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Transaction_Provider.dart';
import '../Widgets/weeklyTransTile.dart';

class WeeklyScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    final wp = Provider.of<Transaction>(context);

    return Container(
          color: Theme.of(context).backgroundColor,
          child:
          /*wp.doFilter
          ?wp.filterList.length==0
          ?Center(child: Text("no transactions yet"),)
          :ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx,i)=> WeeklyTransTile(wp.filterList[i]),
            itemCount: wp.filterList.length)
          :*/
          wp.weekList.length==0
          ?Center(child: Text(
              "No Transactions Today",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)
          ),)
          :ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx,i)=> WeeklyTransTile(wp.weekList[i]),
            itemCount: wp.weekList.length,
          ),
    );
  }
}