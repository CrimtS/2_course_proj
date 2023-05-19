import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_inside/pages/homePage.dart';
import 'package:mw_inside/pages/searchObjectPage.dart';

class HomeSearchSubmitPage extends StatefulWidget {
  const HomeSearchSubmitPage({Key key}) : super(key: key);

  @override
  _HomeSearchSubmitPageState createState() => _HomeSearchSubmitPageState();
}

class _HomeSearchSubmitPageState extends State<HomeSearchSubmitPage> {
  Widget currentPage;

  void goSearchPage(String query) {
    setState(() {
      currentPage = SearchObject(onGoBack: onGoBackCallBack, query: query);
    });
  }

  void onGoBackCallBack() {
    setState(() {
      currentPage = HomePage(onGoToSearch: goSearchPage);
    });
  }

  void initializePage() {
    if (currentPage == null) currentPage = HomePage(onGoToSearch: goSearchPage);
  }

  @override
  Widget build(BuildContext context) {
    initializePage();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: currentPage,
    );
  }
}
