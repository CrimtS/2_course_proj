import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_inside/components/loadingCircle.dart';
import 'package:mw_inside/components/objectCard.dart';
import 'package:mw_inside/config.dart';
import 'package:mw_inside/services/backendCommunicationService.dart';
import 'package:mw_inside/services/locationService.dart';
import 'dart:math';
import 'package:provider/provider.dart';

import '../services/geoService.dart';
import '../services/storageService.dart';

class NearbyObjectsList extends StatefulWidget {
  final void Function(int) onGoToObject;

  NearbyObjectsList({Key key, @required this.onGoToObject}) : super(key: key);

  @override
  _NearbyObjectsListState createState() => _NearbyObjectsListState();
}

class _NearbyObjectsListState extends State<NearbyObjectsList> {
  List<dynamic> nearbyObjects = [];
  var locationData;

  Future<void> loadData() async {
    if (!mounted || !isUseful(locationData)) {
      return; // Just do nothing if the widget is disposed.
    }
    List filter = await buildFilterArray();
    Map requestData = {
      "latitude": locationData.latitude,
      "longitude": locationData.longitude,
      "filter": filter,
    };
    List<dynamic> res=await getNearbyObjects(requestData);
    if (mounted) {
      setState(() {
        print(res);
        nearbyObjects = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    locationData = Provider.of<UserLocation>(context);

    if (nearbyObjects == null) nearbyObjects = [];

    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: themeColor,
        child: ListView.separated(
          padding: EdgeInsets.all(0.0),
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: max(nearbyObjects.length, 1),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 8.0);
          },
          itemBuilder: (context, index) {
            if (nearbyObjects.length > 0) {
              Map currentObject = nearbyObjects[index];
              String imageUrl = currentObject['image_url'] == null
                  ? animeGirlsUrl
                  : currentObject['image_url'];
              return ObjectCard(
                id: currentObject['id'],
                objectUrl: currentObject['url'],
                distance: calculateDistance(locationData.latitude,locationData.longitude,currentObject['latitude'],currentObject['longitude']),
                category: currentObject['category'],
                nameRu: currentObject['name_ru'],
                nameEn: currentObject['name_en'],
                wikiRu: currentObject['wiki_ru'],
                wikiEn: currentObject['wiki_en'],
                imgUrl: imageUrl,
                address: currentObject['address'],
                onGoToObject: widget.onGoToObject,
              );
            } else {
              loadData();
              return Container(
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Text("Нет объектов по вашим фильтрам"),
                    SizedBox(height: 15.0),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
