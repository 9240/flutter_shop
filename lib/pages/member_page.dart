import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/conuter.dart';
class MemberPage extends StatelessWidget {
  const MemberPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Provide<Counter>(
          builder: (context,child,counter){
            return Text("${counter.value}");
          },
        ),
      ),
    );
  }
}