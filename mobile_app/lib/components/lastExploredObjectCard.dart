import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_inside/components/loadingCircle.dart';
import 'package:mw_inside/components/objectCard.dart';
import 'package:mw_inside/config.dart';
import 'package:mw_inside/services/backendCommunicationService.dart';
import 'package:mw_inside/services/geoService.dart';
import 'package:mw_inside/services/locationService.dart';
import 'package:provider/provider.dart';


class LastExploredObjectCard extends StatefulWidget {
  const LastExploredObjectCard({Key key}) : super(key: key);

  @override
  _LastExploredObjectCardState createState() => _LastExploredObjectCardState();
}

class _LastExploredObjectCardState extends State<LastExploredObjectCard> {
  bool isLoaded = false;
  bool exists;
  Map lastObject;

  Widget title = Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            "Последний открытый объект",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 18.0,
            ),
          ),
        ),
        Container(
          child: SizedBox(
            height: 2.0,
            child: Container(color: themeColor),
          ),
        )
      ],
    ),
  );

  void loadData() async {
    exists = false;
    isLoaded = true;
   Map response = await serverRequest('get', '/user_stats/last_exploration', null);
   if (response["latitude"]!=null){
     if (mounted){
       setState(() {
         lastObject = response;
         exists = true;
         isLoaded = true;
       });
     }
   }
   else{
     if (mounted) {
       setState(() {
         exists = false;
         isLoaded = true;
       });
     }
   }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var locationData = Provider.of<UserLocation>(context);

    if (!isLoaded){
      loadData();
      return Container(
        child: Column(
          children: [
            title,
            SizedBox(height: 5.0),
            LoadingCircle(),
          ],
        ),
      );
    }
    else if (exists){
      String imageUrl = lastObject['image_url'] == null ? animeGirlsUrl : lastObject['image_url'];
      int distance = 0;
      if (isUseful(locationData)){
        distance = calculateDistance(
          locationData.latitude,
          locationData.longitude,
          lastObject['latitude'],
          lastObject['longitude'],
        );
      }
      return Container(
        child: Column(
          children: [
            title,
            ObjectCard(
              id: lastObject['id'],
              objectUrl: lastObject['url'],
              distance: distance,
              category: lastObject['category'],
              nameRu: lastObject['name_ru'],
              nameEn: lastObject['name_en'],
              wikiRu: lastObject['wiki_ru'],
              wikiEn: lastObject['wiki_en'],
              imgUrl: imageUrl,
              address: lastObject['address'],
              onGoToObject: (int id) {},
            ),
          ],
        ),
      );
    }
    else{
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              width: screenWidth,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    color: Colors.blueGrey.withOpacity(0.2),
                    child: Center(
                      child: Text(
                        "Вы пока не открыли ни одного объекта",
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
