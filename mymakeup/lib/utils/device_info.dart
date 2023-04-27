import 'dart:developer';
import 'dart:io';
import 'package:mymakeup/models/package_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfo {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  IosDeviceInfo? iosDeviceInfo;
  PackageAppInfo? packageAppInfo;
  AndroidDeviceInfo? androidDeviceInfo;
  WebBrowserInfo? webBrowserInfo;

  DeviceInfo() {
    PackageInfo.fromPlatform().then((value) {
      packageAppInfo = PackageAppInfo(value.appName, value.packageName,
          value.version, value.buildNumber, value.buildSignature);
     print(value.packageName);
      getDeviceInfo();
    });
  }

  Future<dynamic> getDeviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();
      // if (Platform.isIOS) {
      //   iosDeviceInfo = await deviceInfo.iosInfo;
      // } else if (Platform.isAndroid) {
      //   androidDeviceInfo = await deviceInfo.androidInfo;
      // }
      // else {
        webBrowserInfo = await deviceInfo.webBrowserInfo;
        log(webBrowserInfo!.data!.toString(),name: "web platform");
      }

}
