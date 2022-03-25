import 'package:coffee_shop/activities/Models/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Transaction_list extends StatefulWidget {
  final List<TransactionDetails> list;
  final Function delete_transaction;
  Transaction_list(this.list, this.delete_transaction);

  @override
  _Transaction_listState createState() => _Transaction_listState();
}

class _Transaction_listState extends State<Transaction_list> {
  @override
  Widget build(BuildContext context) {
    return widget.list.isEmpty
        ? DisplayEmptyRow()
        : ListView.builder(
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                color: Colors.white,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.purple.shade800,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FittedBox(
                        child: Text(
                          '\Rs ${widget.list[index].amount.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),
                    ),
                  ),
                  title: Text(widget.list[index].title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
                  subtitle: Text(
                    DateFormat.yMd().format(widget.list[index].date),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      widget.delete_transaction(widget.list[index].id);
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.deepPurple.shade200,
                    ),
                  ),
                ),
              );
            },
          );
  }
}

Widget DisplayEmptyRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          decoration: BoxDecoration(
              color: Colors.amber,
              border: Border.all(
                color: Colors.amber,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.assignment,
                  size: 18,
                  color: Colors.purple.shade800,
                ),
                SizedBox(
                  width: 3,
                ),
                const Text(
                  "Start Tracking Your Expense",
                  style: TextStyle(color: Colors.purple),
                ),
              ],
            ),
          )),
    ],
  );
}
