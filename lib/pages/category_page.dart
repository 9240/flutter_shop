import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';
import 'dart:convert';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../routers/application.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text("商品分类"),),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodsList(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//左侧大类菜单
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list=[];
  var listIndex = 0;
  @override
  void initState() {
    _getCategory();
    _getGoodsList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1,color: Colors.black12)
        )
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context,int index){
          return _leftInkWell(index);
        },
      ),
    );
  }

  Widget _leftInkWell(int index){
    bool isClick = false;
    isClick = (index==listIndex)?true:false;
    return InkWell(
      onTap: (){
        var childList = list[index]['bxMallSubDto'];
        setState(() {
          listIndex = index;
        });
        var categoryId = list[index]['mallCategoryId'];
        Provide.value<ChildCategoty>(context).getChildCategoty(childList,categoryId);
        _getGoodsList(categoryId:categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10,top: 20),
        decoration: BoxDecoration(
          color: isClick?Color.fromRGBO(240, 240, 240, 1):Colors.white,
          border: Border(
            bottom: BorderSide(width: 1,color: Colors.black12)
          )
        ),
        child: Text(list[index]["mallCategoryName"],style: TextStyle(fontSize: ScreenUtil().setSp(28))),
      ),
    );
  }
  void _getCategory()async{
    await request('getCategory').then((val){
      var data = json.decode(val.toString());
      
      setState(() {
        this.list.addAll(data['data']);
      });
      Provide.value<ChildCategoty>(context).getChildCategoty(list[0]['bxMallSubDto'],list[0]['mallCategoryId']);
    });
  }

  //获取商品
  void _getGoodsList({String categoryId,String categorySubId}) async{
    var data = {
      "categoryId":categoryId==null?"4":categoryId,
      "categorySubId":"",
      "page":1
    };
    request("getMallGoods",formData: data).then((val){
      var data = json.decode(val.toString());
      // setState(() {
      //  this.list = data['data'];
      // });
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(data['data']);
    });
  }
}

//右侧分类导航
class RightCategoryNav extends StatefulWidget {
  RightCategoryNav({Key key}) : super(key: key);

  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  // List list = ['名酒','宝丰','北京二锅头','名酒','宝丰','北京二锅头'];
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategoty>(
      builder: (context,child,childCategoty){
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.black12,width: 1)
            )
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategoty.childCategoryList.length,
            itemBuilder: (context,index){
              // return Text("${childCategoty.childCategoryList[index]['mallSubName']}");
              return _rightInkWell(childCategoty.childCategoryList[index],index);
            },
          ),
        );
      },
    );
  }

  Widget _rightInkWell(Map item,index){
    bool isClick = false;
    isClick = (index == Provide.value<ChildCategoty>(context).childIndex)?true:false;
    return InkWell(
      onTap: (){
        Provide.value<ChildCategoty>(context).changeChildIndex(index,item["mallSubId"]);
        _getGoodsList(item['mallSubId']);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(item['mallSubName'],style: TextStyle(fontSize: ScreenUtil().setSp(28),color: isClick?Colors.pink:Colors.black)),
      ),
    );
  }

  //获取商品
  void _getGoodsList(String categorySubId){
    var data = {
      "categoryId":Provide.value<ChildCategoty>(context).categoryId,
      "categorySubId":categorySubId,
      "page":1
    };
    request("getMallGoods",formData: data).then((val){
      var data = json.decode(val.toString());
      // setState(() {
      //  this.list = data['data'];
      // });
      if(data['data']==null){
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      }else{
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList(data['data']);
      }
    });
  }
}

//商品列表，上拉加载
class CategoryGoodsList extends StatefulWidget {
  CategoryGoodsList({Key key}) : super(key: key);

  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  var scorllController = new ScrollController();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context,child,data){
        try{
          if(Provide.value<ChildCategoty>(context).page == 1){
            scorllController.jumpTo(0.0);
          }
        }catch(e){
          print("进入页面第一次初始化");
        }
        if(data.goodsList.length > 0){
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570),
              child: EasyRefresh(
                child: ListView.builder(
                  controller: scorllController,
                  itemCount: data.goodsList.length,
                  itemBuilder: (context,index){
                    return _listWidget(data.goodsList,index);
                  },
                ),
                onLoad: ()async{
                  print("上拉加载更多");
                  _getMoreList();
                },
              ),
            ),
          );
        }else{
          return Text("暂时没有数据");
        }
      },
    );
  }


  Widget _goodsImage(List list,index){
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(list[index]['image']),
    );
  }

  Widget _goodsName(List list,index){
    return Container(
      width: ScreenUtil().setWidth(370),
      padding: EdgeInsets.all(5.0),
      child: Text(
        list[index]['goodsName'],
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(List list,index){
    return Container(
      width: ScreenUtil().setWidth(370),
      margin: EdgeInsets.only(top: 30),
      child: Row(
        children: <Widget>[
          Text(
            '价格：￥${list[index]["presentPrice"]}',
            style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(18)),
          ),
          Text(
            '价格：￥${list[index]["oriPrice"]}',
            style: TextStyle(color: Colors.black12,decoration: TextDecoration.lineThrough,fontSize: ScreenUtil().setSp(18))
          )
        ]
      ),
    );
  }

  Widget _listWidget(List list,index){
    return InkWell(
      onTap: (){
        // print(list[index]);
        Application.router.navigateTo(context, "/detail?id=${list[index]['goodsId']}");
      },
      child: Container(
        padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1,color: Colors.black12)
          )
        ),
        child: Row(
          children: <Widget>[
             _goodsImage(list,index),
             Column(
               children: <Widget>[
                 _goodsName(list,index),
                 _goodsPrice(list,index)
               ],
             )
          ],
        ),
      ),
    );
  }
  //获取商品
  void _getMoreList(){
    Provide.value<ChildCategoty>(context).addpage();
    var data = {
      "categoryId":Provide.value<ChildCategoty>(context).categoryId,
      "categorySubId":Provide.value<ChildCategoty>(context).subId,
      "page":Provide.value<ChildCategoty>(context).page
    };
    request("getMallGoods",formData: data).then((val){
      var data = json.decode(val.toString());
      // setState(() {
      //  this.list = data['data'];
      // });
      if(data['data']==null){
        Fluttertoast.showToast(
          msg: "没有更多了",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 16.0
        );
        Provide.value<CategoryGoodsListProvide>(context).getMoreList([]);
      }else{
        Provide.value<CategoryGoodsListProvide>(context).getMoreList(data['data']);
      }
    });
  }
}