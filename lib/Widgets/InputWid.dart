import 'package:flutter/material.dart';
import 'package:mymoney/providers/Transaction_Provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

//gadbad in dark mode
class InputWid extends StatefulWidget {
  @override
  _InputWidState createState() => _InputWidState();
}

class _InputWidState extends State<InputWid> {

  bool isLoading = false;
  final amountFocusNode = FocusNode();
  final mopFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  String dropDown;
  String dropDown2;
  String dropDown3;
  DateTime selectedDate;
  final formKey = GlobalKey<FormState>();

  var editedProduct = TransactionItem(
      id: DateTime.now().toString(),
      date: DateTime.now(),
      title: '',
      amount: 0.00,
      isCredited: false,
      modeOfPayment: "None",
      description: '',
      category: cat.Others);

  void addDate(BuildContext ctx1) {
    showDatePicker(
            context: ctx1,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = new DateTime(pickedDate.year,pickedDate.month,pickedDate.day,DateTime.now().hour,DateTime.now().minute);

        editedProduct = TransactionItem(
          id: editedProduct.id,
          date: selectedDate,
          title: editedProduct.title,
          amount: editedProduct.amount,
          isCredited: editedProduct.isCredited,
          modeOfPayment: editedProduct.modeOfPayment,
          description: editedProduct.description,
          category: editedProduct.category,
        );
        //editedProduct.date = pickedDate;
      });
    });
  }

  Future<void> saveForm() async{
    final isValid = formKey.currentState.validate();
    if (!isValid) return;
    if (selectedDate == null || dropDown == null || dropDown2 == null|| dropDown3 == null) return;
    formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    try
    {
      await Provider.of<Transaction>(context, listen: false).addTransaction(editedProduct);
    }
    catch(error)
    {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text(error.toString()),
          actions: <Widget>[
            FlatButton(child: Text('Okay'), onPressed: () {
              Navigator.of(ctx).pop();
            },)
          ],
        ),
      );
    }
    finally
    {
      setState(() => isLoading = false );
      Navigator.of(context).pop();
    }
  }

  void dispose() {
    amountFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Add Transaction',
            style: TextStyle(fontSize: 24)),//Theme.of(context).textTheme.bodyText2,),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: saveForm,
          ),
        ],
      ),
      body: isLoading
        ? Center(child: CircularProgressIndicator(backgroundColor: Theme.of(context).backgroundColor,),)
        :SingleChildScrollView(
        child: Container(
          color: Theme.of(context).backgroundColor,
          height: MediaQuery.of(context).size.height- AppBar().preferredSize.height-MediaQuery.of(context).padding.top,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Add a Transaction",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.grey, width: 0.5)),
                          width: MediaQuery.of(context).size.width / 2.5,
                          child:
                            Center(
                              child: DropdownButton<String>(
                                hint: Text('Choose One'),
                                value: dropDown,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(
                                    color: Colors.black
                                ),
                                underline: Container(
                                  color: Theme.of(context).backgroundColor,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropDown = newValue;
                                    editedProduct = TransactionItem(
                                      id: editedProduct.id,
                                      date: editedProduct.date,
                                      title: editedProduct.title,
                                      amount: editedProduct.amount,
                                      isCredited: dropDown == "Income" ? true : false,
                                      modeOfPayment: editedProduct.modeOfPayment,
                                      description: editedProduct.description,
                                      category: editedProduct.category,
                                    );
                                  });
                                },
                                items: <String>['Expenditure','Income']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.5)),
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  selectedDate == null
                                      ? 'Choose a Date'
                                      : '${DateFormat.yMMMd().format(selectedDate)}',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                IconButton(
                                  icon: Icon(Icons.date_range),
                                  color: Theme.of(context).buttonColor,
                                  onPressed: () {
                                    addDate(context);
                                    //print(selectedDate.toString());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: Theme.of(context).textTheme.bodyText2,
                          border: new OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Theme.of(context).buttonColor,
                              width: 0.5,
                            ),
                          )),
                      style: Theme.of(context).textTheme.bodyText2,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(amountFocusNode);
                      },
                      onSaved: (value) {
                        editedProduct = TransactionItem(
                          id: editedProduct.id,
                          date: selectedDate,
                          title: value,
                          amount: editedProduct.amount,
                          isCredited: editedProduct.isCredited,
                          modeOfPayment: editedProduct.modeOfPayment,
                          description: editedProduct.description,
                          category: editedProduct.category,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please enter a Title';
                        else
                          return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Amount',
                          labelStyle: Theme.of(context).textTheme.bodyText2,
                          border: new OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Theme.of(context).buttonColor,
                              width: 0.5,
                            ),
                          )
                      ),
                      style: Theme.of(context).textTheme.bodyText2,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: amountFocusNode,
                      onSaved: (value) {
                        editedProduct = TransactionItem(
                          id: editedProduct.id,
                          date: editedProduct.date,
                          title: editedProduct.title,
                          amount: double.parse(value),
                          isCredited: editedProduct.isCredited,
                          modeOfPayment: editedProduct.modeOfPayment,
                          description: editedProduct.description,
                          category: editedProduct.category,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter a Number';
                        if (double.tryParse(value) == null)
                          return 'Engter a valid number';
                        if (double.parse(value) <= 0)
                          return ' Enter the price greater than 0';
                        else
                          return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left:10),
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton<String>(
                        hint: Text('Mode of Payment'),
                        value: dropDown2,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: Colors.black
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropDown2 = newValue;
                            editedProduct = TransactionItem(
                              id: editedProduct.id,
                              date: editedProduct.date,
                              title: editedProduct.title,
                              amount: editedProduct.amount,
                              isCredited: editedProduct.isCredited,
                              modeOfPayment: dropDown2 == 'GPAY/PAYTM'?'GPAY':dropDown2,
                              description: editedProduct.description,
                              category: editedProduct.category,
                            );
                          });
                        },
                        items: <String>['CASH','GPAY/PAYTM','CARD']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left:10),
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton<String>(
                        hint: Text('Category'),
                        value: dropDown3,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: Colors.black
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.grey[500],
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropDown3 = newValue;
                            editedProduct = TransactionItem(
                              id: editedProduct.id,
                              date: editedProduct.date,
                              title: editedProduct.title,
                              amount: editedProduct.amount,
                              isCredited: editedProduct.isCredited,
                              modeOfPayment: editedProduct.modeOfPayment,
                              description: editedProduct.description,
                              category: dropDown3== "Food"
                                    ? cat.Food
                                        : dropDown3== "Transport"
                                    ? cat.Transport
                                        : dropDown3== "Shopping"
                                    ? cat.Shopping
                                        : dropDown3== "Health"
                                    ? cat.Health
                                        : cat.Others,
                            );
                          });
                        },
                        items: <String>['Food','Transport','Shopping','Health','Others']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: Theme.of(context).textTheme.bodyText2,
                          border: new OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Theme.of(context).buttonColor,
                              width: 0.5,
                            ),
                          )
                      ),
                      style: Theme.of(context).textTheme.bodyText2,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: descriptionFocusNode,
                      onSaved: (value) {
                        editedProduct = TransactionItem(
                          id: editedProduct.id,
                          date: editedProduct.date,
                          title: editedProduct.title,
                          amount: editedProduct.amount,
                          isCredited: editedProduct.isCredited,
                          modeOfPayment: editedProduct.modeOfPayment,
                          description: value,
                          category: editedProduct.category,
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Spacer(),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Save",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: saveForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//iscredited and date
