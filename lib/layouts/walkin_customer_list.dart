import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_api_connector.dart';
import 'package:odoo_api/odoo_user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor_management/layouts/walkin_customer_form.dart';
import 'package:visitor_management/models/walkincustomer.dart';

import '../constants.dart';
import '../utility.dart';

class WalkinCustomerList extends StatefulWidget{


  WalkinCustomerListWidget createState()=> WalkinCustomerListWidget(); 
  
  
  
  
  
}






class  WalkinCustomerListWidget extends State<WalkinCustomerList>{


  String getFilteredString(String string) {
    int startindex = string.indexOf(",");
    int endIndex = string.lastIndexOf("]");
    String str = string.substring(startindex + 1, endIndex);

    return str;
  }

  String getProjectId(String string) {
    int startindex = string.indexOf("[");
    int endIndex = string.indexOf(",");
    String str = string.substring(startindex + 1, endIndex);

    return str;
  }


  Future<List<WalkinCustomer>> fetchWalkinCustomerList() async {

    final prefs = await SharedPreferences.getInstance();
    String? username=prefs.getString("Username");
    String? password=prefs.getString("Password");
    String? url=prefs.getString("Url");
    String? dbname=prefs.getString("DbName");
    OdooClient odooClient = OdooClient(url);
    await odooClient
        .authenticate(username, password, dbname)
        .then((AuthenticateCallback auth) async {
      if (auth.isSuccess) {
        final prefs = await SharedPreferences.getInstance();
        final user = auth.getUser();
        prefs.setString("UserId", user.uid.toString());
        print("Hey fetchWorkOrderList${user.name}");
        print("UserId fetchWorkOrderList ${user.uid}");
      } else {
        // login fail
        print("Error ${auth.getError()}");
        print("Login failed");
      }
    });

    //print("DeliveryRunId"+delivery.pickuprunid);

   // final List domain = [['delivery_run_id','=',delivery==null?int.parse(deliveryrunid):int.parse(delivery.pickuprunid)] ]; //['workcenter_id','=',260] ['delivery_run_id','=',int.parse(delivery.pickuprunid)] ['pickup_run_id','=',int.parse(delivery.pickuprunid)]
    final List domain = [['is_visitor','=','true']]; //['workcenter_id','=',260] ['delivery_run_id','=',int.parse(delivery.pickuprunid)] ['pickup_run_id','=',int.parse(delivery.pickuprunid)]
    //
    //  // var fields = ["id", "name"];
    List<String> fields = [
      "name",
      "image_1920",
      "email",
      "phone",
      "mobile",
      "date_of_birth",
      "anniversary_date",
      "street",
      "street2",
      "city",
      "state_id",
      "zip",
      "country_id",
      "parent_id",
      "category_id",
      "vat",

      /*name = name
      image = image_1920
      email = email
      phone = phone
      mobile = mobile
      dob = date_of_birth*/


    ];

    OdooResponse result =
    await odooClient.searchRead("res.partner", domain, fields);
    if (!result.hasError()) {
      print("Successful_walkin_customers");
      var response = result.getResult();
      log(response.toString());
      var encoded = json.encode(response['records']);
      // data = json.encode(encoded);

      var data = json.decode(encoded);

      print(data);

      for (var u in data) {
        String id=u["id"].toString();
        String name=u["name"].toString();
        String image=u["image_1920"].toString();
        String email=u["email"].toString();
        String phone=u["phone"].toString();
        String mobile=u["mobile"].toString();
        String dob=u["date_of_birth"].toString();
        String doa = u["anniversary_date"].toString();
        String street=u["street"].toString();
        String street2=u["street2"].toString();
        String city=u["city"].toString();
        String stateid=u["state_id"].toString();
        String zip=u["zip"].toString();
        String countryid=u["country_id"].toString();
        String categoryid=u["category_id"].toString();
        String taxid=u["vat"].toString();


        if(phone=='false'){
          phone='';
        }

        if(mobile=='false'){
          mobile='';
        }

        if(email=='false'){
          email="";
        }


        if(dob=='false'){
          dob='';
        }
        if(doa=='false'){
          doa='';
        }

        if(street=='false') {
          street = '';
        }
        if(street2=='false'){
          street2='';
        }

        if(city=='false'){
          city='';
        }

        String statename="";
        if(stateid=='false'){
          stateid="";
        }else{
          statename=getFilteredString(stateid);
          stateid=getProjectId(stateid);
        }

        if(zip=='false'){
          zip="";
        }

        String countryname="";
        if(countryid=="false"){
          countryid="";
          countryname="";
        }else{
          countryname=getFilteredString(countryid);
          countryid=getProjectId(countryid);
        }

        dynamic decodedbytes;

        if(image=='false'){
          image="";
          decodedbytes="";
        }
        else{
          decodedbytes = base64Decode(image);

        }



        String appendedaddress=street+','+street2+','+city+','+statename+','+zip+','+countryname;
        String address=appendedaddress.replaceAll("(,)*", "");




        WalkinCustomer walkinCustomer=WalkinCustomer(decodedbytes, name, mobile, address, email, phone, dob, doa, stateid,countryid,id,categoryid,street,street2,city,zip,taxid);
        walkincustomerlist.add(walkinCustomer);


      }




      log("Length_Delivery" + walkincustomerlist.length.toString());

      return walkincustomerlist;
    } else {
      log(result.getError().toString());
    }

    return walkincustomerlist;
  }





  List<WalkinCustomer> walkincustomerlist=[];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return FutureBuilder<List<WalkinCustomer>>( future:fetchWalkinCustomerList(),
        builder: (context, snapshot) {
          return new  Scaffold(body:(!snapshot.hasData)?Center(child:CircularProgressIndicator()): Container(child:ListView.builder(

              itemCount: walkincustomerlist.length,

              itemBuilder: (BuildContext context, int index) {
                return  Padding(
                  padding: EdgeInsets.fromLTRB(8.0,8.0,8.0,0),

                  child: Card(
                    child:GestureDetector(

                        onTap: (){

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WalkinCustomerForm(),
                              settings: RouteSettings(
                                arguments:walkincustomerlist.elementAt(index),
                              ),

                            ),
                          );


                        },
                        child: Row(children:[Expanded(child: Column(children: [
                          SizedBox(width:100,
                              child:walkincustomerlist.elementAt(index).image==""?Image.asset("images/verts_logo_40px.png"):Image.memory(walkincustomerlist.elementAt(index).image))

                        ],),flex: 1,),Expanded(child: Column(
                          children: <Widget>[
                            Container(
                              decoration: new BoxDecoration(
                                color: colorCustom,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(20, 10, 0, 10),
                                    child: Text(
                                      walkincustomerlist.elementAt(index).name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                                child: Row(
                                  children: <Widget>[
                                   /* Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(20, 10, 0, 10),*/
                                      Flexible(
                                          child: Text(
                                            walkincustomerlist.elementAt(index).address,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold ,color: colorCustom),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    ),
                                    /*Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(120, 16.0, 0, 0),
                                  child: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                  ),
                                )*/
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 0.5,
                              color: themecolor,
                            ),
                            Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child: Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(20, 10, 0, 10),
                                      child: Text(
                                        walkincustomerlist.elementAt(index).email,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,color: colorCustom),
                                      ),
                                    ),flex: 2,)
                                    ,

                               /*     Expanded(child: IconButton(
                                        icon:
                                        Icon(FontAwesomeIcons.phoneAlt),
                                        iconSize: 20,
                                        color: Colors.green,
                                        onPressed: () {

                                          if(deliverydetaillist.elementAt(index).cellnumber==''){
                                            Utility.showSnackBar(context, 'Please add mobile number');
                                          }else{
                                            Utility.launchUrl('tel:'+deliverydetaillist.elementAt(index).cellnumber);
                                          }





                                        }),flex: 1,),*/

/*                                    Expanded(child: IconButton(
                                        icon:
                                        Icon(FontAwesomeIcons.sms),
                                        iconSize: 20,
                                        color: Colors.green,
                                        onPressed: () {

                                          if(deliverydetaillist.elementAt(index).cellnumber==''){
                                            Utility.showSnackBar(context, 'Please add mobile number');
                                          }else{
                                            Utility.launchUrl('sms:'+deliverydetaillist.elementAt(index).cellnumber+'?body=hello');
                                          }





                                        }),flex: 1,),*/
                                    /*Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(68, 16.0, 0, 0),
                              child: Text(
                                "",
                                textAlign: TextAlign.center,
                              ),
                            )*/
                                  ],
                                )),
                            Divider(
                              height: 0.5,
                              color: themecolor,
                            ),
                            Container(
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(20, 10, 0, 10),
                                      child: Text(
                                        walkincustomerlist.elementAt(index).phonenumber,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,color: colorCustom),
                                      ),
                                    ),
                                    /*  Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 16.0, 0, 0),
                              child: Text(
                                "",
                                textAlign: TextAlign.center,
                              ),
                            ),*/
                                  ],
                                )),
                            Divider(
                              height: 0.5,
                              color: themecolor,
                            ),
                            Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child: Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(20, 10, 0, 10),
                                      child: Text(
                                        walkincustomerlist.elementAt(index).mobilenumber,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,color: colorCustom),
                                      ),
                                    ),flex: 2,),
                             /*       Expanded(child: IconButton(
                                        icon:
                                        Icon(FontAwesomeIcons.mapMarker),
                                        iconSize: 20,
                                        color: Colors.red,
                                        onPressed: () {

                                          if(deliverydetaillist.elementAt(index).address==''){
                                            Utility.showSnackBar(context, 'Please add valid location');
                                          }else{
                                            String query = Uri.encodeComponent(deliverydetaillist.elementAt(index).address);
                                            Utility.launchUrl("https://www.google.com/maps/search/?api=1&query=$query");
                                          }





                                        }),flex: 1,),*/
                                    /*  Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 16.0, 0, 0),
                              child: Text(
                                "",
                                textAlign: TextAlign.center,
                              ),
                            ),*/
                                  ],
                                )),
                            Divider(
                              height: 0.5,
                              color: themecolor,
                            ),
                            Container(
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(20, 10, 0, 10),
                                      child: Text(
                                        walkincustomerlist.elementAt(index).dob,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,color: colorCustom),
                                      ),
                                    ),
                                    /*  Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 16.0, 0, 0),
                              child: Text(
                                "",
                                textAlign: TextAlign.center,
                              ),
                            ),*/
                                  ],
                                )),


                          ],
                        ),flex: 2,),]),

                  ),

                ));
              }
          )),
            // home: new Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70.0),
              child: SafeArea(
                child: new AppBar(
                    title: new Text("Walk-in Customer List"),
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

                         IconButton(icon:
                      Icon(FontAwesomeIcons.fileSignature),
                          onPressed: () {
                            Utility.CallNavigator(context, WalkinCustomerForm(), "");
                          }

                      ),

                    ]
                ),
              ),
            ),
          //  drawer: navigationDrawer(dbname,url,username),
          );});

  }
  
  
  
  
  
}
    