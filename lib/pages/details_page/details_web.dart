import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';

class DetailWeb extends StatelessWidget {
  const DetailWeb({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var goodsDetail = Provide.value<DetailsInfoProvide>(context).goodsInfo['goodsDetail'];
    return Provide<DetailsInfoProvide>(
      builder: (context,child,data){
        var isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
        if(isLeft){
          return Container(
            margin: EdgeInsets.only(bottom: 80),
            child: Column(
              children: <Widget>[
                Text("商品详情"),
                Text("商品详情"),
                Text("商品详情"),
                Text("商品详情"),
                Text("商品详情"),
                Text("商品详情"),
                Text("商品详情"),
                Text("商品详情"),
              ],
            ),
          );
        }else{
          return Container(
            // padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(bottom: 80),
            width: ScreenUtil().setWidth(750),
            alignment: Alignment.center,
            child: Text("暂无数据"),
          );
        }
      },
    );
  }
}