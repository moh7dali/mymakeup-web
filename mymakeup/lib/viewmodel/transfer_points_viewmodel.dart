import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymakeup/http/api_urls.dart';
import 'package:mymakeup/http/http_client.dart';
import 'package:mymakeup/models/TransferPointsModel.dart';
import 'package:mymakeup/models/main_response.dart';
import 'package:mymakeup/models/user_current_points_model.dart';
import 'package:mymakeup/utils/helper.dart';
import 'package:mymakeup/viewmodel/main_viewmodel.dart';

class TransferPointsViewModel extends GetxController {
  bool isLoading=true;
  final formKey = GlobalKey<FormState>();
  UserCurrentPoints currentPoints = UserCurrentPoints();
  TransferPointsModel transferPointsModel = TransferPointsModel();
  final pointsTransfer = TextEditingController();
  final phoneNo = TextEditingController();
  @override
  void onInit() {
    getUserCurrentPoints();
    super.onInit();
  }


  transferPoints(){
    if(formKey.currentState!.validate()){
      print('Success');
      sendPoints();
    }
  }
//962777430624
  sendPoints() {

    Helper().loading();
    HttpClientApp().request(
        method: 'POST',
        url: APIUrls.transferCustomerBalance,
        body: {
          "MobileNumber": "+962${phoneNo.text}",
          "TransferBalance": pointsTransfer.text
        },
        files: {},isJson: true).then((response) {
      TransferPointsModel mainResponse = TransferPointsModel.fromJson(json.decode(response));
      Get.back();
      if (mainResponse.isSucceeded!) {
        pointsTransfer.clear();
        phoneNo.clear();
        Helper().successfullySnackBar('successFully'.tr);
        getUserCurrentPoints();
      } else {
        if (mainResponse.errors!.isNotEmpty) {
          Helper().errorSnackBar(mainResponse.errors![0].errorMessage!);
        } else {
          Helper().errorSnackBar('defaultError'.tr);
        }
      }


    });
  }
  getUserCurrentPoints() {
    HttpClientApp().request(
        method: 'GET',
        url: APIUrls.getUserCurrentPoints,
        body: {},
        files: {}).then((response) {
      currentPoints = UserCurrentPoints.fromJson(json.decode(response));
      if(Get.isRegistered<MainViewModel>()){
        Get.find<MainViewModel>().getLoyalty();
      }

      if (currentPoints.isSucceeded!) {
      } else {
        if (currentPoints.errors!.isNotEmpty) {
          Helper().errorSnackBar(currentPoints.errors![0].errorMessage!);
        } else {
          Helper().errorSnackBar('defaultError'.tr);
        }
      }
      isLoading = false;
      update();
    });
  }


}

