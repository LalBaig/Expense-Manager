import 'package:coffee_shop/activities/Models/User.dart';
import 'package:coffee_shop/activities/authenticate/authenticate_screen.dart';
import 'package:coffee_shop/activities/Dashboard/Dashboard.dart';
import 'package:coffee_shop/services/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user =Provider.of<UserData?>(context);
    if(user==null) {
      return Authenticate_Screen();
    }
    else{
      return Dashboard();
    }
  }
}
