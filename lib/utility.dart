import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Utility{

/*
  static void launchUrl() async {
    const url = 'http://verts.co.in';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
*/


  static void CallNavigator(BuildContext buildContext,Widget widget,Object object){
    Navigator.push(
      buildContext,
      MaterialPageRoute(
        builder: (context) => widget,
        settings: RouteSettings(
          arguments:object,
        ),

      ),
    );


  }

  static void CallNavigatorRemoveStackUntil(BuildContext buildContext,Widget widget,Object object){
    Navigator.of(buildContext).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        widget, settings: RouteSettings(
      arguments:object,
    )), (Route<dynamic> route) => false);

  }

  static removePrefStr(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }


  static saveList(List<String> list) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setStringList("Barcodelist", list);
  }

  static Future<List<String>?> getList() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList("Barcodelist");
  }

  static void showSnackBar(BuildContext buildContext,String message){
    ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
      content: Container(
        //color: Colors.white,
        width: 100,
        decoration: BoxDecoration(color: Colors.black, border: Border.all(width: 1.0, color: Colors.black), borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 100),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(message,style: TextStyle(color: Colors.white),),
        ),
      ),   behavior: SnackBarBehavior.floating,backgroundColor:Colors.transparent.withOpacity(0),elevation: 0,
    ));


  }

  static void showSimpleSnackbar(BuildContext buildContext,String message){
    ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
      content: Text(message),
    ));

  }





}