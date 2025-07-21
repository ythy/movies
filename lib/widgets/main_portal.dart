import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movies/models/model_theme.dart';
import 'package:movies/widgets/top_bar.dart';
import 'package:movies/widgets/nav_home.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Mainframe extends StatefulWidget {

  /// Initializes [key] for subclasses.
  const Mainframe({super.key});

  @override
  State<Mainframe> createState() => _MainframeState();
}


class _MainframeState extends State<Mainframe> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child:Scaffold(
        appBar: TopBar(),
        body: const TabBarView(
          children: [
            Home(),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.directions_transit)),
            Tab(icon: Icon(Icons.directions_bike)),
          ],
        ),
      ),
    );
  }
}


// bottom: const TabBar(
// tabs: [
// Tab(icon: Icon(Icons.directions_car)),
// Tab(icon: Icon(Icons.directions_transit)),
// Tab(icon: Icon(Icons.directions_bike)),
// ],
// ),