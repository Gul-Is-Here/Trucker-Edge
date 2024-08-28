import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:trucker_edge/screens/load_screen/load_screen.dart';
import 'package:trucker_edge/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucker_edge/controllers/home_controller.dart';
import 'package:intl/intl.dart';

import '../../services/firebase_services.dart';

class UpdateScreen extends StatefulWidget {
  final HomeController homeController;
  final bool isUpdate;

  const UpdateScreen(
      {super.key, required this.homeController, required this.isUpdate});

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseServices().fetchAllEntriesForEditing();
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: FirebaseServices().fetchAllEntriesForEditing(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: AppColor().secondaryAppColor,
              ));
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            var data = snapshot.data ?? [];
            if (data.isEmpty) {
              return const Center(child: Text('No update data available.'));
            }

            return Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'ID',
                        style: TextStyle(
                            fontFamily: robotoRegular,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Date',
                        style: TextStyle(
                            fontFamily: robotoRegular,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Time',
                        style: TextStyle(
                            fontFamily: robotoRegular,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Action',
                        style: TextStyle(
                            fontFamily: robotoRegular,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: data.map<DataRow>((load) {
                    var timestamp = (load['timestamp'] as Timestamp?)?.toDate();
                    var date = timestamp != null
                        ? DateFormat('yyyy-MM-dd').format(timestamp)
                        : 'N/A';
                    var time = timestamp != null
                        ? DateFormat('HH:mm:ss').format(timestamp)
                        : 'N/A';
                    var loadId = load['id'] ?? 'Unknown';
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(loadId,
                            style: const TextStyle(
                                fontFamily: robotoRegular, fontSize: 14))),
                        DataCell(Text(
                          date,
                          style: const TextStyle(
                              fontFamily: robotoRegular, fontSize: 14),
                        )),
                        DataCell(Text(time,
                            style: const TextStyle(
                                fontFamily: robotoRegular, fontSize: 14))),
                        DataCell(
                          Row(
                            children: [
                              TextButton(
                                onPressed: () async {
                                  var documentId = load['id'] as String?;
                                  if (documentId != null) {
                                    var loadData = await FirebaseServices()
                                        .fetchEntryForEditing(documentId);
                                    Get.to(() => LoadScreen(
                                          isUpdate: widget.isUpdate,
                                          documentId: documentId,
                                          homeController: widget.homeController,
                                          loadData: loadData,
                                        ));
                                  }
                                },
                                child: const Text('Edit'),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    FirebaseServices()
                                        .transferAndDeleteWeeklyData();
                                  },
                                  child: Text('Delete'))
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
