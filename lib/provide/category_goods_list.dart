import 'package:flutter/material.dart';


class CategoryGoodsListProvide with ChangeNotifier{
  List goodsList =[];

  //点击大类时更换商品列表
  getGoodsList(List list){
    this.goodsList = list;
    notifyListeners();
  }

  getMoreList(List list){
    this.goodsList.addAll(list);
    notifyListeners();
  }
}