import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import 'dart:convert';

class CartPage extends StatelessWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List list = json.decode(Provide.value<CartProvide>(context).cartString);
    print("购物车页面${list.length}");
    return Scaffold(
      appBar: AppBar(
        title: Text("购物车"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context,index){
            return ListTile(
              title: Text("${list[index]['goodsName']}-----${list[index]['count']}"),
            );
          },
        ),
      ),
    );
  }
}