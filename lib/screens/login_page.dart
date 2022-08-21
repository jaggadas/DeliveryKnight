import 'package:delivery_knight_restaurant/constants/constants.dart';
import 'package:delivery_knight_restaurant/elements/standardbutton.dart';
import 'package:delivery_knight_restaurant/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';



class LoginPage extends StatefulWidget {
  static const id = "loginpage";
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String enteredEmail;
  late String enteredPassword;
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  bool showSpinner=false;
  final _auth=FirebaseAuth.instance;
  bool validateForm() {
    if (email.text.isEmpty ||password.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Log In'),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(image: kBgImageLogin, fit: BoxFit.cover),
            ),
          ),
          // Image(image:kLogoImage,height: 250,width: 250,),
          ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: kTransparentColor,
                    elevation: 10,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: kTransparentColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Let\'s get started',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kTextColor, fontSize: 30),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: kTextFieldInputDecoration.copyWith(
                                icon: Icon(
                                  Icons.email,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Enter email"),
                            onChanged: (value) {
                              enteredEmail = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: password,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style: TextStyle(color: Colors.black),
                            decoration: kTextFieldInputDecoration.copyWith(
                                icon: Icon(
                                  Icons.password,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Enter password"),
                            onChanged: (value) {
                              enteredPassword = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          StandardButton(
                              text: 'Log In',
                              onPressed: () async {
                                if (validateForm()) {
                                  setState(() {
                                    showSpinner=true;
                                  });
                                  try{
                                    final loggedInUser=await _auth.signInWithEmailAndPassword(email: enteredEmail, password: enteredPassword);
                                    if(loggedInUser!=null){
                                      Navigator.popAndPushNamed(context, HomePage.id);
                                      setState(() {
                                        showSpinner=false;
                                      });
                                    }
                                  }
                                  catch(e){
                                    setState(() {
                                      showSpinner=false;
                                    });
                                    print(e);
                                   Fluttertoast.showToast(
                                        msg:"$e",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: kPrimaryColor,
                                    content: const Text(
                                      "Invalid input",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ));
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
