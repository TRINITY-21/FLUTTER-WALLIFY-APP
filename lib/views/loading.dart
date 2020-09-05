import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      color:Color(0xFA424242),
      child:Center(
        child:SpinKitChasingDots(
          color:Colors.blue[100],
          size:50,
        ),
      ),
    );
  }
}