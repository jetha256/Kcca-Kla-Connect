import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:icon_forest/mbi_combi.dart';
import 'package:icon_forest/mbi_linecons.dart';
import 'package:icon_forest/system_uicons.dart';
import 'package:icon_forest/ternav_icons_duotone.dart';
import 'package:kcca_kla_connect/config/base.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:popover/popover.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../config/functions.dart';
import '../../models/incident.dart';
import '../../reusables/text.dart';
import 'incidentpage.dart';

class EngIncidents extends StatefulWidget {
  const EngIncidents({Key? key}) : super(key: key);

  @override
  State<EngIncidents> createState() => _EngIncidentsState();
}

class _EngIncidentsState extends Base<EngIncidents> {
  Future<List<Incident>>? _incidents;
  Future<List<Incident>>? _incidentsApproved;
  Future<List<Incident>>? _incidentsNotApproved;
  bool responseStatus = false;
  bool? isEngineer;

  _checkIfEnge() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isEngineer = prefs.getBool("isengineer");
    });
  }

  //get incidents and filter those near me
  Future<List<Incident>> getIncidents() async {
    List<Incident> returnValue = [];
    String userId = "";
    String _authToken = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl + "incidents");

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    // _username = prefs.getString("email")!;
    // _password = prefs.getString("password")!;

    // await AppFunctions.authenticate(_username, _password);
    // _authToken = prefs.getString("authToken")!;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
      },
    );
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      List<Incident> incidentsmodel =
          (items as List).map((data) => Incident.fromJson(data)).toList();
      var incidents = incidentsmodel;
      returnValue = incidentsmodel;

      // Navigator.pushNamed(context, AppRouter.home);
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  //get incidents and filter those near me
  Future<List<Incident>> getIncidentsApproved() async {
    List<Incident> returnValue = [];
    String userId = "";
    String _authToken = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl + "incidents/approved");

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    // _username = prefs.getString("email")!;
    // _password = prefs.getString("password")!;

    // await AppFunctions.authenticate(_username, _password);
    // _authToken = prefs.getString("authToken")!;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
      },
    );
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      List<Incident> incidentsmodel =
          (items as List).map((data) => Incident.fromJson(data)).toList();
      var incidents = incidentsmodel;
      returnValue = incidentsmodel;

      // Navigator.pushNamed(context, AppRouter.home);
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  //get incidents and filter those near me
  Future<List<Incident>> getIncidentsNotApproved() async {
    List<Incident> returnValue = [];
    String userId = "";
    String _authToken = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl + "incidents/unapproved");

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    // _username = prefs.getString("email")!;
    // _password = prefs.getString("password")!;

    // await AppFunctions.authenticate(_username, _password);
    // _authToken = prefs.getString("authToken")!;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
      },
    );
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      List<Incident> incidentsmodel =
          (items as List).map((data) => Incident.fromJson(data)).toList();
      var incidents = incidentsmodel;
      returnValue = incidentsmodel;

      // Navigator.pushNamed(context, AppRouter.home);
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  // approve incidents

  Future<void> _approveeIncident(String id, int index) async {
    String _authToken = "";
    String userId = "";
    String idInc = "";
    setState(() {
      responseStatus = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl + "incidents/restore");

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    String _username = prefs.getString("email")!;
    String _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;
    print("++++++" + "Approve FUNCTION" + "+++++++");
    // Navigator.pushNamed(context, AppRouter.home);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      responseStatus = true;
    });
    var bodyString = {
      "id": id,
      "updatedby": userId,
    };

    var body = jsonEncode(bodyString);

    var response = await http.put(url,
        headers: {
          "Content-Type": "Application/json",
          'Authorization': 'Bearer $_authToken',
        },
        body: body);
    print(id);
    print(userId);
    print(body.toString());
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      showSnackBar('Approved');
      setState(() {
        _incidents!.asStream().asyncMap((event) {
          event.elementAt(index).status = '1';
        });
      });

      setState(() {
        context.loaderOverlay.hide();
      });
    } else if (response.statusCode == 409) {
      setState(() {
        context.loaderOverlay.hide();
      });
      showSnackBar("User account not activated.");
    } else {
      setState(() {
        context.loaderOverlay.hide();
      });
      showSnackBar("Authentication Failure: Invalid credentials.");
    }
  }

  Future<void> _archiveIncident(String id, int index) async {
    String _authToken = "";
    String userId = "";
    String idInc = "";
    setState(() {
      responseStatus = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl + "incidents/archive");

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    String _username = prefs.getString("email")!;
    String _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;
    print("++++++" + "Approve FUNCTION" + "+++++++");
    // Navigator.pushNamed(context, AppRouter.home);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      responseStatus = true;
    });
    var bodyString = {
      "id": id,
      "updatedby": userId,
    };

    var body = jsonEncode(bodyString);

    var response = await http.put(url,
        headers: {
          "Content-Type": "Application/json",
          'Authorization': 'Bearer $_authToken',
        },
        body: body);
    print(id);
    print(userId);
    print(body.toString());
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      showSnackBar('Changed to pending');
      setState(() {
        _incidents!.asStream().asyncMap((event) {
          event.elementAt(index).status = '0';
        });
      });

      setState(() {
        context.loaderOverlay.hide();
      });
    } else if (response.statusCode == 409) {
      setState(() {
        context.loaderOverlay.hide();
      });
      showSnackBar("User account not activated.");
    } else {
      setState(() {
        context.loaderOverlay.hide();
      });
      showSnackBar("Authentication Failure: Invalid credentials.");
    }
  }

  Future<void> _resolveincident(String id, int index) async {
    String _authToken = "";
    String userId = "";
    String idInc = "";
    setState(() {
      responseStatus = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl + "incidents/resolve");

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    String _username = prefs.getString("email")!;
    String _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;
    print("++++++" + "Approve FUNCTION" + "+++++++");
    // Navigator.pushNamed(context, AppRouter.home);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      responseStatus = true;
    });
    var bodyString = {
      "id": id,
      "updatedby": userId,
    };

    var body = jsonEncode(bodyString);

    var response = await http.put(url,
        headers: {
          "Content-Type": "Application/json",
          'Authorization': 'Bearer $_authToken',
        },
        body: body);
    print(id);
    print(userId);
    print(body.toString());
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      showSnackBar('Changed to resolved');
      setState(() {
        _incidents!.asStream().asyncMap((event) {
          event.elementAt(index).status = '2';
        });
      });

      setState(() {
        context.loaderOverlay.hide();
      });
    } else if (response.statusCode == 409) {
      setState(() {
        context.loaderOverlay.hide();
      });
      showSnackBar("User account not activated.");
    } else {
      setState(() {
        context.loaderOverlay.hide();
      });
      showSnackBar("Authentication Failure: Invalid credentials.");
    }
  }

  Future<void> _rejectIncident(String id, int index) async {
    String _authToken = "";
    String userId = "";
    String idInc = "";
    setState(() {
      responseStatus = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl + "incidents/reject");

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    String _username = prefs.getString("email")!;
    String _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;
    print("++++++" + "Approve FUNCTION" + "+++++++");
    // Navigator.pushNamed(context, AppRouter.home);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      responseStatus = true;
    });
    var bodyString = {
      "id": id,
      "updatedby": userId,
    };

    var body = jsonEncode(bodyString);

    var response = await http.put(url,
        headers: {
          "Content-Type": "Application/json",
          'Authorization': 'Bearer $_authToken',
        },
        body: body);
    print(id);
    print(userId);
    print(body.toString());
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      showSnackBar('Changed to Rejected');
      setState(() {
        _incidents!.asStream().asyncMap((event) {
          event.elementAt(index).status = '3';
        });
      });

      setState(() {
        responseStatus = false;
        context.loaderOverlay.hide();
      });
    } else if (response.statusCode == 409) {
      setState(() {
        responseStatus = false;
        context.loaderOverlay.hide();
      });
      showSnackBar("User account not activated.");
    } else {
      setState(() {
        responseStatus = false;
        context.loaderOverlay.hide();
      });
      showSnackBar("Authentication Failure: Invalid credentials.");
    }
  }

  @override
  void initState() {
    super.initState();
    _incidents = getIncidents();
    _incidentsApproved = getIncidentsApproved();
    _incidentsNotApproved = getIncidentsNotApproved();
    _checkIfEnge();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(
            "Incidents",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            tabs: [
              Tab(
                icon: SystemUicons(SystemUicons.episodes),
                text: 'All',
              ),
              Tab(
                icon: SystemUicons(SystemUicons.check_circle_outside),
                text: 'Approved',
              ),
              Tab(
                icon: SystemUicons(SystemUicons.warning_circle),
                text: 'Not approved',
              )
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * .95,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(245, 245, 245, 1),
                  ),
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * .83,
                        ),
                        child: FutureBuilder<List<dynamic>>(
                          future: _incidents,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return Expanded(
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: GestureDetector(
                                                onTap: () {
                                                  push(IncidentPage(
                                                      incident: snapshot
                                                          .data![index]));
                                                },
                                                child: Text(
                                                  snapshot.data![index].name
                                                      .toString()
                                                      .toUpperCase(),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              subtitle: GestureDetector(
                                                onTap: () {
                                                  push(IncidentPage(
                                                      incident: snapshot
                                                          .data![index]));
                                                },
                                                child: Text(
                                                  snapshot
                                                      .data![index].description,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              trailing: Container(
                                                width: 100,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        push(IncidentPage(
                                                            incident: snapshot
                                                                .data![index]));
                                                      },
                                                      child: Container(
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: snapshot
                                                                        .data![
                                                                            index]
                                                                        .file1 !=
                                                                    '' &&
                                                                snapshot
                                                                        .data![
                                                                            index]
                                                                        .file1 !=
                                                                    null
                                                            ? Image.memory(
                                                                Base64Decoder()
                                                                    .convert(snapshot
                                                                        .data![
                                                                            index]
                                                                        .file1
                                                                        .split(
                                                                            ',')
                                                                        .last
                                                                        .trim()),
                                                                fit:
                                                                    BoxFit.fill,
                                                                height: 80,
                                                              )
                                                            : Image.asset(
                                                                'assets/images/signin.jpeg',
                                                                fit:
                                                                    BoxFit.fill,
                                                                height: 80,
                                                              ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              context) {
                                                            bool
                                                                changeVariable =
                                                                false;
                                                            return StatefulBuilder(
                                                                builder: (context,
                                                                    StateSetter
                                                                        setState) {
                                                              return AlertDialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                content:
                                                                    SizedBox(
                                                                  height: 200,
                                                                  child:
                                                                      ListView(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          push(IncidentPage(
                                                                              incident: snapshot.data![index]));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              50,
                                                                          color:
                                                                              const Color(0xFF2A2D3E),
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.visibility,
                                                                                color: Color.fromRGBO(34, 112, 59, 1),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () async {
                                                                                  setState(() {});
                                                                                },
                                                                                child: ReuseText(
                                                                                  text: 'View',
                                                                                  color: Colors.white,
                                                                                  fWeight: FontWeight.w400,
                                                                                  size: 16,
                                                                                  textAlign: TextAlign.left,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          context
                                                                              .loaderOverlay
                                                                              .show();
                                                                          _resolveincident(
                                                                            snapshot.data![index].id,
                                                                            index,
                                                                          ).then((value) =>
                                                                              Navigator.pop(context));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              50,
                                                                          color:
                                                                              const Color(0xFF2A2D3E),
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: const [
                                                                              Icon(
                                                                                FontAwesomeIcons.circleCheck,
                                                                                color: Color.fromRGBO(34, 112, 59, 1),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Expanded(
                                                                                child: ReuseText(
                                                                                  text: 'Resolved',
                                                                                  color: Colors.white,
                                                                                  fWeight: FontWeight.w400,
                                                                                  size: 16,
                                                                                  textAlign: TextAlign.left,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          context
                                                                              .loaderOverlay
                                                                              .show();
                                                                          _approveeIncident(
                                                                            snapshot.data![index].id,
                                                                            index,
                                                                          ).then((value) =>
                                                                              Navigator.pop(context));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              50,
                                                                          color:
                                                                              const Color(0xFF2A2D3E),
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: const [
                                                                              Icon(
                                                                                FontAwesomeIcons.closedCaptioning,
                                                                                color: Color.fromRGBO(34, 112, 59, 1),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              ReuseText(
                                                                                text: 'Approve',
                                                                                color: Colors.white,
                                                                                fWeight: FontWeight.w400,
                                                                                size: 16,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  changeVariable
                                                                      ? CircularProgressIndicator()
                                                                      : Container(),
                                                                  changeVariable
                                                                      ? Container()
                                                                      : TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Cancel',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.red,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                  changeVariable
                                                                      ? Container()
                                                                      : TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.of(context).pop(),
                                                                          child:
                                                                              const Text(
                                                                            'Done',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.blueAccent,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                ],
                                                              );
                                                            });
                                                          },
                                                        );
                                                      },
                                                      child: Icon(Icons.list),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: snapshot.data![index]
                                                                .status ==
                                                            '0'
                                                        ? Text(
                                                            'Pending',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          )
                                                        : snapshot.data![index]
                                                                    .status ==
                                                                '1'
                                                            ? Text(
                                                                'Approved',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .amber,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              )
                                                            : snapshot
                                                                        .data![
                                                                            index]
                                                                        .status ==
                                                                    '2'
                                                                ? Text(
                                                                    'Resolved',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .amber,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    'Rejected',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      timeago.format(
                                                          snapshot.data![index]
                                                              .datecreated,
                                                          locale: 'en_short'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: Container(
                                    child: Text("No posted incidents as yet"),
                                  ),
                                );
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppConstants.primaryColor),
                                ),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * .95,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(245, 245, 245, 1),
                  ),
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * .83,
                        ),
                        child: FutureBuilder<List<dynamic>>(
                          future: _incidentsApproved,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return Expanded(
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: GestureDetector(
                                                onTap: () {
                                                  push(IncidentPage(
                                                      incident: snapshot
                                                          .data![index]));
                                                },
                                                child: Text(
                                                  snapshot.data![index].name
                                                      .toString()
                                                      .toUpperCase(),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              subtitle: GestureDetector(
                                                onTap: () {
                                                  push(IncidentPage(
                                                      incident: snapshot
                                                          .data![index]));
                                                },
                                                child: Text(
                                                  snapshot
                                                      .data![index].description,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              trailing: Container(
                                                width: 100,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        push(IncidentPage(
                                                            incident: snapshot
                                                                .data![index]));
                                                      },
                                                      child: Container(
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: snapshot
                                                                        .data![
                                                                            index]
                                                                        .file1 !=
                                                                    '' &&
                                                                snapshot
                                                                        .data![
                                                                            index]
                                                                        .file1 !=
                                                                    null
                                                            ? Image.memory(
                                                                Base64Decoder()
                                                                    .convert(snapshot
                                                                        .data![
                                                                            index]
                                                                        .file1
                                                                        .split(
                                                                            ',')
                                                                        .last
                                                                        .trim()),
                                                                fit:
                                                                    BoxFit.fill,
                                                                height: 80,
                                                              )
                                                            : Image.asset(
                                                                'assets/images/signin.jpeg',
                                                                fit:
                                                                    BoxFit.fill,
                                                                height: 80,
                                                              ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              context) {
                                                            bool
                                                                changeVariable =
                                                                false;
                                                            return StatefulBuilder(
                                                                builder: (context,
                                                                    StateSetter
                                                                        setState) {
                                                              return AlertDialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                content:
                                                                    SizedBox(
                                                                  height: 200,
                                                                  child:
                                                                      ListView(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          push(IncidentPage(
                                                                              incident: snapshot.data![index]));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              50,
                                                                          color:
                                                                              const Color(0xFF2A2D3E),
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.visibility,
                                                                                color: Color.fromRGBO(34, 112, 59, 1),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () async {
                                                                                  setState(() {});
                                                                                },
                                                                                child: ReuseText(
                                                                                  text: 'View',
                                                                                  color: Colors.white,
                                                                                  fWeight: FontWeight.w400,
                                                                                  size: 16,
                                                                                  textAlign: TextAlign.left,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          context
                                                                              .loaderOverlay
                                                                              .show();
                                                                          _resolveincident(
                                                                            snapshot.data![index].id,
                                                                            index,
                                                                          ).then((value) =>
                                                                              Navigator.pop(context));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              50,
                                                                          color:
                                                                              const Color(0xFF2A2D3E),
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: const [
                                                                              Icon(
                                                                                FontAwesomeIcons.circleCheck,
                                                                                color: Color.fromRGBO(34, 112, 59, 1),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Expanded(
                                                                                child: ReuseText(
                                                                                  text: 'Resolved',
                                                                                  color: Colors.white,
                                                                                  fWeight: FontWeight.w400,
                                                                                  size: 16,
                                                                                  textAlign: TextAlign.left,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          context
                                                                              .loaderOverlay
                                                                              .show();
                                                                          _archiveIncident(
                                                                            snapshot.data![index].id,
                                                                            index,
                                                                          ).then(
                                                                              (value) {
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              50,
                                                                          color:
                                                                              const Color(0xFF2A2D3E),
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: const [
                                                                              Icon(
                                                                                FontAwesomeIcons.closedCaptioning,
                                                                                color: Color.fromRGBO(34, 112, 59, 1),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              ReuseText(
                                                                                text: 'Disapprove',
                                                                                color: Colors.white,
                                                                                fWeight: FontWeight.w400,
                                                                                size: 16,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  responseStatus
                                                                      ? CircularProgressIndicator()
                                                                      : Container(),
                                                                  responseStatus
                                                                      ? Container()
                                                                      : TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Cancel',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.red,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                  responseStatus
                                                                      ? Container()
                                                                      : TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.of(context).pop(),
                                                                          child:
                                                                              const Text(
                                                                            'Done',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.blueAccent,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                ],
                                                              );
                                                            });
                                                          },
                                                        );
                                                        // showPopover(
                                                        //   context: context,
                                                        //   barrierColor:
                                                        //       Colors.black87,
                                                        //   backgroundColor:
                                                        //       Colors.white54,
                                                        //   transitionDuration:
                                                        //       const Duration(
                                                        //           milliseconds:
                                                        //               150),
                                                        //   bodyBuilder:
                                                        //       (context) {
                                                        //     return Scrollbar(
                                                        //       child:
                                                        //           GlassmorphicContainer(
                                                        //         width: 350,
                                                        //         borderRadius:
                                                        //             10,
                                                        //         blur: .5,
                                                        //         alignment:
                                                        //             Alignment
                                                        //                 .center,
                                                        //         border: 0,
                                                        //         linearGradient: LinearGradient(
                                                        //             begin: Alignment
                                                        //                 .topLeft,
                                                        //             end: Alignment
                                                        //                 .bottomRight,
                                                        //             colors: [
                                                        //               const Color(
                                                        //                       0xFFffffff)
                                                        //                   .withOpacity(
                                                        //                       0.1),
                                                        //               const Color(
                                                        //                       0xFFFFFFFF)
                                                        //                   .withOpacity(
                                                        //                       0.05),
                                                        //             ],
                                                        //             stops: const [
                                                        //               0.1,
                                                        //               1,
                                                        //             ]),
                                                        //         borderGradient:
                                                        //             LinearGradient(
                                                        //           begin: Alignment
                                                        //               .topLeft,
                                                        //           end: Alignment
                                                        //               .bottomRight,
                                                        //           colors: [
                                                        //             const Color(
                                                        //                     0xFFffffff)
                                                        //                 .withOpacity(
                                                        //                     0.5),
                                                        //             const Color(
                                                        //                     (0xFFFFFFFF))
                                                        //                 .withOpacity(
                                                        //                     0.5),
                                                        //           ],
                                                        //         ),
                                                        //         padding: const EdgeInsets
                                                        //                 .symmetric(
                                                        //             vertical:
                                                        //                 8),
                                                        //         height: 210,
                                                        //         child: ListView(
                                                        //           padding:
                                                        //               const EdgeInsets
                                                        //                   .all(8),
                                                        //           children: [
                                                        //             GestureDetector(
                                                        //               onTap:
                                                        //                   () {
                                                        //                 setState(
                                                        //                     () {});
                                                        //                 Navigator.pop(
                                                        //                     context);
                                                        //               },
                                                        //               child:
                                                        //                   Container(
                                                        //                 height:
                                                        //                     50,
                                                        //                 color: const Color(
                                                        //                     0xFF2A2D3E),
                                                        //                 padding:
                                                        //                     const EdgeInsets.symmetric(horizontal: 10),
                                                        //                 child:
                                                        //                     Row(
                                                        //                   mainAxisAlignment:
                                                        //                       MainAxisAlignment.start,
                                                        //                   children: [
                                                        //                     const Icon(
                                                        //                       Icons.visibility,
                                                        //                       color: Color.fromRGBO(34, 112, 59, 1),
                                                        //                     ),
                                                        //                     const SizedBox(
                                                        //                       width: 10,
                                                        //                     ),
                                                        //                     GestureDetector(
                                                        //                       onTap: () async {
                                                        //                         setState(() {});
                                                        //                       },
                                                        //                       child: ReuseText(
                                                        //                         text: 'View',
                                                        //                         color: Colors.white,
                                                        //                         fWeight: FontWeight.w400,
                                                        //                         size: 16,
                                                        //                         textAlign: TextAlign.left,
                                                        //                       ),
                                                        //                     ),
                                                        //                   ],
                                                        //                 ),
                                                        //               ),
                                                        //             ),
                                                        //             const Divider(),
                                                        //             GestureDetector(
                                                        //               onTap:
                                                        //                   () {
                                                        //                 print(
                                                        //                     'object');
                                                        //               },
                                                        //               child:
                                                        //                   Container(
                                                        //                 height:
                                                        //                     50,
                                                        //                 color: const Color(
                                                        //                     0xFF2A2D3E),
                                                        //                 padding:
                                                        //                     const EdgeInsets.symmetric(horizontal: 10),
                                                        //                 child:
                                                        //                     Row(
                                                        //                   mainAxisAlignment:
                                                        //                       MainAxisAlignment.start,
                                                        //                   children: const [
                                                        //                     Icon(
                                                        //                       FontAwesomeIcons.circleCheck,
                                                        //                       color: Color.fromRGBO(34, 112, 59, 1),
                                                        //                     ),
                                                        //                     SizedBox(
                                                        //                       width: 10,
                                                        //                     ),
                                                        //                     Expanded(
                                                        //                       child: ReuseText(
                                                        //                         text: 'Approve',
                                                        //                         color: Colors.white,
                                                        //                         fWeight: FontWeight.w400,
                                                        //                         size: 16,
                                                        //                         textAlign: TextAlign.left,
                                                        //                       ),
                                                        //                     ),
                                                        //                   ],
                                                        //                 ),
                                                        //               ),
                                                        //             ),
                                                        //             const Divider(),
                                                        //             GestureDetector(
                                                        //               onTap:
                                                        //                   () {
                                                        //                 Navigator.pop(
                                                        //                     context);
                                                        //                 print(
                                                        //                     'heey');
                                                        //               },
                                                        //               child:
                                                        //                   Container(
                                                        //                 height:
                                                        //                     50,
                                                        //                 color: const Color(
                                                        //                     0xFF2A2D3E),
                                                        //                 padding:
                                                        //                     const EdgeInsets.symmetric(horizontal: 10),
                                                        //                 child:
                                                        //                     Row(
                                                        //                   mainAxisAlignment:
                                                        //                       MainAxisAlignment.start,
                                                        //                   children: const [
                                                        //                     Icon(
                                                        //                       FontAwesomeIcons.closedCaptioning,
                                                        //                       color: Color.fromRGBO(34, 112, 59, 1),
                                                        //                     ),
                                                        //                     SizedBox(
                                                        //                       width: 10,
                                                        //                     ),
                                                        //                     ReuseText(
                                                        //                       text: 'Disapprove',
                                                        //                       color: Colors.white,
                                                        //                       fWeight: FontWeight.w400,
                                                        //                       size: 16,
                                                        //                     ),
                                                        //                   ],
                                                        //                 ),
                                                        //               ),
                                                        //             ),
                                                        //           ],
                                                        //         ),
                                                        //       ),
                                                        //     );
                                                        //   },
                                                        //   onPop: () => print(
                                                        //       'Popover was popped!'),
                                                        //   direction:
                                                        //       PopoverDirection
                                                        //           .left,
                                                        //   width: 150,
                                                        //   height: 170,
                                                        //   arrowHeight: 15,
                                                        //   arrowWidth: 30,
                                                        // );
                                                      },
                                                      child: Icon(Icons.list),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: snapshot.data![index]
                                                                .status ==
                                                            '0'
                                                        ? Text(
                                                            'Pending',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          )
                                                        : snapshot.data![index]
                                                                    .status ==
                                                                '1'
                                                            ? Text(
                                                                'Approved',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .amber,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              )
                                                            : snapshot
                                                                        .data![
                                                                            index]
                                                                        .status ==
                                                                    '2'
                                                                ? Text(
                                                                    'Resolved',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .amber,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    'Rejected',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text("No approved incidents"),
                                );
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppConstants.primaryColor),
                                ),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * .95,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(245, 245, 245, 1),
                  ),
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * .83,
                        ),
                        child: FutureBuilder<List<dynamic>>(
                          future: _incidentsNotApproved,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return Expanded(
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: GestureDetector(
                                                onTap: () {
                                                  push(IncidentPage(
                                                      incident: snapshot
                                                          .data![index]));
                                                },
                                                child: Text(
                                                  snapshot.data![index].name
                                                      .toString()
                                                      .toUpperCase(),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              subtitle: GestureDetector(
                                                onTap: () {
                                                  push(IncidentPage(
                                                      incident: snapshot
                                                          .data![index]));
                                                },
                                                child: Text(
                                                  snapshot
                                                      .data![index].description,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              trailing: Container(
                                                width: 100,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        push(IncidentPage(
                                                            incident: snapshot
                                                                .data![index]));
                                                      },
                                                      child: Container(
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: snapshot
                                                                        .data![
                                                                            index]
                                                                        .file1 !=
                                                                    '' &&
                                                                snapshot
                                                                        .data![
                                                                            index]
                                                                        .file1 !=
                                                                    null
                                                            ? Image.memory(
                                                                Base64Decoder()
                                                                    .convert(snapshot
                                                                        .data![
                                                                            index]
                                                                        .file1
                                                                        .split(
                                                                            ',')
                                                                        .last
                                                                        .trim()),
                                                                fit:
                                                                    BoxFit.fill,
                                                                height: 80,
                                                              )
                                                            : Image.asset(
                                                                'assets/images/signin.jpeg',
                                                                fit:
                                                                    BoxFit.fill,
                                                                height: 80,
                                                              ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              context) {
                                                            bool
                                                                changeVariable =
                                                                false;
                                                            return StatefulBuilder(
                                                                builder: (context,
                                                                    StateSetter
                                                                        setState) {
                                                              return AlertDialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                content:
                                                                    SizedBox(
                                                                  height: 200,
                                                                  child:
                                                                      ListView(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          push(IncidentPage(
                                                                              incident: snapshot.data![index]));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              50,
                                                                          color:
                                                                              const Color(0xFF2A2D3E),
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.visibility,
                                                                                color: Color.fromRGBO(34, 112, 59, 1),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () async {
                                                                                  setState(() {});
                                                                                },
                                                                                child: ReuseText(
                                                                                  text: 'View',
                                                                                  color: Colors.white,
                                                                                  fWeight: FontWeight.w400,
                                                                                  size: 16,
                                                                                  textAlign: TextAlign.left,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          context
                                                                              .loaderOverlay
                                                                              .show();
                                                                          _approveeIncident(
                                                                            snapshot.data![index].id,
                                                                            index,
                                                                          ).then((value) =>
                                                                              Navigator.pop(context));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              50,
                                                                          color:
                                                                              const Color(0xFF2A2D3E),
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: const [
                                                                              Icon(
                                                                                FontAwesomeIcons.circleCheck,
                                                                                color: Color.fromRGBO(34, 112, 59, 1),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Expanded(
                                                                                child: ReuseText(
                                                                                  text: 'Approve',
                                                                                  color: Colors.white,
                                                                                  fWeight: FontWeight.w400,
                                                                                  size: 16,
                                                                                  textAlign: TextAlign.left,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          context
                                                                              .loaderOverlay
                                                                              .show();
                                                                          _rejectIncident(
                                                                            snapshot.data![index].id,
                                                                            index,
                                                                          ).then(
                                                                              (value) {
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              50,
                                                                          color:
                                                                              const Color(0xFF2A2D3E),
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: const [
                                                                              Icon(
                                                                                FontAwesomeIcons.closedCaptioning,
                                                                                color: Color.fromRGBO(34, 112, 59, 1),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              ReuseText(
                                                                                text: 'Reject',
                                                                                color: Colors.white,
                                                                                fWeight: FontWeight.w400,
                                                                                size: 16,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  responseStatus
                                                                      ? CircularProgressIndicator()
                                                                      : Container(),
                                                                  responseStatus
                                                                      ? Container()
                                                                      : TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Cancel',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.red,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                  responseStatus
                                                                      ? Container()
                                                                      : TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.of(context).pop(),
                                                                          child:
                                                                              const Text(
                                                                            'Done',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.blueAccent,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                ],
                                                              );
                                                            });
                                                          },
                                                        );
                                                        // showPopover(
                                                        //   context: context,
                                                        //   barrierColor:
                                                        //       Colors.black87,
                                                        //   backgroundColor:
                                                        //       Colors.white54,
                                                        //   transitionDuration:
                                                        //       const Duration(
                                                        //           milliseconds:
                                                        //               150),
                                                        //   bodyBuilder:
                                                        //       (context) {
                                                        //     return Scrollbar(
                                                        //       child:
                                                        //           GlassmorphicContainer(
                                                        //         width: 350,
                                                        //         borderRadius:
                                                        //             10,
                                                        //         blur: .5,
                                                        //         alignment:
                                                        //             Alignment
                                                        //                 .center,
                                                        //         border: 0,
                                                        //         linearGradient: LinearGradient(
                                                        //             begin: Alignment
                                                        //                 .topLeft,
                                                        //             end: Alignment
                                                        //                 .bottomRight,
                                                        //             colors: [
                                                        //               const Color(
                                                        //                       0xFFffffff)
                                                        //                   .withOpacity(
                                                        //                       0.1),
                                                        //               const Color(
                                                        //                       0xFFFFFFFF)
                                                        //                   .withOpacity(
                                                        //                       0.05),
                                                        //             ],
                                                        //             stops: const [
                                                        //               0.1,
                                                        //               1,
                                                        //             ]),
                                                        //         borderGradient:
                                                        //             LinearGradient(
                                                        //           begin: Alignment
                                                        //               .topLeft,
                                                        //           end: Alignment
                                                        //               .bottomRight,
                                                        //           colors: [
                                                        //             const Color(
                                                        //                     0xFFffffff)
                                                        //                 .withOpacity(
                                                        //                     0.5),
                                                        //             const Color(
                                                        //                     (0xFFFFFFFF))
                                                        //                 .withOpacity(
                                                        //                     0.5),
                                                        //           ],
                                                        //         ),
                                                        //         padding: const EdgeInsets
                                                        //                 .symmetric(
                                                        //             vertical:
                                                        //                 8),
                                                        //         height: 210,
                                                        //         child: ListView(
                                                        //           padding:
                                                        //               const EdgeInsets
                                                        //                   .all(8),
                                                        //           children: [
                                                        //             GestureDetector(
                                                        //               onTap:
                                                        //                   () {
                                                        //                 setState(
                                                        //                     () {});
                                                        //                 Navigator.pop(
                                                        //                     context);
                                                        //               },
                                                        //               child:
                                                        //                   Container(
                                                        //                 height:
                                                        //                     50,
                                                        //                 color: const Color(
                                                        //                     0xFF2A2D3E),
                                                        //                 padding:
                                                        //                     const EdgeInsets.symmetric(horizontal: 10),
                                                        //                 child:
                                                        //                     Row(
                                                        //                   mainAxisAlignment:
                                                        //                       MainAxisAlignment.start,
                                                        //                   children: [
                                                        //                     const Icon(
                                                        //                       Icons.visibility,
                                                        //                       color: Color.fromRGBO(34, 112, 59, 1),
                                                        //                     ),
                                                        //                     const SizedBox(
                                                        //                       width: 10,
                                                        //                     ),
                                                        //                     GestureDetector(
                                                        //                       onTap: () async {
                                                        //                         setState(() {});
                                                        //                       },
                                                        //                       child: ReuseText(
                                                        //                         text: 'View',
                                                        //                         color: Colors.white,
                                                        //                         fWeight: FontWeight.w400,
                                                        //                         size: 16,
                                                        //                         textAlign: TextAlign.left,
                                                        //                       ),
                                                        //                     ),
                                                        //                   ],
                                                        //                 ),
                                                        //               ),
                                                        //             ),
                                                        //             const Divider(),
                                                        //             GestureDetector(
                                                        //               onTap:
                                                        //                   () {
                                                        //                 print(
                                                        //                     'object');
                                                        //               },
                                                        //               child:
                                                        //                   Container(
                                                        //                 height:
                                                        //                     50,
                                                        //                 color: const Color(
                                                        //                     0xFF2A2D3E),
                                                        //                 padding:
                                                        //                     const EdgeInsets.symmetric(horizontal: 10),
                                                        //                 child:
                                                        //                     Row(
                                                        //                   mainAxisAlignment:
                                                        //                       MainAxisAlignment.start,
                                                        //                   children: const [
                                                        //                     Icon(
                                                        //                       FontAwesomeIcons.circleCheck,
                                                        //                       color: Color.fromRGBO(34, 112, 59, 1),
                                                        //                     ),
                                                        //                     SizedBox(
                                                        //                       width: 10,
                                                        //                     ),
                                                        //                     Expanded(
                                                        //                       child: ReuseText(
                                                        //                         text: 'Approve',
                                                        //                         color: Colors.white,
                                                        //                         fWeight: FontWeight.w400,
                                                        //                         size: 16,
                                                        //                         textAlign: TextAlign.left,
                                                        //                       ),
                                                        //                     ),
                                                        //                   ],
                                                        //                 ),
                                                        //               ),
                                                        //             ),
                                                        //             const Divider(),
                                                        //             GestureDetector(
                                                        //               onTap:
                                                        //                   () {
                                                        //                 Navigator.pop(
                                                        //                     context);
                                                        //                 print(
                                                        //                     'heey');
                                                        //               },
                                                        //               child:
                                                        //                   Container(
                                                        //                 height:
                                                        //                     50,
                                                        //                 color: const Color(
                                                        //                     0xFF2A2D3E),
                                                        //                 padding:
                                                        //                     const EdgeInsets.symmetric(horizontal: 10),
                                                        //                 child:
                                                        //                     Row(
                                                        //                   mainAxisAlignment:
                                                        //                       MainAxisAlignment.start,
                                                        //                   children: const [
                                                        //                     Icon(
                                                        //                       FontAwesomeIcons.closedCaptioning,
                                                        //                       color: Color.fromRGBO(34, 112, 59, 1),
                                                        //                     ),
                                                        //                     SizedBox(
                                                        //                       width: 10,
                                                        //                     ),
                                                        //                     ReuseText(
                                                        //                       text: 'Disapprove',
                                                        //                       color: Colors.white,
                                                        //                       fWeight: FontWeight.w400,
                                                        //                       size: 16,
                                                        //                     ),
                                                        //                   ],
                                                        //                 ),
                                                        //               ),
                                                        //             ),
                                                        //           ],
                                                        //         ),
                                                        //       ),
                                                        //     );
                                                        //   },
                                                        //   onPop: () => print(
                                                        //       'Popover was popped!'),
                                                        //   direction:
                                                        //       PopoverDirection
                                                        //           .left,
                                                        //   width: 150,
                                                        //   height: 170,
                                                        //   arrowHeight: 15,
                                                        //   arrowWidth: 30,
                                                        // );
                                                      },
                                                      child: Icon(Icons.list),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: snapshot.data![index]
                                                                .status ==
                                                            '0'
                                                        ? Text(
                                                            'Pending',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          )
                                                        : snapshot.data![index]
                                                                    .status ==
                                                                '1'
                                                            ? Text(
                                                                'Approved',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .amber,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              )
                                                            : snapshot
                                                                        .data![
                                                                            index]
                                                                        .status ==
                                                                    '2'
                                                                ? Text(
                                                                    'Resolved',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .amber,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    'Rejected',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      timeago.format(
                                                          snapshot.data![index]
                                                              .datecreated,
                                                          locale: 'en_short'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text("Non unapproved incidents"),
                                );
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppConstants.primaryColor),
                                ),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
