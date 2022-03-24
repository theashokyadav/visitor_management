import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor_management/layouts/bottom_bar.dart';
import 'package:visitor_management/utility.dart';
import 'constants.dart';
import 'layouts/homepage.dart';



void main() async{
 // runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('UserId');
  print(email);



  runApp(MaterialApp(home: email == null ? MyApp() : BottomBarScreen(),theme: ThemeData(

    primarySwatch: colorCustom,

    visualDensity: VisualDensity.adaptivePlatformDensity,
  )));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Loginpage(),
    );
  }
}



class Loginpage extends StatefulWidget{
@override
_Loginpagestate createState() => _Loginpagestate();
}

class _Loginpagestate extends State<Loginpage> {
  var textFieldValueHolder = TextEditingController();
  var passwordValueHolder = TextEditingController();
  bool indicatorvisible =false;
  List databases=[];
  bool listviewvisible=false;
  String selecteddb="";
  var urlholder=TextEditingController();






  String username = "";
  String password = "";

  getTextInputData(BuildContext buildContext) {
    log("set_state_called");
/*
    setState(() {
    log("set_state_called");
     // username = textFieldValueHolder.text;
*/
//    textFieldValueHolder.text = 'admin';         //anthony
//    passwordValueHolder.text = "admin";          //Anthony!23

    log(textFieldValueHolder.text);
    log(passwordValueHolder.text);

    OdooClient odooClient = OdooClient(dbselection?urlholder.text:SERVER_URL2);

    //  odooClient.authenticate(username, password, Constants.DB_NAME);

    void getResponse() async{
      await odooClient
          .authenticate(textFieldValueHolder.text, passwordValueHolder.text,
          dbselection?selecteddb:DB2_NAME)
          .then((AuthenticateCallback auth) async {
        if (auth.isSuccess) {
          final prefs = await SharedPreferences.getInstance();
          print("SessionId"+auth.getSessionId());

          final user = auth.getUser();
          if(dbselection){
            prefs.setString("UserId", user.uid.toString());
            prefs.setString("Username", textFieldValueHolder.text);
            prefs.setString("Password", passwordValueHolder.text);
            prefs.setString("Url", urlholder.text);
            prefs.setString("DbName", selecteddb);
            print("Hey ${user.name}");
            print("UserId ${user.uid}");

          }
          else{
            prefs.setString("UserId", user.uid.toString());
            prefs.setString("Username", textFieldValueHolder.text);
            prefs.setString("Password", passwordValueHolder.text);
            prefs.setString("Url", SERVER_URL2);
            prefs.setString("DbName", DB2_NAME);
            print("Hey ${user.name}");
            print("UserId ${user.uid}");


          }

          setState(() {
            indicatorvisible=false;
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomBarScreen(),
              // Pass the arguments as part of the RouteSettings. The
              // DetailScreen reads the arguments from these settings.
            ),
          );
        } else {
          // login fail
          Scaffold.of(buildContext).showSnackBar(SnackBar(
            content: Text("Invalid username or password"),
          ));
          setState(() {
            indicatorvisible=false;
          });
          textFieldValueHolder.text='';
          passwordValueHolder.text='';
          print("Error ${auth.getError()}");
          print("Login failed");
        }
      });
    }

    getResponse();

/*

    });
*/
  }

  Future<List> getDBs(String url) async{
    var client = OdooClient(url);
    await client.getDatabases().then((value) => databases=value);
    print(databases.length.toString());

    return databases;



  }


  /* @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);



  }*/

  void ShowDialog(BuildContext context) {
    databases.clear();

    showDialog(
        context: context,
        builder: (BuildContext context) {


          /*  return FutureBuilder(
              future: getDBs(""),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());*/
          return StatefulBuilder( // StatefulBuilder
              builder: (context, setState) {
                return AlertDialog(
                  contentPadding: EdgeInsets.all(10.0),
                  content: Stack(children:[Container(

                    child: Column(children: [
                      Row(children: [
                        Container(width: 200,
                            child:TextField(controller: urlholder..text=SERVER_URL2,keyboardType:TextInputType.text,textAlign: TextAlign.start,textAlignVertical: TextAlignVertical.center, decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  bottom: 15,
                                  left: 15// HERE THE IMPORTANT PART
                              ),
                              hintText: 'Enter url',

                              hintStyle: TextStyle( color:  Colors.grey),
                              hoverColor: colorCustom,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorCustom, //this has no effect
                                ),

                                borderRadius: BorderRadius.circular(2.0),
                              ),
                            ))),
                        IconButton(icon: Image.asset("images/dbconnect.png",height: 20,width: 20,),  onPressed:  () async{

                          await getDBs(urlholder.text);
                          setState(() {
                            listviewvisible=true;

                            //    print("selected_popup_length"+selectedpopUpList.length.toString());
                          });
                        },
                        ),


                      ],),

                      /*FlatButton(
                        color: Constants.colorCustom,
                        child: Text("Connect",style: TextStyle(color: Colors.white),),
                        onPressed:  () async{

                          await getDBs(urlholder.text);
                          setState(() {
                            listviewvisible=true;
                            //    print("selected_popup_length"+selectedpopUpList.length.toString());
                          });
                        },
                      ),*/
                      Visibility(visible:listviewvisible,child: Flexible(child:Container(width:double.maxFinite,child:ListView.separated(
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8.0,0,8.0,0),
                              child:GestureDetector( onTap :(){

                                selecteddb=databases.elementAt(index);
                                print(selecteddb);
                                Navigator.pop(context);




                              },
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [


                                        /* Divider(
                                                color: Theme.of(context).primaryColor,
                                              ),*/
                                        new Row(
                                          children: <Widget>[
                                            new Container(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(20, 10, 0, 10),
                                                  child: new Text(
                                                    databases.elementAt(index),
                                                    style: new TextStyle(fontSize: 15.0,color: colorCustom),
                                                  ),
                                                ))
                                          ],
                                        ),
                                        Divider(
                                          height: 0.5,
                                          color: themecolor,
                                        ),

                                      ])),
                              /*title: Text(measureList.elementAt(index).startdate,
                                     ),*/
                              /* ),*/
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(color: Colors.white,height: 0,);
                          },
                          itemCount: databases.length))))





                    ],
                    ),


                  ),Visibility(visible:indicatorvisible,child:Center(
                      child: CircularProgressIndicator()))],),
                );});/*});*/
        }
    );








  }


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return new IgnorePointer(ignoring:indicatorvisible,child:Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
        title: Image.asset('images/visitor.png', height: 200, ),
        toolbarHeight: 220,
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
      ),

      body:Builder(  builder: (context) =>  Center(
        child: Stack(children:[Visibility(visible:dbselection,child: Padding(
          padding: const EdgeInsets.fromLTRB(0,10,10,0),
          child: Row(children: [Spacer(),
            IconButton(icon:  Icon(FontAwesomeIcons.database,color: Colors.black,size: 20,), onPressed:(){ShowDialog(context);} )
          ],),
        )),Center(child:Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          /*  Container(
                height:120,
                child:
                Image.asset("images/company.png")
            ),*/

            Container(
                width:300,
             //   padding: const EdgeInsets.fromLTRB(50,30.0,50,0),

                child: TextField(
                  controller: textFieldValueHolder,
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your username',
                    hintStyle: TextStyle( color: colorCustom),
                    labelText: "UserName",
                    hoverColor: colorCustom,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: colorCustom, //this has no effect
                      ),

                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                )),
            Container(
                 width: 300,
                padding: const EdgeInsets.fromLTRB(0,20.0,0,0),
                child: TextField(
                  controller: passwordValueHolder,
                  autocorrect: true,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: TextStyle( color: colorCustom),
                    labelText: "Password",
                    hoverColor: colorCustom,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: colorCustom, //this has no effect
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Container(width: 300,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      // side: BorderSide(color: Colors.red)
                  ),
                  gradient: LinearGradient(
                      colors: [
                        gradientColor1,
                        gradientColor2,
                      ]

                  )

                ),
                padding: const EdgeInsets.fromLTRB(0,0.0,0,0),
                child: MaterialButton(
                  padding: EdgeInsets.all(12.0),
                  minWidth: double.infinity,
                  onPressed: () {
                    if(dbselection){
                      if(textFieldValueHolder.text==''){


                        Utility.showSnackBar(context, "Please enter username");

                      }
                      else if(passwordValueHolder.text==''){
                        Utility.showSnackBar(context, "Please enter password");


                      }else if(selecteddb==''){
                        Utility.showSnackBar(context, "Please select database");

                      }else{
                        getTextInputData(context);
                        setState(() {
                          indicatorvisible=true;
                        });
                      }

                    }else{
                      if(textFieldValueHolder.text==''){
                        Utility.showSnackBar(context, "Please enter username");


                      }
                      else if(passwordValueHolder.text==''){
                        Utility.showSnackBar(context, "Please enter password");


                      }else{
                        getTextInputData(context);
                        setState(() {
                          indicatorvisible=true;
                        });
                      }


                    }


                  },
                  child: Text("Login", style:TextStyle(fontSize: 20)),
                  // color: colorCustom,
                  textColor: Colors.white,
                  height: 40.0,
                ),
              ),
            ),
            Container(
                width: 300,
                padding: const EdgeInsets.fromLTRB(0,20,0,0),
                child:Row(children:[
                  GestureDetector(
                      onTap:(){
                        /*Utility.launchUrl();*/},
                      child:SizedBox(width:100,
                          child:Image.asset("images/verts_logo_40px.png"))),
                  Padding(
                    padding: const EdgeInsets.only(left:50.0),
                    child: Text("Version :"+APP_VERSION,style: TextStyle(fontSize: 15,color: colorCustom),),
                  ),

                ])),

          ],
        )),Visibility(visible:indicatorvisible,child:Center(
            child: CircularProgressIndicator()))]),
      )),
    ));
  }
}
