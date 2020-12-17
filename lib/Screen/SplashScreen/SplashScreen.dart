import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/Screen/Home/home.dart';
import 'package:provider/Screen/Login/login.dart';
import 'package:provider/Screen/Request/pickUp.dart';
import 'package:provider/Screen/Request/pickuplast.dart';
import 'package:provider/Screen/SignUp/signup2.dart';
import 'package:provider/data/globalvariables.dart';
import 'package:provider/lastlogin.dart';
import 'package:provider/theme/style.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final String userID;
  final String requestID;
  final String requestIDs;

  SplashScreen({this.userID, this.requestID,this.requestIDs});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  Position currentLocation;
  Position current;
  var fromlat,fromlong,tolat,tolong;
  LatLng fromloc,toloc;

  Animation animation,
      delayedAnimation,
      muchDelayAnimation,
      transfor,
      fadeAnimation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 0.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    transfor = BorderRadiusTween(
        begin: BorderRadius.circular(125.0),
        end: BorderRadius.circular(0.0))
        .animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
   // getRequestDetails();

    if (widget.userID == null) {
      new Timer(new Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=> SignupScreen2()));

      });

    } else {
      if (widget.requestID == null) {
        new Timer(new Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=> HomeScreen()));

        });
      }
      else {
        if(widget.requestIDs == null)
        {
          setRequest();
          new Timer(new Duration(seconds: 2), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=> PickUp(
              requestID: widget.requestID,
              screenName: 'HOME',
            )));

          });

        }else{
          getRequestDetails();
        }

      }
    }
  }




  @override
  void dispose() {
    super.dispose();
  }
  void nav(){
    new Timer(new Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=> LoginScreen()));

    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            body: new Container(
              decoration: new BoxDecoration(color: Colors.white),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Flexible(
                    flex: 1,
                    child: new Center(
                      child: FadeTransition(
                          opacity: fadeAnimation,
                          child: Image.asset(
                            "assets/Picture1.png",
                            height: 100.0,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  Position current1;
  Future setRequest() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Position position =  await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    current1 = position;
    setState(() {

      Globals.loc = current1;
      Globals.two = pref.getString('requestIDs');
    });
  }
  Future getRequestDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Position position =  await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    current = position;
    setState(() {
      Globals.two = pref.getString('requestIDs');
      Globals.loc = position;});
    if(widget.requestIDs!=null){
      var collectionRef = Firestore.instance.collection('requests');
      var doc = await collectionRef.document(widget.requestIDs).get();
      if(doc.exists){
        await Firestore.instance
            .collection('requests')
            .document(widget.requestIDs)
            .get()
            .then((DocumentSnapshot snap) {
          print('reqeust Data: ' + snap.data.toString());
          setRequestData(snap.data);
        });
      }else
      {

        await Firestore.instance
            .collection('temp')
            .document(widget.requestIDs)
            .get()
            .then((DocumentSnapshot snap) {
          print('reqeust Data: ' + snap.data.toString());
          setRequestData(snap.data);
        });
      }



    }
  }
  Future setRequestData(Map<String, dynamic> requestData) async {
    Position position =  await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    current = position;
    print('SOME THING: ' + requestData.toString());
    setState(() {
      Globals.loc = current;
      fromlat = requestData['positionFrom']['latitude'];
      fromlong = requestData['positionFrom']['longitude'];
      tolat = requestData['positionTo']['latitude'];
      tolong = requestData['positionTo']['longitude'];
      fromloc = LatLng(fromlat,fromlong);
      toloc = LatLng(tolat,tolong);
      g();
    });
  }
   g(){
     new Timer(new Duration(seconds: 2), () {
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=> PickUpLast(
         requestID: widget.requestID,
         requestIDone: widget.requestIDs,
         from:fromloc ,
         to: toloc,
         screenName: 'HOME',
       )));

     });



  }
}
