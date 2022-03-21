

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryknight/authservice/authservice.dart';
import 'package:deliveryknight/constants.dart';
import 'package:deliveryknight/models/Users.dart';
import 'package:deliveryknight/screens/ItemSelect.dart';
import 'package:deliveryknight/screens/myprofilepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  static const id = "homepage";
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Users currentUser = Users(name: 'name', phone: 'phone', regNo: 'regNo');
  bool gotData = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData() async {
    var userData =
        await firestore.collection("users").doc(auth.currentUser?.uid).get();
    print(userData.get('phone'));
    currentUser = Users(
        phone: userData.get('phone'),
        regNo: userData.get('regNo'),
        name: userData.get('name'));
    setState(() {
      gotData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,

        title: Text('Choose Restaurant',),
      ),
      drawer: Drawer(
        backgroundColor: kBackground,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 300,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                ),
                child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      gotData ? currentUser.name : 'Username',
                      style: TextStyle(color: kBackground, fontSize: 18),
                    )),
              ),
            ),
            ListTile(
              title: Text(
                'My Profile',
                style: TextStyle(color: kPrimaryColor),
              ),
              leading: Icon(
                Icons.person,
                color: kPrimaryColor,
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pushNamed(context, MyProfile.id);
              },
            ),
            ListTile(
              title: Text(
                'Sign out',
                style: TextStyle(color: kPrimaryColor),
              ),
              leading: Icon(
                Icons.power_settings_new,
                color: kPrimaryColor,
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                AuthService().signOut(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClipperTwo(flip: true),
            child: Container(
              color: kPrimaryColor,
              height: 500,
            ),
          ),
          Center(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(

                    padding: const EdgeInsets.all(8.0),
                    child: Material(elevation: 20,shadowColor: kPrimaryColor,child: Padding(
                      padding: const EdgeInsets.only(top:25.0,left: 25.0,bottom: 25),
                      child: Container(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order Food now',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: kPrimaryColor)),
                          Text('order delicious food to satisfy your craving now!',style:TextStyle(fontSize: 15,color:kPrimaryColor)),
                        ],
                      ),),
                    ),color: kBackground,borderRadius: BorderRadius.circular(15),),
                  ),
                  RestaurantStream()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        List<RestaurantWidget> restaurantWidgets = [];
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final restaurantData = snapshot.data?.docs;
        for (var restaurant in restaurantData!) {
          String resName = restaurant.get("restaurantName");
          final resWidget = RestaurantWidget(name: resName, id: restaurant.id);
          restaurantWidgets.add(resWidget);
        }
        return Expanded(
          // child: ListView(
          //   children: restaurantWidgets,
          // ),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: (1 / 1.2),
            children: restaurantWidgets,
            crossAxisSpacing: 2,
            mainAxisSpacing: 10,
          ),
        );
      },
      stream: firestore.collection('Restaurant').orderBy("restaurantName").snapshots(),
    );
  }
}

class RestaurantWidget extends StatefulWidget {
  RestaurantWidget({required this.name, required this.id});
  String name;
  String id;
  @override
  State<RestaurantWidget> createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends State<RestaurantWidget> {
  String imageRes = "assets/logo.png";
  String tagLine = "Fresh food at your doorstep..";
  Future getImage() async {
    var tagLineData =
        await firestore.collection('Restaurant').doc(widget.id).get();
    var data = await firestore.collection('Images').doc(widget.id).get();
    var image = data.get('image');
    setState(() {
      imageRes = image;
      tagLine = tagLineData.get('TagLine');
    });
  }

  @override
  Widget build(BuildContext context) {
    getImage();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ItemSelect(
              restaurantId: widget.id,
            );
          }),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 5),
        child: Material(
          elevation: 20,

          borderRadius: BorderRadius.circular(15),
          shadowColor: kPrimaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  flex: 3,
                  child: (
                      CachedNetworkImage(
                        imageUrl: imageRes,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                      )

                  ),),
              Flexible(

                  flex: 1,
                  child: (Container(

                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 8.0, right: 8.0),
                          child: Text(
                            widget.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                                fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ))),
              Flexible(
                  flex: 1,
                  child: (Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            tagLine,
                            style: TextStyle(fontSize: 13),
                          ),
                        )
                      ],
                    ),
                  )))
            ],
          ),
        ),
      ),
    );
  }
}
