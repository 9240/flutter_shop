import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import 'dart:convert';
import './cart_page/cart_item.dart';
import './cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("购物车"),
      ),
      body: Stack(
        children: <Widget>[
          Provide<CartProvide>(
            builder: (context,child,childCategory){
              List list = json.decode(Provide.value<CartProvide>(context).cartString);
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context,index){
                  return CartItem(list[index]);
                },
              );
            },
          ),
          Positioned(
            bottom:0,
            left:0,
            child: CartBottom(),
          )
        ],
      ),
    );
  }
}