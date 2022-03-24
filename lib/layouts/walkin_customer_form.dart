import 'dart:convert';
import 'dart:developer';
import 'dart:io' as Io;
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_api_connector.dart';
import 'package:odoo_api/odoo_user_response.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor_management/models/company.dart';
import 'package:visitor_management/models/country.dart';
import 'package:visitor_management/models/states.dart';
import 'package:visitor_management/models/tag.dart';
import 'package:visitor_management/models/walkincustomer.dart';

import '../constants.dart';
import '../take_picture_screen.dart';
import '../utility.dart';
class WalkinCustomerForm extends StatefulWidget{


  WalkinCustomerFormWidget createState()=> WalkinCustomerFormWidget();

}


class WalkinCustomerFormWidget extends State{


  List<States> stateslist = [];
  List<Country> countrylist = [];
  List<Company> companylist = [];
  List<Tag> taglist = [];

  var visitornameholder=TextEditingController();
  var streetholder=TextEditingController();
  var street2holder=TextEditingController();
  var cityholder=TextEditingController();
  var zipholder=TextEditingController();
  var taxidholder=TextEditingController();
  var jobpositionholder=TextEditingController();
  var phoneholder=TextEditingController();
  var mobileholder=TextEditingController();
  var emailholder=TextEditingController();
  var websiteholder=TextEditingController();
  var titleholder=TextEditingController();


  States currentSelectedValueStates=States("0", "Select");
  Country currentSelectedValueCountry=Country("0", "Select");
  Company currentSelectedValueCompany=Company("0", "Select");
  Tag currentSelectedValueTag=Tag("0", "Select");


 late OdooResponse result;

  bool isconfirmvisible=false;
  bool afterentersuccess=false;


 late WalkinCustomer? walkinCustomer;

  String previousnotes="";
  String currentnotes="";

  bool InReadmode=false;

  var birthdate="";
  var anniversarydate="";

  bool indicatorvisible=false;

  String imagePath="";


  void getDateofBirth() async {
    var order = await getDate();
    setState(() {
      birthdate = DateFormat('yyyy-MM-dd').format(order);
    });
  }

  void getDateofAnniversary() async {
    var order = await getDate();
    setState(() {

      anniversarydate = DateFormat('yyyy-MM-dd').format(order);
    });
  }


  Future<DateTime?> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
  }


  Future<List<Company>> fetchCompanies() async {
    final prefs = await SharedPreferences.getInstance();
    String? username=prefs.getString("Username");
    String? password=prefs.getString("Password");
    String? url=prefs.getString("Url");
    String? dbname=prefs.getString("DbName");
    OdooClient odooClient = OdooClient(url);
    await odooClient
        .authenticate(
        username, password, dbname)
        .then((AuthenticateCallback auth) async {
      if (auth.isSuccess) {
        final prefs = await SharedPreferences.getInstance();

        final user = auth.getUser();
        prefs.setString("UserId", user.uid.toString());
        print("Hey ${user.name}");
        print("UserId ${user.uid}");
      } else {
        // login fail
        print("Error ${auth.getError()}");
        print("Login failed");
      }
    });

    final domain = [['is_company','=','true']];
    var fields = ["parent_id"];

    OdooResponse result =
    await odooClient.searchRead("res.partner", domain, fields);
    if (!result.hasError()) {
      print("Successful_Companies");
      var response = result.getResult();
      log(response.toString());
      var encoded = json.encode(response['records']);
      // data = json.encode(encoded);
      var data = json.decode(encoded);

      print(data);

      // log("data_length"+data);
      if(currentSelectedValueCompany=='false'){
        Company company=Company("0","Select Company");
        companylist.add(company);
      }else{
        Company company=Company("0","Select Company");
        companylist.add(company);
      }



      for (var u in data) {
        print(u);
        //  print(u["id"]);
        // String id = u["id"].toString();
        String parentid = u["parent_id"].toString();

//        print("Id_inside" + id);
//        print("Name_inside" + name);
//        print("assign_inside" + assignto);

        String name = "";
        String id = "";

        if(parentid == "false"){
          name = "";
          id = "false";
        }
        else{
          name = getFilteredString(parentid);
          id = getProjectId(parentid);
        }

        // Company company=Company(id,name);
        // companylist.add(company);

      }

      log("Length" + companylist.length.toString());

      return companylist;
    } else {
      log(result.getError().toString());
      // setState(() {
      //   indicatorvisible = false;
      // });
    }

    return companylist;
  }
  Future<List<States>> fetchStates() async {
    final prefs = await SharedPreferences.getInstance();
    String? username=prefs.getString("Username");
    String? password=prefs.getString("Password");
    String? url=prefs.getString("Url");
    String? dbname=prefs.getString("DbName");
    OdooClient odooClient = OdooClient(url);
    await odooClient
        .authenticate(
        username, password, dbname)
        .then((AuthenticateCallback auth) async {
      if (auth.isSuccess) {
        final prefs = await SharedPreferences.getInstance();

        final user = auth.getUser();
        prefs.setString("UserId", user.uid.toString());
        print("Hey ${user.name}");
        print("UserId ${user.uid}");
      } else {
        // login fail
        print("Error ${auth.getError()}");
        print("Login failed");
      }
    });

    final domain = [];
    var fields = ["state_id"];

    OdooResponse result =
    await odooClient.searchRead("res.partner", domain, fields);
    if (!result.hasError()) {
      print("Successful_States");
      var response = result.getResult();
      log(response.toString());
      var encoded = json.encode(response['records']);
      // data = json.encode(encoded);
      var data = json.decode(encoded);

      print(data);

      // log("data_length"+data);
      if(currentSelectedValueStates=='false'){
        States state= States("0","Select State");
        stateslist.add(state);
      }else{
        States state=States("0","Select State");
        stateslist.add(state);
      }



      for (var u in data) {
        print(u);
        //  print(u["id"]);
        // String id = u["id"].toString();
        String stateid = u["state_id"].toString();

//        print("Id_inside" + id);
//        print("Name_inside" + name);
//        print("assign_inside" + assignto);

        String name = "";
        String id = "";

        if(stateid == "false"){
          name = "";
          id = "false";
        }
        else{
          name = getFilteredString(stateid);
          id = getProjectId(stateid);
        }


        States state=States(id,name);
        stateslist.add(state);

      }

      log("Length" + stateslist.length.toString());

      return stateslist;
    } else {
      log(result.getError().toString());
      // setState(() {
      //   indicatorvisible = false;
      // });
    }

    return stateslist;
  }
  Future<List<Country>> fetchCountries() async {
    final prefs = await SharedPreferences.getInstance();
    String? username=prefs.getString("Username");
    String? password=prefs.getString("Password");
    String? url=prefs.getString("Url");
    String? dbname=prefs.getString("DbName");
    OdooClient odooClient = OdooClient(url);
    await odooClient
        .authenticate(
        username, password, dbname)
        .then((AuthenticateCallback auth) async {
      if (auth.isSuccess) {
        final prefs = await SharedPreferences.getInstance();

        final user = auth.getUser();
        prefs.setString("UserId", user.uid.toString());
        print("Hey ${user.name}");
        print("UserId ${user.uid}");
      } else {
        // login fail
        print("Error ${auth.getError()}");
        print("Login failed");
      }
    });

    final domain = [];
    var fields = ["country_id"];

    OdooResponse result =
    await odooClient.searchRead("res.partner", domain, fields);
    if (!result.hasError()) {
      print("Successful_Countries");
      var response = result.getResult();
      log(response.toString());
      var encoded = json.encode(response['records']);
      // data = json.encode(encoded);
      var data = json.decode(encoded);

      print(data);

      // log("data_length"+data);
      if(currentSelectedValueCountry=='false'){
        Country country = Country("0","Select Country");
        countrylist.add(country);
      }else{
        Country country=Country("0","Select Country");
        countrylist.add(country);
      }



      for (var u in data) {
        print(u);
        //  print(u["id"]);
        // String id = u["id"].toString();
        String countryid = u["country_id"].toString();

//        print("Id_inside" + id);
//        print("Name_inside" + name);
//        print("assign_inside" + assignto);

        String name = "";
        String id = "";

        if(countryid == "false"){
          name = "";
          id = "false";
        }
        else{
          name = getFilteredString(countryid);
          id = getProjectId(countryid);
        }


        Country country=Country(id,name);
        countrylist.add(country);

      }

      log("Length" + countrylist.length.toString());

      return countrylist;
    } else {
      log(result.getError().toString());
      // setState(() {
      //   indicatorvisible = false;
      // });
    }

    return countrylist;
  }
  Future<List<Tag>> fetchTags() async {
    final prefs = await SharedPreferences.getInstance();
    String? username=prefs.getString("Username");
    String? password=prefs.getString("Password");
    String? url=prefs.getString("Url");
    String? dbname=prefs.getString("DbName");
    OdooClient odooClient = OdooClient(url);
    await odooClient
        .authenticate(
        username, password, dbname)
        .then((AuthenticateCallback auth) async {
      if (auth.isSuccess) {
        final prefs = await SharedPreferences.getInstance();

        final user = auth.getUser();
        prefs.setString("UserId", user.uid.toString());
        print("Hey ${user.name}");
        print("UserId ${user.uid}");
      } else {
        // login fail
        print("Error ${auth.getError()}");
        print("Login failed");
      }
    });

    final domain = [];
    var fields = ["category_id"];

    OdooResponse result =
    await odooClient.searchRead("res.partner.category", domain, fields);
    if (!result.hasError()) {
      print("Successful_Tags");
      var response = result.getResult();
      log(response.toString());
      var encoded = json.encode(response['records']);
      // data = json.encode(encoded);
      var data = json.decode(encoded);

      print(data);

      // log("data_length"+data);
      if(currentSelectedValueTag=='false'){
        Tag tag = Tag("0","Select Tag");
        taglist.add(tag);
      }else{
        Tag tag=Tag("0","Select Tag");
        taglist.add(tag);
      }



      for (var u in data) {
        print(u);
        //  print(u["id"]);
        // String id = u["id"].toString();
        String tagid = u["country_id"].toString();

//        print("Id_inside" + id);
//        print("Name_inside" + name);
//        print("assign_inside" + assignto);

        String name = "";
        String id = "";

        if(tagid == "false"){
          name = "";
          id = "false";
        }
        else{
          name = getFilteredString(tagid);
          id = getProjectId(tagid);
        }


        Tag tag=Tag(id,name);
        taglist.add(tag);

      }

      log("Length" + taglist.length.toString());

      return taglist;
    } else {
      log(result.getError().toString());
      // setState(() {
      //   indicatorvisible = false;
      // });
    }

    return taglist;
  }


  Future<OdooResponse> AddVisitor(BuildContext context) async{
    final prefs = await SharedPreferences.getInstance();
    String? username=prefs.getString("Username");
    String? password=prefs.getString("Password");
    String? url=prefs.getString("Url");
    String? dbname=prefs.getString("DbName");
    OdooClient odooClient = OdooClient(url);
    await odooClient
        .authenticate(
        username, password, dbname)
        .then((AuthenticateCallback auth) async {
      if (auth.isSuccess) {
        final prefs = await SharedPreferences.getInstance();

        final user = auth.getUser();
        prefs.setString("UserId", user.uid.toString());
        print("Hey ${user.name}");
        print("UserId ${user.uid}");
      } else {
        // login fail
        print("Error ${auth.getError()}");
        print("Login failed");
      }
    });

    Map<String, Object> map = {'name': visitornameholder.text, 'phone': phoneholder.text, 'mobile': mobileholder.text, 'email': emailholder.text, 'website': websiteholder.text, 'anniversary_date': anniversarydate.toString(), 'date_of_birth': birthdate.toString(), /*'category_id': currentSelectedValueTag.tagid,*/ 'street': streetholder.text, 'street2': street2holder.text, 'city': cityholder.text, 'state_id': currentSelectedValueStates.stateid, 'zip': zipholder.text, 'country_id': currentSelectedValueCountry.countryid, 'vat': taxidholder.text};
    print(map.toString());
    result = await odooClient.create("res.partner", map);

    if (!result.hasError()) {
      print("Successful_Create");
      var response = result.getResult();
      log(response.toString());
      Utility.showSnackBar(context, "Visitor Added Successfully");
        setState(() {
        indicatorvisible=false;
      });


    } else {

      var response = result.getError();
      var encoded = json.encode(response['data']);
      // data = json.encode(encoded);

      var data = json.decode(encoded);
      var encoded2=json.encode(data['arguments']);

      var finalstr=json.decode(encoded2);

      print(data);
      print("Odoo message"+finalstr.toString());

      Utility.showSnackBar(context, finalstr.toString());


      log(result.getError().toString());
      setState(() {
        indicatorvisible=false;
      });
    }







    return result;





  }




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










  // Future myFutureMethodOverall(BuildContext buildContext) async {
  //   Future<List<Vehicle>> future1 = fetchVehicles(); // will take 1 sec
  //   Future<List<Yard>> future2 = fetchYards(); // will take 3 secs
  //   Future<List<Zone>> future3 = fetchZones();
  //   Future<List<Lane>> future4 = fetchLanes();
  //   Future<List<Bay>> future5 = fetchBays();
  //   Future<List<GateKeeper>> future6 = fetchGateKeepers();
  //   Future<List<GateNumber>> future7 = fetchGateNumbers();
  //   Future<List<CheckPointSet>> future8 = fetchCheckPointSets();
  //   Future<List<InternalDriver>> future9 = fetchInternalDrivers();
  //   Future<List<Customer>> future10 = fetchCustomers();
  //   Future<List<IdType>> future11 = fetchIdTypesList();
  //   Future<List<Category>> future12 = fetchCategories();
  //   Future<List<CheckPoint>> future13 = fetchCheckPoints();
  //   Future<void> future14 = fetchIncomingItems();
  //
  //   // will take 3 secs
  //   // will take 3 secs
  //
  //   return await Future.wait([future1, future2, future3,future4,future5,future6,future7,future8,future9,future10,future11,future12,future13,future14]);
  // }

  Future myFutureMethodOverallCreate(BuildContext buildContext) async {
    Future<List<Company>> future1 = fetchCompanies(); // will take 1 sec
    Future<List<States>> future2 = fetchStates();
    Future<List<Country>> future3 = fetchCountries();
    Future<List<Tag>> future4 = fetchTags();


    // will take 3 secs
    // will take 3 secs

    return await Future.wait([future1, future2, future3, future4]);
  }







  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 400), () {
      companylist.clear();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      stateslist.clear();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      countrylist.clear();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      taglist.clear();
    });




    if(ModalRoute.of(context)!.settings.arguments.runtimeType==WalkinCustomer){
      InReadmode=true;
      walkinCustomer= ModalRoute.of(context)!.settings.arguments as WalkinCustomer?;

      visitornameholder.text = walkinCustomer!.name;
      streetholder.text=walkinCustomer!.street;
      street2holder.text=walkinCustomer!.street2;
      cityholder.text=walkinCustomer!.city;
      zipholder.text=walkinCustomer!.zip;
      taxidholder.text=walkinCustomer!.taxid;
      phoneholder.text=walkinCustomer!.phonenumber;
      mobileholder.text=walkinCustomer!.mobilenumber;
      emailholder.text=walkinCustomer!.email;
      birthdate=walkinCustomer!.dob;
      anniversarydate=walkinCustomer!.doa;
      currentSelectedValueCompany=Company("0", "Select");
      currentSelectedValueStates=States(walkinCustomer!.stateid,"Select");
      currentSelectedValueCountry=Country(walkinCustomer!.countryid,"Select");

      print("In read only mode");
      print(walkinCustomer!.name.toString());

    }
    else{
      InReadmode=false;
      print("In edit only mode");
    }
    return FutureBuilder(
        future: /*InReadmode?myFutureMethodOverall(context):ModalRoute.of(context).settings.arguments!=''?myFutureMethodOverall(context):*/myFutureMethodOverallCreate(context),
        builder: (context, AsyncSnapshot<dynamic> snapshot) { return Scaffold( resizeToAvoidBottomInset: true,
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
                        
                    ))),
            body:Builder( builder:(context) =>(!snapshot.hasData)?Center(child: CircularProgressIndicator()):Stack(children:[SingleChildScrollView(child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            child: Column(children: <Widget>[
                              // Visibility(visible:isconfirmvisible||afterentersuccess,child: Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: FlatButton(
                              //     padding: EdgeInsets.all(12.0),
                              //     onPressed: ()  {
                              //       // ShowDialog(context);
                              //
                              //       /*  aftermovelinescreated?CallActionButtonValidate(context, pickingid):CallActionButtonValidate(context, consumption.id);
                              //       setState(() {
                              //         indicatorvisible=true;
                              //       });*/
                              //
                              //
                              //     },
                              //
                              //
                              //     child:Text("CONFIRM"),
                              //     color: colorCustom,
                              //     textColor: Colors.white,
                              //   ),
                              // )),
                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final cameras = await availableCameras();
                                        final firstCamera = cameras.last;
                                        // Utility.CallNavigator(context, TakePictureScreen(camera: firstCamera), "");

                                     imagePath = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TakePictureScreen(camera: firstCamera),
                                          ),
                                        );
                                     final bytes = Io.File(imagePath).readAsBytesSync();
                                     String img64 = base64Encode(bytes);
                                     setState(() {
                                       imagePath=imagePath;
                                     });

                                     print("Image Path:"+imagePath);
                                     print("Base 64 Image"+img64);


                                      },
                                      child: Container(alignment: Alignment.topLeft,
                                          child: Icon(Icons.camera_alt),
                                  ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(80, 10, 0, 0),
                                    child: SizedBox(
                                      height: 100,
                                      child:(){
                                        if(imagePath==""){
                                          return Image.asset("images/user.png");
                                        }
                                        else{
                                        return Image.file(File(imagePath));
                                        }

                                        }() ),
                                  ),

                                ],
                              ),


                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Container(alignment: Alignment.topLeft,
                                        child: Text("Name",
                                            style: new TextStyle(fontSize: 13,color: colorCustom))),
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 10, 0),
                                    child: Container(
                                        child: (Container(
                                            child:TextField(enabled: InReadmode?false:true,
                                                keyboardType: TextInputType.text,controller: visitornameholder,textAlignVertical: TextAlignVertical.center, decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(
                                                    15,  // HERE THE IMPORTANT PART
                                                  ),
                                                  hintText: 'Name',

                                                  hintStyle: TextStyle( color: Colors.grey),
                                                  hoverColor: colorCustom,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: colorCustom, //this has no effect
                                                    ),

                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ))))),
                                  ),

                                ],
                              ),

                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // new Container(
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.fromLTRB(
                                  //           30, 10, 0, 0),
                                  //       child: new Align(alignment: Alignment.centerLeft,child:Text(
                                  //           'State',
                                  //           style: new TextStyle(
                                  //               fontSize: 15.0,
                                  //               color: colorCustom)),
                                  //       ),
                                  //     )),
                                  new Container(
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              30, 10, 20, 0),
                                          child:IgnorePointer(ignoring: InReadmode,
                                              child:
                                              SearchableDropdown(
                                                value: currentSelectedValueCompany,
                                                onChanged: (value) {
                                                  setState(() {
                                                    //   countryselected=true;
                                                    currentSelectedValueCompany = value;
                                                    print(currentSelectedValueCompany);
                                                  });
                                                },
                                                items: companylist.map((item) {
                                                  return new DropdownMenuItem<Company>(
                                                      child:SizedBox(width:200,child: Text(item.companyname,style: new TextStyle(
                                                          color: Colors
                                                              .black)),), value: item);
                                                }).toList(),
                                                isExpanded: true,
                                                hint: 'Select Company',
                                                isCaseSensitiveSearch: false,
                                                searchHint: new Text(
                                                  'Select Company',
                                                  style: new TextStyle(fontSize: 15.0,color: colorCustom),
                                                ),


                                              )
                                          ))
                                  )],
                              ),

                              // Company Dropdown Here

                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Container(alignment: Alignment.topLeft,
                                        child: Text("Address",
                                            style: new TextStyle(fontSize: 13,color: colorCustom))),
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 10, 0),
                                    child: Container(
                                        child: (Container(
                                            child:TextField(enabled: InReadmode?false:true,
                                                keyboardType: TextInputType.text,controller: streetholder,textAlignVertical: TextAlignVertical.center, decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(
                                                    15,  // HERE THE IMPORTANT PART
                                                  ),
                                                  hintText: 'Street',

                                                  hintStyle: TextStyle( color: Colors.grey),
                                                  hoverColor: colorCustom,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: colorCustom, //this has no effect
                                                    ),

                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ))))),
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 10, 0),
                                    child: Container(
                                        child: (Container(
                                            child:TextField(enabled: InReadmode?false:true,
                                                keyboardType: TextInputType.text,controller: street2holder,textAlignVertical: TextAlignVertical.center, decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(
                                                    15,  // HERE THE IMPORTANT PART
                                                  ),
                                                  hintText: 'Street 2',

                                                  hintStyle: TextStyle( color: Colors.grey),
                                                  hoverColor: colorCustom,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: colorCustom, //this has no effect
                                                    ),

                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ))))),
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 10, 0),
                                    child: Container(
                                        child: (Container(
                                            child:TextField(enabled: InReadmode?false:true,
                                                keyboardType: TextInputType.text,controller: cityholder,textAlignVertical: TextAlignVertical.center, decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(
                                                    15,  // HERE THE IMPORTANT PART
                                                  ),
                                                  hintText: 'City',

                                                  hintStyle: TextStyle( color: Colors.grey),
                                                  hoverColor: colorCustom,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: colorCustom, //this has no effect
                                                    ),

                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ))))),
                                  ),


                                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // new Container(
                                      //     child: Padding(
                                      //       padding: const EdgeInsets.fromLTRB(
                                      //           30, 10, 0, 0),
                                      //       child: new Align(alignment: Alignment.centerLeft,child:Text(
                                      //           'State',
                                      //           style: new TextStyle(
                                      //               fontSize: 15.0,
                                      //               color: colorCustom)),
                                      //       ),
                                      //     )),
                                      new Container(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                30, 10, 20, 0),
                                            child:IgnorePointer(ignoring: InReadmode,
                                                child:
                                                SearchableDropdown(
                                                  value: currentSelectedValueStates,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      //   countryselected=true;
                                                      currentSelectedValueStates = value;
                                                      print(currentSelectedValueStates);
                                                    });
                                                  },
                                                  items: stateslist.map((item) {
                                                    return new DropdownMenuItem<States>(
                                                        child:SizedBox(width:200,child: Text(item.statename,style: new TextStyle(
                                                            color: Colors
                                                                .black)),), value: item);
                                                  }).toList(),
                                                  isExpanded: true,
                                                  hint: 'Select State',
                                                  isCaseSensitiveSearch: false,
                                                  searchHint: new Text(
                                                    'Select State',
                                                    style: new TextStyle(fontSize: 15.0,color: colorCustom),
                                                  ),


                                                )
                                          ))
                                      )],
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 10, 0),
                                    child: Container(
                                        child: (Container(
                                            child:TextField(enabled: InReadmode?false:true,
                                                keyboardType: TextInputType.text,controller: zipholder,textAlignVertical: TextAlignVertical.center, decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(
                                                    15,  // HERE THE IMPORTANT PART
                                                  ),
                                                  hintText: 'ZIP',

                                                  hintStyle: TextStyle( color: Colors.grey),
                                                  hoverColor: colorCustom,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: colorCustom, //this has no effect
                                                    ),

                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ))))),
                                  ),

                                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // new Container(
                                      //     child: Padding(
                                      //       padding: const EdgeInsets.fromLTRB(
                                      //           30, 10, 0, 0),
                                      //       child: new Align(alignment: Alignment.centerLeft,child:Text(
                                      //           'State',
                                      //           style: new TextStyle(
                                      //               fontSize: 15.0,
                                      //               color: colorCustom)),
                                      //       ),
                                      //     )),
                                      new Container(
                                          child: Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  30, 10, 20, 0),
                                              child:IgnorePointer(ignoring: InReadmode,
                                                  child:
                                                  SearchableDropdown(
                                                    value: currentSelectedValueCountry,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        //   countryselected=true;
                                                        currentSelectedValueCountry = value;
                                                        print(currentSelectedValueCountry.countryname);
                                                        print(currentSelectedValueCountry.countryid);
                                                      });
                                                    },
                                                    items: countrylist.map((item) {
                                                      return new DropdownMenuItem<Country>(
                                                          child:SizedBox(width:200,child: Text(item.countryname,style: new TextStyle(
                                                              color: Colors
                                                                  .black)),), value: item);
                                                    }).toList(),
                                                    isExpanded: true,
                                                    hint: 'Select Country',
                                                    isCaseSensitiveSearch: false,
                                                    searchHint: new Text(
                                                      'Select Country',
                                                      style: new TextStyle(fontSize: 15.0,color: colorCustom),
                                                    ),


                                                  )
                                              ))
                                      )],
                                  ),
                                ],
                              ),


                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Container(alignment: Alignment.topLeft,
                                        child: Text("Tax ID",
                                            style: new TextStyle(fontSize: 13,color: colorCustom))),
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 10, 0),
                                    child: Container(
                                        child: (Container(
                                            child:TextField(enabled: InReadmode?false:true,
                                                keyboardType: TextInputType.text,controller: taxidholder,textAlignVertical: TextAlignVertical.center, decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(
                                                    15,  // HERE THE IMPORTANT PART
                                                  ),
                                                  hintText: 'e.g. BE0477472701',

                                                  hintStyle: TextStyle( color: Colors.grey),
                                                  hoverColor: colorCustom,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: colorCustom, //this has no effect
                                                    ),

                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ))))),
                                  ),

                                ],
                              ),


                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Container(alignment: Alignment.topLeft,
                                        child: Text("Job Position",
                                            style: new TextStyle(fontSize: 13,color: colorCustom))),
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 10, 0),
                                    child: Container(
                                        child: (Container(
                                            child:TextField(enabled: InReadmode?false:true,
                                                keyboardType: TextInputType.text,controller: jobpositionholder,textAlignVertical: TextAlignVertical.center, decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(
                                                    15,  // HERE THE IMPORTANT PART
                                                  ),
                                                  hintText: 'e.g. Sales Director',

                                                  hintStyle: TextStyle( color: Colors.grey),
                                                  hoverColor: colorCustom,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: colorCustom, //this has no effect
                                                    ),

                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ))))),
                                  ),

                                ],
                              ),



                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Container(alignment: Alignment.topLeft,
                                        child: Text("Phone",
                                            style: new TextStyle(fontSize: 13,color: colorCustom))),
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 10, 0),
                                    child: Container(
                                        child: (Container(
                                            child:TextField(enabled: InReadmode?false:true,
                                                keyboardType: TextInputType.text,controller: phoneholder,textAlignVertical: TextAlignVertical.center, decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(
                                                    15,  // HERE THE IMPORTANT PART
                                                  ),
                                                  hintText: 'Phone',

                                                  hintStyle: TextStyle( color: Colors.grey),
                                                  hoverColor: colorCustom,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: colorCustom, //this has no effect
                                                    ),

                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ))))),
                                  ),

                                ],
                              ),

                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Container(alignment: Alignment.topLeft,
                                        child: Text("Mobile",
                                            style: new TextStyle(fontSize: 13,color: colorCustom))),
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 10, 0),
                                    child: Container(
                                        child: (Container(
                                            child:TextField(enabled: InReadmode?false:true,
                                                keyboardType: TextInputType.text,controller: mobileholder,textAlignVertical: TextAlignVertical.center, decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(
                                                    15,  // HERE THE IMPORTANT PART
                                                  ),
                                                  hintText: 'Mobile',

                                                  hintStyle: TextStyle( color: Colors.grey),
                                                  hoverColor: colorCustom,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: colorCustom, //this has no effect
                                                    ),

                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ))))),
                                  ),

                                ],
                              ),

                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Container(alignment: Alignment.topLeft,
                                        child: Text("Email",
                                            style: new TextStyle(fontSize: 13,color: colorCustom))),
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 10, 0),
                                    child: Container(
                                        child: (Container(
                                            child:TextField(enabled: InReadmode?false:true,
                                                keyboardType: TextInputType.text,controller: emailholder,textAlignVertical: TextAlignVertical.center, decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(
                                                    15,  // HERE THE IMPORTANT PART
                                                  ),
                                                  hintText: 'Email',

                                                  hintStyle: TextStyle( color: Colors.grey),
                                                  hoverColor: colorCustom,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: colorCustom, //this has no effect
                                                    ),

                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ))))),
                                  ),

                                ],
                              ),

                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Container(alignment: Alignment.topLeft,
                                        child: Text("Website Link",
                                            style: new TextStyle(fontSize: 13,color: colorCustom))),
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 10, 0),
                                    child: Container(
                                        child: (Container(
                                            child:TextField(enabled: InReadmode?false:true,
                                                keyboardType: TextInputType.text,controller: websiteholder,textAlignVertical: TextAlignVertical.center, decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(
                                                    15,  // HERE THE IMPORTANT PART
                                                  ),
                                                  hintText: 'e.g. https://verts.co.in',

                                                  hintStyle: TextStyle( color: Colors.grey),
                                                  hoverColor: colorCustom,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: colorCustom, //this has no effect
                                                    ),

                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ))))),
                                  ),

                                ],
                              ),

                              Row(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 20, 0, 0),
                                    child: Container(
                                        child: Align(alignment:Alignment.centerLeft,child:Text("Anniversary Date",
                                            style: new TextStyle(fontSize: 13,color: colorCustom)))),
                                  ),

                                  Expanded(child:  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 20, 10, 0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(color:colorCustom)
                                        ),
                                        child:GestureDetector(
                                            onTap: (){
                                              if(InReadmode){

                                              }else{
                                                getDateofAnniversary();
                                              }


                                            },
                                            child: (Text(anniversarydate,  //measurement.requiredqty
                                              style: new TextStyle(fontSize: 15,),))

                                        )),
                                  ), flex: 2),

                                ],
                              ),

                              Row(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 20, 0, 0),
                                    child: Container(
                                        child: Align(alignment:Alignment.centerLeft,child:Text("Date of Birth",
                                            style: new TextStyle(fontSize: 13,color: colorCustom)))),
                                  ),

                                  Expanded(child:  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 20, 10, 0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(color:colorCustom)
                                        ),
                                        child:GestureDetector(
                                            onTap: (){
                                              if(InReadmode){

                                              }else{
                                                getDateofBirth();
                                              }


                                            },
                                            child: (Text(birthdate,  //measurement.requiredqty
                                              style: new TextStyle(fontSize: 15,),))

                                        )),
                                  ), flex: 2),

                                ],
                              ),

                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Container(alignment: Alignment.topLeft,
                                        child: Text("Title",
                                            style: new TextStyle(fontSize: 13,color: colorCustom))),
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 10, 0),
                                    child: Container(
                                        child: (Container(
                                            child:TextField(enabled: InReadmode?false:true,
                                                keyboardType: TextInputType.text,controller: titleholder,textAlignVertical: TextAlignVertical.center, decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(
                                                    15,  // HERE THE IMPORTANT PART
                                                  ),
                                                  hintText: 'e.g. Mister',

                                                  hintStyle: TextStyle( color: Colors.grey),
                                                  hoverColor: colorCustom,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: colorCustom, //this has no effect
                                                    ),

                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ))))),
                                  ),

                                ],
                              ),

                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 10, 0, 0),
                                    child: Container(alignment: Alignment.topLeft,
                                        child: Text("Tags",
                                            style: new TextStyle(fontSize: 13,color: colorCustom))),
                                  ),

                                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // new Container(
                                      //     child: Padding(
                                      //       padding: const EdgeInsets.fromLTRB(
                                      //           30, 10, 0, 0),
                                      //       child: new Align(alignment: Alignment.centerLeft,child:Text(
                                      //           'State',
                                      //           style: new TextStyle(
                                      //               fontSize: 15.0,
                                      //               color: colorCustom)),
                                      //       ),
                                      //     )),
                                      new Container(
                                          child: Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  30, 10, 20, 0),
                                              child:IgnorePointer(ignoring: InReadmode,
                                                  child:
                                                  SearchableDropdown(
                                                    value: currentSelectedValueTag,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        //   countryselected=true;
                                                        currentSelectedValueTag = value;
                                                        print(currentSelectedValueTag);
                                                      });
                                                    },
                                                    items: taglist.map((item) {
                                                      return new DropdownMenuItem<Tag>(
                                                          child:SizedBox(width:200,child: Text(item.tagname,style: new TextStyle(
                                                              color: Colors
                                                                  .black)),), value: item);
                                                    }).toList(),
                                                    isExpanded: true,
                                                    hint: 'Tags',
                                                    isCaseSensitiveSearch: false,
                                                    searchHint: new Text(
                                                      'Tags',
                                                      style: new TextStyle(fontSize: 15.0,color: colorCustom),
                                                    ),


                                                  )
                                              ))
                                      )],
                                  ),

                                ],
                              ),







                                                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Visibility(visible:!InReadmode,child:  Column(
                                  children: <Widget>[
                                    SizedBox(
                                        width: 250,
                                        child: FlatButton(
                                          padding: EdgeInsets.all(12.0),
                                          onPressed: ()  {
                                            // if(currentSelectedVehicle.vehicleid=='0'){
                                            //   Utility.showSnackBar(context, 'Please select vehicle');
                                            // }else if(currentSelectedyard.yardid=='0'){
                                            //   Utility.showSnackBar(context, 'Please select yard');
                                            // }else if(currentSelectedkeeper.gatekeeperid=='0'){
                                            //   Utility.showSnackBar(context, 'Please select gate keeper');
                                            // }else if(currentSelectedgateno.gatenumberid=='0'){
                                            //   Utility.showSnackBar(context, 'Please select gate number');
                                            // }else{
                                            //   CreateGateLines(context);
                                            //   setState(() {
                                            //     indicatorvisible=true;
                                            //   });
                                            // }
                                            AddVisitor(context);
                                            setState(() {
                                              indicatorvisible=true;
                                            });



                                          },
                                          child: Text("ADD"),
                                          color: colorCustom,
                                          textColor: Colors.white,
                                        )),
                                  ],
                                )),
                              ),






                            ])),
                      ),


                    ],
                  ),
                ))),Visibility(visible:indicatorvisible,child:Center(
                child: CircularProgressIndicator()))])));});





  }












}