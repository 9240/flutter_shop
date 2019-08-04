import 'package:flutter/material.dart';


class DeatilsPage extends StatelessWidget {
  final String goodsId;
  const DeatilsPage(this.goodsId,{Key key}) : super(key: key);
  // DeatilsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("商品ID:${goodsId}"),
      ),
    );
  }
}