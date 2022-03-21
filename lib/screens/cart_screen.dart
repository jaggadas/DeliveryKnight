import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import '../constants.dart';
class CartScreen extends StatefulWidget {
  static const id='cart screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(  appBar: AppBar(
      elevation: 0,
      backgroundColor: kPrimaryColor,
      title: Text("Cart"),

    ),
      body: Stack(
          children: [
          ClipPath(clipper:
          DiagonalPathClipperTwo(),child: Container(color: kPrimaryColor,height: 400,),),
          Column(
            children: [
              Flexible(flex: 1,child: Container(padding: EdgeInsets.all(15),alignment: Alignment.bottomRight,child: Column(mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.end,children: [Text('Total',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 75),),Text('250\$',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30))],),)),
              Flexible(flex: 2,child: Material(elevation: 15,child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Flexible(flex: 3,child: Container(child: Text('Item Name'
                        ,textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),))),
                      Flexible(flex: 1,child: Container(child: Text('Price' ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19)))),
                      Flexible(flex: 1,child: Container(child: Text('Qty' ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19)))),
                      Flexible(flex: 1,child: Container(child: Text('Total' ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19)))),
                    ],),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Flexible(flex: 1,child: Container(child: Text('Dope Margherita Large'
                        ,textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),))),
                      Flexible(flex: 1,child: Container(child: Text('460' ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)))),
                      Flexible(flex: 1,child: Container(child: Text('2' ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)))),
                      Flexible(flex: 1,child: Container(child: Text('920' ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)))),
                    ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(flex: 5,child: Container(child: Text('Hello World'),)),
                        Flexible(flex: 1,child: Container(child:Text('Hello World') ,)),
                        Flexible(flex: 1,child: Container(child: Text('Hello World'),)),
                        Flexible(flex: 1,child: Container(child:Text('Hello World') ,))
                      ],
                    )
                  ],
                ),
              ),))
            ],
          ),

          ]));
  }
}
