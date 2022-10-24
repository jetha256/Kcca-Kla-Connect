import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kcca_kla_connect/config/base.dart';
import 'package:kcca_kla_connect/models/triphistory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../reusables/button.dart';
import '../../reusables/text.dart';
import '../todestination.dart';
import 'package:intl/intl.dart';

class TripHistory extends StatefulWidget {
  const TripHistory({Key? key}) : super(key: key);

  @override
  State<TripHistory> createState() => _TripHistoryState();
}

class _TripHistoryState extends Base<TripHistory> {
  Future<List<TripHistorys>>? _history;
  //get incidents and filter those near me
  Future<List<TripHistorys>> getHistory() async {
    List<TripHistorys> returnValue = [];
    String userId = "";
    String _authToken = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl + "trips/user/$userId");

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
      List<TripHistorys> tripHistorysmodel =
          (items as List).map((data) => TripHistorys.fromJson(data)).toList();
      var tripHistorys = tripHistorysmodel;
      returnValue = tripHistorysmodel;
      print('json.encode(returnValue)');
      print(json.encode(returnValue));
      print('json.encode(returnValue)');

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
    _history = getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
                        "Trip History",
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
                  future: _history,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd  kk:mm')
                                    .format(snapshot.data![index].datecreated);
                            return Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 55,
                                                    width: 8,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const CircleAvatar(
                                                          radius: 4,
                                                          backgroundColor:
                                                              Color.fromRGBO(34,
                                                                  112, 59, 1),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        1),
                                                            width: 2,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 8,
                                                          height: 8,
                                                          color: Colors.red,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              SizedBox(
                                                height: 55,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data![index]
                                                          .destinationaddress,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      snapshot.data![index]
                                                          .startaddress,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              SizedBox(
                                                height: 55,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        push(ToDestination(
                                                          long: snapshot
                                                              .data![index]
                                                              .destinationlong,
                                                          lati: snapshot
                                                              .data![index]
                                                              .destinationlat,
                                                        ));
                                                      },
                                                      child: ReuseButton(
                                                        radius: 20,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .04,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .3,
                                                        color: const Color
                                                                .fromRGBO(
                                                            34, 112, 59, 1),
                                                        child: const ReuseText(
                                                          text: 'Revisit',
                                                          color: Colors.white,
                                                          size: 14,
                                                          fWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // ListTile(
                                              //   leading: SizedBox(
                                              //     height: 45,
                                              //     width: 8,
                                              //     child: Column(
                                              //       mainAxisAlignment:
                                              //           MainAxisAlignment.start,
                                              //       crossAxisAlignment:
                                              //           CrossAxisAlignment.center,
                                              //       children: [
                                              //         const CircleAvatar(
                                              //           radius: 4,
                                              //           backgroundColor: Color.fromRGBO(
                                              //               34, 112, 59, 1),
                                              //         ),
                                              //         Expanded(
                                              //           child: Container(
                                              //             margin:
                                              //                 const EdgeInsets.symmetric(
                                              //                     vertical: 1),
                                              //             width: 2,
                                              //             color: Colors.black,
                                              //           ),
                                              //         ),
                                              //         Container(
                                              //           width: 8,
                                              //           height: 8,
                                              //           color: Colors.red,
                                              //         )
                                              //       ],
                                              //     ),
                                              //   ),
                                              //   title: Text(
                                              //     snapshot.data![index].destinationaddress
                                              //         .toString()
                                              //         .toUpperCase(),
                                              //     maxLines: 3,
                                              //     overflow: TextOverflow.ellipsis,
                                              //     style: const TextStyle(
                                              //         color: Colors.black,
                                              //         fontSize: 15,
                                              //         fontWeight: FontWeight.w700),
                                              //   ),
                                              //   subtitle: Text(
                                              //     snapshot.data![index].startaddress,
                                              //     maxLines: 3,
                                              //     overflow: TextOverflow.ellipsis,
                                              //     style: const TextStyle(
                                              //       color: Colors.black,
                                              //       fontSize: 15,
                                              //       fontWeight: FontWeight.w700,
                                              //     ),
                                              //   ),
                                              //   trailing: GestureDetector(
                                              //     onTap: () {
                                              //       push(ToDestination(
                                              //         long: snapshot
                                              //             .data![index].destinationlong,
                                              //         lati: snapshot
                                              //             .data![index].destinationlat,
                                              //       ));
                                              //     },
                                              //     child: ReuseButton(
                                              //       radius: 20,
                                              //       height: MediaQuery.of(context)
                                              //               .size
                                              //               .height *
                                              //           .04,
                                              //       width: MediaQuery.of(context)
                                              //               .size
                                              //               .width *
                                              //           .3,
                                              //       color: const Color.fromRGBO(
                                              //           34, 112, 59, 1),
                                              //       child: const ReuseText(
                                              //         text: 'Revisit',
                                              //         color: Colors.white,
                                              //         size: 14,
                                              //         fWeight: FontWeight.w400,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              // Padding(
                                              //   padding: const EdgeInsets.symmetric(
                                              //       horizontal: 20, vertical: 10),
                                              //   child: Row(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment.start,
                                              //     children: [
                                              //       const Icon(Icons.timelapse),
                                              //       Text(formattedDate),
                                              //     ],
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.timelapse,
                                                size: 14,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(formattedDate),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return Container(
                          child: Text("You have no  history"),
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
    );
  }
}
