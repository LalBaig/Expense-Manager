import 'package:coffee_shop/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Transaction_Menu extends StatefulWidget {
  late final int counter;
  late final Function addTransaction;
  Transaction_Menu(this.addTransaction, this.counter);

  @override
  _Transaction_MenuState createState() => _Transaction_MenuState();
}

class _Transaction_MenuState extends State<Transaction_Menu> {
  int itemCount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemCount = widget.counter;
  }

  final userTitleController = TextEditingController();
  final userAmountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> Add_data_into_list() async {
    final enteredTitle = userTitleController.text;
    final enteredAmount = double.parse(userAmountController.text);

    if (enteredAmount <= 0 || enteredTitle.isEmpty || _selectedDate == null) {
      return;
    }

    widget.addTransaction(userTitleController.text,
        double.parse(userAmountController.text), _selectedDate);

    Navigator.of(context).pop();

    DateTime dateID = _selectedDate;
    User? user = FirebaseAuth.instance.currentUser;

    await database(uid: user!.uid).createUserTransaction_list(
        userTitleController.text,
        double.parse(userAmountController.text),
        dateID,
        itemCount);
  }

  void _DatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 8.0,
        child: Container(
          margin: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(color: Colors.purple.shade800),
                    icon: Icon(
                      Icons.title,
                      color: Colors.purple.shade800,
                    )),
                controller: userTitleController,
                keyboardType: TextInputType.text,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Amount",
                  labelStyle: TextStyle(color: Colors.purple.shade800),
                  icon: Icon(
                    Icons.attach_money_outlined,
                    color: Colors.purple.shade800,
                  ),
                ),
                controller: userAmountController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.date_range,
                    color: Colors.purple.shade800,
                    size: 20,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    _selectedDate == null
                        ? _selectedDate.toString()
                        : DateFormat.yMd().format(_selectedDate),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade800),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        _DatePicker();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.purple.shade800,
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      child: Text(
                        "Choose Date",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              TextButton.icon(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.purple.shade800,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  onPressed: () {
                    Add_data_into_list();
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Transaction",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
