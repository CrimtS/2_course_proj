import 'package:url_launcher/url_launcher.dart';

void tryLaunch(String url) async{
  try{
    await launch(url);
  }
  catch(e){
    print("ERROR: $e");
  }
}
