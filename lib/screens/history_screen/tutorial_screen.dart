import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:trucker_edge/constants/image_strings.dart';
import 'package:trucker_edge/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(
        backgroundColor: AppColor().primaryAppColor,
        title: Text(
          'Tutorial',
          style: TextStyle(
            color: AppColor().appTextColor,
            fontFamily: robotoRegular,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SfPdfViewer.asset('assets/pdf/TruckerEdge.pdf'),
    );
  }
}
