import 'package:flutter/material.dart';
import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:trucker_edge/widgets/my_drawer_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(
        backgroundColor: AppColor().primaryAppColor,
        title: Text(
          'Tutorial',
          style: TextStyle(
            fontFamily: robotoRegular,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              10.heightBox,
              Text(
                'Introduction',
                style: TextStyle(
                  fontFamily: robotoRegular,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              20.heightBox,
              ElevatedButton(
                onPressed: () => downloadPDF(),
                child: Text('Download Tutorial PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> downloadPDF() async {
    // Step 1: Request storage permission
    if (await _requestPermission(Permission.storage)) {
      try {
        final url =
            'https://example.com/tutorial.pdf'; // Replace with actual hosted URL

        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/App-Tutorial-Trucker-Edge.pdf';

        // Step 2: Start downloading the file
        await _dio.download(url, filePath);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF downloaded to $filePath')),
        );
      } catch (e) {
        // Step 3: Handle download errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading PDF: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  // Method to request storage permission
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }
}
