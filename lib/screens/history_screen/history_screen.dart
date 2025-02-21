import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trucker_edge/app_classes/app_class.dart';
import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:trucker_edge/screens/history_screen/history_details_screen.dart';
import 'package:trucker_edge/services/firebase_services.dart';
import 'package:trucker_edge/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:velocity_x/velocity_x.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(
        title: Text(
          'History',
          style: TextStyle(
              color: AppColor().appTextColor, fontFamily: robotoRegular),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: FirebaseServices().fetchHistoryDataById(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  itemCount: 6, // Number of shimmer items to show
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                color: Colors.white,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 20,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    width: 150,
                                    height: 20,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No history data found.'));
          } else {
            var historyData = snapshot.data!;

            // Sort the historyData by updateTime in descending order
            historyData.sort((a, b) {
              DateTime aTime = DateTime(1970);
              DateTime bTime = DateTime(1970);

              if (a['data']['calculatedValues'] != null &&
                  a['data']['calculatedValues'].isNotEmpty) {
                var aTimestamp = a['data']['calculatedValues'][0]['updateTime'];
                if (aTimestamp is Timestamp) {
                  aTime = aTimestamp.toDate();
                } else if (aTimestamp is DateTime) {
                  aTime = aTimestamp;
                }
              }

              if (b['data']['calculatedValues'] != null &&
                  b['data']['calculatedValues'].isNotEmpty) {
                var bTimestamp = b['data']['calculatedValues'][0]['updateTime'];
                if (bTimestamp is Timestamp) {
                  bTime = bTimestamp.toDate();
                } else if (bTimestamp is DateTime) {
                  bTime = bTimestamp;
                }
              }

              return bTime.compareTo(aTime);
            });

            return ListView.builder(
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> document = historyData[index];
                List<dynamic> calculatedValues =
                    document['data']['calculatedValues'];

                // Check if calculatedValues is not empty and get the first element's updateTime
                DateTime dateTime;
                if (calculatedValues.isNotEmpty &&
                    calculatedValues[0]['updateTime'] != null) {
                  var timestamp = calculatedValues[0]['updateTime'];
                  if (timestamp is Timestamp) {
                    dateTime = timestamp.toDate();
                  } else if (timestamp is DateTime) {
                    dateTime = timestamp;
                  } else {
                    dateTime = DateTime
                        .now(); // Fallback if the timestamp is not recognized
                  }
                } else {
                  dateTime =
                      DateTime.now(); // Fallback if the timestamp is null
                }

                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => HistoryDetailsScreen(
                        data: document['data'],
                        documentId: document['id'],
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => HistoryDetailsScreen(
                            data: document['data'],
                            documentId: document['id'],
                          ),
                          transition: Transition.circularReveal,
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.info_rounded,
                                size: 40,
                                color: AppColor().secondaryAppColor,
                              ),
                              Column(
                                children: [
                                  Text(document['id']),
                                  Text(AppClass()
                                      .formatDateTimeFriendly(dateTime)),
                                ],
                              ),
                            ],
                          ),
                       SizedBox(height:10),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
