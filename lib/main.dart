import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/conuter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
import 'package:fluro/fluro.dart';
import './routers/application.dart';
import './routers/routes.dart';
import './provide/details_info.dart';
void main(){
  var counter = Counter();
  var childCategory = ChildCategoty();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  var providers = Providers();


  

  providers
  ..provide(Provider<Counter>.value(counter))
  ..provide(Provider<ChildCategoty>.value(childCategory))
  ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
  ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide));
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
    final router = Router();
    Routes.configRoutes(router);
    Application.router = router;
    return Container(
      child: MaterialApp(
        title: "百姓生活+",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
        onGenerateRoute: Application.router.generator,
      ),
    );
  }
}