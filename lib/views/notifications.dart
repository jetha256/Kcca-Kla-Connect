import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _userId = "";
  String _authToken = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                  ),
                  Container(
                    child: const Text(
                      "Notifications",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 35,
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              // child: RefreshIndicator(
              child:
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: notifications.orderBy('timestamp').snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       if (snapshot.data!.docs.isEmpty) {
                  //         return Center(
                  //           child: Column(
                  //             children: const [
                  //               // Image.asset("assets/images/"),
                  //               Text("No Notifications")
                  //             ],
                  //           ),
                  //         );
                  //       }
                  //       // return MessageWall(
                  //       //   messages: snapshot.data!.docs,
                  //       //   onDelete: _deletMessage,
                  //       // );
                  //       // return Text((snapshot.data!.docs[0].data()
                  //       //         as Map<String, dynamic>)
                  //       //     .toString());
                  //       return ListView.builder(
                  //           scrollDirection: Axis.vertical,
                  //           itemCount: snapshot.data!.docs.length,
                  //           shrinkWrap: true,
                  //           itemBuilder: (context, index) {
                  //             final data = (snapshot.data!.docs[index].data()
                  //                 as Map<String, dynamic>);
                  //             final user = FirebaseAuth.instance.currentUser;
                  //             return Container(
                  //               margin: const EdgeInsets.only(bottom: 3),
                  //               padding: const EdgeInsets.symmetric(vertical: 5),
                  //               decoration:
                  //                   const BoxDecoration(color: Colors.white),
                  //               child: ListTile(
                  //                 leading: Icon(Icons.notifications),
                  //                 trailing: Text(
                  //                   "10m",
                  //                   style: TextStyle(
                  //                       fontWeight: FontWeight.w400,
                  //                       fontSize: 12),
                  //                 ),
                  //                 tileColor: Colors.white,
                  //                 title: Text(
                  //                   data['title'],
                  //                   style: TextStyle(
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 14),
                  //                 ),
                  //                 subtitle: Text(
                  //                   data['content'],
                  //                   style: TextStyle(
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 14),
                  //                 ),
                  //               ),
                  //             );
                  //           });
                  //     } else {
                  //       return const Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     }
                  //   },
                  // ),
                  ListView.builder(
                itemCount: 0,
                itemBuilder: (BuildContext context, int index) => Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: const ListTile(
                    leading: Icon(Icons.notifications),
                    trailing: Text(
                      "10m",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                    ),
                    tileColor: Colors.white,
                    title: Text(
                      "hello ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      "Its the kampala ....... ....... ...... ....",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
            // ),
          ],
        ),
      ),
    );
  }
}
