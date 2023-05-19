import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_inside/components/NearbyMap.dart';
import 'package:mw_inside/components/loadingCircle.dart';
import 'package:mw_inside/config.dart';
import 'package:mw_inside/services/locationService.dart';
import 'package:mw_inside/components/nearbyObjectsList.dart';
import 'package:mw_inside/services/permissionService.dart';
import 'package:provider/provider.dart';


class StrollPage extends StatefulWidget {
  final void Function(int) onGoToObject;

  StrollPage({Key key, @required this.onGoToObject}) : super(key: key);

  @override
  _StrollPageState createState() => _StrollPageState();
}

class _StrollPageState extends State<StrollPage> {
  bool updateTrigger = false;
  dynamic locationData;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    locationData = Provider.of<UserLocation>(context);

    return FutureBuilder<bool>(
      future: checkLocationPermission(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data){
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: NearbyMap(height: screenHeight / 3),
                ),
                SizedBox(
                  height: 3.0,
                  child: Container(color: themeColorShade)),
                Flexible(
                    child: Container(
                        color: Colors.grey[300],
                        child: NearbyObjectsList(onGoToObject: widget.onGoToObject)
                    )
                ),
              ],
            ),
          );
        }
        else{
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingCircle(),
                    SizedBox(height: 20.0),
                    Text("Loading", style: TextStyle(fontSize: 20.0)),
                  ]
              )
          );
        }
      },
    );
  }
}
