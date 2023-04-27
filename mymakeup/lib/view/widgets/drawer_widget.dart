import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mymakeup/utils/constant/assets_constant.dart';
import 'package:mymakeup/utils/navigation.dart';
import 'package:mymakeup/utils/theme/app_theme.dart';
import 'package:mymakeup/view/screens/bottomnavigationscreens/branches_screen.dart';
import 'package:mymakeup/view/screens/bottomnavigationscreens/loyalty_screen.dart';
import 'package:mymakeup/view/screens/drawerscreens/connect_with_us_screen.dart';
import 'package:mymakeup/view/screens/drawerscreens/call_us_screen.dart';
import 'package:mymakeup/view/screens/drawerscreens/invite_friends_screen.dart';
import 'package:mymakeup/view/screens/drawerscreens/language_screen.dart';
import 'package:mymakeup/view/screens/drawerscreens/my_order_screen.dart';
import 'package:mymakeup/view/screens/drawerscreens/profile_screen.dart';
import 'package:mymakeup/view/screens/drawerscreens/transfer_points_screen.dart';
import 'package:mymakeup/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../viewmodel/main_viewmodel.dart';
import '../screens/main_screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: GetBuilder<AuthViewModel>(
          init: AuthViewModel(),
          builder: (controller) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Hero(
                          tag: 'logoTAg',
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              AssetsConstant.splashLogo,
                              width: Get.width * .5,
                            ),
                          )),
                    ),
                    drawerContent(
                      'mymakeupMain',
                      AssetsConstant.drawerHome,
                      isHome: true,
                      onTap: () {
                        // Get.back();
                        Get.delete<MainViewModel>();
                        Get.offAll(MainScreen());
                      },
                    ),
                    drawerContent(
                      'profile',
                      AssetsConstant.drawerAccount,
                      onTap: () {
                        controller.login(() {
                          Get.back();
                          NavigationApp.to(ProfileScreen());
                        });
                      },
                    ),
                    drawerContent(
                      'branches',
                      AssetsConstant.drawerBranches,
                      onTap: () {
                        Get.back();
                        NavigationApp.to(BranchesScreen());
                      },
                    ),
                    drawerContent('inviteFriends', AssetsConstant.drawerInvite,
                        onTap: () {
                      controller.login(() {
                        Get.back();
                        NavigationApp.to(InviteFriendsScreen());
                        //Share.share(controller.inviteTex);
                      });
                    }),
                    drawerContent(
                      'contactUs',
                      AssetsConstant.drawerContact,
                      onTap: () {
                        controller.login(() {
                          Get.back();
                          NavigationApp.to(CallUsScreen());
                        });
                      },
                    ),
                    drawerContent(
                      'rateOurApp',
                      AssetsConstant.drawerRate,
                      onTap: () {
                        if (Platform.isAndroid) {
                          launchUrl(Uri.parse(
                              'market://details?id=com.mozaic.www.mymakeup'));
                        } else if (Platform.isIOS) {
                          launchUrl(
                            Uri.parse(
                                'https://apps.apple.com/jo/app/id1600237949'),
                          );
                        }
                      },
                    ),
                    drawerContent(
                      'Language',
                      AssetsConstant.drawerLanguage,
                      onTap: () {
                        Get.back();
                        NavigationApp.to(LanguageScreen());
                      },
                    ),
                    drawerContent(
                      'developedBy',
                      AssetsConstant.drawerDevelopedBy,
                      onTap: () {
                        controller.developBy();
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget drawerContent(String title, String icon,
      {required GestureTapCallback onTap, bool isHome = false}) {
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(
                icon,
                height: 20.w,
                color: AppTheme.colorAccent,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                title.tr,
                style: AppTheme.lightStyle(
                    color: AppTheme.colorAccent, size: 15.sp),
              )
            ],
          ),
        ),
      ),
    );
  }
}
