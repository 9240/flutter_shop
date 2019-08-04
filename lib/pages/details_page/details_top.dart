import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailTop extends StatelessWidget {
  const DetailTop({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context,child,data){
        var goodsInfo = Provide.value<DetailsInfoProvide>(context).goodsInfo;
        // print(goodsInfo);
        if(goodsInfo != null){
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _goodsImage(goodsInfo['image1']),
                _goodsName(goodsInfo['goodsName']),
                _goodsNum(goodsInfo['goodsSerialNumber']),
                _goodsPrice(goodsInfo['oriPrice'],goodsInfo['presentPrice'])
              ],
            ),
          );
        }else{
          return Text("加载中");
        }
      },
    );
  }

  //商品图片
  Widget _goodsImage(url){
    return Image.network(url,width: ScreenUtil().setWidth(740));
  }

  //商品名称
  Widget _goodsName(name){
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.only(left: 5.0),
      child: Text(
        name,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30)
        ),
      ),
    );
  }

  //商品编号
  Widget _goodsNum(num){
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(top: 15.0),
      margin: EdgeInsets.only(top: 18.0),
      child: Text(
        '编号：$num',
        style: TextStyle(
          color: Colors.black45
        ),
      ),
    );
  }

  //价格
  Widget _goodsPrice(p1,p2){
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Text(
            "￥$p1    ",
            style: TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.w900),
          ),
          Text.rich(
            TextSpan(
              text: "市场价：",
              children: [
                TextSpan(
                  text: "$p2",
                  style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.black12)
                )
              ]
            )
          )
        ],
      ),
    );
  }
}