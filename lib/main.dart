import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mymoney/Widgets/InputWid.dart';
import 'package:mymoney/providers/Transaction_Provider.dart';
import 'package:mymoney/providers/User_Provider.dart';
import 'package:mymoney/screens/DashBoard.dart';
import 'package:mymoney/screens/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //bool isDark = true;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => User(),
        ),

        // CHECK THIS
        /*ChangeNotifierProxyProvider<User,Transaction>(
          //create: (context) =>Transaction(),
          update: (context,user,prevProv)=>Transaction(
            userId: user.id,
          ),
        ),*/
        ChangeNotifierProvider<Transaction>(
          create: (_) => Transaction(),
        ),
      ],
      child: MaterialApp(
          title: 'My Money',
          theme: ThemeData(
            /*backgroundColor: isDark ? Colors.black : Colors.white,
            buttonColor: isDark ? Colors.white : Colors.black,
            textTheme: ThemeData.dark().textTheme.copyWith(
                  bodyText2: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),*/
            backgroundColor: Color(0xFFfaf3dd),
            buttonColor: Colors.black,
            textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText2: TextStyle(color:Colors.black,),
              headline6: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
              headline4: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
              headline5: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),
            ),
            primarySwatch: Colors.teal,
            //primaryColor: Color.fromRGBO(109, 202, 201,1),
            primaryColor: Colors.teal,
          ),
            home: StreamBuilder(
                stream: FirebaseAuth.instance.onAuthStateChanged,
                builder: (context, AsyncSnapshot<FirebaseUser> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (userSnapshot.hasData)
                  {
                    print('userlogin started');
                    Future<void> future = Future(() => Provider.of<User>(context, listen: false).setUserAndLogIn(userSnapshot.data));
                    print('userlogin ran');
                    return DashBoard();
                  }
                  return AuthScreen();
                }),
          routes: {
            //'/': (ctx) => AuthScreen(),
            'Dashboard':(ctx)=>DashBoard(),
            'Auth':(ctx)=>AuthScreen(),
            'inputScreen': (ctx) => InputWid(),
          },
        ),
    );
  }
}
