import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/Screen/Login/loginPhoneVerification.dart';
import 'package:provider/theme/style.dart';
import 'package:provider/Components/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autovalidate = false;
  Validations validations = new Validations();
  static final phoneController = TextEditingController();
  static BuildContext loginScreenContext;

  @override
  Widget build(BuildContext context) {
    loginScreenContext = context;
    return Scaffold(
      body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Column(children: <Widget>[
                // Container(
                //   height: 250.0,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //       image: DecorationImage(
                //           image: AssetImage("assets/image/icon/Layer_2.png"),
                //           fit: BoxFit.cover)),
                // ),
                SizedBox(height: 100,),
                Center(child: Image.asset('assets/Picture1.png')),
                new Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 80.0, 18.0, 0.0),
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: double.infinity,
                        child: new Column(
                          children: <Widget>[

                            new Container(
                              //padding: EdgeInsets.only(top: 100.0),
                                child: new Material(
                                  borderRadius: BorderRadius.circular(7.0),
                                  elevation: 5.0,
                                  child: new Container(
                                    width: MediaQuery.of(context).size.width - 20.0,
                                    height: MediaQuery.of(context).size.height * 0.4,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20.0)),
                                    child: new Form(
                                        autovalidate: autovalidate,
                                        key: formKey,
                                        child: new Container(
                                          padding: EdgeInsets.all(18.0),
                                          child: new Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Login',
                                                style: headingBlack2,
                                              ),
                                              new Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  TextFormField(
                                                      controller: phoneController,
                                                      keyboardType: TextInputType.phone,
                                                      validator:
                                                      validations.validateMobile,
                                                      decoration: InputDecoration(
                                                          border: OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                5.0),
                                                          ),
                                                          prefixIcon: Icon(
                                                            Icons.phone,
                                                            color: blackColor,
                                                            size: 20.0,
                                                          ),
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              CupertinoIcons
                                                                  .clear_thick_circled,
                                                              color: greyColor2,
                                                            ),
                                                            onPressed: () {
                                                              phoneController.text = '';
                                                            },
                                                          ),
                                                          contentPadding:
                                                          EdgeInsets.only(
                                                              left: 15.0,
                                                              top: 15.0),
                                                          hintText: 'Phone',
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily:
                                                              'Quicksand'))),
                                                ],
                                              ),
                                              new ButtonTheme(
                                                height: 50.0,
                                                minWidth:
                                                MediaQuery.of(context).size.width,
                                                child: RaisedButton.icon(
                                                  shape: new RoundedRectangleBorder(
                                                      borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0)),
                                                  elevation: 0.0,
                                                  color: primaryColor,
                                                  icon: new Text(''),
                                                  label: new Text(
                                                    'NEXT',
                                                    style: headingWhite,
                                                  ),
                                                  onPressed: () {
                                                    if (phoneController.text.isEmpty) {
                                                      print('its shit');
                                                      setState(() {
                                                        autovalidate = true;
                                                      });
                                                    } else if (phoneController
                                                        .text.length !=
                                                        10) {
                                                      print('its not equal to 8');
                                                      setState(() {
                                                        autovalidate = true;
                                                      });
                                                    } else {
                                                      sendSMSToPhone();
                                                    }

                                                    // SharedPreferences prefs =
                                                    //     await SharedPreferences
                                                    //         .getInstance();
                                                    // String userID =
                                                    //     prefs.getString('userID');
                                                    // if (userID == null) {
                                                    //   print('GOOD NEWS MAN');
                                                    // } else {
                                                    //   print(
                                                    //       'its a fucked up situation');
                                                    // }
                                                    // _sendCodeToPhoneNumber();
                                                    // submit();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                )),
                            new Container(
                                padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      "Create new account? ",
                                      style: textGrey,
                                    ),
                                    new InkWell(
                                      onTap: () =>
                                          Navigator.pushNamed(context, '/signup2'),
                                      child: new Text(
                                        "Sign Up",
                                        style: textStyleActive1,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ))),
              ])
            ]),
          )),
    );
  }

  Future sendSMSToPhone() async {
    var firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+92' + phoneController.text,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  final PhoneVerificationCompleted verificationCompleted =
      (AuthCredential auth) {
    print('PhoneVerificationCompleted : Auto retrieving verification code');

    // setState(() {
    //   status = 'Auto retrieving verification code';
    // });
    AuthCredential _authCredential = auth;

    FirebaseAuth.instance
        .signInWithCredential(_authCredential)
        .then((AuthResult value) {
      if (value.user != null) {
        print('PhoneVerificationCompleted if: Authentication successful');

        // setState(() {
        //   status = 'Authentication successful';
        // });
        // onAuthenticationSuccessful();
      } else {
        print(
            'PhoneVerificationCompleted else: Invalid code/invalid authentication');

        // setState(() {
        //   status = 'Invalid code/invalid authentication';
        // });
      }
    }).catchError((error) {
      // setState(() {
      print(
          'PhoneVerificationCompleted catch: Something has gone wrong, please try later');
      // });
    });
  };

  final PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
    String actualCode = verificationId;
    String phoneNumber = phoneController.text;
    // setState(() {
    print('PhoneCodeSent : Code sent to phone');
    Navigator.push(
      loginScreenContext,
      MaterialPageRoute(
          builder: (context) => LoginPhoneVerification(
              verificationId: actualCode, phoneNumber: phoneNumber)),
    );
    // Navigator.of(loginScreenContext).pushNamedAndRemoveUntil(
    //     '/profile_setup', (Route<dynamic> route) => false);
    //   status = "\nEnter the code sent to " + phone;
    // });
  };

  final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    String actualCode = verificationId;
    // setState(() {
    print("PhoneCodeAutoRetrievalTimeout: Auto retrieval time out");
    // });
  };

  final PhoneVerificationFailed verificationFailed =
      (AuthException authException) {
    print('PhoneVerificationFailed: ' + authException.message);
    // setState(() {
    //   status = '${authException.message}';

    //   print("Error message: " + status);
    //   if (authException.message.contains('not authorized'))
    //     status = 'Something has gone wrong, please try later';
    //   else if (authException.message.contains('Network'))
    //     status = 'Please check your internet connection and try again';
    //   else
    //     status = 'Something has gone wrong, please try later';
    // });
  };
}