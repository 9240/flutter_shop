import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int page = 1;
  List<Map> hotGoodsList = [];

  String homePageContent = "正在获取数据";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("百姓生活+"),),
      body: FutureBuilder(
        builder: (context,snapshot){
          if(snapshot.hasData){
            //数据处理
            var data = json.decode(snapshot.data.toString());
            // print(data['data']['integralMallPic']);
            List<Map> swiper = (data['data']['slides'] as List).cast();
            List<Map> navigatorList = (data['data']['category'] as List).cast();
            String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];
            List<Map> recommendList = (data['data']['recommend'] as List).cast();
            String floor1Title =data['data']['floor1Pic']['PICTURE_ADDRESS'];
            String floor2Title =data['data']['floor2Pic']['PICTURE_ADDRESS'];
            String floor3Title =data['data']['floor3Pic']['PICTURE_ADDRESS'];
            List<Map> floor1 = (data['data']['floor1'] as List).cast(); 
            List<Map> floor2 = (data['data']['floor2'] as List).cast();
            List<Map> floor3 = (data['data']['floor3'] as List).cast();
            return EasyRefresh(
              child: ListView(
                children: <Widget>[
                  SwiperDiy(swiperDateList:swiper),
                  TopNavigator(navigatorList:navigatorList),
                  AdBanner(adPicture:adPicture),
                  LeaderPhone(leaderImage: leaderImage,leaderPhone: leaderPhone),
                  Recommend(recommendList: recommendList),
                  FloorTitle(pictureAddress:floor1Title),
                  FloorContent(floorGoodsList:floor1),
                  FloorTitle(pictureAddress:floor2Title),
                  FloorContent(floorGoodsList:floor2),
                  FloorTitle(pictureAddress:floor3Title),
                  FloorContent(floorGoodsList:floor3),
                  _hotGoods(),
                ],
              ),
              onLoad: () async{
                print("加载更多");
                var formPage = {'page':page};
                await request("homePageBelowConten",formData:formPage).then((val){
                  var data = json.decode(val.toString());
                  List<Map> newGoodsList = (data['data'] as List).cast();
                  setState(() {
                    hotGoodsList.addAll(newGoodsList);
                  page++; 
                  });
                });
              },
            );
          }else{
            return Center(
              child: Text("加载中"),
            );
          }
        },
        future: getHomePageContent(),
      ),
    );
  }
  //火爆专区主体内容
  Widget _wrapList(){
    if(hotGoodsList.length != 0){
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){},
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'],width: ScreenUtil().setWidth(375),),
                Text(
                  val['name'],
                  maxLines:1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(color: Colors.black12,decoration: TextDecoration.lineThrough),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    }else{
      return Text("");
    }
  }
  
  Widget _hotGoods(){
    return Container(
      child: Column(
        children: <Widget>[
          _wrapList()
        ],
      ),
    );
  }
}


//首页轮播组件
class SwiperDiy extends StatelessWidget {
  const SwiperDiy({Key key,this.swiperDateList}) : super(key: key);
  final List swiperDateList;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(314),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemCount: swiperDateList.length,
        pagination: SwiperPagination(),
        autoplay: true,
        itemBuilder: (BuildContext ctx,int index){
          return Image.network("${swiperDateList[index]['image']}",fit: BoxFit.cover,);
        },
      ),
    );
  }
}

//首页顶部导航
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  const TopNavigator({Key key,this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context,item){
    return InkWell(
      onTap: (){
        print("点击导航");
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if(this.navigatorList.length>10){
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(350),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item){
          return _gridViewItemUI(context,item);
        }).toList(),
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}

//广告
class AdBanner extends StatelessWidget {
  final String adPicture;
  const AdBanner({Key key,this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

//店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage;//店长图片
  final String leaderPhone;//店长电话
  const LeaderPhone({Key key,this.leaderImage,this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: (){
          _launchURL();
        },
        child: Image.network(leaderImage),
      ),
    );
  }
  void _launchURL() async{
    String url = 'tel:'+leaderPhone;
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'url不能进行访问';
    }
  }
}

//商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key,this.recommendList}) : super(key: key);
  //标题方法
  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1,color: Colors.black12)
        )
      ),
      child: Text(
        "商品推荐",
        style: TextStyle(color: Colors.pink),
      ),
    );
  }
  //商品单独项方法
  Widget _item(index){
    return InkWell(
      onTap: (){},
      child: Container(
        height: ScreenUtil().setHeight(350),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              width: 1,
              color: Colors.black12,
            )
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text("￥${recommendList[index]['mallPrice']}"),
            Text(
              "￥${recommendList[index]['mallPrice']}",
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey
              ),
            )
          ],
        ),
      ),
    );
  }


  //横向列表方法
  Widget _recommendList(){
    return Container(
      height: ScreenUtil().setHeight(350),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (BuildContext context,int index){
          return _item(index);
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(410),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList()
        ],
      ),
    );
  }
}


//楼层标题组件
class FloorTitle extends StatelessWidget {
  final String pictureAddress;
  const FloorTitle({Key key,this.pictureAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(this.pictureAddress),
    );
  }
}


//楼层商品组件
class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  const FloorContent({Key key,this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods()
        ],
      ),
    );
  }

  Widget _firstRow(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[1]),
        _goodsItem(floorGoodsList[2])
      ],
    );
  }

  Widget _otherGoods(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4])
      ],
    );
  }

  Widget _goodsItem(Map goods){
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: (){
          print("屏幕的宽度${ScreenUtil.screenHeight}");
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}


//获取火爆专区的数据
class HotGoods extends StatefulWidget {
  HotGoods({Key key}) : super(key: key);

  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  int page = 1;
  List<Map> hotGoodsList = [];
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
         children: <Widget>[
           hotTitle
         ],
       ),
    );
  }
  //火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(color: Colors.black12,width: 0.5)
      )
    ),
    child: Text("火爆专区"),
  );
}