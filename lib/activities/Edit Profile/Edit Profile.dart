import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldState = GlobalKey<ScaffoldState>();
   String updated_profession="";
   String updated_phone="";
  final userRef = FirebaseFirestore.instance.collection("Profiles");
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body:SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              child: Column(
                children: <Widget>[
                  Text("Change Personal Information",style: TextStyle(fontSize: 20),),
                  Divider(
                    height: 20.0,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter New Profession',
                        hintText: 'Profession',
                        labelStyle: TextStyle(color: Colors.purple.shade800),

                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Profession!";
                        }
                        return null;
                      },

                      onChanged: (val){
                        setState(() {
                            updated_profession=val;
                        });

                      },

                    ),
                  SizedBox(height: 20,),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter New Phone',
                      hintText: 'Phone',
                      labelStyle: TextStyle(color: Colors.purple.shade800),

                  ),
                    validator: (value) {
                      if (value == null || value.length < 11) {
                        return "Invalid Phone ";
                      }
                      return null;
                    },
                    onChanged: (val){
                      setState(() {
                          updated_phone=val;
                      });

                    },

                  ),
                  SizedBox(height: 20,),
                  
                  ElevatedButton(onPressed: () {
                    updateProfile(updated_profession,updated_phone);

                  }
                  , child: Text("Confirm"),
                    style:ElevatedButton.styleFrom(
                      primary: Colors.purple.shade800,
                    )
                  ),
                ],
              ),
            ),

        ),
      ),
      
    );
  }

  void updateProfile(String updated_profession, String updated_phone) {
      userRef.doc(user!.uid).update({
        "profession":updated_profession,
        "phone":updated_phone
      });
    
  }
}
