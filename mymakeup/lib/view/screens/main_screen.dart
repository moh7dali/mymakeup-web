import 'package:mymakeup/view/widgets/actions_app_bar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mymakeup/utils/constant/assets_constant.dart';
import 'package:mymakeup/utils/navigation.dart';
import 'package:mymakeup/utils/theme/app_theme.dart';
import 'package:mymakeup/view/screens/notification_screen.dart';
import 'package:mymakeup/view/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mymakeup/view/widgets/bottom_navigation_bwr_widget.dart' as n;
import '../../main.dart';
import '../../models/cart_model.dart';
import '../../utils/constant/shared_preferences_constant.dart';
import '../../utils/helper.dart';
import '../../viewmodel/main_viewmodel.dart';
import '../widgets/drawer_widget.dart';
import 'cart_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey(); // Create a key
  bool isSelectedTab = true;

  @override
  Widget build(BuildContext context) {
    final arguments = Map<String, dynamic>.from(
        (ModalRoute.of(context)?.settings.arguments ?? {}) as Map);
    return GetBuilder<MainViewModel>(
        init: MainViewModel(arguments: arguments),
        builder: (mainController) {
          return Scaffold(
            key: scaffoldKey,
            bottomNavigationBar: const n.NavigationBar(),
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  scaffoldKey.currentState!.openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    AssetsConstant.menu,
                    color: AppTheme.colorAccent,
                  ),
                ),
              ),
              iconTheme: const IconThemeData(color: AppTheme.colorAccent),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Hero(
                tag: 'logoTag',
                child: Image.asset(
                  AssetsConstant.logo,
                  height: Get.height * .04,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        mainController.loginCart(() {
                          mainController.unReadCount = 0;
                          Get.back();
                          NavigationApp.to(NotificationScreen());
                        });
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              AssetsConstant.notifications,
                              color: AppTheme.colorAccent,
                              width: Get.width * .08,
                            ),
                          ),
                          if (mainController.unReadCount > 0)
                            Positioned(
                              top: 0,
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        mainController.unReadCount < 10
                                            ? 6
                                            : 2.0),
                                    child: Text(
                                      '${mainController.unReadCount}',
                                      style: AppTheme.boldStyle(
                                          color: Colors.white, size: 14),
                                    ),
                                  )),
                            )
                        ],
                      ),
                    ),
                    ActionsAppBarWidget(
                      isHome: true,
                    ),
                  ],
                ),
              ],
            ),
            drawer: const DrawerWidget(),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: mainController.currentWidget),
                  ],
                ),
                // Positioned(
                //   bottom: 10,
                //   child: Container(
                //     height: Get.height * .075,
                //     width: Get.width,
                //     child: Stack(
                //       children: [
                //         Positioned(
                //           bottom: Get.height * .007,
                //           top: Get.height * .007,
                //           left: Get.width * .02,
                //           right: Get.width * .02,
                //           child: Center(
                //             child: ClipRRect(
                //               borderRadius: BorderRadius.circular(100),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceAround,
                //                 children: [
                //                   Expanded(
                //                     child: GestureDetector(
                //                       onTap: () {
                //                         mainController.changeTab(0);
                //                       },
                //                       child: Container(
                //                         color: mainController.currentIndex == 0
                //                             ? AppTheme.colorAccent
                //                             : AppTheme.bottomNavColor,
                //                         child: Column(
                //                           children: [
                //                             SizedBox(
                //                               height: Get.height * .01,
                //                             ),
                //                             Image.asset(
                //                               AssetsConstant.homeTabIcon,
                //                               height: Get.height * .02,
                //                               color:
                //                                   mainController.currentIndex ==
                //                                           0
                //                                       ? AppTheme.bottomNavColor
                //                                       : AppTheme.colorAccent,
                //                             ),
                //                             const SizedBox(
                //                               width: 8,
                //                             ),
                //                             Text(
                //                               'homeTab'.tr,
                //                               style: AppTheme.boldStyle(
                //                                   color: mainController
                //                                               .currentIndex ==
                //                                           0
                //                                       ? AppTheme.bottomNavColor
                //                                       : AppTheme.colorAccent,
                //                                   size: 14.sp),
                //                             )
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                   Expanded(
                //                     child: GestureDetector(
                //                       onTap: () {
                //                         mainController.loginCart(() {
                //                           mainController.changeTab(3);
                //                         });
                //                       },
                //                       child: Container(
                //                         color: mainController.currentIndex == 3
                //                             ? AppTheme.colorAccent
                //                             : AppTheme.bottomNavColor,
                //                         child: Column(
                //                           children: [
                //                             SizedBox(
                //                               height: Get.height * .01,
                //                             ),
                //                             Image.asset(
                //                                 AssetsConstant.drawerOrder,
                //                                 height: Get.height * .02,
                //                                 color: mainController
                //                                             .currentIndex ==
                //                                         3
                //                                     ? AppTheme.bottomNavColor
                //                                     : AppTheme.colorAccent),
                //                             const SizedBox(
                //                               width: 8,
                //                             ),
                //                             Text(
                //                               'orderHistory'.tr,
                //                               style: AppTheme.boldStyle(
                //                                   color: mainController
                //                                               .currentIndex ==
                //                                           3
                //                                       ? AppTheme.bottomNavColor
                //                                       : AppTheme.colorAccent,
                //                                   size: 14.sp),
                //                             )
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //         Align(
                //           alignment: Alignment.center,
                //           child: Stack(
                //             children: [
                //               Container(
                //                 decoration: BoxDecoration(
                //                     shape: BoxShape.circle,
                //                     color: AppTheme.colorWhite,
                //                     border: Border.all(
                //                         color: AppTheme.colorAccent)),
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(3.0),
                //                   child: Container(
                //                     decoration: BoxDecoration(
                //                         shape: BoxShape.circle,
                //                         color: AppTheme.colorAccent),
                //                     child: Padding(
                //                       padding: const EdgeInsets.all(8.0),
                //                       child: SizedBox(
                //                         width: Get.height * .075,
                //                         height: Get.height * .075,
                //                         child: GestureDetector(
                //                           onTap: () {
                //                             mainController.loginCart(() {
                //                               NavigationApp.to(CartScreen());
                //                             });
                //                           },
                //                           child: Image.asset(
                //                             AssetsConstant.cart,
                //                             color: Colors.white,
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               Positioned(
                //                 top: 0,
                //                 left: 0,
                //                 right: 0,
                //                 child: ValueListenableBuilder<List<CartItem>>(
                //                   valueListenable: cartList,
                //                   builder: (BuildContext context,
                //                       List<CartItem> value, Widget? child) {
                //                     int numberOfItems = 0;
                //                     value.forEach((element) {
                //                       numberOfItems = (numberOfItems +
                //                           int.parse(
                //                               element.itemQuantity.toString()));
                //                     });
                //                     return value.isEmpty
                //                         ? Container()
                //                         : Container(
                //                             decoration: const BoxDecoration(
                //                                 shape: BoxShape.circle,
                //                                 color: Colors.red),
                //                             child: Center(
                //                               child: Text(
                //                                 '$numberOfItems',
                //                                 style: AppTheme.boldStyle(
                //                                     color: Colors.white,
                //                                     size: 14),
                //                               ),
                //                             ),
                //                           );
                //                   },
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        });
  }
}
