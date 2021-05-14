import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Exceptions/httpException.dart' ;

enum cat {Food,Transport,Shopping,Health,Others}
class TransactionItem
{
  @required final String id;
  @required final String userId;
  @required final DateTime date;
  @required final String title;
  @required final double amount;
  @required final bool isCredited;
  @required final String modeOfPayment;
  @required final cat category;
  String description;

  TransactionItem({
    this.id,
    this.userId,
    this.date,
    this.title,
    this.amount,
    this.isCredited,
    this.modeOfPayment,
    this.description = '',
    this.category, // used in dailytransTile forget abt it
  });
}

class WeekTransaction
{
  final DateTime title;
  final List<TransactionItem> transList;
  //bool showDetail;
  WeekTransaction({this.title,this.transList});//this.showDetail = false});


  double getWeekTotal()
  {
    var total = 0.0;
    for(var i =0 ;i<transList.length;i++)
    {
      transList[i].isCredited == true? total += transList[i].amount:total -= transList[i].amount;
    }
    return total;
  }
  double getWeekSpent()
  {
    var total = 0.0;
    for(var i =0 ;i<transList.length;i++)
    {
      if(!transList[i].isCredited)
        total += transList[i].amount;
    }
    return total;
  }
  double getWeekEarned()
  {
    var total = 0.0;
    for(var i =0 ;i<transList.length;i++)
    {
      if(transList[i].isCredited)
        total += transList[i].amount;
    }
    return total;
  }

}

class MonthTransaction
{
  final DateTime title;
  final List<TransactionItem> transList;
  bool showDetail;
  MonthTransaction({this.title,this.transList,this.showDetail = false,});


  double getMonthTotal()
  {
    var total = 0.0;
    for(var i =0 ;i<transList.length;i++)
    {
      transList[i].isCredited == true? total += transList[i].amount:total -= transList[i].amount;
    }
    return total;
  }
  double getMonthSpent()
  {
    var total = 0.0;
    for(var i =0 ;i<transList.length;i++)
    {
      if(!transList[i].isCredited)
        total += transList[i].amount;
    }
    return total;
  }
  double getMonthEarned()
  {
    var total = 0.0;
    for(var i =0 ;i<transList.length;i++)
    {
      if(transList[i].isCredited)
        total += transList[i].amount;
    }
    return total;
  }

}



class Transaction with ChangeNotifier
{
  String userId = '0403';
  int setMonthlyLimit = 1; // should be part of User provider .. only temp
  int setWeeklyLimit =1;


  bool doFilter = false;

  List<TransactionItem> _filterList =[];
  List<TransactionItem> _transList = [
    /*TransactionItem(
      id: DateTime.now().toString(),
      userId: '0403',
      date: DateTime.now(),
      title: 'Chips',
      amount: 10,
      isCredited: false,
      description: "Lays",
      modeOfPayment: "GPAY",
      category: cat.Food,
    ),
    TransactionItem(
      id: DateTime.now().toString(),
      userId: "0403",
      date: DateTime.now(),
      title: 'Medicine',
      amount: 20,
      isCredited: true,
      description: "Crocin",
      modeOfPayment: "CASH",
      category: cat.Health
    ),*/
  ];
  List<WeekTransaction> _weekList =[];
  List<MonthTransaction> _monthList =[];


  List<TransactionItem> get filterList
  {return [..._filterList];}
  List<TransactionItem> get tranList
  {return [..._transList];}
  List<WeekTransaction> get weekList
  {return [..._weekList];}
  List<MonthTransaction> get monthList
  {return [..._monthList];}




  DateTime getNearestMonday(DateTime date)
  {
    while(date.weekday != 1)
    {
      date = date.subtract(Duration(days: 1));
    }
    return date;
  }
  void addWeeklyTransaction(TransactionItem item)
  {
    DateTime nearestMonDate = getNearestMonday(item.date);
    String nearestMonDateStr = DateFormat.yMMMd().format(nearestMonDate);


    for(var i =0 ;i<_weekList.length;i++)
    {
      String checkDate = DateFormat.yMMMd().format(_weekList[i].title);
      if( checkDate == nearestMonDateStr)
      {
        _weekList[i].transList.insert(0,TransactionItem(
          id:item.id,
          userId: userId,
          title: item.title,
          date: item.date,
          amount: item.amount,
          isCredited: item.isCredited,
          description: item.description,
          modeOfPayment: item.modeOfPayment,
          category: item.category,
        ),
        );
        return;
      }
    }

    List<TransactionItem> temp = [];
    temp.add(TransactionItem(
        id:item.id,
        userId: userId,
        title: item.title,
        date: item.date,
        amount: item.amount,
        isCredited: item.isCredited,
        description: item.description,
        modeOfPayment: item.modeOfPayment,
        category: item.category,
      ),
    );
    //int idx = userWeekLimitList.indexWhere((element) => element['title'] == nearestMonDateStr);
    _weekList.insert(0, WeekTransaction(
        title: nearestMonDate,
        transList: temp,
      )
    );
  }
  void removeWeeklyTransaction(String id)
  {
    _weekList.forEach((item1){
      item1.transList.removeWhere((item2){
        return item2.id.toString() == id;
      });
    });
    _weekList.removeWhere((item){
      return item.transList.length == 0;
    });
  }

  void createWeekTransaction()
  {
    _weekList =[];
    _transList.forEach((element) {
      addWeeklyTransaction(element);
    });

  }



  void addMonthlyTransaction(TransactionItem item)
  {
    for(var i =0 ;i<_monthList.length;i++)
    {
      if( _monthList[i].title.month.toString() == item.date.month.toString())
      {
        _monthList[i].transList.insert(0,TransactionItem(
          id:item.id,
          userId: userId,
          title: item.title,
          date: item.date,
          amount: item.amount,
          isCredited: item.isCredited,
          description: item.description,
          modeOfPayment: item.modeOfPayment,
          category: item.category,
        ),
        );
        return;
      }
    }

    List<TransactionItem> temp = [];
    temp.add(TransactionItem(
    id:item.id,
    userId: userId,
    title: item.title,
        date: item.date,
        amount: item.amount,
        isCredited: item.isCredited,
        description: item.description,
        modeOfPayment: item.modeOfPayment,
        category: item.category,
    ),
    );
    //if(idx == -1)
    _monthList.insert(0, MonthTransaction(
        title: item.date,
        transList: temp,
    )
    );
  }
  void removeMonthlyTransaction(id)
  {
    _monthList.forEach((item1){
      item1.transList.removeWhere((item2){
        return item2.id.toString() == id;
      });
    });
    _monthList.removeWhere((item){
      return item.transList.length == 0;
    });
  }
  void createMonthlyTransaction()
  {
    _monthList = [];
    _transList.forEach((element) {
      addMonthlyTransaction(element);
    });
  }






  Future<void> addTransaction(TransactionItem item) async
  {
    final url = 'https://moneymanager-fd8ff.firebaseio.com/transaction.json';
    try {
      final response = await http.post(  // will use response later to get id
        url,
        body: json.encode({
          //'id': item.id,
          'userId': userId,
          'title': item.title,
          'date': item.date.toIso8601String(),
          'amount': item.amount,
          'isCredited': item.isCredited,
          'description': item.description,
          'modeOfPayment': item.modeOfPayment,
          'category': item.category.toString(),    // check
        }),
      );

      _transList.insert(0, TransactionItem(
        id: json.decode(response.body)['name'],            // use response to get id from
        userId: userId,
        title: item.title,
        date: item.date,
        amount: item.amount,
        isCredited: item.isCredited,
        description: item.description,
        modeOfPayment: item.modeOfPayment,
        category: item.category,
      ),
      );
      print(_transList[0].id+"successfully added");
      addWeeklyTransaction(item);
      addMonthlyTransaction(item);
      notifyListeners();
    }
    catch(error){
      throw error;
    }

  }
  Future<void> removeTransaction(String id)
  {
    final url = 'https://moneymanager-fd8ff.firebaseio.com/transaction/$id.json';
    return http.delete(url).then((response){
      if(response.statusCode >=400) throw httpException('Could not delete product');
      _transList.removeWhere((item){return item.id == id;});
      removeWeeklyTransaction(id);
      removeMonthlyTransaction(id);
      notifyListeners();
    }).catchError((error){
      return error.toString();
    });
  }
  Future<void> createTransMonthWeekList() async
  {
    //_transList =[];
    //_transList.addAll(_tempList.where((element) => element.userId == userId)); //cant use
    final url = 'https://moneymanager-fd8ff.firebaseio.com/transaction.json';
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      if(extractedData == null) return ;
      final List<TransactionItem> tempList =[];
      extractedData.forEach((prodId, prodData) {
        tempList.add(TransactionItem(
          id: prodId,
          userId: prodData['userId'],
          title: prodData['title'],
          date: DateTime.parse(prodData['date']),
          amount: prodData['amount'],
          isCredited: prodData['isCredited'],
          description: prodData['description'] == null?'':prodData['description'],
          modeOfPayment: prodData['modeOfPayment'],
          category: prodData['category'] == "cat.Food"
            ? cat.Food
            : prodData['category']== "cat.Transport"
            ? cat.Transport
            : prodData['category']== "cat.Shopping"
            ? cat.Shopping
            : prodData['category']== "cat.Health"
            ? cat.Health
            : cat.Others,
        ));
      });
      tempList.sort((item1,item2)=>item1.date.compareTo(item2.date));
      _transList = tempList;
      createMonthlyTransaction();
      createWeekTransaction();
    }
    catch(error){
      throw(error);
    }
    //print(_transList);

    //notifyListeners();
  }









  void filterTransList(bool isCash,bool isGpay,bool isCard)
  {

    doFilter = true;
    _filterList = [];
    _transList.forEach((item){
      if(isGpay&&item.modeOfPayment == "GPAY")
      {
        _filterList.add(item);
      }
      if(isCash&&item.modeOfPayment == "CASH")
      {
        _filterList.add(item);
      }
      if(isCard&&item.modeOfPayment == "CARD")
      {
        _filterList.add(item);
      }
    });
    notifyListeners();
  }

}