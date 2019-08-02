import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    _getCategory();
    return Container(
       child: Text("分类页面"),
    );
  }
  void _getCategory()async{
    await request('getCategory').then((val){
      var data = json.decode(val.toString());
      print(data);
      // CategoryBigListModel list = CategoryBigListModel.formJson(data['data']);
      // list.data.forEach((item){
      //   print(item.mallCategoryName);
      // });
    });
  }
}