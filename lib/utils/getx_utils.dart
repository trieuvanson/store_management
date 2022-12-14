import 'package:flutter/animation.dart';
import 'package:get/get.dart';

pop({dynamic result}) {
  Get.off(() => result);
}

popAll({dynamic result}) {
  Get.offAll(() => result);
}

getScreen(
    {required dynamic screen,
    int? milliseconds = 300,
    Transition? transition,
    Curve? curve,
    bool? opaque}) {
  milliseconds = milliseconds ?? 300;
  Get.to(() => screen(),
      transition: transition,
      curve: curve,
      opaque: opaque,
      duration: Duration(milliseconds: milliseconds));
}

getScreenOffAll(
    {required dynamic screen,
    int? milliseconds = 300,
    Transition? transition,
    Curve? curve,
    bool? opaque}) {
  milliseconds = milliseconds ?? 300;
  Get.offAll(() => screen,
      transition: transition,
      curve: curve,
      opaque: opaque!,
      duration: Duration(milliseconds: milliseconds));
}
