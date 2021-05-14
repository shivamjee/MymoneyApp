import 'package:flutter/material.dart';
import 'package:mymoney/providers/Transaction_Provider.dart';
import 'package:mymoney/providers/User_Provider.dart';
import 'package:provider/provider.dart';
import '../Widgets/SetLimit.dart';
import '../Widgets/SpeedChart.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:flutter_swiper/flutter_swiper.dart';


class OverViewScreen extends StatefulWidget {
  @override
  _OverViewScreenState createState() => _OverViewScreenState();
}



class _OverViewScreenState extends State<OverViewScreen> {


  int monthlyLimit,  weeklyLimit;
  double monthlyNet=0,monthlySpent=0,monthlyEarned=0,weeklyNet=0,weeklySpent=0,weeklyEarned=0;
  DateTime monthDate = DateTime.now(), weekDate = DateTime.now();
  bool isLoading = false;

  //needs work
  void findMonth(BuildContext ctx1)
  {
    showMonthPicker(
      context: ctx1,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime.now(),
      initialDate: monthDate,
      locale: Locale("en"),
    ).then((picketDate) {
      if (picketDate != null) {
        setState(() {
          monthDate = picketDate;
          if(monthDate.month != weekDate.month)
          {
            weekDate = monthDate;
            weekDate = weekDate.add(Duration(days: 7));
          }
        });
      }
    });
  }
  void findweek(BuildContext ctx1)
  {
    showDatePicker(
        context: ctx1,
        initialDate: weekDate,
        firstDate: DateTime(monthDate.year,monthDate.month,1),
        lastDate: DateTime(monthDate.year,monthDate.month+1,0)).then((pickedDate){
      if (pickedDate == null)
      { return;}
      setState(() {
        weekDate = pickedDate;
      });
    });

  }
  @override
  Widget build(BuildContext context) {

    var userProv = Provider.of<User>(context, listen: true);
    var transProv = Provider.of<Transaction>(context, listen: true);
    weekDate = transProv.getNearestMonday(weekDate);
    int idx = userProv.monthLimitList.indexWhere((element) =>element['title'] == DateFormat.yMMM().format(monthDate));
    monthlyLimit = idx == -1?null:userProv.monthLimitList[idx]['value'];
    idx = userProv.weekLimitList.indexWhere((element)=>element['title'] == DateFormat.MMMd().format(weekDate));
    weeklyLimit = idx == -1?null:userProv.weekLimitList[idx]['value'];

    idx = transProv.monthList.indexWhere((element) => element.title.month == monthDate.month);
    if(idx != -1 && monthlyLimit != null)
    {
      monthlyNet = transProv.monthList[idx].getMonthTotal();
      monthlySpent = transProv.monthList[idx].getMonthSpent();
      monthlyEarned = transProv.monthList[idx].getMonthEarned();
    }
    idx = transProv.weekList.indexWhere((element)=>DateFormat.MMMd().format(element.title) == DateFormat.MMMd().format(weekDate));
    if(idx != -1 && weeklyLimit != null)
    {
      weeklyNet = transProv.weekList[idx].getWeekTotal();
      weeklySpent = transProv.weekList[idx].getWeekSpent();
      weeklyEarned = transProv.weekList[idx].getWeekSpent();
    }


    return isLoading
      ?Center(child: CircularProgressIndicator(backgroundColor: Theme.of(context).backgroundColor,),)
      :Container(
        color: Theme.of(context).backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RaisedButton(
                        color: Colors.pink,
                        onPressed: ()=>findMonth(context),
                        child: Text(DateFormat.yMMM().format(monthDate)),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: RaisedButton(
                        color: Colors.pink,
                        onPressed: ()=>findweek(context),
                        child: Text(DateFormat.MMMd().format(Provider.of<Transaction>(context, listen: false).getNearestMonday(weekDate)),),
                      ),
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SetLimitButton(
                    "Monthly",
                    monthlyLimit,
                    Color.fromRGBO(94, 151, 202, 1),
                  ),
                  //Color.fromRGBO(50, 125, 245, 1)),
                  SetLimitButton(
                    "Weekly",
                    weeklyLimit,
                    Color.fromRGBO(100, 50, 125, 1),
                  ),
                  //Color.fromRGBO(128, 57, 245, 1)),
                ],
              ),
              SizedBox(height: 15,),
              (monthlyLimit==null || weeklyLimit == null)?
              Container(
                  child: Center(
                    child: Text(
                        "Set Monthly & Weekly Limit",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)
                    ),
                  )
              )
              :Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/1.7,
                child: Swiper(
                  itemBuilder: (BuildContext context, int i) {
                    if(i==0)
                      return SpeedChart(context, "Monthly", monthlyLimit==0?1:monthlyLimit.toDouble(), monthlyNet,monthlyEarned,monthlySpent);
                    else
                      return SpeedChart(context, "Weekly", weeklyLimit==0?1:weeklyLimit.toDouble(), weeklyNet,weeklyEarned,weeklySpent);

                  },
                  //indicatorLayout: PageIndicatorLayout.,
                  autoplay: true,
                  autoplayDisableOnInteraction: true,
                  itemCount: 2,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 0.8,
                  scale: 0.9,
                  //layout: SwiperLayout.STACK,
                  pagination: new SwiperPagination(
                      margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                      builder: new DotSwiperPaginationBuilder(
                          color: Colors.white30,
                          activeColor: Colors.white,
                          size: 10,
                          activeSize: 10.0),
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
    );
  }


  Future<void> newLimits() async  //not used
  {
    if(monthlyLimit==null || weeklyLimit == null) {
      await alertToSetLimit("Monthly",monthlyLimit); //.then((value){print("hi1");return alertToSetLimit("Weekly",weeklyLimit);});
      print(monthlyLimit);
      await alertToSetLimit("Weekly", weeklyLimit);
      print("weekly done");
    }
  }
  Future<void> alertToSetLimit(String header,int limit) async
  {
    await showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Center(
              child: Text('Set $header Limit',
                  style: Theme.of(context).textTheme.headline6),
            ),
            content: header == 'Monthly'?SetLimit(limit):SetLimit(limit,monthlyLimit));
      }).then((value) async{
        setState(() {isLoading = true;});
        header == 'Monthly'
        ? await Provider.of<User>(context, listen: false).addMonthLimit(DateFormat.yMMM().format(monthDate), value)
        : await Provider.of<User>(context, listen: false).addWeekLimit(DateFormat.MMMd().format(weekDate), value);
        setState(() => header == 'Monthly'
            ? monthlyLimit = value
            : weeklyLimit = value);
          isLoading = false;
      });
  }


  Widget SetLimitButton(String header, int limit, Color bgColor) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 100,
        width: (MediaQuery.of(context).size.width / 2) - 10,
        child: Container(
          margin: EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                bgColor.withOpacity(0.7),
                bgColor,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: GestureDetector(
            onTap: () {
              alertToSetLimit(header, limit);
            },
            child: Center(
              child: Text(
                "$header Limit:\n ${limit!=null?limit:"-"}",
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
