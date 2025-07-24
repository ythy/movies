import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cards/form_card.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(child: Text("I am home page "));
  }

}