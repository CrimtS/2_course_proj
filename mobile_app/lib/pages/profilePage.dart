import 'package:flutter/material.dart';
import 'package:mw_inside/services/uiService.dart';
import 'package:mw_inside/components/loadingCircle.dart';
import 'package:mw_inside/components/middleButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:mw_inside/services/authorizationService.dart';
import 'package:mw_inside/services/storageService.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onLogOutPressed;

  ProfilePage({@required this.onLogOutPressed});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  int notificationsRadius;
  String name, email, rank, dateJoined;
  int id, points;
  List<dynamic> tags;
  bool loaded = false, loading = false;
  Map<String, bool> categories = {};

  @override
  void initState() {
    super.initState();
    loadNotificationsRadius();
    loadCategories();
  }

  void loadNotificationsRadius() async {
    int value = await getNotificationsRadius();
    setState(() {
      notificationsRadius = value;
    });
  }

  void loadCategories() async {
    Map<String, bool> loadedCategories = await getCategories();
    setState(() {
      categories = loadedCategories;
    });
  }

  void toggleCategory(String key) async {
    await updateCategory(key, !categories[key]);
    loadCategories();
  }

  ElevatedButton getCategoryButton(String key, bool value, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: value ? color : color.withOpacity(0.3),
      ),
      onPressed: () async {
        await updateCategory(key, !value);
        setState(() {
          categories[key] = !value;
        });
      },
      child: Text(getRussianCategoryPlural(key)),
    );
  }

  void loadData() async {
    String uName = await readUsername();
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    if (mounted) {
      setState(() {
        name = uName;
        loading = false;
        loaded = true;
      });
    }
  }



  Widget getLogOutButton() {
    return Center(
      child: MiddleButton(
        text: "Выйти",
        press: () async {
          logOut();
          widget.onLogOutPressed();
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final List<Color> colors = [
      Colors.deepPurpleAccent,
      Colors.orange,
      Colors.amber,
      Colors.blueAccent,
      Colors.red,
      Colors.green,
      Colors.teal,
      Colors.pinkAccent,
      Colors.tealAccent,
      Colors.grey,
      Colors.indigo,
      Colors.greenAccent,
    ];

    if (loaded) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50.0),
                Text(
                  'Профиль',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Текущий радиус уведомлений: $notificationsRadius',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('20'),
                    Expanded(
                      child: Slider(
                        value: notificationsRadius.toDouble(),
                        min: 20,
                        max: 500,
                        divisions: 96,
                        label: notificationsRadius.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            notificationsRadius = value.round();
                          });
                          saveNotificationsRadius(notificationsRadius);
                        },
                      ),
                    ),
                    Text('500'),
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  "Выбранные категории объектов:",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: categories.entries
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) => getCategoryButton(
                            entry.value.key,
                            entry.value.value,
                            colors[entry.key % colors.length],
                          ))
                      .toList(),
                ),
                SizedBox(height: 30.0),
                getLogOutButton(),
              ],
            ),
          ),
        ),
      );
    } else {
      if (!loading) loadData();
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          LoadingCircle(),
          SizedBox(height: 20.0),
          Text(
            "Loading",
            style: TextStyle(fontSize: 20.0),
          ),
        ])),
      );
    }
  }
}
