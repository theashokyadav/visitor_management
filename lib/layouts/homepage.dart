
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class NewHomePage extends StatefulWidget{

  NewHomePageWidget createState()=> NewHomePageWidget();

}


class NewHomePageWidget extends State<NewHomePage>{
  String dbname="";
  String url="";
  String username="";

  Map<String, double> dataMap = {
    "Delhi": 40,
    "Mumbai": 30,
    "Kolkata": 20,
    "Chennai": 10,
  };

  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];


  Future<void> _getPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dbname = prefs.getString('DbName')!;
    url = prefs.getString('Url')!;
    username = prefs.getString('Username')!;

    print(dbname+ " "+url);
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
        theme: ThemeData(

          primarySwatch: colorCustom,

        ),

        home: new FutureBuilder(
            future: _getPrefs(),
            builder: (context, snapshot) {

              return new Scaffold(

                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(70.0),
                    child: SafeArea(
                      child: new AppBar(
                          title: new Text("Today in Snapshot"),
                          centerTitle: true,
                          flexibleSpace: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(

                                colors: [
                                  gradientColor1,
                                  gradientColor2,
                                ],
                              ),
                            ),
                          ),
                          actions: [

                            /*   IconButton(icon:
                      Icon(FontAwesomeIcons.signOutAlt),
                          onPressed: () {
                            Utility.CallNavigator(context, MyApp(), "");
                            Utility.removePrefStr('UserId');
                          }

                      ),*/

                          ]
                      ),
                    ),
                  ),

                body:SingleChildScrollView(child: Column(children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: PieChart(
                      dataMap: dataMap,
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width/1.5,
                      colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.disc,
                      ringStrokeWidth: 32,
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: false,
                        decimalPlaces: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: SizedBox(width: double.infinity,
                        height: 120,
                        child: Card(child: FlatButton(
                          padding: EdgeInsets.all(12.0),
                          onPressed: () {
                          /*  Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeliveryList(),
                              ),
                            );*/
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              // Icon(FontAwesomeIcons.busAlt, color: Colors.orange[800],
                              //   size: 40,),
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                              //   child: Divider(
                              //       height: 1, color: colorCustom),
                              // ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text("Visits: 2",
                                  style: TextStyle(fontSize: 20,color: Colors.white),),
                              ),
                            ],
                          ),
                          color: Colors.teal,
                          textColor: colorCustom,
                        ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: SizedBox(width: double.infinity,
                        height: 120,
                        child: Card(child: FlatButton(
                          padding: EdgeInsets.all(12.0),
                          onPressed: () {
                           /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PickupLists(),
                                // Pass the arguments as part of the RouteSettings. The
                                // DetailScreen reads the arguments from these settings.
                              ),
                            );*/
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              // Icon(FontAwesomeIcons.bus, color: Colors.orange[800],
                              //   size: 40,),
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                              //   child: Divider(
                              //       height: 1, color: colorCustom),
                              // ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text(
                                  "Birthdays: 1", style: TextStyle(fontSize: 20,color: Colors.white),),
                              )
                            ],
                          ),
                          color: Colors.amber,
                          textColor: colorCustom,
                        ))),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: SizedBox(width: double.infinity,
                        height: 120,
                        child: Card(

                            child: FlatButton(
                          padding: EdgeInsets.all(12.0),
                          onPressed: () {
                            /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PickupLists(),
                                // Pass the arguments as part of the RouteSettings. The
                                // DetailScreen reads the arguments from these settings.
                              ),
                            );*/
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              // Icon(FontAwesomeIcons.bus, color: Colors.orange[800],
                              //   size: 40,),
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                              //   child: Divider(
                              //       height: 1, color: colorCustom),
                              // ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text(
                                  "Anniversaries: 1", style: TextStyle(fontSize: 20,color: Colors.white),),
                              )
                            ],
                          ),
                          color: Colors.deepOrangeAccent,
                          textColor: colorCustom,
                        ))),
                  ),


                ],
                ))



/*        body:SingleChildScrollView(child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: double.infinity,
                height: 125,
                child:Card(child:FlatButton(

                  padding: EdgeInsets.all(12.0),
                  onPressed: () {
                 //   Utility.CallNavigator(context, VehicleList(), "");
                    *//*  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiasionList(),
                        // Pass the arguments as part of the RouteSettings. The
                        // DetailScreen reads the arguments from these settings.
                      ),
                    );*//*
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,// Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(FontAwesomeIcons.car,color: Colors.orange[300],size: 30,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Divider(height: 1,color: colorCustom),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Text("Vehicle"),
                      )
                    ],
                  ),color: Colors.white,textColor: colorCustom,


                ))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: double.infinity,
                height: 125,
                child:Card(child:FlatButton(

                  padding: EdgeInsets.all(12.0),
                  onPressed: () {
               //     Utility.CallNavigator(context, GateIncomingList(), "");
                    *//*  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiasionList(),
                        // Pass the arguments as part of the RouteSettings. The
                        // DetailScreen reads the arguments from these settings.
                      ),
                    );*//*
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,// Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(FontAwesomeIcons.shoppingCart,color: Colors.orange[300],size: 30,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Divider(height: 1,color: colorCustom),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Text("Incoming"),
                      )
                    ],
                  ),color: Colors.white,textColor: colorCustom,


                ))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: double.infinity,
                height: 125,
                child:Card(child:FlatButton(

                  padding: EdgeInsets.all(12.0),
                  onPressed: () {
               //     Utility.CallNavigator(context, OutGoingList(), "");
                    *//*  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiasionList(),
                        // Pass the arguments as part of the RouteSettings. The
                        // DetailScreen reads the arguments from these settings.
                      ),
                    );*//*
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,// Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(FontAwesomeIcons.shoppingCart,color: Colors.orange[300],size: 30,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Divider(height: 1,color: colorCustom),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Text("Outgoing"),
                      )
                    ],
                  ),color: Colors.white,textColor: colorCustom,


                ))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: double.infinity,
                height: 125,
                child:Card(child:FlatButton(

                  padding: EdgeInsets.all(12.0),
                  onPressed: () {
                  //  Utility.CallNavigator(context, InternalTransferList(), "");
                    *//*  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiasionList(),
                        // Pass the arguments as part of the RouteSettings. The
                        // DetailScreen reads the arguments from these settings.
                      ),
                    );*//*
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,// Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(FontAwesomeIcons.shoppingCart,color: Colors.orange[300],size: 30,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Divider(height: 1,color: colorCustom),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Text("Internal Transfer"),
                      )
                    ],
                  ),color: Colors.white,textColor: colorCustom,


                ))),
          ),
       *//*   Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: double.infinity,
                height: 125,
                child:Card(child:FlatButton(

                  padding: EdgeInsets.all(12.0),
                  onPressed: () {
                    Utility.CallNavigator(context,  Deliveries(), "Deliveries");
                    *//**//*  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiasionList(),
                        // Pass the arguments as part of the RouteSettings. The
                        // DetailScreen reads the arguments from these settings.
                      ),
                    );*//**//*
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,// Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(FontAwesomeIcons.shoppingCart,color: Colors.orange[300],size: 30,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Divider(height: 1,color: Constants.colorCustom),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Text("Deliveries"),
                      )
                    ],
                  ),color: Colors.white,textColor: Constants.colorCustom,


                ))),
          ),*//*
      *//*    Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: double.infinity,
                height: 125,
                child:Card(child:FlatButton(

                  padding: EdgeInsets.all(12.0),
                  onPressed: () {
                    Utility.CallNavigator(context,  StockAudit(), "false");
                    *//**//*  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiasionList(),
                        // Pass the arguments as part of the RouteSettings. The
                        // DetailScreen reads the arguments from these settings.
                      ),
                    );*//**//*
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,// Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(FontAwesomeIcons.shoppingCart,color: Colors.green[300],size: 30,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Divider(height: 1,color: Constants.colorCustom),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Text("Stock Audit"),
                      )
                    ],
                  ),color: Colors.white,textColor: Constants.colorCustom,


                ))),
          ),*//*




       *//*   Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: double.infinity,
                height: 125,
                child:Card(child:FlatButton(

                  padding: EdgeInsets.all(12.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskList(),
                        // Pass the arguments as part of the RouteSettings. The
                        // DetailScreen reads the arguments from these settings.
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,// Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(FontAwesomeIcons.tasks,size: 30,color: Colors.yellow[600],),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Divider(height: 1,color: Constants.colorCustom),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Text("Tasks"),
                      )
                    ],
                  ),color: Colors.white,textColor: Constants.colorCustom,


                ))),
          ),*//*



       *//*   Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: double.infinity,
                height: 125,
                child:Card(child:FlatButton(

                  padding: EdgeInsets.all(12.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MeasurementList(),
                        // Pass the arguments as part of the RouteSettings. The
                        // DetailScreen reads the arguments from these settings.
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,// Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(FontAwesomeIcons.fileSignature,color: Colors.orange[800],size: 30,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Divider(height: 1,color: Constants.colorCustom),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Text("Submit Measurement Sheet"),
                      )
                    ],
                  ),color: Colors.white,textColor: Constants.colorCustom,


                ))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: double.infinity,
                height: 125,
                child:Card(child:FlatButton(

                  padding: EdgeInsets.all(12.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailyMeasurementList(),
                        // Pass the arguments as part of the RouteSettings. The
                        // DetailScreen reads the arguments from these settings.
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,// Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(FontAwesomeIcons.arrowsAlt,color: Colors.orange[800],size: 30,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Divider(height: 1,color: Constants.colorCustom),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,16.0,0,0),
                        child: Text("Daily Measurement"),
                      )
                    ],
                  ),color: Colors.white,textColor: Constants.colorCustom,


                ))),
          ),*//*













        ],
      ))*/
              );}));





  }





}