import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:trucker_edge/screens/load_screen/load_screen.dart';
import 'package:trucker_edge/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucker_edge/controllers/home_controller.dart';
import 'package:intl/intl.dart';
import 'dart:async';

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
  late Future<List<Map<String, dynamic>>> _futureData;
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  // Function to fetch the data and refresh the state
  void _fetchData() {
    setState(() {
      _futureData = FirebaseServices().fetchAllEntriesForEditing();
    });
  }

  // Function to start auto-refresh every 60 seconds
  void _startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _fetchData(); // Fetch new data and refresh the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureData,
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
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No entries available.'),
                  ],
                ),
              );
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
                        ? DateFormat('hh:mm:ss a').format(timestamp)
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
                        DataCell(Text(
                          time,
                          style: const TextStyle(
                              fontFamily: robotoRegular, fontSize: 14),
                        )),
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
                              // Removed delete button as requested
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

