import 'package:coffee_shop/shared/loading%20spin.dart';
import 'package:flutter/material.dart';
import 'package:coffee_shop/services/authenticate.dart';
class RegisterUser extends StatefulWidget {

  final Function toggleView;
  RegisterUser({required this.toggleView});


  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {

  final Authenticate auth =Authenticate();


  final formkey=GlobalKey<FormState>();

  String email="";
  String password="";
  String name="";
  String phone="";
  String profession="";


  String error_wrongEmail="";
  bool isloading=false;

  @override
  Widget build(BuildContext context) {
    return isloading ? loading_spin():Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Register User"),
        elevation: 1.5
        ,
      ),
      body:SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10,),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',labelStyle: TextStyle(color: Colors.purple),
                          hintText: 'Enter Name Here',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        onChanged: (val){
                          setState(() {
                            name=val;
                          });
                        },

                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',labelStyle: TextStyle(color: Colors.purple),
                          hintText: 'Enter Email Here',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter a valid email";
                          }
                          return null;
                        },
                        onChanged: (val){
                          setState(() {
                            email=val;
                          });

                        },

                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',labelStyle: TextStyle(color: Colors.purple),
                          hintText: 'Enter Password Here',
                        ),
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return 'Minimum length limit 8 chars';
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
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone',labelStyle: TextStyle(color: Colors.purple),
                          hintText: 'Enter Phone Number',
                        ),
                        validator: (value) {
                          if (value == null || value.length<11) {
                            return 'Please enter valid number ';
                          }
                          return null;
                        },
                        onChanged: (val){
                          setState(() {
                            phone=val;
                          });
                        },

                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Profession',labelStyle: TextStyle(color: Colors.purple),
                          hintText: 'Enter Your Profession',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter profession';
                          }
                          return null;
                        },
                        onChanged: (val){
                          setState(() {
                            profession=val;
                          });
                        },

                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(onPressed: () async{



                         if(formkey.currentState!.validate()){
                           setState(() {
                             isloading=true;
                           });
                          dynamic result= await auth.ResisterUser(email,password,name,phone,profession);



                           if(result==null) {
                            setState(() {
                              error_wrongEmail="Please Enter a Valid Email!";
                              isloading=false;
                            });
                          }
                         }


                      }
                          , child: Text("Sign up",style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple.shade800
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(error_wrongEmail,
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 14.0
                      ),),
                      SizedBox(height: 10,),
                      Row(children: <Widget>[
                        SizedBox(width: 80,),
                        Text("Already Registered?"),
                        SizedBox(width: 2,),
                        Icon(Icons.person,
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
                        child: const Text('Sign In',style: TextStyle(color: Colors.purple),),
                      ),
                    ],
                  ),

                ),
              ),
            )
        );
  }
}
