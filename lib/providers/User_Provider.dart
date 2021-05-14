import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User with ChangeNotifier
{
  String id;
  String name;
  String image;
  String number;
  String token;
  List<Map<String,Object>> _monthLimitList=[];
  List<Map<String,Object>> _weekLimitList=[];

  List<Map<String,Object>> get monthLimitList
  {return [..._monthLimitList];}
  List<Map<String,Object>> get weekLimitList
  {return [..._weekLimitList];}

  Future<void> addMonthLimit(String month, int limit) async
  {
    final url = 'https://moneymanager-fd8ff.firebaseio.com/users/$id/monthLimitList.json';
    try {
      _monthLimitList.add({'title': month, 'value': limit});
      notifyListeners();
      final resp = await http.put(url, body: json.encode(_monthLimitList));
      if (resp.statusCode >= 400) {
        _monthLimitList.removeLast();
        notifyListeners();
        print(resp.statusCode);
      }
    }
    catch (error) {
      _monthLimitList.removeLast();
      notifyListeners();
      print(error);
    }
  }
  Future<void> addWeekLimit(String week, int limit) async
  {
    final url = 'https://moneymanager-fd8ff.firebaseio.com/users/$id/weekLimitList.json';
    try {
      _weekLimitList.add({'title':week,'value':limit});
      notifyListeners();
      final resp = await http.put(url, body: json.encode(_weekLimitList));
      if (resp.statusCode >= 400) {
        _weekLimitList.removeLast();
        notifyListeners();
        print(resp.statusCode);
      }
    }
    catch (error) {
      _weekLimitList.removeLast();
      notifyListeners();
      print(error);
    }

  }
  void setUserData(String uid, String utoken,  Map<String,dynamic> map)
  {
    id = uid;
    name = map['name'];
    number = map['number'];
    image = map['image'];
    token = utoken;
    (map['monthLimitList']).forEach((item){
      _monthLimitList.add({'title':item['title'].toString(),'value':int.parse((item['value']).toString())});
    });
    (map['weekLimitList'] as List<dynamic>).forEach((item){
      _weekLimitList.add({'title':item['title'],'value':int.parse((item['value']).toString())});
    });
    notifyListeners();
  }
  Future<void> setUserAndLogIn(FirebaseUser user) async
  {
    if (user != null)
    {
      final url = 'https://moneymanager-fd8ff.firebaseio.com/users.json';
      try {
        final idToken = await user.getIdToken();
        final String token = idToken.token;
        final resp = await http.get(url);

        final extractedData = json.decode(resp.body) as Map<String, dynamic>;
        MapEntry extractedMap = null;
        if(extractedData != null)
          extractedMap= extractedData.entries.firstWhere((element)=>element.value['number']==user.phoneNumber,orElse: ()=>null);
        if (extractedMap != null) {
          setUserData(extractedMap.key, token, extractedMap.value);
        }
      }
      catch (error) {
        throw error;
      }
    }
  }
    Future<void> setUserAndSignIn(FirebaseUser user, String phoneNo,String name) async
    {
      if (user != null) {
        final url = 'https://moneymanager-fd8ff.firebaseio.com/users.json';
        try {
          final idToken = await user.getIdToken();
          final String token = idToken.token;
          final resp = await http.get(url);

          final extractedData = json.decode(resp.body) as Map<String, dynamic>;
          MapEntry extractedMap = null;
          if(extractedData != null)
            extractedMap= extractedData.entries.firstWhere((element)=>element.value['number']==phoneNo,orElse: ()=>null);
          if (extractedMap != null) {
            print("inside if");
            setUserData(extractedMap.key, token, extractedMap.value);
          }
          else {
            print("inside else");
            Map<String, dynamic> map = {
              'name': name,
              'number': phoneNo,
              'image': '',
              'monthLimitList': [{'title': 'Nov 2020', 'value': 2000},],         //MAKE THEM EMPTY
              'weekLimitList': [{'title': 'Nov 16', 'value': 200},],
            };
            final postResp = await http.post(url, body: json.encode(map));
            setUserData(json.decode(postResp.body)['name'],token, map);
            print("hi3");
          }
        }
        catch (error) {
          throw error;
        }
      }
    }
    Future<void> signOut() async
    {
      try
      {
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        print(e.toString());
      }
    }
  }
