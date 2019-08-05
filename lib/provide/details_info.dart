import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier{
  Map goodsInfo;
  bool isLeft = true;
  bool isRight = false;
  //从后台获取商品数据
  getGoodsInfo(String id) async{
    var formData = {'goodId':id};
    await request("getGoodDetailById",formData: formData).then((val){
      var responseData = json.decode(val.toString());
      this.goodsInfo = responseData['data']['goodInfo'];
      // print(goodsInfo['goodsDetail']);
      notifyListeners();
    });
  }

  //改变tabbar的状态
  changeTabBar(String changeState){
    if(changeState == 'left'){
      this.isLeft = true;
      this.isRight = false;
    }else{
      this.isLeft = false;
      this.isRight = true;
    }
    notifyListeners();
  }
}