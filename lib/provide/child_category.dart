import 'package:flutter/material.dart';


class ChildCategoty with ChangeNotifier{
  List childCategoryList =[];
  int childIndex = 0;//子类高亮索引
  String categoryId;//大类ID
  String subId = '';
  int page = 1;//列表页数
  getChildCategoty(List list,String categoryId){
    this.childIndex = 0;//获取子类，并重置子类索引
    this.categoryId = categoryId;
    this.page = 1;
    Map all = {
      "mallSubId":"",
      "mallCategoryId":"0",
      "comments":"null",
      "mallSubName":"全部",
    };
    childCategoryList=[all];
    childCategoryList.addAll(list);
    notifyListeners();
  }
  //改变子类索引
  changeChildIndex(index,subId){
    this.childIndex = index;
    this.subId = subId;
    this.page = 1;
    notifyListeners();
  }

  //增加page
  addpage(){
    this.page++;
  }
}