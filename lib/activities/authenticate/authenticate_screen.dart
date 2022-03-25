import 'package:coffee_shop/services/Register.dart';
import 'package:coffee_shop/services/sign_in.dart';
import 'package:flutter/material.dart';
class Authenticate_Screen extends StatefulWidget {
  const Authenticate_Screen({Key? key}) : super(key: key);

  @override
  _Authenticate_ScreenState createState() => _Authenticate_ScreenState();
}

class _Authenticate_ScreenState extends State<Authenticate_Screen> {

  bool isSign_in=true;
  void toggleView(){
    setState(() {
      isSign_in=!isSign_in;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isSign_in)
      {
        return SignIn(toggleView: toggleView);
      }
    else{
      return RegisterUser(toggleView: toggleView);
    }
  }
}
