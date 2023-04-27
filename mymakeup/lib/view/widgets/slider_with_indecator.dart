import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymakeup/models/slider_model.dart';
import 'package:mymakeup/utils/theme/app_theme.dart';
import '../../models/home_model.dart';
import '../../utils/constant/assets_constant.dart';
import '../../utils/navigation.dart';
import '../screens/categry_products_screen.dart';
import '../screens/product_screen.dart';

class SliderAdsWidget extends StatefulWidget {
  const SliderAdsWidget(this.isLoading, {Key? key, required this.slides})
      : super(key: key);
  final bool isLoading;
  final List<HomeSliders> slides;

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<SliderAdsWidget> {
  int _current = 0;
  bool isStart = false;
  final CarouselController _controller = CarouselController();

  List<Widget> imageSliders() {
    return widget.slides
        .map((item) => GestureDetector(
              onTap: () {
                log(item.toJson().toString());
                if (item.productItemId != null && item.hasProduct!) {
                  Get.bottomSheet(
                      FractionallySizedBox(
                        heightFactor: .955,
                        child: ProductScreen(item.productItemId!),
                      ),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      barrierColor: AppTheme.colorAccent);
                } else if (item.categoryId != null) {
                  // todo category ID : null cake shop
                  List<RootCategories> brandCategories = [
                    RootCategories(
                      id: item.categoryId,
                    )
                  ];
                  bool? hasSubCategories = item.hasSubCategory;
                  NavigationApp.to(
                    CategoryProductsScreen(
                        tag: 'subCategory#${item.categoryId}',
                        hasSubCategories: hasSubCategories,
                        brandCategories: brandCategories,
                        productModuleId: item.categoryId,
                        productModuleType: 23,
                        selectedCategory: RootCategories(
                          id: item.categoryId,
                        )),
                  );
                  // Get.toNamed(item.url);
                }
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [

                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(
                            item.imageUrl!,
                          ),
                          fit: BoxFit.cover,
                        )),
                        child:  BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child:
                          CachedNetworkImage(
                            imageUrl: item.imageUrl! ?? '',
                            fit: BoxFit.contain,
                            width: Get.width * .5,
                            placeholder: (w, e) => Image.asset(
                              AssetsConstant.loading,
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (c, e, s) =>
                                Image.asset(AssetsConstant.placeHolder),
                          ),
                          // Image.network(
                          //   item.imageUrl!,
                          //   fit: BoxFit.cover,
                          //   loadingBuilder: (context, child, progress) {
                          //     if (progress == null) {
                          //       return child;
                          //     }
                          //     return ClipRRect(
                          //         borderRadius: BorderRadius.circular(16),
                          //         child: Image.asset(
                          //           AssetsConstant.loading,
                          //           fit: BoxFit.cover,
                          //           width: Get.height,
                          //         ));
                          //   },
                          //   width: Get.height,
                          // )
                        ),
                      ),
                    ],
                  )),
            ))
        .toList();
  }

  List<Widget> loadings() {
    return [
      ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            AssetsConstant.loading,
            fit: BoxFit.cover,
            width: Get.height,
          ))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * .25,
      child: Column(children: [
        Expanded(
          child: CarouselSlider(
            items: widget.isLoading ? loadings() : imageSliders(),
            carouselController: _controller,
            options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 4),
                autoPlayAnimationDuration: Duration(milliseconds: 300),
                height: Get.height * .25,
                enlargeCenterPage: true,
                aspectRatio: 0.1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                    isStart = true;
                  });
                  Future.delayed(Duration(milliseconds: 100), () {
                    setState(() {
                      isStart = false;
                    });
                  });
                }),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.slides.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: _current == entry.key ? 40.0 : 15,
                height: 6.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppTheme.colorPrimaryTrans),
                child: _current == entry.key
                    ? Row(
                        children: [
                          AnimatedContainer(
                            duration: Duration(seconds: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppTheme.colorAccent,
                            ),
                            height: 6.0,
                            width: isStart ? 15 : 40.0,
                          ),
                        ],
                      )
                    : Container(),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}
