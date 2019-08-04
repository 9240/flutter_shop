import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/conuter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
void main(){
  var counter = Counter();
  var childCategory = ChildCategoty();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var providers = Providers();
  providers
  ..provide(Provider<Counter>.value(counter))
  ..provide(Provider<ChildCategoty>.value(childCategory))
  ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide));
  runApp(
    ProviderNode(
      providers: providers,
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: "百姓生活+",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
      ),
    );
  }
}