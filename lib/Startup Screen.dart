import 'package:coffee_shop/services/authenticate.dart';
import 'package:coffee_shop/services/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'activities/Models/User.dart';


class StartUpScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     return StreamProvider<UserData?>.value(
      catchError: (_, __) => null,
      value: Authenticate().user,
      initialData: null,
      child: MaterialApp(

        theme: ThemeData(
          primaryColor: Colors.purple.shade800,
          inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.purple.shade800),

              )),
          hintColor: Colors.purple.shade800,
          textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.purple.shade800),

        ),

        home:Wrapper(),
      ),
    );

  }
}
