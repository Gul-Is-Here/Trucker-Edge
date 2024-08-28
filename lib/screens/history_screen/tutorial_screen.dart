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
              // Dummy image with arrow for "Add Cost Per Mile Fee"
              tutorialStepWithArrow(
                'Step 1: Add Cost Per Mile Fee',
                registerImage,
                Alignment.bottomRight,
              ),
              20.heightBox,
              // Dummy image with arrow for "Add Fixed Payment"
              tutorialStepWithArrow(
                'Step 2: Add Fixed Payment',
                'https://dummyimage.com/600x400/ccc/000.png&text=Fixed+Payment',
                Alignment.topLeft,
              ),
              20.heightBox,
              // Dummy image with arrow for "Add a Load"
              tutorialStepWithArrow(
                'Step 3: Add a Load',
                'https://dummyimage.com/600x400/ccc/000.png&text=Add+a+Load',
                Alignment.centerRight,
              ),
              20.heightBox,
              // Dummy image with arrow for "View Load History"
              tutorialStepWithArrow(
                'Step 4: View Load History',
                'https://dummyimage.com/600x400/ccc/000.png&text=View+Load+History',
                Alignment.topRight,
              ),
              20.heightBox,
              // Dummy image with arrow for "Analyze Expenses and Profit"
              tutorialStepWithArrow(
                'Step 5: Analyze Expenses and Profit',
                'https://dummyimage.com/600x400/ccc/000.png&text=Analyze+Expenses+and+Profit',
                Alignment.bottomLeft,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tutorialStepWithArrow(
      String title, String imageUrl, Alignment arrowAlignment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: robotoRegular,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        10.heightBox,
        Stack(
          children: [
            Image.asset(
              imageUrl,
              width: MediaQuery.of(context).size.width * 1,
              height: 200,
              fit: BoxFit.contain,
            ),
            Positioned(
              top: arrowAlignment == Alignment.topLeft ||
                      arrowAlignment == Alignment.topRight
                  ? 10
                  : null,
              bottom: arrowAlignment == Alignment.bottomLeft ||
                      arrowAlignment == Alignment.bottomRight
                  ? 10
                  : null,
              left: arrowAlignment == Alignment.topLeft ||
                      arrowAlignment == Alignment.bottomLeft
                  ? 10
                  : null,
              right: arrowAlignment == Alignment.topRight ||
                      arrowAlignment == Alignment.bottomRight
                  ? 10
                  : null,
              child: Icon(
                Icons.arrow_forward,
                size: 40,
                color: Colors.red,
              ).rotateCustom(arrowAlignment == Alignment.topLeft
                  ? -45
                  : arrowAlignment == Alignment.bottomRight
                      ? 135
                      : arrowAlignment == Alignment.topRight
                          ? 45
                          : -135),
            ),
          ],
        ),
      ],
    );
  }
}

extension RotationExtension on Widget {
  Widget rotateCustom(double angle) {
    return Transform.rotate(
      angle: angle * 3.14159 / 180,
      child: this,
    );
  }
}
