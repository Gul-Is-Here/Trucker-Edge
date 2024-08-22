import 'package:get/get.dart';

class HistroyController extends GetxController {
  RxBool isCloseFixedCost = true.obs;
  RxBool isClosePerMileCost = true.obs;

  void toggleFixedCost() {
    isCloseFixedCost.value = !isCloseFixedCost.value;
  }

  void toggleFixedCostPerMile() {
    isClosePerMileCost.value = !isClosePerMileCost.value;
  }
}
