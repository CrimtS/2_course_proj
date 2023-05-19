import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_inside/components/lastExploredObjectCard.dart';
import 'package:mw_inside/components/searchBar.dart';
import 'package:mw_inside/components/trackingSwitchButton.dart';
import 'package:mw_inside/components/userExplorationStats.dart';


class HomePage extends StatefulWidget {
  final void Function(String) onGoToSearch;
  final void Function() onGoToSubmit;

  HomePage({Key key, @required this.onGoToSearch, @required this.onGoToSubmit}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void onSearchSubmit(String query){
    if (query != "")
      widget.onGoToSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            Center(child: SearchBar(onSubmit: onSearchSubmit,)),
            SizedBox(height: 10.0),
            LastExploredObjectCard(),
            Expanded(child: UserExplorationStats()),
            Center(child: TrackingSwitchButton()),
            SizedBox(height: 7.0),
          ],
        ),
      ),
    );
  }
}
