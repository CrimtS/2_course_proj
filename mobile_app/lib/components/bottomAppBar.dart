import 'package:flutter/material.dart';
import 'package:mw_inside/config.dart';
import 'package:mw_inside/pages/homeSearchPage.dart';
import 'package:mw_inside/pages/profilePage.dart';
import 'package:mw_inside/pages/strollObjectPage.dart';


class CustomBottomAppBar extends StatefulWidget {
  final VoidCallback updateFunction;

  CustomBottomAppBar({@required this.updateFunction});

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  int _currIndex = 0;
  List<Widget> _children;

  void onTappedBar(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _children = [
      HomeSearchSubmitPage(),
      StrollObjectPage(),
      ProfilePage(onLogOutPressed: () {widget.updateFunction();}),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: _children[_currIndex]),
        backgroundColor: themeColor,
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.blueGrey[500],
            selectedItemColor: themeColor,
            onTap: onTappedBar,
            iconSize: 27.0,
            currentIndex: _currIndex,
            backgroundColor: Colors.white,
            items:
            [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Главная'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.directions_walk),
                  label: 'Прогулка'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Профиль'
              ),
            ]
        ),
      ),
    );
  }
}