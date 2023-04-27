import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:mymakeup/utils/helper.dart';
import 'package:mymakeup/utils/theme/app_theme.dart';
import 'package:mymakeup/viewmodel/signin_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/constant/assets_constant.dart';
import '../widgets/animated_shake_widget.dart';
class VerifyMobileScreen extends StatelessWidget {
  VerifyMobileScreen({Key? key, required this.controller}) : super(key: key);
  final SigninViewModel controller;
  final formKey = GlobalKey<FormState>();
  final sakeKey = GlobalKey<ShakeWidgetState>();
  StreamController<ErrorAnimationType> errorController =
  StreamController<ErrorAnimationType>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GetBuilder<SigninViewModel>(
        init: SigninViewModel(),
        builder: (controller) => SizedBox(
          width: Get.width,
          height: Get.height,
          child: Stack(
            children: [
              Positioned(
                top: Get.height * .15,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Hero(
                            tag: 'logoTAg',
                            child: Image.asset(
                              AssetsConstant.splashLogo,
                              width: Get.width * .8,
                            )),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: Get.height * .02,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            'verifyText'.tr,
                            textAlign: TextAlign.center,
                            style: AppTheme.lightStyle(
                              color: Colors.black,
                              size: 18.sp,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: Get.height * .014,
                        ),
                        AnimatedOpacity(
                          opacity: controller.mainOpacity,
                          duration: const Duration(milliseconds: 800),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: SizedBox(
                                  width: Get.width,
                                  child: Row(
                                    textDirection: TextDirection.ltr,
                                    children: [
                                      Expanded(
                                        child: ShakeWidget(
                                          key: sakeKey,
                                          shakeOffset: 10,
                                          shakeCount: 2,
                                          shakeDuration:
                                          const Duration(milliseconds: 800),
                                          child: Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: PinCodeTextField(
                                              keyboardType:
                                              TextInputType.number,
                                              length: 4,
                                              obscureText: false,
                                              animationType: AnimationType.fade,

                                              controller:
                                              controller.smsCodeController,
                                              textStyle: AppTheme.lightStyle(
                                                  color: Colors.black,
                                                  size: 24),
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              hintCharacter: '--',
                                              autoDisposeControllers: false,
                                              pinTheme: PinTheme(
                                                shape: PinCodeFieldShape.box,
                                                borderRadius:
                                                BorderRadius.circular(12),
                                                fieldHeight: Get.width * .12,
                                                fieldWidth: Get.width * .12,
                                                activeFillColor: AppTheme
                                                    .colorAccent
                                                    .withOpacity(.1),
                                                activeColor:
                                                AppTheme.colorAccent,
                                                selectedColor: AppTheme
                                                    .colorAccent
                                                    .withOpacity(.1),
                                                selectedFillColor: AppTheme
                                                    .colorAccent
                                                    .withOpacity(.1),
                                                inactiveColor:
                                                AppTheme.colorAccent,
                                                inactiveFillColor: AppTheme
                                                    .colorPrimaryTrans
                                                    .withOpacity(.1),
                                              ),
                                              animationDuration:
                                              Duration(milliseconds: 300),
                                              enableActiveFill: true,
                                              errorAnimationController:
                                              errorController,
                                              // controller: textEditingController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  sakeKey.currentState?.shake();
                                                } else if (value.length == 4) {}
                                                return null;
                                              },

                                              onCompleted: (v) {
                                                print("Completed");
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  controller.verifyCode(
                                                      controller
                                                          .smsCodeController
                                                          .text);
                                                }
                                              },

                                              onChanged: (value) {
                                                print(value);
                                                // setState(() {
                                                //   currentText = value;
                                                // });
                                              },
                                              beforeTextPaste: (text) {
                                                print(
                                                    "Allowing to paste $text");
                                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                                return true;
                                              },
                                              appContext: context,
                                            ).paddingSymmetric(
                                                horizontal: Get.width * .15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'enter4Digit'.tr,
                                style: AppTheme.lightStyle(color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        Hero(
                          tag: 'buttonNext',
                          child: GestureDetector(
                            onTap: () {
                              formKey.currentState!.validate();
                            },
                            child: Container(
                              width: Get.width * .8,
                              decoration: BoxDecoration(
                                  color: AppTheme.colorAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 12),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      'letsGo'.tr,
                                      style: AppTheme.lightStyle(
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            controller.smsDuration,
                            style: AppTheme.lightStyle(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              controller.resend();
                            },
                            child: Container(
                              width: Get.width * .8,
                              decoration: BoxDecoration(
                                  color: (controller.timer?.isActive ?? false)
                                      ? AppTheme.colorPrimaryTrans
                                      : AppTheme.colorAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 12),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      'resendOtp'.tr,
                                      style: AppTheme.lightStyle(
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            String number = controller.phoneController.text;
                            if (number.startsWith('0')) {
                              print("yes");
                              number = number.replaceFirst('0', '');
                            }
                            Helper().actionDialog(
                                "${'wrongMobile'.tr}+962${number}",
                                'changeMobile'.tr,
                                confirm: controller.changeMobile, cancel: () {
                              Get.back();
                            });
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 26.0, vertical: 20),
                                child: Text(
                                  'wrongMobile'.tr,
                                  style: AppTheme.boldStyle(
                                      color: AppTheme.colorAccent, size: 16.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Uri uri = Uri.parse("tel:0778830883");
                            if (!await launchUrl(uri)) {
                              throw 'Could not launch $uri';
                            }
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 26.0, vertical: 3),
                                child: Text(
                                  'needHelp'.tr,
                                  style: AppTheme.boldStyle(
                                      color: AppTheme.colorAccent, size: 16.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}