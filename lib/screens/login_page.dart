import 'package:deliveryknight/authservice/authservice.dart';
import 'package:deliveryknight/constants.dart';
import 'package:deliveryknight/elements/standardbutton.dart';
import 'package:deliveryknight/screens/interstitialpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login_screen';
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late String entered_phone;
  late String verificationId;
  late String smsCode;
  bool codeSent = false;
  bool showSpinner = false;
  late ProgressDialog pr;

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult,context);
      pr.close();
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      pr.close();
      Fluttertoast.showToast(
          msg: "${authException.message}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print('${authException.message}');
    };
    final PhoneCodeSent smsSent = (String verId, int? forceResend) {
      setState(() {
        print("hello");

        this.codeSent = true;
        pr.close();
      });

      this.verificationId = verId;
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };
    await auth.verifyPhoneNumber(
      phoneNumber: "+91$phoneNo",
      timeout: const Duration(seconds: 30),
      verificationCompleted: verified,
      verificationFailed: verificationFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }
  toggleSpinner() {
    setState(() {
      showSpinner = !showSpinner;
    });
  }
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context: context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(children: [

        ClipPath(clipper:
        DiagonalPathClipperTwo(),child: Container(color: kPrimaryColor,height: 350,),),
        Container(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 200),child: Text('DeliveryKnight',style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.bold),)),
        ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 100, left: 15, right: 15, bottom: 132),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    codeSent
                        ? FlatButton(
                            onPressed: () {
                              setState(() {
                                codeSent = !codeSent;
                              });
                            },
                            child: Text(
                              'Change phone number',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline),
                            ))
                        : Container(),
                    SizedBox(height: 200,),
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
                              enabled: !codeSent,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(color: Colors.black),
                              decoration: kTextFieldInputDecoration,
                              onChanged: (value) {
                                entered_phone = value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            codeSent
                                ? TextField(
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Colors.black),
                                    decoration:
                                        kTextFieldInputDecoration.copyWith(
                                            hintText: "Enter OTP",
                                            icon: const Icon(
                                              Icons.password,
                                              size: 24,
                                              color: Color(0xffEE2B29),
                                            )),
                                    onChanged: (value) {
                                      smsCode = value;
                                    },
                                  )
                                : Container(),
                            SizedBox(
                              height: 10,
                            ),
                            StandardButton(
                              text: codeSent ? 'Verify' : 'Get OTP',
                              onPressed: () async {


                                if (codeSent) {

                                  await AuthService()
                                      .signInWithOTP(smsCode, verificationId,context);

                                  pr.close();
                                } else {
                                  pr.show(max: 100, msg: "Please Wait", backgroundColor: kGrey,
                                    progressValueColor: kPrimaryColor,
                                    progressBgColor: Colors.deepOrange,
                                    msgColor: Colors.white,);
                                  await verifyPhone(entered_phone);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
