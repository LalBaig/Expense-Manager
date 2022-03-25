import 'package:coffee_shop/activities/Models/User.dart';
import 'package:coffee_shop/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authenticate{
  final FirebaseAuth _auth=FirebaseAuth.instance;

  UserData? _userfromFirebase(User user) {
    return user != null ? UserData(uid: user.uid) : null;
  }


  Stream<UserData?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userfromFirebase(user!));
  }

  Future Sign_In(String email,String pass) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User? user = FirebaseAuth.instance.currentUser;
      return  _userfromFirebase(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future Sign_Out() async {

    try {
        return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future ResisterUser(String email, String pass,String name, String phone,String profession)async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      User? user = FirebaseAuth.instance.currentUser;
      await database(uid:user!.uid).createUserProfile(name, email, phone,profession);
      return  _userfromFirebase;
    }catch(e){
      print(e.toString());
      return null;

    }

  }

}