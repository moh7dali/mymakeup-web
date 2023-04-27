import 'dart:convert';

import 'package:mymakeup/utils/constant/assets_constant.dart';
import 'package:mymakeup/view/screens/product_screen.dart';
import 'package:mymakeup/view/widgets/animated_shake_widget.dart';
import 'package:mymakeup/view/widgets/no_items_widget.dart';
import 'package:mymakeup/viewmodel/cart_viewmodel.dart';
import 'package:mymakeup/viewmodel/my_addresses_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../models/cart_model.dart';
import '../../models/products_model.dart';
import '../../utils/constant/shared_preferences_constant.dart';
import '../../utils/helper.dart';
import '../../utils/theme/app_theme.dart';
import 'checkout_screen.dart';
import 'main_screen.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);
  final shakeKey = GlobalKey<ShakeWidgetState>();

  double taxValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          Get.offAll(MainScreen());
          return false;
        },

      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ValueListenableBuilder<List<CartItem>>(
          valueListenable: cartList,
          builder:
              (BuildContext context, List<CartItem> cartItems, Widget? child) {
            return GetBuilder<CartViewModel>(
                init: CartViewModel(cartItems),
                builder: (controller) => GetBuilder<MyAddressesViewModel>(
                  init: MyAddressesViewModel(cartViewModel: controller,isCartAddress: true),
                  builder: (controllerAddress) => Scaffold(
                    appBar: AppBar(
                      leading: BackButton(
                        onPressed: () {
                          Get.offAll(MainScreen());
                        },
                      ),
                      centerTitle: false,
                      iconTheme:
                      const IconThemeData(color: AppTheme.colorAccent),
                      title: Text('cart'.tr,
                          style: AppTheme.boldStyle(
                              color: AppTheme.colorAccent, size: 16.sp)),
                      actions: [
                        GestureDetector(
                          onTap: () {
    if (cartItems.isNotEmpty) {
                            Helper().actionDialog(
                              'cancleOrder'.tr,
                              'cancleCartbody'.tr,
                              confirm: () {
                                SharedPreferences.getInstance().then((prefs) {
                                  prefs.setStringList(
                                      SharedPreferencesKey.cart, []);
                                  cartList.value = cartFromJson(
                                      "${prefs.getStringList(SharedPreferencesKey.cart) ?? []}");
                                  Get.back();
                                });
                              },
                              cancel: () {
                                Get.back();
                              },
                            );}
                          },
                          child:  Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.delete_forever,
                              size: 35,
                              color: cartItems.isEmpty
                                  ? AppTheme.colorPrimary
                                  : AppTheme.colorAccent,
                            ),
                          ),
                        )
                      ],
                    ),
                    bottomNavigationBar: cartItems.isEmpty
                        ? Container(
                      height: 0,
                    )
                        : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text('subTotal'.tr,
                                  style: AppTheme.boldStyle(
                                      color: Colors.black,
                                      size: 14.sp)),
                              Text(
                                  '${controller.subTotal.toStringAsFixed(2)} ${controller.unitPrice}',
                                  style: AppTheme.boldStyle(
                                      color: AppTheme.colorAccent,
                                      size: 14.sp)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: AppTheme.colorPrimary),
                                      borderRadius:
                                      BorderRadius.circular(5)),
                                  child: Center(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(12.0),
                                      child: Text('addMore'.tr,
                                          style: AppTheme.boldStyle(
                                              color: AppTheme.colorPrimary,
                                              size: 15.sp)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.delete<CartViewModel>();
                                  Get.to(CheckoutScreen());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: controller.isProcessed
                                          ? Colors.grey
                                          : AppTheme.colorAccent,
                                      borderRadius:
                                      BorderRadius.circular(5)),
                                  child: Center(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(12.0),
                                      child: Text('checkOut'.tr,
                                          style: AppTheme.boldStyle(
                                              color: Colors.white,
                                              size: 16.sp)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                    body: SingleChildScrollView(
                      controller: controller.scrollController,
                      child: Column(
                        children: [
                          ValueListenableBuilder<List<CartItem>>(
                            valueListenable: cartList,
                            builder: (BuildContext context,
                                List<CartItem> cartItems, Widget? child) {
                              return cartItems.isEmpty
                                  ? GestureDetector(
                                onTap: () {},
                                child: NoItemsWidget(
                                    img: AssetsConstant.noCart,
                                    title: 'emptyCart'.tr,
                                    hasColor: false,
                                    body: ''),
                              )
                                  : controller.isCartLoading
                                  ? SizedBox(
                                height: Get.height,
                                    child: const Center(
                                child:
                                const CircularProgressIndicator(),
                              ),
                                  )
                                  : Column(
                                children: [
                                  cartListWidget(
                                      cartItems, controller),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (controller
                                      .alsoAddedProducts
                                      .productItems
                                      ?.isNotEmpty ??
                                      false)
                                    Padding(
                                      padding: const EdgeInsets
                                          .symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                                'peopleAlsoAdded'
                                                    .tr,
                                                style: AppTheme
                                                    .lightStyle(
                                                    color: AppTheme.colorPrimary,
                                                    size:
                                                    14.sp)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  if (controller
                                      .alsoAddedProducts
                                      .productItems
                                      ?.isNotEmpty ??
                                      false)
                                    SizedBox(
                                      height: 200.h,
                                      child: ListView.builder(
                                        scrollDirection:
                                        Axis.horizontal,
                                        itemBuilder: (context,
                                            index) =>
                                            buildPeopleAlsoAddedItem(
                                                controller
                                                    .alsoAddedProducts
                                                    .productItems![index]),
                                        itemCount: controller
                                            .alsoAddedProducts
                                            .productItems
                                            ?.length,
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }

  Widget buildPeopleAlsoAddedItem(ProductItem productItem) {
    String image = productItem.url!;
    double price = productItem.productItemPrices![0].price;
    String mealCurrency =
    productItem.productItemPrices![0].currancyDisplayName!;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: Get.width * .45,
        decoration: BoxDecoration(
            border: Border.all(color: AppTheme.colorPrimary),
            borderRadius: BorderRadius.circular(16)
        ),
        child: GestureDetector(
          onTap: () {
            if (kDebugMode) {
              print('productItem.id! ${productItem.id!}');
            }
            Get.bottomSheet(
                FractionallySizedBox(
                  heightFactor: .956,
                  child: ProductScreen(productItem.id!),
                ),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                barrierColor: AppTheme.colorAccent);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: CachedNetworkImage(
                      width: Get.width * .4,
                      fit: BoxFit.cover,
                      imageUrl: image),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          productItem.name ?? '',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 13.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,

                          color: AppTheme.colorPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      price.toString(),
                      style: TextStyle(color: AppTheme.colorAccent, fontSize: 14.sp),
                    ),
                    Text(
                      mealCurrency,
                      style: TextStyle(color: AppTheme.colorAccent, fontSize: 14.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cartListWidget(List<CartItem> cartItems, CartViewModel controller) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        bool startPositionAdd = false;
        bool startPositionSub = false;
        return Card(
          color: Get.theme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color:AppTheme.colorPrimary),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: Get.height*.15,
                        width: Get.width*.25,
                        child: CachedNetworkImage(
                          imageUrl: cartItems[index].itemUrl ?? '',
                          placeholder: (w, e) => Image.asset(
                            AssetsConstant.loading,
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (c, e, s) =>
                              Image.asset(AssetsConstant.placeHolder),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      cartItems[index].itemName!.trim(),
                                      style: AppTheme.boldStyle(
                                          color:AppTheme.colorPrimary,
                                          size: 13.sp),
                                    ),
                                  ),
                                ),
                                if (cartItems[index].productProperties != null)
                                  Container(
                                    height: Get.height * .03,
                                    width: Get.height * .03,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: HexColor.fromHex(cartItems[index]
                                            .productProperties![0]
                                            .value!)),
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Container(
                              height: 1,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('totalPrice'.tr,
                                    style: AppTheme.lightStyle(
                                        size: 14.sp,
                                        color: AppTheme.colorPrimary)),
                                Text(
                                    cartItems[index].itemTotalOfferPrice! > 0
                                        ? cartItems[index]
                                        .itemTotalOfferPrice!
                                        .toStringAsFixed(2)
                                        : cartItems[index]
                                        .itemTotalPrice!
                                        .toStringAsFixed(2),
                                    style: AppTheme.lightStyle(
                                       size: 14.sp,
                                        color: AppTheme.colorAccent)),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Container(
                              height: 1,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            if (cartItems[index].itemInstructions != "")
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('specialOrder'.tr),
                                  Text(cartItems[index].itemInstructions!),
                                ],
                              ),
                            const SizedBox(
                              height: 6,
                            ),
                            Container(
                              height: Get.width * .08,
                              width: Get.width * .28,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100)),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.colorAccent,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.black)),
                                      child: GestureDetector(
                                        onTapDown: (details) {
                                          startPositionAdd = true;
                                          startPositionSub = false;
                                          controller.update();
                                        },
                                        onTapUp: (details) {
                                          cartItems[index].itemQuantity = int.parse(
                                              cartItems[index]
                                                  .itemQuantity
                                                  .toString()) +
                                              1;
                                          if (cartItems[index].itemOfferPrice! > 0) {
                                            cartItems[index].itemTotalOfferPrice =
                                                double.parse(cartItems[index]
                                                    .itemTotalOfferPrice
                                                    .toString()) +
                                                    double.parse(cartItems[index]
                                                        .itemOfferPrice
                                                        .toString());
                                            for (var element
                                            in cartItems[index].itemOptions!) {
                                              cartItems[index]
                                                  .itemTotalOfferPrice = double.parse(
                                                  cartItems[index]
                                                      .itemTotalOfferPrice
                                                      .toString()) +
                                                  double.parse(
                                                      element.optionPrice.toString());
                                            }
                                          } else {
                                            cartItems[index].itemTotalPrice =
                                                double.parse(cartItems[index]
                                                    .itemTotalPrice
                                                    .toString()) +
                                                    double.parse(cartItems[index]
                                                        .itemPrice
                                                        .toString());
                                            for (var element
                                            in cartItems[index].itemOptions!) {
                                              cartItems[index]
                                                  .itemTotalPrice = double.parse(
                                                  cartItems[index]
                                                      .itemTotalPrice
                                                      .toString()) +
                                                  double.parse(
                                                      element.optionPrice.toString());
                                            }
                                          }
                                          startPositionAdd = true;
                                          controller.update();
                                          Future.delayed(
                                              const Duration(milliseconds: 50), () {
                                            startPositionAdd = false;
                                            controller.update();
                                          });
                                          SharedPreferences.getInstance()
                                              .then((prefs) {
                                            List<String> cartListItem =
                                                prefs.getStringList(
                                                    SharedPreferencesKey.cart) ??
                                                    [];
                                            if (kDebugMode) {
                                              print('cartListItem: $cartListItem');
                                            }
                                            cartListItem[index] =
                                                jsonEncode(cartItems[index].toJson());
                                            prefs.setStringList(
                                                SharedPreferencesKey.cart,
                                                cartListItem);
                                            cartListItem = prefs.getStringList(
                                                SharedPreferencesKey.cart) ??
                                                [];
                                            if (kDebugMode) {
                                              print('cartListItem1: $cartListItem');
                                            }
                                            cartList.value = cartFromJson(
                                                "${prefs.getStringList(SharedPreferencesKey.cart) ?? []}");
                                            controller.checkPromPrices();
                                            controller.calculatePrices();
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(Icons.add,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    left: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppTheme.colorAccent,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.black)),
                                      child: GestureDetector(
                                        onTapDown: (details) {
                                          startPositionAdd = false;
                                          startPositionSub = true;
                                          controller.update();
                                        },
                                        onTapUp: (details) {
                                          if (int.parse(cartItems[index]
                                              .itemQuantity
                                              .toString()) >
                                              1) {
                                            cartItems[index].itemQuantity = int.parse(
                                                cartItems[index]
                                                    .itemQuantity
                                                    .toString()) -
                                                1;
                                            if (cartItems[index].itemOfferPrice! >
                                                0) {
                                              cartItems[index].itemTotalOfferPrice =
                                                  double.parse(cartItems[index]
                                                      .itemTotalOfferPrice
                                                      .toString()) -
                                                      double.parse(cartItems[index]
                                                          .itemOfferPrice
                                                          .toString());
                                              for (var element
                                              in cartItems[index].itemOptions!) {
                                                cartItems[index].itemTotalOfferPrice =
                                                    double.parse(cartItems[index]
                                                        .itemTotalOfferPrice
                                                        .toString()) -
                                                        double.parse(element
                                                            .optionPrice
                                                            .toString());
                                              }
                                            } else {
                                              cartItems[index].itemTotalPrice =
                                                  double.parse(cartItems[index]
                                                      .itemTotalPrice
                                                      .toString()) -
                                                      double.parse(cartItems[index]
                                                          .itemPrice
                                                          .toString());
                                              for (var element
                                              in cartItems[index].itemOptions!) {
                                                cartItems[index].itemTotalPrice =
                                                    double.parse(cartItems[index]
                                                        .itemTotalPrice
                                                        .toString()) -
                                                        double.parse(element
                                                            .optionPrice
                                                            .toString());
                                              }
                                            }
                                            SharedPreferences.getInstance()
                                                .then((prefs) {
                                              List<String> cartListItem =
                                                  prefs.getStringList(
                                                      SharedPreferencesKey
                                                          .cart) ??
                                                      [];
                                              print('cartListItem: $cartListItem');
                                              cartListItem[index] = jsonEncode(
                                                  cartItems[index].toJson());
                                              prefs.setStringList(
                                                  SharedPreferencesKey.cart,
                                                  cartListItem);
                                              cartListItem = prefs.getStringList(
                                                  SharedPreferencesKey.cart) ??
                                                  [];
                                              print('cartListItem1: $cartListItem');
                                              cartList.value = cartFromJson(
                                                  "${prefs.getStringList(SharedPreferencesKey.cart) ?? []}");
                                            });
                                          } else {
                                            cartItems.removeAt(index);
                                            SharedPreferences.getInstance()
                                                .then((prefs) {
                                              List<String> cartListItem =
                                                  prefs.getStringList(
                                                      SharedPreferencesKey
                                                          .cart) ??
                                                      [];
                                              cartListItem.removeAt(index);
                                              prefs.setStringList(
                                                  SharedPreferencesKey.cart,
                                                  cartListItem);
                                              cartList.value = cartFromJson(
                                                  "${prefs.getStringList(SharedPreferencesKey.cart) ?? []}");
                                              controller.cartItems = cartList.value;
                                              controller.calculatePrices();
                                            });
                                          }

                                          startPositionSub = true;
                                          controller.update();
                                          Future.delayed(
                                              const Duration(milliseconds: 50), () {
                                            startPositionSub = false;
                                            controller.update();
                                            controller.checkPromPrices();
                                            controller.calculatePrices();
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(Icons.remove,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  AnimatedAlign(
                                    duration: const Duration(milliseconds: 100),
                                    alignment: startPositionAdd
                                        ? Alignment.centerRight
                                        : startPositionSub
                                        ? Alignment.centerLeft
                                        : Alignment.center,
                                    child: Container(
                                        height: Get.width * .1,
                                        width: Get.width * .1,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppTheme.colorPrimary,
                                                width: 2),
                                            color: AppTheme.colorPrimary,
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: Text(
                                              cartItems[index]
                                                  .itemQuantity
                                                  .toString(),
                                              style: AppTheme.lightStyle(
                                                  color: Colors.white,
                                                  size: Get.width * .035)),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Helper().actionDialog(
                              '${cartItems[index].itemName!.trim()}'.tr,
                              'clearOneItem'.tr,
                              confirm: () {
                                SharedPreferences.getInstance().then((prefs) {
                                  List<String> cartListItem = prefs.getStringList(
                                      SharedPreferencesKey.cart) ??
                                      [];
                                  cartListItem.removeAt(index);
                                  prefs.setStringList(
                                      SharedPreferencesKey.cart, cartListItem);
                                  cartList.value = cartFromJson(
                                      "${prefs.getStringList(SharedPreferencesKey.cart) ?? []}");
                                  controller.cartItems = cartList.value;
                                  controller.calculatePrices();
                                  controller.checkPromPrices();
                                  Get.back();
                                });
                              },
                              cancel: () {
                                Get.back();
                              },
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(
                              Icons.cancel,
                              color: AppTheme.colorAccent,
                              size: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: Colors.black,
                ),
                const SizedBox(height: 12),
                if (cartItems[index].itemOptions!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 6,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cartItems[index].itemOptions!.length,
                          itemBuilder: (context, optionIndex) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${cartItems[index].itemOptions![optionIndex].optionParentName??''}: ',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppTheme.colorAccent)),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Text(
                                      cartItems[index]
                                          .itemOptions![optionIndex]
                                          .optionName!,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color:AppTheme.colorPrimary))),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}

