import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryknight/constants.dart';
import 'package:deliveryknight/screens/cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class ItemSelect extends StatefulWidget {
  static const id = "item select";
  String restaurantId;
  ItemSelect({required this.restaurantId});

  @override
  _ItemSelectState createState() => _ItemSelectState();
}

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class _ItemSelectState extends State<ItemSelect> {
  String title = "Restaurant";
  String image='assets/kLogoImage';
  bool gotImage=false;

  void setData() async {
    var resTitle =
        await firestore.collection('Restaurant').doc(widget.restaurantId).get();
    var resImage=await firestore.collection('Images').doc(widget.restaurantId).get();


    setState(() {
      title = resTitle.get('restaurantName');
      image=resImage.get("image");
      gotImage=true;

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setData();
    return Scaffold(
      floatingActionButton: FloatingActionButton(backgroundColor: kPrimaryColor,onPressed: (){Navigator.pushNamed(context, CartScreen.id);},child: Icon(Icons.shopping_cart,color: Colors.white,),),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kPrimaryColor,
          title: Text(title),
        ),
        body: Stack(
          children: [
            ClipPath(clipper:
            DiagonalPathClipperTwo(),child: Container(color: kPrimaryColor,height: 400,),),
            Column(
              children: [
                // Hero(tag: 'restaurantImage', child: Container(height: 300,decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover,image: gotImage?NetworkImage(image):kLogoImage as ImageProvider,)),)),
                DishesStream(id: widget.restaurantId)],
            ),
          ],
        ));
  }
}

class DishesStream extends StatelessWidget {
  String id;
  DishesStream({required this.id});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        List<DishWidget> dishes = [];
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final menuData = snapshot.data?.docs;

        for (var menuItem in menuData!) {
          if (menuItem.id == id) {
            if (menuItem.exists) {
              List menu = menuItem.get("Menu");
              if (menu.isNotEmpty) {
                for (var menuItem in menu) {
                  final dishName = menuItem.keys.elementAt(0);
                  final dishPrice = menuItem[dishName];
                  final dishWidget =
                      DishWidget(dishName: dishName, dishPrice: dishPrice);
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

class DishWidget extends StatefulWidget {
  DishWidget({required this.dishName, required this.dishPrice});
  String dishName;
  String dishPrice;

  @override
  State<DishWidget> createState() => _DishWidgetState();
}

class _DishWidgetState extends State<DishWidget> {
  int count=0;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
      child: Material(
        borderRadius: BorderRadius.circular(5 ),
        elevation: 10,
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 25,right: 25,top: 10),
                        child: Text(
                          widget.dishName,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex:2 ,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 25,right: 25,top: 10),
                            child: Text(
                              "${widget.dishPrice} ₹",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Row(mainAxisAlignment: MainAxisAlignment.end,children: [
              IconButton(onPressed: (){
                if(count==0){
                  setState(() {
                    count=0;
                  });
                }
                else{
                  setState(() {
                    count--;
                  });
                }
              }, icon: Icon(Icons.remove,color: kPrimaryColor,)),
              Text(count.toString()),
              IconButton(onPressed: (){
                setState(() {
                  count++;
                });
              }, icon: Icon(Icons.add,color: kPrimaryColor,)),
            ],)
          ],
        ),
      ),
    );
  }
}
