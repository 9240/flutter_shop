import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/pages/cart_page/cart_count.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';
class CartItem extends StatelessWidget {
  final Map item;
  CartItem(this.item);

  @override
  Widget build(BuildContext context) {
    print(item);
    return Container(
      margin: EdgeInsets.fromLTRB(5.0,2.0,5.0,2.0),
      padding: EdgeInsets.fromLTRB(5.0,10.0,5.0,10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width:1,color:Colors.black12)
        )
      ),
      child: Row(
        children: <Widget>[
          _cartCheckBt(item['isCheck']),
          _cartImage(item['image']),
          _cartGoodsName(item['goodsName'],item['count']),
          _cartPrice(context,item['price'],item['goodsId'])
        ],
      ),
    );
  }
  //多选按钮
  Widget _cartCheckBt(item){
    return Container(
      child: Checkbox(
        value: item,
        activeColor:Colors.pink,
        onChanged: (bool val){},
      ),
    );
  }
  //商品图片 
  Widget _cartImage(image){
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1,color:Colors.black12)
      ),
      child: Image.network(image),
    );
  }
  //商品名称
  Widget _cartGoodsName(goodsName,count){
    return Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Text(goodsName),
          CartCount(count)
        ],
      ),
    );
  }

  //商品价格
  Widget _cartPrice(context,price,id){
    return Container(
      width:ScreenUtil().setWidth(150) ,
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Text('￥$price'),
          Container(
            child: InkWell(
              onTap: (){
                Provide.value<CartProvide>(context).deleteOneGoods(id);
              },
              child: Icon(
                Icons.delete_forever,
                color: Colors.black26,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}