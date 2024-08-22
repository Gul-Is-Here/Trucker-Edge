import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trucker_edge/app_classes/app_class.dart';
import 'package:get/get_rx/get_rx.dart';

class FirebaseBarChartServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;

  Future<List<Map<String, dynamic>>> fetchBarData(
      {DateTime? startDate, DateTime? endDate}) async {
    final User? user = auth.currentUser;

    if (user == null) {
      return [];
    }

    Query query =
        firestore.collection('users').doc(user.uid).collection('history');

    if (startDate != null && endDate != null) {
      query = query
          .where('transferTimestamp',
              isGreaterThanOrEqualTo: AppClass().formatDateSpecific(startDate))
          .where('transferTimestamp',
              isLessThanOrEqualTo: AppClass().formatDateSpecific(endDate));

      print(
          'Querying between ${AppClass().formatDateSpecific(startDate)} and ${AppClass().formatDateSpecific(endDate)}');
    } else {
      query = query.orderBy('transferTimestamp', descending: true);
    }

    try {
      final QuerySnapshot querySnapshot = await query.get();
      final List<Map<String, dynamic>> data = [];

      for (var doc in querySnapshot.docs) {
        data.add(doc.data() as Map<String, dynamic>);
      }

      return data;
    } catch (e) {
      return [];
    }
  }
}
