import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier{
  Map goodsInfo;
  //从后台获取商品数据
  getGoodsInfo(String id){
    var formData = {'goodId':id};
    request("getGoodDetailById",formData: formData).then((val){
      var responseData = json.decode(val.toString());
      this.goodsInfo = responseData['data']['goodInfo'];
      notifyListeners();
    });
  }
}