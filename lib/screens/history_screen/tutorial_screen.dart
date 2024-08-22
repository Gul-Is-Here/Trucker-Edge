import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/widgets/my_drawer_widget.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late FlickManager _flickManager;
  @override
  void initState() {
    super.initState();
    _flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(
            'https://drive.google.com/uc?export=download&id=1RGWL7XViKfX5Is2XRYZZQwZAWEq5ckEd'))
          ..initialize().then((_) {
            setState(() {});
          }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(
        backgroundColor: AppColor().primaryAppColor,
      ),
      body: Center(
        child: AspectRatio(
            aspectRatio: 16 / 10,
            child: FlickVideoPlayer(
              flickManager: _flickManager,
            )),
      ),
    );
  }
}
