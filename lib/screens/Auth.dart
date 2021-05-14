import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:mymoney/providers/User_Provider.dart';
import 'package:mymoney/screens/DashBoard.dart';

final _formKey = GlobalKey<FormState>();
final  _key = GlobalKey<ScaffoldState>();


class AuthScreen extends StatefulWidget {

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _mobilenumcontroller = new TextEditingController();

  final TextEditingController _namecontroller = new TextEditingController();
  String verificationCode;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String verificationId;
  String otp;
  String phoneNo;
  bool phoneVerify = false;
  bool otpVerify = false;

  Future<void> verifyPhone() async {
    phoneNo = '+91'+_mobilenumcontroller.text.trim();
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      print("phone code auto retrieval timeout");
      verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) async{
      verificationId = verId;
      print("code sent");
      await otpDialogBox();
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {
      print("verification done successfully");
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print("Verification failed");
      setState(() {
        otpVerify = false;
        phoneVerify = false;
      });
      //print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }

  otpDialogBox() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter your OTP'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyText2,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  otp = value;
                },
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  setState(() {
                    otpVerify = true;
                  });
                  await signIn(otp,context);
                  //Navigator.of(context).pop();
                },
                child: otpVerify
                ?Center(child:CircularProgressIndicator(backgroundColor: Theme.of(context).backgroundColor,))
                :Text(
                  'Submit',
                ),
              ),
            ],
          );
        });
  }

  Future<void> signIn(String otp,BuildContext context) async {
    await firebaseAuth.signInWithCredential(PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: otp,))
      .then((AuthResult result) async {
      FirebaseUser user = result.user;
        try{
          print("user signin started");
          await Provider.of<User>(context,listen: false).setUserAndSignIn(user, phoneNo, _namecontroller.text.trim());
          print("user signin ran");
        }
        catch(error){
          throw error;
        }
        Navigator.pop(context);
      })
      .catchError((error) {
        if(this.mounted)
        {
          setState(() {
            otpVerify = false;
            phoneVerify = false;
          });
        }
        print(error.toString());
        Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height : MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.redAccent.shade200, Colors.pinkAccent.shade200]
            )
        ),
        child: phoneVerify
        ?Center(child:CircularProgressIndicator(backgroundColor: Theme.of(context).backgroundColor,))
        :SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new SizedBox(height: MediaQuery.of(context).size.height*0.2,),
                new Container(
                  alignment: Alignment.center,
                  height: 150,
                  width: 150,
                  child: new Image.asset("assets/images/car.png",
                      height: 125,
                      width: 125,
                      fit: BoxFit.fill
                  ),
                ),
                new SizedBox(height: 20.000,),
                Center(
                  child: new Text("LOGIN",
                    style: new TextStyle(fontSize: 25, decoration: TextDecoration.underline, color: Colors.white),),
                ),

                new SizedBox(height: 8.0,),
                new Text("Enter your Name and Mobile Number to proceed",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,


                  ),),
                new SizedBox(height: 30.0,),
                Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width*0.85,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.transparent,
                      border: Border.all(
                          color: Colors.white,
                          width: 0.5
                      )
                  ),
                  child: Row(
                      children:[
                        new CircleAvatar(
                          radius: 25.00,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.supervised_user_circle, color: Colors.redAccent,),
                        ),
                        Expanded(
                          child: new TextFormField(
                            textAlign: TextAlign.center,
                            controller: _namecontroller,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                labelText: "User Name",
                                labelStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white
                                ),
                                contentPadding: EdgeInsets.fromLTRB(70, 0.0, 100, 0.0)

                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),]
                  ),
                ),
                SizedBox(height: 30.0,),
                Container(

                  height: 50.0,
                  width: MediaQuery.of(context).size.width*0.85,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.transparent,
                      border: Border.all(
                          color: Colors.white,
                          width: 0.5
                      )
                  ),
                  child: Row(
                    children: <Widget>[
                      new CircleAvatar(
                        radius: 25.00,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.mobile_screen_share, color: Colors.redAccent,),
                      ),
                      Expanded(
                        child: new TextFormField(
                          textAlign: TextAlign.center,
                          controller: _mobilenumcontroller,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              labelText: "Mobile number",
                              labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white
                              ),
                              contentPadding: EdgeInsets.fromLTRB(67, 0.0, 100, 0.0)
                          ),
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please enter a number';
                            if(value.length != 10)
                              return 'PLease enter a valid number';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                new SizedBox(height: 42.000,),
                SizedBox(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width*0.85,
                  child: new RaisedButton(onPressed: (){
                    if(_formKey.currentState.validate()) {
                      verifyPhone();
                      setState(() {
                        phoneVerify = true;
                      });
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=> Otp(_mobilenumcontroller.text.trim(),_namecontroller.text.trim())));}
                    }
                  },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),

                    ),

                    child: new Text("Send OTP", style: new TextStyle(
                      fontSize: 20,
                      color: Colors.redAccent,

                    ),),
                    color: Colors.white,),
                ),
              ],),
          ),
        ),
      ),
    );
  }}