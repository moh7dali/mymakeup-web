import 'package:mymakeup/utils/constant/assets_constant.dart';
import 'package:mymakeup/viewmodel/splash_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashViewModel>(
        init: SplashViewModel(),
        builder: (controller) => Stack(
          children: [
            // Positioned(
            //   left: 0,
            //   right: 0,
            //   top: 0,
            //   bottom: 0,
            //   child: Image.asset(AssetsConstant.splashBack, fit: BoxFit.cover),
            // ),
            AnimatedPositioned(
                top: controller.isAnimated ? Get.height *.2 : Get.height * .35,
                left: 0,
                right: 0,
                child: Hero(
                  tag: 'logoTAg',
                    child: Image.asset(
                  AssetsConstant.splashLogo,
                  height: Get.height * .1,
                )),
                duration: const Duration(seconds: 1))
          ],
        ),
      ),
    );
  }
}
