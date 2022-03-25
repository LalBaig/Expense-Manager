import 'package:coffee_shop/services/authenticate.dart';
import 'package:coffee_shop/shared/loading%20spin.dart';
import 'package:flutter/material.dart';
class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final Authenticate auth =Authenticate();
  final formkey=GlobalKey<FormState>();
  String email="";
  String password="";
  String email_not_registered="";
  bool isloading=false;
  @override
  Widget build(BuildContext context) {
    return isloading ? loading_spin(): Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sign In"),
        elevation: 1.5
        ,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white10,
          child: Container(
              color: Colors.white10,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 50),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      //Email text Input
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',labelStyle: TextStyle(color: Colors.purple),
                          hintText: 'Enter Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                        onChanged: (val){
                          setState(() {
                            email=val;
                          });
                        },

                      ),
                      //Pass TextInput
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',labelStyle: TextStyle(color: Colors.purple),
                          hintText: 'Enter Password',
                        ),
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return "Password must be atleast of 8 characters ";
                          }
                          return null;
                        },
                        obscureText: true,
                        onChanged: (val){
                          setState(() {
                            password=val;
                          });

                        },

                      ),

                      SizedBox(height: 10,),
                      ElevatedButton(onPressed: () async{
                        if(formkey.currentState!.validate()){
                          setState(() {

                            isloading=true;
                          });
                          dynamic result=await auth.Sign_In(email,password);
                          if(result==null){
                            setState(() {
                              email_not_registered=" This Email is not Registered!";
                              isloading=false;

                            });
                          }

                        }

                      }
                          , child: Text("Log in"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple.shade800
                      ),),

                      SizedBox(height: 10,),

                      Text(email_not_registered,
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 14.0
                        ),),

                      SizedBox(height: 20,),
                      Row(children: <Widget>[
                        SizedBox(width: 60,),
                        Text("Not Registered?"),
                        SizedBox(width: 2,),
                        Icon(Icons.person_add,
                        size: 20,),

                      ],),
                      SizedBox(height: 8,),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: const Text('Sign Up', style: TextStyle(color: Colors.purple),),
                      ),

                    ],
                  ),

                ),
              )
          ),
          ),
      ),
    );
  }
}
