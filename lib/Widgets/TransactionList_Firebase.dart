// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:coffee_shop/activities/Models/Transaction.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// class TransactionList_FIREBASE extends StatefulWidget {
//
//   final List<TransactionDetails> oldList;
//   final Function delete_transaction;
//
//   TransactionList_FIREBASE(this.oldList,this.delete_transaction);
//
//   @override
//   _TransactionList_FIREBASEState createState() => _TransactionList_FIREBASEState();
// }
//
//
// class _TransactionList_FIREBASEState extends State<TransactionList_FIREBASE> {
//
//   User? user = FirebaseAuth.instance.currentUser;
//   String title="";
//   double Amount=0.0;
//   DateTime date=DateTime.now();
//   String id="";
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     GetExistingList();
//   }
//     void GetExistingList() async {
//       var stream = await FirebaseFirestore.instance.collection("Expenses").doc(
//           user!.uid).
//       collection("List of Transactions").get().then((value) =>
//       {
//         value.docs.forEach((element) {
//           setState(() {
//             title=element.get("Title");
//             Amount=element.get("Amount");
//             date=element.get("Date").toDate();
//             id=element.get("ID");
//
//           });
//           widget.oldList.add(TransactionDetails(
//               id: id, amount: Amount, date: date, title: title));
//
//         })
//       });
//     }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//       height: 450,
//       child: ListView.builder(
//         itemCount: widget.oldList.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: EdgeInsets.symmetric(
//               vertical: 10,
//               horizontal: 8,
//             ),
//             color: Colors.white,
//             elevation: 5.0 ,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             child: ListTile(
//
//               leading: CircleAvatar(
//                 radius: 40,
//                 backgroundColor: Colors.purple.shade800,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: FittedBox(
//                     child: Text(
//                       '\Rs ${widget.oldList[index].amount.toStringAsFixed(2)}',
//                       style: TextStyle(color: Colors.amber),
//                     ),
//                   ),
//                 ),
//               ),
//
//               title: Text(widget.oldList[index].title,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   )),
//
//               subtitle: Text(DateFormat.yMd().format(widget.oldList[index].date),
//                 style: TextStyle(color: Colors.grey,),),
//               trailing: IconButton(onPressed: () {
//                 widget.delete_transaction(widget.oldList[index].id);
//                 print(id);
//               }, icon: Icon(Icons.delete_outline,color: Colors.deepPurple.shade200,),
//
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
