import 'package:cloud_firestore/cloud_firestore.dart';

class database{
  final String uid;
  final CollectionReference profileInfo =
  FirebaseFirestore.instance.collection("Profiles");

  final CollectionReference ListItems =
  FirebaseFirestore.instance.collection("Expenses");


  database({required this.uid});


  Future<void> createUserProfile(String name, String email, String phone,String Profession) async
  {
    return await profileInfo.doc(uid).set({
      'name':name,
      'phone':phone,
      'email':email,
      'profession':Profession,
    });
  }

  Future<void> createUserTransaction_list(String title,double amount, DateTime date,int count) async{
    return await ListItems.doc(uid).collection("List of Transactions").doc("Item $count").set({
      'ID':"Item $count",
      'Title':title,
      'Amount':amount,
      'Date':date,
    });
  }


}



