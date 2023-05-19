import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_inside/config.dart';
import 'package:mw_inside/services/permissionService.dart';

class LocationPermissionErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Управление доступом к геолокации",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
                SizedBox(height: 30.0),
                Center(
                  child: Container(
                    width: screenWidth - 60.0,
                    child: Text(
                      "Пожалуйста удостоверьтесь, что приложение ВСЕГДА имеет доступ к вашей геолокации.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  child: TextButton(
                    onPressed: () {
                      getAlwaysPermission();
                    },
                    child: Text(
                      "Разрешить",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: themeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
