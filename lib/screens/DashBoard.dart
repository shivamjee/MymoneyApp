import 'package:flutter/material.dart';
import 'package:mymoney/Widgets/Settings_Button.dart';
import 'package:mymoney/providers/User_Provider.dart';
import 'package:mymoney/screens/OverViewScreen.dart';
import 'package:provider/provider.dart';
import '../screens/DailyScreen.dart';
import '../screens/WeeklyScreen.dart';
import '../screens/MonthlyScreen.dart';
import '../providers/Transaction_Provider.dart';

class DashBoard extends StatefulWidget
{
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  var init = true;
  var isLoading = false;
  @override
  void didChangeDependencies() {
    if(init)
    {
      setState(() {
        isLoading = true;
      });
      Provider.of<Transaction>(context,listen: false).createTransMonthWeekList().then(
          (_){
            setState(() {isLoading = false;});
          }
      ).catchError((error){print(error);});
    }
    init = false;
    super.didChangeDependencies();
  }
  void resetPage()
  {
    setState(() {});

  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('Money Manager',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.notifications,color: Colors.black,),
                onPressed: ()=>Provider.of<User>(context,listen: false).signOut(),
                color: Theme.of(context).buttonColor,
              ),
              SettingsButton(resetPage),

              IconButton(
                icon: Icon(Icons.account_circle,color: Colors.black,),
                iconSize: 50,
                color: Theme.of(context).buttonColor
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  text: 'OverView',
                ),
                Tab(
                  text: 'Daily',
                ),
                Tab(
                  text: 'Weekly',
                ),
                Tab(
                  text: 'Monthly',
                ),
              ],
            ),
          ),
          body: isLoading
            ?Center(child: CircularProgressIndicator(backgroundColor: Theme.of(context).backgroundColor,),)
            :TabBarView(
              children: <Widget>[
                OverViewScreen(),
                DailyScreen(),
                WeeklyScreen(),
                MonthlyScreen(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.black,
            elevation: 20,
            /*shape: ShapeBorder(

            ),*/
            //hoverColor: Colors.pink,
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
            //foregroundColor: Colors.black,
            onPressed: (){
              Navigator.of(context).pushNamed('inputScreen');
            },
          ),
        ),
    );
  }
}
