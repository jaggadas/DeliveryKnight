import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_knight_restaurant/constants/constants.dart';
import 'package:delivery_knight_restaurant/elements/standardbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddItem extends StatefulWidget {
  static const id = "additem";
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

String url = '';
FirebaseFirestore firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
FirebaseStorage _storage = FirebaseStorage.instance;

class _AddItemState extends State<AddItem> {
  late String enteredName;
  late String enteredPrice;
  late File _imageFile;
  final picker = ImagePicker();
  late String enteredTagLine;
  bool showSpinner=false;

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
      showSpinner=true;
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = _imageFile.path;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((value) async{

        await firestore.collection('Images').doc(_auth.currentUser?.uid).set({'image': value});
        setState(() {
          showSpinner=false;
        });
      });
    });

  }

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 220.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                keyboardType: TextInputType.name,
                style: TextStyle(color: Colors.black),
                decoration: kTextFieldInputDecoration.copyWith(
                    icon: Icon(
                      Icons.restaurant_menu,
                      color: kPrimaryColor,
                    ),
                    hintText: "Enter dish name"),
                onChanged: (value) {
                  enteredName = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                decoration: kTextFieldInputDecoration.copyWith(
                    icon: Icon(
                      Icons.money,
                      color: kPrimaryColor,
                    ),
                    hintText: "Enter price"),
                onChanged: (value) {
                  enteredPrice = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: StandardButton(
                  text: 'Add',
                  onPressed: () async {
                    DocumentSnapshot menu = await firestore
                        .collection('Menu')
                        .doc(_auth.currentUser?.uid)
                        .get();
                    if (menu.exists) {
                      await firestore
                          .collection('Menu')
                          .doc(_auth.currentUser?.uid)
                          .update({
                        'Menu': FieldValue.arrayUnion([
                          {enteredName: enteredPrice}
                        ])
                      });
                    } else {
                      await firestore
                          .collection('Menu')
                          .doc(_auth.currentUser?.uid)
                          .set({
                        'Menu': FieldValue.arrayUnion([
                          {enteredName: enteredPrice}
                        ])
                      });
                    }
                    Navigator.pop(context);
                  }),
            )
          ],
        ),
      ),
    );
    Dialog tagLineDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 140.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                keyboardType: TextInputType.name,
                style: TextStyle(color: Colors.black),
                decoration: kTextFieldInputDecoration.copyWith(
                    icon: Icon(
                      Icons.border_color,
                      color: kPrimaryColor,
                    ),
                    hintText: "Enter tagline"),
                onChanged: (value) {
                  enteredTagLine = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: StandardButton(
                  text: 'Add',
                  onPressed: () async {
                      await firestore
                          .collection('Restaurant')
                          .doc(_auth.currentUser?.uid)
                          .update({
                        'TagLine': enteredTagLine
                      });
                    Navigator.pop(context);
                  }),
            )
          ],
        ),
      ),
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          showDialog(
              context: context, builder: (BuildContext context) => errorDialog);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            showDialog(
                context: context, builder: (BuildContext context) => tagLineDialog);
          },icon: Icon(Icons.create),),
          IconButton(
              onPressed: () async {
                await pickImage();
                await uploadImageToFirebase(context);


              },
              icon: Icon(Icons.photo_camera))
        ],
        backgroundColor: kPrimaryColor,
        title: Text("Edit Info"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Dish name',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text('Dish price',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(
                      width: 50,
                    )
                  ],
                ),
              ),
              DishesStream(),
            ],
          ),
        ),
      ),
    );
  }
}

class DishesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        List<DishItem> dishes = [];
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final dishesData = snapshot.data?.docs;

        for (var dish in dishesData!) {
          if (dish.id == auth.currentUser?.uid) {
            print("Data matched");
            if (dish.exists) {
              List menu = dish.get("Menu");
              if (menu.isNotEmpty) {
                for (var menuItem in menu) {
                  final dishName = menuItem.keys.elementAt(0);
                  final dishPrice = menuItem[dishName];
                  final dishWidget =
                      DishItem(dishName: dishName, dishPrice: dishPrice);
                  dishes.add(dishWidget);
                }
              }
              return Expanded(
                  child: ListView(
                children: dishes,
              ));
            }
          }
        }
        return Expanded(child: Center(child: Text("No Dishes")));
      },
      stream: firestore.collection('Menu').snapshots(),
    );
  }
}

class DishItem extends StatelessWidget {
  DishItem({required this.dishName, required this.dishPrice});
  String dishName;
  String dishPrice;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Material(
            elevation: 10,
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kTransparentColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(dishName),
                    Text(dishPrice),
                    IconButton(
                        onPressed: () async {
                          await firestore
                              .collection('Menu')
                              .doc(auth.currentUser?.uid)
                              .update({
                            'Menu': FieldValue.arrayRemove([
                              {dishName: dishPrice}
                            ])
                          });
                        },
                        icon: Icon(Icons.delete))
                  ],
                ))),
      ),
    );
  }
}
