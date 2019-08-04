import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/details_page.dart';

Handler detailsHander = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    String goodsId = params['id'].first;
    print("商品详情${goodsId}");
    return DeatilsPage(goodsId);
  }
);