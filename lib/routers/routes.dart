import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_hander.dart';


class Routes{
  static String root = '/';
  static String detailsPage = '/detail';
  static void configRoutes(Router router){
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context,Map<String,List<String>> parame){
        print("找不到页面");
        return ;
      }
    );

    router.define(detailsPage,handler:detailsHander);
  }
}
