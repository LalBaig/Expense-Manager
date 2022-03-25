import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/Widgets/TransactionList_Firebase.dart';
import 'package:coffee_shop/Widgets/chart.dart';
import 'package:coffee_shop/Widgets/transaction_list.dart';
import 'package:coffee_shop/Widgets/transaction_menu.dart';
import 'package:coffee_shop/activities/Account/Account.dart';
import 'package:coffee_shop/activities/Models/Transaction.dart';
import 'package:coffee_shop/services/authenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Dashboard());

class Dashboard extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Dashboard> {
  int count = 0;
  bool _showChart = false;
  String recettitle = "";
  double recentAmount = 0.0;
  DateTime recentdate = DateTime.now();
  String recentid = "";

  @override
  void initState() {
    super.initState();
    getUserdata(user!.uid);
    checkDBExits(user!);
    _loadCounter();
  }

  String name = "";
  bool dbExits = false;
  final Authenticate auth = Authenticate();

  final userRef = FirebaseFirestore.instance.collection("Profiles");
  User? user = FirebaseAuth.instance.currentUser;
  late final List<TransactionDetails> _transaclistion_LIST = [];

  List<TransactionDetails> get recentTransaction {
    return _transaclistion_LIST.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appbar, Widget txList) {
    return [
      Container(
          height: (mediaQuery.size.height -
                  appbar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.35,
          child: Chart(recentTransaction)),
      txList
    ];
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appbar, Widget txChart) {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Chart"),
        SizedBox(
          width: 5,
        ),
        Switch.adaptive(
            activeColor: Colors.amber,
            value: _showChart,
            onChanged: (value) {
              setState(() {
                _showChart = value;
              });
            }),
      ]),
      _showChart
          ? txChart
          : Container(
              height: (mediaQuery.size.height -
                      appbar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child:
                  Transaction_list(_transaclistion_LIST, _deleteTransactions))
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final mediaQuery = MediaQuery.of(context);
    final appbar = AppBar(
      title: const Text("Dashboard"),
    );
    final txChart = Container(
        height: (MediaQuery.of(context).size.height -
                appbar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: Chart(recentTransaction));
    final txList = Container(
        height: (mediaQuery.size.height -
                appbar.preferredSize.height -
                mediaQuery.padding.top) *
            0.65,
        child: Transaction_list(_transaclistion_LIST, _deleteTransactions));

    return Scaffold(
      appBar: appbar,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome,",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Log out'),
              leading: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onTap: () async {
                await auth.Sign_Out();
              },
            ),
            ListTile(
                title: const Text('Profile'),
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.black,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new Account()));
                })
          ],
        ),
      ),

      //show the bar chat and list
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          if (isLandscape)
            ..._buildLandscapeContent(mediaQuery, appbar, txChart),
          if (!isLandscape)
            ..._buildPortraitContent(mediaQuery, appbar, txList),
        ]),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          OpenTransactionBox();
        },
        child: Icon(
          Icons.add,
          color: Colors.purple.shade800,
        ),
        elevation: 5.0,
        backgroundColor: Colors.amber,
      ),
    );
  }

  void getUserdata(String uid) async {
    final DocumentSnapshot doc = await userRef.doc(uid).get();
    setState(() {
      name = doc.get("name");
    });
  }

  void checkDBExits(User user) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('Expenses');

      var doc = await collectionRef
          .doc(user.uid)
          .collection("List of Transactions")
          .limit(1)
          .get();
      setState(() {
        dbExits = doc.docs.isNotEmpty;
      });
    } catch (e) {
      print(e.toString());
      throw e;
    }
    if (dbExits) {
      GetExistingList();
    }
  }

  void _addNewTransaction(String Title, double Amount, DateTime chosendate) {
    final newTx = TransactionDetails(
        id: "Item $count", amount: Amount, date: chosendate, title: Title);

    _transaclistion_LIST.add(newTx);
    _incrementCounter();
  }

  void OpenTransactionBox() {
    showModalBottomSheet(
        context: context,
        builder: (builderContext) {
          return GestureDetector(
            onTap: () {},
            child: Transaction_Menu(_addNewTransaction, count),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransactions(String id) {
    setState(() {
      _transaclistion_LIST.removeWhere((element) => element.id == id);
    });
    print(user!.uid);
    print(id);
    FirebaseFirestore.instance
        .collection('Expenses')
        .doc(user!.uid)
        .collection('List of Transactions')
        .doc(id)
        .delete();
    _decrementCounter();
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      count = (prefs.getInt('counter') ?? 0);
    });
  }

  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      count = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', count);
    });
  }

  void _decrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      count = (prefs.getInt('counter') ?? 0) - 1;
      prefs.setInt('counter', count);
    });
  }

  void GetExistingList() async {
    var stream = await FirebaseFirestore.instance
        .collection("Expenses")
        .doc(user!.uid)
        .collection("List of Transactions")
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                setState(() {
                  recettitle = element.get("Title");
                  recentAmount = element.get("Amount");
                  recentdate = element.get("Date").toDate();
                  recentid = element.get("ID");
                });
                _transaclistion_LIST.add(TransactionDetails(
                    id: recentid,
                    amount: recentAmount,
                    date: recentdate,
                    title: recettitle));
              })
            });
  }
}
