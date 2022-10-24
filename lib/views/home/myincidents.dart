import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kcca_kla_connect/config/base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../config/functions.dart';
import '../../models/incident.dart';
import 'incidentpage.dart';

class MyIncidents extends StatefulWidget {
  const MyIncidents({Key? key}) : super(key: key);

  @override
  State<MyIncidents> createState() => _MyIncidentsState();
}

class _MyIncidentsState extends Base<MyIncidents> {
  Future<List<Incident>>? _incidents;
  //get incidents and filter those near me
  Future<List<Incident>> getIncidents() async {
    List<Incident> returnValue = [];
    String userId = "";
    String _authToken = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl + "incidents/user/$userId");

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

  @override
  void initState() {
    super.initState();
    _incidents = getIncidents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * .95,
            width: MediaQuery.of(context).size.width * 1,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(245, 245, 245, 1),
            ),
            child: Column(
              children: [
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 35,
                        width: 35,
                      ),
                      const SizedBox(
                        child: Text(
                          "My incidents",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
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
                              return GestureDetector(
                                onTap: () {
                                  push(IncidentPage(
                                      incident: snapshot.data![index]));
                                },
                                child:
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     Container(
                                    //       margin: EdgeInsets.symmetric(
                                    //           vertical: 5, horizontal: 10),
                                    //       height: 30,
                                    //       width: MediaQuery.of(context).size.width *
                                    //           .85,
                                    //       color: Colors.black,
                                    //     ),
                                    //   ],
                                    // ),
                                    Row(
                                  children: [
                                    Expanded(
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
                                              title: Text(
                                                snapshot.data![index].name
                                                    .toString()
                                                    .toUpperCase(),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Text(
                                                snapshot
                                                    .data![index].description,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              trailing: Container(
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: snapshot.data![index]
                                                                .file1 !=
                                                            '' &&
                                                        snapshot.data![index]
                                                                .file1 !=
                                                            null
                                                    ? Image.memory(
                                                        Base64Decoder().convert(
                                                            snapshot
                                                                .data![index]
                                                                .file1
                                                                .split(',')
                                                                .last
                                                                .trim()),
                                                        fit: BoxFit.fill,
                                                        height: 80,
                                                      )
                                                    : Image.asset(
                                                        'assets/images/signin.jpeg',
                                                        fit: BoxFit.fill,
                                                        height: 80,
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
                                                            : Text(
                                                                'Resolved',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
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
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return Container(
                            child: Text("You haven't posted incidents"),
                          );
                        }
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppConstants.primaryColor),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
