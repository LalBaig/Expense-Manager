
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/activities/Edit%20Profile/Edit%20Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

    io.File? _storedImage;


    Future<void>pickImage(ImageSource source) async {
    try {
      final XFile? ImagePicked = await ImagePicker().pickImage(source: source);
      if (ImagePicked == null) {
        return;
      }
      final ImageConvert = io.File(ImagePicked.path);


        setState(() {
          _storedImage = ImageConvert;
        });




      final appDocumentDirectory=await syspath.getApplicationDocumentsDirectory();
      final appDocumentPath=appDocumentDirectory.path;

      final ImageFile=await path.basename(ImageConvert.path);
      final LocalSave=await ImageConvert.copy("${appDocumentPath}/${ImageFile}");


      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('ProfileImage', LocalSave.path.toString());


    } on PlatformException catch (e) {
      print("Failed to pick the image: $e");
    }

  }



  final userRef = FirebaseFirestore.instance.collection("Profiles");
  User? user = FirebaseAuth.instance.currentUser;
  String name = "";
  String email = "";
  String phone = "";
  String Profession = "";

    @override
    void initState() {
      super.initState();
      getUserdata(user!.uid);
      GetUserProfileImage();


    }



    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                imageProfile(),
                SizedBox(height: 20),
                Divider(
                  height: 15.0,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  "Name",
                  style: TextStyle(
                      color: Colors.blueGrey, fontSize: 15, letterSpacing: 1.5),
                ),
                SizedBox(height: 2),
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 18,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Text(
                      "Contact: ",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.phone,
                      color: Colors.grey,
                      size: 20.0,
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  phone,
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 18,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Text(
                      "Email",
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15,
                          letterSpacing: 1.5),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.email,
                      color: Colors.grey,
                      size: 20.0,
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  email,
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                Text(
                  "Profession",
                  style: TextStyle(
                      color: Colors.blueGrey, fontSize: 15, letterSpacing: 1.5),
                ),
                SizedBox(height: 2),
                Text(
                  Profession,
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 18,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w500),
                ),

              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(

          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, new MaterialPageRoute(
                builder: (context) => new EditProfile()));
          },
          backgroundColor: Colors.deepPurpleAccent.shade400,
          child: Icon(Icons.edit),
          elevation: 5.0,
        ),
      );
    }

    void getUserdata(String uid) async {
      final DocumentSnapshot doc = await userRef.doc(uid).get();
      setState(() {
        name = doc.get("name");
        email = doc.get("email");
        phone = doc.get("phone");
        Profession = doc.get("profession");
      });
    }


    Widget imageProfile()  {

      return Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundImage:_storedImage==null?
            Image.asset("assets/flutter.jpeg").image:
            Image.file(io.File(_storedImage!.path)).image,
            radius: 80,

          ),
          Positioned(
              bottom: 2,
              left: 100,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return Container(
                          child: new Wrap(
                            children: <Widget>[
                              new ListTile(
                                  leading: new Icon(Icons.camera_alt),
                                  title: new Text('Take a Photo'),
                                  onTap: () =>
                                  {
                                    pickImage(ImageSource.camera),
                                    Navigator.pop(context)
                                  }
                              ),
                              new ListTile(
                                leading: new Icon(Icons.photo),
                                title: new Text('Pick a Image'),
                                onTap: () =>
                                {
                                  pickImage(ImageSource.gallery),
                                  Navigator.pop(context)

                                },
                              ),
                            ],
                          ),
                        );
                      }
                  );
                },
                child: Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: Colors.deepPurpleAccent.shade100,

                ),
              )


          ),
        ],
      );

    }


  void GetUserProfileImage() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
      String? temp=prefs.getString("ProfileImage");
      if(temp==null){
        return;
      }


    setState(() {
      _storedImage=io.File(temp);
    });

  }



  }


